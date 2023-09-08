Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B857EEEB571
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Sep 2023 23:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbjIHXew (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Sep 2023 19:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbjIHXew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2023 19:34:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EEF18E
        for <linux-xfs@vger.kernel.org>; Fri,  8 Sep 2023 16:34:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE35C433C9;
        Fri,  8 Sep 2023 23:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694216087;
        bh=JQZYvlaD2m2kir6LTuZKiDLwftO8eKJjYTaezgfeAhk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uuaYle7P5M6QfGY3JlKSABrivAi6vJajC6XOJWZPh7C0NQTngtQApkh1dResaNpS8
         7jRWKge/JrR4gucue1ju9XFe3RM/278XEap5KRkLAF4qG2FU8ydAIYwVRdG6CEgK5a
         ykRtRE8FuzOAObZe8FcRwqDLooogFkfocuLQ37yUigJd4nU+Mmv75hjGw62byGbJ75
         BaGqxT08X483UhzVfhO4NQM9gjRpCFslQSGShEz3MlpmQi/u0Lbs5Pmt/ctmaMe0gf
         nsRgZi5EvWJvSUdtxhvcVP5Izgyb7cjtsYgCZcaJvgxnj65PoapXhotOqD5xogVqfc
         Rxt7BNv9svK8w==
Date:   Fri, 8 Sep 2023 16:34:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: log EFIs for all btree blocks being used to
 stage a btree
Message-ID: <20230908233447.GY28186@frogsfrogsfrogs>
References: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
 <169049623218.921279.10028914723578681696.stgit@frogsfrogsfrogs>
 <ZNCuQ/mxsHQ67vjz@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNCuQ/mxsHQ67vjz@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 07, 2023 at 06:41:39PM +1000, Dave Chinner wrote:
> On Thu, Jul 27, 2023 at 03:24:32PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > We need to log EFIs for every extent that we allocate for the purpose of
> > staging a new btree so that if we fail then the blocks will be freed
> > during log recovery.  Add a function to relog the EFIs, so that repair
> > can relog them all every time it creates a new btree block, which will
> > help us to avoid pinning the log tail.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> .....
> > +/*
> > + * Set up automatic reaping of the blocks reserved for btree reconstruction in
> > + * case we crash by logging a deferred free item for each extent we allocate so
> > + * that we can get all of the space back if we crash before we can commit the
> > + * new btree.  This function returns a token that can be used to cancel
> > + * automatic reaping if repair is successful.
> > + */
> > +static int
> > +xrep_newbt_schedule_autoreap(
> > +	struct xrep_newbt		*xnr,
> > +	struct xrep_newbt_resv		*resv)
> > +{
> > +	struct xfs_extent_free_item	efi_item = {
> > +		.xefi_blockcount	= resv->len,
> > +		.xefi_owner		= xnr->oinfo.oi_owner,
> > +		.xefi_flags		= XFS_EFI_SKIP_DISCARD,
> > +		.xefi_pag		= resv->pag,
> > +	};
> > +	struct xfs_scrub		*sc = xnr->sc;
> > +	struct xfs_log_item		*lip;
> > +	LIST_HEAD(items);
> > +
> > +	ASSERT(xnr->oinfo.oi_offset == 0);
> > +
> > +	efi_item.xefi_startblock = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno,
> > +			resv->agbno);
> > +	if (xnr->oinfo.oi_flags & XFS_OWNER_INFO_ATTR_FORK)
> > +		efi_item.xefi_flags |= XFS_EFI_ATTR_FORK;
> > +	if (xnr->oinfo.oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
> > +		efi_item.xefi_flags |= XFS_EFI_BMBT_BLOCK;
> > +
> > +	INIT_LIST_HEAD(&efi_item.xefi_list);
> > +	list_add(&efi_item.xefi_list, &items);
> > +
> > +	xfs_perag_intent_hold(resv->pag);
> > +	lip = xfs_extent_free_defer_type.create_intent(sc->tp, &items, 1,
> > +			false);
> 
> Hmmmm.
> 
> That triggered flashing lights and sirens - I'm not sure I really
> like the usage of the defer type arrays like this, nor the
> duplication of the defer mechanisms for relogging, etc.
> 
> Not that I have a better idea right now - is this the final form of
> this code, or is more stuff built on top of it or around it?

Soooo.  Now that another month has passed, I've had the time to think
about this topic some more.

I've flat-out rejected my own suggestion to leave the ondisk bnobt
unchanged and stash the reservations in the extent busy tree, because
the resulting IO sequence ends up being:

<read everything we need to synthesize records>
<write btree blocks to disk>

T0: commit btree root

<remove first extent we used for the btree from busy list>

T1: remove first extent from bnobt
T2: rmapbt updates for the first extent

<remove second extent we used for the btree from busy list>

T3: remove second extent from bnobt
T4: rmapbt updates for the second extent
...

Because we cannot risk having the system go down before we finish
writing all these transactions.  One could invent a new log intent items
that capture promises to allocate blocks, but that only reduces the
problem to:

T0: commit btree root
intent item for first extent
intent item for second extent
...
run out of transaction reservation

T1: more intent items

Same problem, just harder to hit.  So.  I'll requeue the "hide the space
in the extent busy tree" for some day when writing to a hole becomes hot
enough to make this important again.

---------------

However, I thought about what newbt.c really wants to do with EFIs.
A transaction removes each extent from the bnobt (until we have enough
blocks to write out the new btree) and logs an EFI to free that space.

If the new tree write succeeds and we reserved exactly enough blocks,
then all we want to do is:

1) Log the EFDs to the same transaction where we commit the new btree
   root.  We don't free the space.

If the new tree write succeeds and we reserved too many blocks, then we
want the btree root commit transaction to:

1) same as above

2) For eextents that we only wrote partially, we want to log an EFD for
   the existing EFI at the same time that we log a new EFI to free
   whatever we didn't use.

3) For the extents that we completely didn't use, we want to log EFDs
   and free the space.

If the new tree write fails, then we want the last transaction in the
chain to:

3) same as above

Also note that we want to relog EFIs if we need to move the log tail
forward.  Right now I copy and paste the xfs_defer_relog code into
newbt.c, which is awful.

We could actually use the regular defer ops extent freeing mechanism for
case (3) above, since that's already how xfs_extent_free_later works.

For case (1) and (2), we want a slight variation on deferred extent
freeing.  The EFI log item would still get created, but now we want to
mark a deferred work item to be set aside when xfs_defer_finish is
trying to call ->finish_item on tp->t_dfops.

When the btree write finishes, we mark the deferred extent free work
item as stale and remove the mark we put on that item in the previous
step.  This enables the deferred extent free item to go through the
usual xfs_defer_finish state machine so that an EFD gets created.  The
only difference is that now xfs_trans_free_extent doesn't call
__xfs_free_extent.

This also means that each _claim_block function can now call
xrep_defer_finish() to relog the EFIs between each btree block write.

----------------

As for the code that reaps old ondisk structures -- I created a new
dfops type called "barrier" so that the reap code never writes out an
EFI with more than two extents per log item.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

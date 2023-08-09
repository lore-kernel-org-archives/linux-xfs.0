Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C70AC001DE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Aug 2023 23:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjHIXwh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 19:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjHIXwg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 19:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7DBE74
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 16:52:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1E686407D
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 23:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092CEC433C8;
        Wed,  9 Aug 2023 23:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691625155;
        bh=4QPmfPcBqAkktnljpbhrfTB4edaJooI7FKOra7FeYEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wfvsa+TvjHo5n8SCFl5BBWCwEDjGrwXTduOjON/PMyTA/RXV2UTHJIiJQpY3IasC4
         ObdR+UFbeiWY5v0MqZrEOT3AtpAWXeDanzegQE+9AqtBtbBKaPNU0keAIkgZ9Tw4kV
         ruaS2JvKXWaOuD28fwwBHQjoEfO99EHkbrfmJg9x5swvQCBMQIqwDzhILPyb6tdcmt
         trGutIY0ekG/H0dOMzXQ4UAHkztRUdcoPaX+iFVNWMfY9NMGBjPb/5lJv20dL+b/tI
         ap249VSYfNFnTZ8kRCZAti+NYRoOiuASdKcUk6XyuCufG9ItS30qI9lnrXFJZLp/qR
         YPa9mfPwp3pIQ==
Date:   Wed, 9 Aug 2023 16:52:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: log EFIs for all btree blocks being used to
 stage a btree
Message-ID: <20230809235234.GZ11352@frogsfrogsfrogs>
References: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
 <169049623218.921279.10028914723578681696.stgit@frogsfrogsfrogs>
 <ZNCuQ/mxsHQ67vjz@dread.disaster.area>
 <20230808005452.GN11352@frogsfrogsfrogs>
 <ZNHcgXhda8KUqOl8@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNHcgXhda8KUqOl8@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 08, 2023 at 04:11:13PM +1000, Dave Chinner wrote:
> On Mon, Aug 07, 2023 at 05:54:52PM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 07, 2023 at 06:41:39PM +1000, Dave Chinner wrote:
> > > On Thu, Jul 27, 2023 at 03:24:32PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > We need to log EFIs for every extent that we allocate for the purpose of
> > > > staging a new btree so that if we fail then the blocks will be freed
> > > > during log recovery.  Add a function to relog the EFIs, so that repair
> > > > can relog them all every time it creates a new btree block, which will
> > > > help us to avoid pinning the log tail.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > .....
> > > > +/*
> > > > + * Set up automatic reaping of the blocks reserved for btree reconstruction in
> > > > + * case we crash by logging a deferred free item for each extent we allocate so
> > > > + * that we can get all of the space back if we crash before we can commit the
> > > > + * new btree.  This function returns a token that can be used to cancel
> > > > + * automatic reaping if repair is successful.
> > > > + */
> > > > +static int
> > > > +xrep_newbt_schedule_autoreap(
> > > > +	struct xrep_newbt		*xnr,
> > > > +	struct xrep_newbt_resv		*resv)
> > > > +{
> > > > +	struct xfs_extent_free_item	efi_item = {
> > > > +		.xefi_blockcount	= resv->len,
> > > > +		.xefi_owner		= xnr->oinfo.oi_owner,
> > > > +		.xefi_flags		= XFS_EFI_SKIP_DISCARD,
> > > > +		.xefi_pag		= resv->pag,
> > > > +	};
> > > > +	struct xfs_scrub		*sc = xnr->sc;
> > > > +	struct xfs_log_item		*lip;
> > > > +	LIST_HEAD(items);
> > > > +
> > > > +	ASSERT(xnr->oinfo.oi_offset == 0);
> > > > +
> > > > +	efi_item.xefi_startblock = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno,
> > > > +			resv->agbno);
> > > > +	if (xnr->oinfo.oi_flags & XFS_OWNER_INFO_ATTR_FORK)
> > > > +		efi_item.xefi_flags |= XFS_EFI_ATTR_FORK;
> > > > +	if (xnr->oinfo.oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
> > > > +		efi_item.xefi_flags |= XFS_EFI_BMBT_BLOCK;
> > > > +
> > > > +	INIT_LIST_HEAD(&efi_item.xefi_list);
> > > > +	list_add(&efi_item.xefi_list, &items);
> > > > +
> > > > +	xfs_perag_intent_hold(resv->pag);
> > > > +	lip = xfs_extent_free_defer_type.create_intent(sc->tp, &items, 1,
> > > > +			false);
> > > 
> > > Hmmmm.
> > > 
> > > That triggered flashing lights and sirens - I'm not sure I really
> > > like the usage of the defer type arrays like this, nor the
> > > duplication of the defer mechanisms for relogging, etc.
> > 
> > Yeah, I don't quite like manually tromping through the defer ops state
> > machine here either.  Everywhere /else/ in XFS logs an EFI and finishes
> > it to free the space.  Just to make sure we're on the same page, newbt
> > will allocate space, log an EFI, and then:
> > 
> > 1. Use the space and log an EFD for the space to cancel the EFI
> > 2. Use some of the space, log an EFD for the space we used, immediately
> >    log a new EFI for the unused parts, and finish the new EFI manually
> > 3. Don't use any of the space at all, and finish the EFI manually
> > 
> > Initially, I tried using the regular defer ops mechanism, but this got
> > messy on account of having to extern most of xfs_defer.c so that I could
> > manually modify the defer ops state.  It's hard to generalize this,
> > since there's only *one* place that actually needs manual flow control.
> 
> *nod*
> 
> But I can't help but think it's a manifestation of a generic
> optimisation that could allow us to avoid needing to use unwritten
> extents for new data alloations...

I've thought about this usecase at various points in the lifetime of the
newbt.c code.  The usecases are indeed very similar -- speculatively
allocate some disk blocks, write to them, and either map them into the
data fork / btree root if the writes actually succeed; or free them
because it failed.

However, I think we could eliminate the overhead of the speculative
allocation out of the bnobt/cnbt (aka step 1) by boosting all of the
tracking to the incore data structures.  Handwaving sketch:

1. Find the extent we want from the free space btrees, and add a record
to the busy extent list with some new state flag that signals
"speculative write: do not DISCARD this extent, and allocating callers
should move on".

(Not sure what happens if the allocating caller /never/ finds space?
Does kicking writeback make sense here?  I am not sure it does.)

2. Create a mapping in the cow fork for the speculatively allocated
space, along with an annotation to that effect.  Also need to absorb
whatever space we reserved in the delalloc mapping for bmbt expansion.

3. Write the blocks.

4. If the write succeeds, we do the cow remap like we do now, but also
remove the extent from the ondisk free space btrees and clear the space
from the busy extent list.

5. If the write fails, clear the space from busy extent list.  Maybe add
the space to a badblocks list(??)

Under this scheme, the only ondisk metadata update is step 4.  I really
like the idea of porting newbt.c to use a mechanism like this, since
the only time we touch the log is if the repair succeeds.

Too bad it doesn't exist yet! :)

For now, the oddball use of EFIs is limited to newbt.c, which means it's
self-contained inside repair.  Except for the "too many extents attached
to an EFI" issue, I think it works well enough to put into use until you
or I have time to figure out how to turn either of our "unwritten extent
for new data allocation" sketches into reality.

(IOWs, I'm trying /not/ to go carving around in the allocator and the
extent busy list when there's already so much to think about. ;))

> > ISTR that was around the time bfoster and I were reworking log intent
> > item recovery, and it was easier to do this outside of the defer ops
> > code than try to refactor it and keep this exceptional piece working
> > too.
> > 
> > > Not that I have a better idea right now - is this the final form of
> > > this code, or is more stuff built on top of it or around it?
> > 
> > That's the final form of it.  The good news is that it's been stable
> > enough despite me tearing into the EFI code again in the rt
> > modernization patchset.  Do you have any further suggestions?
> 
> Not for the patchset as it stands.

<nod> I'll add some monitoring to report the maximum extent counts that
get added to EFIs, and work on something to constrain the number of
extents that get added to a single EFI log item that's coming from
repair.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

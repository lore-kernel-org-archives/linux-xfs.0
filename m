Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA30EB64DD
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 00:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjHHAyz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 20:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjHHAyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 20:54:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF3B171E
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 17:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7460A62341
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 00:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD1CC433C9;
        Tue,  8 Aug 2023 00:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691456092;
        bh=aDatWi4lGHnG6GjWalZQUdz068L5qzC0TDiPLARihwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PF9J1uwc8lKhwqqzb/qSQTfUAgUIIlL88Xedkxb2LeE6q0USOTvuQH5p1P+eRlpfV
         +0m4gn5aB81s15b/dxW4pUez67TxS7RKYpOfDl+N7hRAtjaj86mFd5BTbxZGI/4fZp
         jxioi0+Gb/7IerIU2EMC/ZvFvGQAd1L8mXZnLx4CnriFyFS2tgCNN7Ofki4V3a4JAh
         hhx118qbpOugzMXNZvMsvIjhMEtwy8RiSZbAJcBbw2+QgB86TlAEMJPiB3hWyuJw9+
         /771CUhs08hxbtSv57LcrCluXAWNLl9BqSIfBOLmjiFyBZjNFAVxZyQOJee+9woZEy
         8T4+e4ukqnsfw==
Date:   Mon, 7 Aug 2023 17:54:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: log EFIs for all btree blocks being used to
 stage a btree
Message-ID: <20230808005452.GN11352@frogsfrogsfrogs>
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

Yeah, I don't quite like manually tromping through the defer ops state
machine here either.  Everywhere /else/ in XFS logs an EFI and finishes
it to free the space.  Just to make sure we're on the same page, newbt
will allocate space, log an EFI, and then:

1. Use the space and log an EFD for the space to cancel the EFI
2. Use some of the space, log an EFD for the space we used, immediately
   log a new EFI for the unused parts, and finish the new EFI manually
3. Don't use any of the space at all, and finish the EFI manually

Initially, I tried using the regular defer ops mechanism, but this got
messy on account of having to extern most of xfs_defer.c so that I could
manually modify the defer ops state.  It's hard to generalize this,
since there's only *one* place that actually needs manual flow control.

ISTR that was around the time bfoster and I were reworking log intent
item recovery, and it was easier to do this outside of the defer ops
code than try to refactor it and keep this exceptional piece working
too.

> Not that I have a better idea right now - is this the final form of
> this code, or is more stuff built on top of it or around it?

That's the final form of it.  The good news is that it's been stable
enough despite me tearing into the EFI code again in the rt
modernization patchset.  Do you have any further suggestions?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87647C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Nov 2022 00:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiKPAyD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 19:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiKPAyC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 19:54:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0A9303C5
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 16:54:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC500617E4
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 00:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256CDC433D7;
        Wed, 16 Nov 2022 00:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668560040;
        bh=KRoYPTz52QUqmRFUxym9SFzLzeeLdEPzNv72mGwCrR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o5kKd6JiMlnVDTUzEQ60XKwwZSBLCuwIJbHmjVq/r1W32XV8x9CvetkEsEybuKd03
         8f2/1+EO5WLr/2W19y+ATthcrlYnX95X9hUnUEhQc2HL4wk9tOnXH4l7vNp8EVW7xe
         gEyGRNrdJMfKteNo2n1m6j7j3Di5ImqcYEHZQqfKqJeDb4iGoEd7/FQxGh/VkdZhI7
         RbdPIpKtOS9ucaLnRioueyj3Xb2FCU+NX9noPsoqR/WJie/FDA3M54mzCWGI1Cfvfk
         QGhYjtw5SGSVVCM9rwalOEn8udNa3HY+PiUhOU7LcWo+E5kFxjlhge7MgO2mJXnwX9
         QxkCoSACvpU/w==
Date:   Tue, 15 Nov 2022 16:53:59 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix an inode lookup race in xchk_get_inode
Message-ID: <Y3Q0p6LHYUJ/L1QN@magnolia>
References: <166473482923.1084685.3060991494529121939.stgit@magnolia>
 <166473482957.1084685.13676900912332698227.stgit@magnolia>
 <20221115034954.GX3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115034954.GX3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2022 at 02:49:54PM +1100, Dave Chinner wrote:
> On Sun, Oct 02, 2022 at 11:20:29AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In commit d658e, we tried to improve the robustnes of xchk_get_inode in
> > the face of EINVAL returns from iget by calling xfs_imap to see if the
> > inobt itself thinks that the inode is allocated.  Unfortunately, that
> > commit didn't consider the possibility that the inode gets allocated
> > after iget but before imap.  In this case, the imap call will succeed,
> > but we turn that into a corruption error and tell userspace the inode is
> > corrupt.
> > 
> > Avoid this false corruption report by grabbing the AGI header and
> > retrying the iget before calling imap.  If the iget succeeds, we can
> > proceed with the usual scrub-by-handle code.  Fix all the incorrect
> > comments too, since unreadable/corrupt inodes no longer result in EINVAL
> > returns.
> > 
> > Fixes: d658e72b4a09 ("xfs: distinguish between corrupt inode and invalid inum in xfs_scrub_get_inode")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> OK.
> 
> > ---
> >  fs/xfs/scrub/common.c |  203 ++++++++++++++++++++++++++++++++++++++++---------
> >  fs/xfs/scrub/common.h |    4 +
> >  fs/xfs/xfs_icache.c   |    3 -
> >  fs/xfs/xfs_icache.h   |    1 
> >  4 files changed, 172 insertions(+), 39 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > index 42a25488bd25..9a811c5fa8f7 100644
> > --- a/fs/xfs/scrub/common.c
> > +++ b/fs/xfs/scrub/common.c
> > @@ -635,6 +635,14 @@ xchk_ag_init(
> >  
> >  /* Per-scrubber setup functions */
> >  
> > +void
> > +xchk_trans_cancel(
> > +	struct xfs_scrub	*sc)
> > +{
> > +	xfs_trans_cancel(sc->tp);
> > +	sc->tp = NULL;
> > +}
> > +
> >  /*
> >   * Grab an empty transaction so that we can re-grab locked buffers if
> >   * one of our btrees turns out to be cyclic.
> > @@ -720,6 +728,80 @@ xchk_iget(
> >  	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
> >  }
> >  
> > +/*
> > + * Try to grab an inode.  If we can't, return the AGI buffer so that the caller
> > + * can single-step the loading process to see where things went wrong.
> 
> "Try to grab an inode in a manner that avoids races with physical inode
> allocation. If we can't, return the locked AGI buffer so that the
> caller can single-step the loading process to see where things went
> wrong."

Fixed.

> > + *
> > + * If the iget succeeds, return 0, a NULL AGI, and the inode.
> > + * If the iget fails, return the error, the AGI, and a NULL inode.  This can
> 
> "... the locked AGI, ...."
> 
> > + * include -EINVAL and -ENOENT for invalid inode numbers or inodes that are no
> > + * longer allocated; or any other corruption or runtime error.
> > + * If the AGI read fails, return the error, a NULL AGI, and NULL inode.
> > + * If a fatal signal is pending, return -EINTR, a NULL AGI, and a NULL inode.
> > + */
> > +int
> > +xchk_iget_agi(
> > +	struct xfs_scrub	*sc,
> > +	xfs_ino_t		inum,
> > +	struct xfs_buf		**agi_bpp,
> > +	struct xfs_inode	**ipp)
> > +{
> > +	struct xfs_mount	*mp = sc->mp;
> > +	struct xfs_trans	*tp = sc->tp;
> > +	struct xfs_perag	*pag;
> > +	int			error;
> > +
> > +again:
> > +	*agi_bpp = NULL;
> > +	*ipp = NULL;
> > +	error = 0;
> > +
> > +	if (xchk_should_terminate(sc, &error))
> > +		return error;
> > +
> > +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
> > +	error = xfs_ialloc_read_agi(pag, tp, agi_bpp);
> > +	xfs_perag_put(pag);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfs_iget(mp, tp, inum,
> > +			XFS_IGET_NOWAIT | XFS_IGET_UNTRUSTED, 0, ipp);
> 
> OK, IGET_NOWAIT is new....
> 
> > +#define XFS_IGET_NOWAIT		0x10	/* return EAGAIN instead of blocking */
> 
> But it doesn't prevent blocking. XFS_IGET_UNTRUSTED means we do a
> inobt record lookup (btree buffer locking and IO that can block) as
> well as reading the inode cluster from disk if it's not already in
> cache. Hence this isn't what I'd call a "non-blocking" or "no wait"
> operation. 
> 
> AFAICT, what is needed here is avoiding the -retry mechanism- of the
> lookup, not "non blocking/no wait" semantics. i.e. this seems
> reasonable to get an -EAGAIN error instead of delaying and trying
> again if we are using XFS_IGET_NORETRY semantics....

Aha, yes, thank you for the better name. :)

/* Return -EAGAIN immediately if the inode is unavailable. */
#define XFS_IGET_NORETRY		(1U << 5)

> > +	if (error == -EAGAIN) {
> > +		/*
> > +		 * Cached inode awaiting inactivation.  Drop the AGI buffer in
> > +		 * case the inactivation worker is now waiting for it, and try
> > +		 * the iget again.
> > +		 */
> 
> That's not the only reason xfs_iget() could return -EAGAIN,
> right? radix_tree_preload() failing can cause -EAGAIN to be returned
> from xfs_iget_cache_miss(), as can an instantiation race inserting
> the new inode into the radix tree. The cache hit path has a bunch
> more cases, too. Perhaps:

Yes, I suppose that's possible if the incore inode gets evicted and
someone else is reinstantiating it at the same time we're looking for
it...

> 		/*
> 		 * The inode may be in core but temporarily
> 		 * unavailable and may require the AGI buffer before
> 		 * it can be returned. Drop the AGI buffer and retry
> 		 * the lookup.
> 		 */

...so yes, this is a better explanation of what's going on.

> > +		xfs_trans_brelse(tp, *agi_bpp);
> > +		delay(1);
> > +		goto again;
> > +	}
> > +	if (error == 0) {
> > +		/* We got the inode, so we can release the AGI. */
> > +		ASSERT(*ipp != NULL);
> > +		xfs_trans_brelse(tp, *agi_bpp);
> > +		*agi_bpp = NULL;
> > +	}
> > +
> > +	return error;
> 
> That's better written as:
> 
> 	if (error)
> 		return error;
> 
> 	/* We got the inode, so we can release the AGI. */
> 	ASSERT(*ipp != NULL);
> 	xfs_trans_brelse(tp, *agi_bpp);
> 	*agi_bpp = NULL;
> 	return 0;
> 
> Other than that, the code makes sense.

Fixed.  Thanks for the review.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

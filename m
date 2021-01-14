Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8413C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 22:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF73C23741
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 22:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbhANWuf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 17:50:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728452AbhANWuf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 17:50:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B27423741;
        Thu, 14 Jan 2021 22:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610664594;
        bh=1qSFKNEeo07iGn3NmIOuYz2Mp5AwYElRMnNydryevsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fM21zVmQVbAFzVnEe7WzdjUU41CLe7e+2CDIEpeFoZ9KkQUU91FG6E+V5MD9SZMWc
         njFBogQyWqtcDYte2Zn+Yb1sAFTm/NxmLfjCC5InHDkCNXHyPuj+SJG5LPRaPJklQU
         l2jgmuDrprxjc/u1FuF0umDryfVizJC574R/Nhmr4ndnV3Wj+7Mnn0R6FvKBZ0VhYB
         bt34Q8V5OlGPRQlF6udVQkVQ+/hAHRbCmGZEJzMZhpPHLr626vWrL0EaBizK4Yz8OS
         /Emn4n0Fp1S2m3bj5OZoh+fkDp8mFfgXkGY+wVoX3nNAT/Q1IT+tfrr/8pVscjKpQK
         lhVpVp1vqk75g==
Date:   Thu, 14 Jan 2021 14:49:53 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: refactor the predicate part of
 xfs_free_eofblocks
Message-ID: <20210114224953.GJ1164246@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040740813.1582286.3253329052236449810.stgit@magnolia>
 <X/8KS4it5LAkN6Xr@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/8KS4it5LAkN6Xr@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 03:57:15PM +0100, Christoph Hellwig wrote:
> On Mon, Jan 11, 2021 at 03:23:28PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Refactor the part of _free_eofblocks that decides if it's really going
> > to truncate post-EOF blocks into a separate helper function.  The
> > upcoming deferred inode inactivation patch requires us to be able to
> > decide this prior to actual inactivation.  No functionality changes.
> 
> Is there any specific reason why the new xfs_has_eofblocks helper is in
> xfs_inode.c?  That just makes following the logic a little harder.

I ... have no idea.  This patch also isn't technically needed until we
get to the deferred inactivation patchset, but I'll reshuffle the deck
and move this function back to xfs_bmap_util.c.

> > +
> > +/*
> > + * Decide if this inode have post-EOF blocks.  The caller is responsible
> > + * for knowing / caring about the PREALLOC/APPEND flags.
> > + */
> > +int
> > +xfs_has_eofblocks(
> > +	struct xfs_inode	*ip,
> > +	bool			*has)
> > +{
> > +	struct xfs_bmbt_irec	imap;
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	xfs_fileoff_t		end_fsb;
> > +	xfs_fileoff_t		last_fsb;
> > +	xfs_filblks_t		map_len;
> > +	int			nimaps;
> > +	int			error;
> > +
> > +	*has = false;
> > +	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
> > +	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> > +	if (last_fsb <= end_fsb)
> > +		return 0;
> 
> Where does this strange magic come from?

It comes straight from xfs_free_eofblocks.

I /think/ the purpose of this is to avoid touching any file that's
larger than the page cache supports (i.e. 16T on 32-bit) because inode
inactivation causes pagecache invalidation, and trying to invalidate
with too high a pgoff causes weird integer truncation problems.

> > +	map_len = last_fsb - end_fsb;
> > +
> > +	nimaps = 1;
> > +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> > +	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
> > +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > +
> > +	if (error || nimaps == 0)
> > +		return error;
> > +
> > +	*has = imap.br_startblock != HOLESTARTBLOCK || ip->i_delayed_blks;
> > +	return 0;
> 
> I think this logic could be simplified at lot by using xfs_iext_lookup
> directly. Something like:
> 
> 	*has = false;
> 
> 	xfs_ilock(ip, XFS_ILOCK_SHARED);
> 	if (ip->i_delayed_blks) {
> 		*has = true;
> 		goto out_unlock;
> 	}
> 	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
> 		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);

Is it even worth reading in the bmap btree to clear posteof blocks if we
haven't loaded it already?

--D

> 		if (error)
> 			goto out_unlock;
>         }
> 	if (xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
> 		*has = true;
> out_unlock:
> 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> 	return error;

--D

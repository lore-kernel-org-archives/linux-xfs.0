Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C903BC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 17:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE2164E6C
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 17:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhBWRCe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 12:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233701AbhBWRCE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Feb 2021 12:02:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B435D64E85;
        Tue, 23 Feb 2021 17:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614099682;
        bh=s6C4wWY6IVcUUlEibmsb3kFnnMX+ZhEmnqCosNWZP6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V28hMZ7hSqvXafVMWNNjX3aIiXU4eD9FGZ4eoKfP+jbStkJHp4iAUo50HWGm+hc/P
         dVRkCAGrBnAPAA7nliwZutFmtTnx1Si+qKq5V4oWYYIk6/IZoMzRvaq/4Lbi0KQUHK
         J3OvkAwHp/Uec6kuy2oJeB1pMZkTfroxgwM2PiBOFIihczdKHsHM2TnQwEZ7f03m2r
         LOK39LErr0/SV71JPpC6R79OjjKz/oA29zMQLOsqMCtUYX0FRW1+0yTekfwUi5oYxF
         FSiUm50owXJ7jR9JaNblwda6pUMhSW06GXZWRTW7WQGS/NDhKoYpKCzGns7HDIym6r
         Lgz2Nn7Kkz1cw==
Date:   Tue, 23 Feb 2021 09:01:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Allow scrub to detect inodes with non-maximal sized
 extents
Message-ID: <20210223170122.GK7272@magnolia>
References: <20210223082629.16719-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223082629.16719-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 01:56:29PM +0530, Chandan Babu R wrote:
> This commit now makes it possible for scrub to check if an inode's extents are
> maximally sized i.e. it checks if an inode's extent is contiguous (in terms of
> both file offset and disk offset) with neighbouring extents and the total
> length of both the extents is less than the maximum allowed extent
> length (i.e. MAXEXTLEN).
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/scrub/inode.c   | 11 +++++++----
>  fs/xfs/xfs_bmap_util.c | 36 +++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_bmap_util.h |  5 +++--
>  fs/xfs/xfs_qm.c        |  2 +-
>  4 files changed, 42 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index faf65eb5bd31..33b530785e36 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -478,23 +478,26 @@ xchk_inode_xref_bmap(
>  	xfs_filblks_t		count;
>  	xfs_filblks_t		acount;
>  	int			error;
> +	bool			maximal_sized_exts;
>  
>  	if (xchk_skip_xref(sc->sm))
>  		return;
>  
>  	/* Walk all the extents to check nextents/naextents/nblocks. */
> +	maximal_sized_exts = true;

Shouldn't this be set by xfs_bmap_count_blocks()?  It's purely an out
parameter.

>  	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
> -			&nextents, &count);
> +			&nextents, &count, &maximal_sized_exts);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents < be32_to_cpu(dip->di_nextents))
> +	if (nextents < be32_to_cpu(dip->di_nextents) || !maximal_sized_exts)
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
> +	maximal_sized_exts = true;
>  	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
> -			&nextents, &acount);
> +			&nextents, &acount, &maximal_sized_exts);
>  	if (!xchk_should_check_xref(sc, &error, NULL))
>  		return;
> -	if (nextents != be16_to_cpu(dip->di_anextents))
> +	if (nextents != be16_to_cpu(dip->di_anextents) || !maximal_sized_exts)
>  		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
>  
>  	/* Check nblocks against the inode. */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index e7d68318e6a5..eca39677a46f 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -176,6 +176,25 @@ xfs_bmap_rtalloc(
>   * Extent tree block counting routines.
>   */
>  
> +STATIC bool
> +is_maximal_extent(
> +	struct xfs_ifork	*ifp,
> +	struct xfs_iext_cursor	*icur,
> +	struct xfs_bmbt_irec	*got)
> +{
> +	struct xfs_bmbt_irec	left;
> +
> +	if (xfs_iext_peek_prev_extent(ifp, icur, &left) &&
> +		!isnullstartblock(left.br_startblock) &&
> +		left.br_startoff + left.br_blockcount == got->br_startoff &&
> +		left.br_startblock + left.br_blockcount == got->br_startblock &&
> +		left.br_state == got->br_state &&
> +		left.br_blockcount + got->br_blockcount <= MAXEXTLEN)
> +		return false;

Please don't align the if test code with the statement body.

> +	else

No need for the else here.

> +		return true;
> +}
> +
>  /*
>   * Count leaf blocks given a range of extent records.  Delayed allocation
>   * extents are not counted towards the totals.
> @@ -183,7 +202,8 @@ xfs_bmap_rtalloc(
>  xfs_extnum_t
>  xfs_bmap_count_leaves(
>  	struct xfs_ifork	*ifp,
> -	xfs_filblks_t		*count)
> +	xfs_filblks_t		*count,
> +	bool			*maximal_sized_exts)
>  {
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_irec	got;
> @@ -191,6 +211,10 @@ xfs_bmap_count_leaves(
>  
>  	for_each_xfs_iext(ifp, &icur, &got) {
>  		if (!isnullstartblock(got.br_startblock)) {
> +			if (maximal_sized_exts)
> +				*maximal_sized_exts =
> +					is_maximal_extent(ifp, &icur, &got);

Shouldn't this be *maximal_sized_exts &= is_maximal_extent(); ?

Otherwise this only tells us if the last extent in the fork is maximal.

I also wonder if it's really worth the extra complexity to make the
boolean an optional argument, since there are callers that pass in a
count pointer that's a dummy value.

--D

> +
>  			*count += got.br_blockcount;
>  			numrecs++;
>  		}
> @@ -209,7 +233,8 @@ xfs_bmap_count_blocks(
>  	struct xfs_inode	*ip,
>  	int			whichfork,
>  	xfs_extnum_t		*nextents,
> -	xfs_filblks_t		*count)
> +	xfs_filblks_t		*count,
> +	bool			*maximal_sized_exts)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> @@ -246,7 +271,8 @@ xfs_bmap_count_blocks(
>  
>  		/* fall through */
>  	case XFS_DINODE_FMT_EXTENTS:
> -		*nextents = xfs_bmap_count_leaves(ifp, count);
> +		*nextents = xfs_bmap_count_leaves(ifp, count,
> +				maximal_sized_exts);
>  		break;
>  	}
>  
> @@ -1442,14 +1468,14 @@ xfs_swap_extent_forks(
>  	if (XFS_IFORK_Q(ip) && ip->i_afp->if_nextents > 0 &&
>  	    ip->i_afp->if_format != XFS_DINODE_FMT_LOCAL) {
>  		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
> -				&aforkblks);
> +				&aforkblks, NULL);
>  		if (error)
>  			return error;
>  	}
>  	if (XFS_IFORK_Q(tip) && tip->i_afp->if_nextents > 0 &&
>  	    tip->i_afp->if_format != XFS_DINODE_FMT_LOCAL) {
>  		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
> -				&taforkblks);
> +				&taforkblks, NULL);
>  		if (error)
>  			return error;
>  	}
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 9f993168b55b..7b0ce227c7bd 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -71,10 +71,11 @@ int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
>  
>  xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
>  
> -xfs_extnum_t xfs_bmap_count_leaves(struct xfs_ifork *ifp, xfs_filblks_t *count);
> +xfs_extnum_t xfs_bmap_count_leaves(struct xfs_ifork *ifp, xfs_filblks_t *count,
> +		bool *maximal_sized_exts);
>  int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
>  			  int whichfork, xfs_extnum_t *nextents,
> -			  xfs_filblks_t *count);
> +			  xfs_filblks_t *count, bool *maximal_sized_exts);
>  
>  int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
>  			      xfs_off_t len);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 742d1413e2d0..04fcca5583b3 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1170,7 +1170,7 @@ xfs_qm_dqusage_adjust(
>  				goto error0;
>  		}
>  
> -		xfs_bmap_count_leaves(ifp, &rtblks);
> +		xfs_bmap_count_leaves(ifp, &rtblks, NULL);
>  	}
>  
>  	nblks = (xfs_qcnt_t)ip->i_d.di_nblocks - rtblks;
> -- 
> 2.29.2
> 

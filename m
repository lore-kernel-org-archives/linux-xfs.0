Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0471C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 23:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbiADXaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 18:30:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50828 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiADXaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 18:30:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ACFD615EF
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 23:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB13C36AE0;
        Tue,  4 Jan 2022 23:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641339022;
        bh=2mtJtIx6UcpadHzxkzSvy0XQu0hy+6/GhAn8UVxKg74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cSAJd1mnnFf2HEaVWhkgIP9yCZD9CUklJfyQ8rNklTWtXf7gpZuvtK9IufTGFI+mu
         Cr0Z9QKJHPQoRq6hjp6wlIqo+GyN0pcm+bqLPFSFRMhLB+mAcNVZy8JCAeWv+h/97Z
         0xBB0uigSI6oldeW4r8W5ynLvhPKs/2pIu9AXg3Maqz7xy7IiwfbULs4iaUqf3Q7tO
         GEIvVpvhtBrNTXCAvzyufJwzUy/H9L8RzW4t61n8B0JZit+exhR6zQ1GxMYNIX+qsN
         +NWB6CM5w4maaC3wEmNOjwxWVNhvOxAs8Tbiooj19xfcJovJAUBjXfB5DcLgleFgDV
         NxC0zSAOdMQ7g==
Date:   Tue, 4 Jan 2022 15:30:21 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 02/16] xfs: Introduce xfs_iext_max_nextents() helper
Message-ID: <20220104233021.GH31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-3-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-3-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:05PM +0530, Chandan Babu R wrote:
> xfs_iext_max_nextents() returns the maximum number of extents possible for one
> of data, cow or attribute fork. This helper will be extended further in a
> future commit when maximum extent counts associated with data/attribute forks
> are increased.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Pretty straightforward...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 9 ++++-----
>  fs/xfs/libxfs/xfs_inode_buf.c  | 8 +++-----
>  fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h | 8 ++++++++
>  4 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4dccd4d90622..75e8e8a97568 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -74,13 +74,12 @@ xfs_bmap_compute_maxlevels(
>  	 * ATTR2 we have to assume the worst case scenario of a minimum size
>  	 * available.
>  	 */
> -	if (whichfork == XFS_DATA_FORK) {
> -		maxleafents = MAXEXTNUM;
> +	maxleafents = xfs_iext_max_nextents(whichfork);
> +	if (whichfork == XFS_DATA_FORK)
>  		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
> -	} else {
> -		maxleafents = MAXAEXTNUM;
> +	else
>  		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
> -	}
> +
>  	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
>  	minleafrecs = mp->m_bmap_dmnr[0];
>  	minnoderecs = mp->m_bmap_dmnr[1];
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index cae9708c8587..e6f9bdc4558f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -337,6 +337,7 @@ xfs_dinode_verify_fork(
>  	int			whichfork)
>  {
>  	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		max_extents;
>  
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
> @@ -358,12 +359,9 @@ xfs_dinode_verify_fork(
>  			return __this_address;
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		if (whichfork == XFS_ATTR_FORK) {
> -			if (di_nextents > MAXAEXTNUM)
> -				return __this_address;
> -		} else if (di_nextents > MAXEXTNUM) {
> +		max_extents = xfs_iext_max_nextents(whichfork);
> +		if (di_nextents > max_extents)
>  			return __this_address;
> -		}
>  		break;
>  	default:
>  		return __this_address;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 9149f4f796fc..e136c29a0ec1 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -744,7 +744,7 @@ xfs_iext_count_may_overflow(
>  	if (whichfork == XFS_COW_FORK)
>  		return 0;
>  
> -	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
> +	max_exts = xfs_iext_max_nextents(whichfork);
>  
>  	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
>  		max_exts = 10;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 3d64a3acb0ed..2605f7ff8fc1 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -133,6 +133,14 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>  	return ifp->if_format;
>  }
>  
> +static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
> +{
> +	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
> +		return MAXEXTNUM;
> +
> +	return MAXAEXTNUM;
> +}
> +
>  struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
>  				xfs_extnum_t nextents);
>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
> -- 
> 2.30.2
> 

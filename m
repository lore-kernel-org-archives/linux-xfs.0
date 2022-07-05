Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D07C43334
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 22:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiGEWn2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 18:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGEWn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 18:43:27 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D921DDE
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 15:43:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 49E9810E8235;
        Wed,  6 Jul 2022 08:43:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o8rGJ-00F0OU-J7; Wed, 06 Jul 2022 08:43:19 +1000
Date:   Wed, 6 Jul 2022 08:43:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/3] xfs: use XFS_IFORK_Q to determine the presence of an
 xattr fork
Message-ID: <20220705224319.GF227878@dread.disaster.area>
References: <165705897408.2826746.14673631830829415034.stgit@magnolia>
 <165705899127.2826746.12423521635977762094.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165705899127.2826746.12423521635977762094.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62c4be8a
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=h1tzDQmFr-91kSAHjTcA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 05, 2022 at 03:09:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Modify xfs_ifork_ptr to return a NULL pointer if the caller asks for the
> attribute fork but i_forkoff is zero.  This eliminates the ambiguity
> between i_forkoff and i_af.if_present, which should make it easier to
> understand the lifetime of attr forks.
> 
> While we're at it, remove the if_present checks around calls to
> xfs_idestroy_fork and xfs_ifork_zap_attr since they can both handle attr
> forks that have already been torn down.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c       |    2 --
>  fs/xfs/libxfs/xfs_attr.h       |    2 +-
>  fs/xfs/libxfs/xfs_bmap.c       |    1 -
>  fs/xfs/libxfs/xfs_inode_buf.c  |    1 -
>  fs/xfs/libxfs/xfs_inode_fork.c |    7 +------
>  fs/xfs/libxfs/xfs_inode_fork.h |    1 -
>  fs/xfs/xfs_attr_inactive.c     |   11 ++++-------
>  fs/xfs/xfs_attr_list.c         |    1 -
>  fs/xfs/xfs_icache.c            |    8 +++-----
>  fs/xfs/xfs_inode.c             |    5 ++---
>  fs/xfs/xfs_inode.h             |    2 +-
>  11 files changed, 12 insertions(+), 29 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 6b0d744e5947..002d7dea2190 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -69,8 +69,6 @@ xfs_inode_hasattr(
>  {
>  	if (!XFS_IFORK_Q(ip))
>  		return 0;
> -	if (!ip->i_af.if_present)
> -		return 0;

I much prefer the "if (attr fork present)" style over the
XFS_IFORK_Q() macro. I always have to go look up what all the whacky
IFORK/DFORK macros actually mean, so if we are changing all this
code can we wrap this in something like:

static inline bool
xfs_inode_has_attr_fork(struct xfs_inode *ip)
{
	if (ip->i_forkoff)
		return true;
	return false;
}

And then xfs_inode_hasattr() becomes:

	if (!xfs_inode_has_attr_fork(ip)
		return false;
	if (ip->i_af.if_format == XFS_DINODE_FMT_EXTENTS &&
	    ip->i_af.if_nextents == 0)
		return false;
....

Cheers,

Dave.
>  	if (ip->i_af.if_format == XFS_DINODE_FMT_EXTENTS &&
>  	    ip->i_af.if_nextents == 0)
>  		return 0;
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 0f100db504ee..36371c3b9069 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -576,7 +576,7 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
>  	 * context, i_af is guaranteed to exist. Hence if the attr fork is
>  	 * null, we were called from a pure remove operation and so we are done.
>  	 */
> -	if (!args->dp->i_af.if_present)
> +	if (!XFS_IFORK_Q(args->dp))
>  		return XFS_DAS_DONE;
>  
>  	args->op_flags |= XFS_DA_OP_ADDNAME;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4abb5b4cee0c..77ab5ac1fcbc 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1041,7 +1041,6 @@ xfs_bmap_add_attrfork(
>  	error = xfs_bmap_set_attrforkoff(ip, size, &version);
>  	if (error)
>  		goto trans_cancel;
> -	ASSERT(!ip->i_af.if_present);
>  
>  	xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
>  	logflags = 0;
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index e203c80c1bf8..2aef27b042fe 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -178,7 +178,6 @@ xfs_inode_from_disk(
>  	xfs_failaddr_t		fa;
>  
>  	ASSERT(ip->i_cowfp == NULL);
> -	ASSERT(!ip->i_af.if_present);
>  
>  	fa = xfs_dinode_verify(ip->i_mount, ip->i_ino, from);
>  	if (fa) {
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 9d5141c21eee..b0370b837166 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -282,9 +282,6 @@ xfs_ifork_init_attr(
>  	enum xfs_dinode_fmt	format,
>  	xfs_extnum_t		nextents)
>  {
> -	ASSERT(!ip->i_af.if_present);
> -
> -	ip->i_af.if_present = 1;
>  	ip->i_af.if_format = format;
>  	ip->i_af.if_nextents = nextents;
>  }
> @@ -293,7 +290,6 @@ void
>  xfs_ifork_zap_attr(
>  	struct xfs_inode	*ip)
>  {
> -	ASSERT(ip->i_af.if_present);
>  	ASSERT(ip->i_af.if_broot == NULL);
>  	ASSERT(ip->i_af.if_u1.if_data == NULL);
>  	ASSERT(ip->i_af.if_height == 0);
> @@ -683,7 +679,6 @@ xfs_ifork_init_cow(
>  
>  	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_cache,
>  				       GFP_NOFS | __GFP_NOFAIL);
> -	ip->i_cowfp->if_present = 1;
>  	ip->i_cowfp->if_format = XFS_DINODE_FMT_EXTENTS;
>  }
>  
> @@ -722,7 +717,7 @@ xfs_ifork_verify_local_attr(
>  	struct xfs_ifork	*ifp = &ip->i_af;
>  	xfs_failaddr_t		fa;
>  
> -	if (!ifp->if_present)
> +	if (!XFS_IFORK_Q(ip))
>  		fa = __this_address;
>  	else
>  		fa = xfs_attr_shortform_verify(ip);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 63015e9cee14..0b912bbe4f4b 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -24,7 +24,6 @@ struct xfs_ifork {
>  	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
>  	short			if_broot_bytes;	/* bytes allocated for root */
>  	int8_t			if_format;	/* format of this fork */
> -	int8_t			if_present;	/* 1 if present */
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index dbe715fe92ce..ec20ad7a9001 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -362,12 +362,11 @@ xfs_attr_inactive(
>  
>  	/*
>  	 * Invalidate and truncate the attribute fork extents. Make sure the
> -	 * fork actually has attributes as otherwise the invalidation has no
> +	 * fork actually has xattr blocks as otherwise the invalidation has no
>  	 * blocks to read and returns an error. In this case, just do the fork
>  	 * removal below.
>  	 */
> -	if (xfs_inode_hasattr(dp) &&
> -	    dp->i_af.if_format != XFS_DINODE_FMT_LOCAL) {
> +	if (dp->i_af.if_nextents > 0) {
>  		error = xfs_attr3_root_inactive(&trans, dp);
>  		if (error)
>  			goto out_cancel;
> @@ -388,10 +387,8 @@ xfs_attr_inactive(
>  	xfs_trans_cancel(trans);
>  out_destroy_fork:
>  	/* kill the in-core attr fork before we drop the inode lock */
> -	if (dp->i_af.if_present) {
> -		xfs_idestroy_fork(&dp->i_af);
> -		xfs_ifork_zap_attr(dp);
> -	}
> +	xfs_idestroy_fork(&dp->i_af);
> +	xfs_ifork_zap_attr(dp);
>  	if (lock_mode)
>  		xfs_iunlock(dp, lock_mode);
>  	return error;
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 6a832ee07916..99bbbe1a0e44 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -61,7 +61,6 @@ xfs_attr_shortform_list(
>  	int				sbsize, nsbuf, count, i;
>  	int				error = 0;
>  
> -	ASSERT(dp->i_af.if_present);
>  	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
>  	ASSERT(sf != NULL);
>  	if (!sf->hdr.count)
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e08dedfb7f9d..026c63234f8d 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -102,7 +102,6 @@ xfs_inode_alloc(
>  	memset(&ip->i_af, 0, sizeof(ip->i_af));
>  	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
>  	memset(&ip->i_df, 0, sizeof(ip->i_df));
> -	ip->i_df.if_present = 1;
>  	ip->i_flags = 0;
>  	ip->i_delayed_blks = 0;
>  	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
> @@ -132,10 +131,9 @@ xfs_inode_free_callback(
>  		break;
>  	}
>  
> -	if (ip->i_af.if_present) {
> -		xfs_idestroy_fork(&ip->i_af);
> -		xfs_ifork_zap_attr(ip);
> -	}
> +	xfs_idestroy_fork(&ip->i_af);
> +	xfs_ifork_zap_attr(ip);
> +
>  	if (ip->i_cowfp) {
>  		xfs_idestroy_fork(ip->i_cowfp);
>  		kmem_cache_free(xfs_ifork_cache, ip->i_cowfp);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c9c26d782a38..2f559e16a4db 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -125,7 +125,7 @@ xfs_ilock_attr_map_shared(
>  {
>  	uint			lock_mode = XFS_ILOCK_SHARED;
>  
> -	if (ip->i_af.if_present && xfs_need_iread_extents(&ip->i_af))
> +	if (XFS_IFORK_Q(ip) && xfs_need_iread_extents(&ip->i_af))
>  		lock_mode = XFS_ILOCK_EXCL;
>  	xfs_ilock(ip, lock_mode);
>  	return lock_mode;
> @@ -1768,7 +1768,6 @@ xfs_inactive(
>  			goto out;
>  	}
>  
> -	ASSERT(!ip->i_af.if_present);
>  	ASSERT(ip->i_forkoff == 0);
>  
>  	/*
> @@ -3488,7 +3487,7 @@ xfs_iflush(
>  	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL &&
>  	    xfs_ifork_verify_local_data(ip))
>  		goto flush_out;
> -	if (ip->i_af.if_present &&
> +	if (XFS_IFORK_Q(ip) &&
>  	    ip->i_af.if_format == XFS_DINODE_FMT_LOCAL &&
>  	    xfs_ifork_verify_local_attr(ip))
>  		goto flush_out;
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 045bad62ac25..9bda01311c2f 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -86,7 +86,7 @@ xfs_ifork_ptr(
>  	case XFS_DATA_FORK:
>  		return &ip->i_df;
>  	case XFS_ATTR_FORK:
> -		if (!ip->i_af.if_present)
> +		if (!XFS_IFORK_Q(ip))
>  			return NULL;
>  		return &ip->i_af;
>  	case XFS_COW_FORK:
> 
> 

-- 
Dave Chinner
david@fromorbit.com

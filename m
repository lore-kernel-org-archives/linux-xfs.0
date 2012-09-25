Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8PKJeLF103358 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 15:19:40 -0500
Date: Tue, 25 Sep 2012 15:20:54 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/3 v2] xfs: zero allocation_args on the kernel stack
Message-ID: <20120925202054.GA13214@sgi.com>
References: <20120919163133.097340199@sgi.com>
	<20120919163145.587098223@sgi.com>
	<20120920181650.041917183@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120920181650.041917183@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 20, 2012 at 01:16:45PM -0500, Mark Tinguely wrote:
> Zero the kernel stack space that makes up the xfs_alloc_arg structures.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

I'll just double check that you got all usages of xfs_alloc_arg_t:

xfs_inobt_alloc_block... fixed in f5eb8e7c by HCH
xfs_ialloc_ag_alloc... fixed below
xfs_bmbt_alloc_block... also fixed in f5eb8e7c
xfs_bmap_local_to_extents... fixed below
xfs_bmap_extents_to_btree... fixed below
xfs_bmap_btalloc... fixed below
xfs_free_extent... fixed in 0e1edbd9 by Nathan Scott
xfs_alloc_fix_freelist... fixed below

Looks good!

Reviewed-by: Ben Myers <bpm@sgi.com>

> 
> ---
>  fs/xfs/xfs_alloc.c  |    1 +
>  fs/xfs/xfs_bmap.c   |    3 +++
>  fs/xfs/xfs_ialloc.c |    1 +
>  3 files changed, 5 insertions(+)
> 
> Index: b/fs/xfs/xfs_alloc.c
> ===================================================================
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -1866,6 +1866,7 @@ xfs_alloc_fix_freelist(
>  	/*
>  	 * Initialize the args structure.
>  	 */
> +	memset(&targs, 0, sizeof(targs));
>  	targs.tp = tp;
>  	targs.mp = mp;
>  	targs.agbp = agbp;
> Index: b/fs/xfs/xfs_bmap.c
> ===================================================================
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -2437,6 +2437,7 @@ xfs_bmap_btalloc(
>  	 * Normal allocation, done through xfs_alloc_vextent.
>  	 */
>  	tryagain = isaligned = 0;
> +	memset(&args, 0, sizeof(args));
>  	args.tp = ap->tp;
>  	args.mp = mp;
>  	args.fsbno = ap->blkno;
> @@ -3082,6 +3083,7 @@ xfs_bmap_extents_to_btree(
>  	 * Convert to a btree with two levels, one record in root.
>  	 */
>  	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_BTREE);
> +	memset(&args, 0, sizeof(args));
>  	args.tp = tp;
>  	args.mp = mp;
>  	args.firstblock = *firstblock;
> @@ -3237,6 +3239,7 @@ xfs_bmap_local_to_extents(
>  		xfs_buf_t	*bp;	/* buffer for extent block */
>  		xfs_bmbt_rec_host_t *ep;/* extent record pointer */
>  
> +		memset(&args, 0, sizeof(args));
>  		args.tp = tp;
>  		args.mp = ip->i_mount;
>  		args.firstblock = *firstblock;
> Index: b/fs/xfs/xfs_ialloc.c
> ===================================================================
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -250,6 +250,7 @@ xfs_ialloc_ag_alloc(
>  					/* boundary */
>  	struct xfs_perag *pag;
>  
> +	memset(&args, 0, sizeof(args));
>  	args.tp = tp;
>  	args.mp = tp->t_mountp;
>  
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

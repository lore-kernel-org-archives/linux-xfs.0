Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38108 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbeBLS3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Feb 2018 13:29:53 -0500
Date: Mon, 12 Feb 2018 10:29:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Cleanup old XFS_BTREE_* traces
Message-ID: <20180212182948.GB5217@magnolia>
References: <20180212130005.7199-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180212130005.7199-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 12, 2018 at 02:00:05PM +0100, Carlos Maiolino wrote:
> Remove unused legacy btree traces from IRIX era.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Talking to Dave about it, he mentioned XFS_BTREE_TRACE_CURSOR might be worth to
> turn into a proper ftrace trace point, so I didn't touch _CURSOR traces in this
> patchset, and a proper conversion will be sent later, unless it's not worth at
> all, and I should send a V2 also removing TRACE_CURSOR.

TBH I wonder the opposite -- why not turn all of these into tracepoints?
There must have been some reason for capturing the cursor state along
with an integer/ptr/record/key.  It's the XBT_ENTRY/XBT_EXIT stuff that
I think could go away, since ftrace can already record function
entry/exit.

So, all the XFS_BTREE_TRACE_ARG* become their own tracepoints each named
after the function they're in (see example below).  The XBT_ENTRY and
XBT_FXIT traces can be removed entirely; and the XBT_ERROR traces can
become a new trace_xfs_btree_cursor_error tracepoint.

> Cheers
> 
>  fs/xfs/libxfs/xfs_btree.c | 15 ---------------
>  fs/xfs/libxfs/xfs_btree.h |  7 -------
>  2 files changed, 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 79ee4a1951d1..eb324eb9e5cd 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1439,7 +1439,6 @@ xfs_btree_log_keys(
>  	int			last)
>  {
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);

trace_xfs_btree_log_keys(cur, bp, first, last);

then eliminate the XBT_EXIT thing at the end of the function.

--D

>  
>  	if (bp) {
>  		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
> @@ -1465,7 +1464,6 @@ xfs_btree_log_recs(
>  	int			last)
>  {
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
>  
>  	xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
>  	xfs_trans_log_buf(cur->bc_tp, bp,
> @@ -1486,7 +1484,6 @@ xfs_btree_log_ptrs(
>  	int			last)	/* index of last pointer to log */
>  {
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
>  
>  	if (bp) {
>  		struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
> @@ -1544,7 +1541,6 @@ xfs_btree_log_block(
>  	};
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGBI(cur, bp, fields);
>  
>  	if (bp) {
>  		int nbits;
> @@ -1594,7 +1590,6 @@ xfs_btree_increment(
>  	int			lev;
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGI(cur, level);
>  
>  	ASSERT(level < cur->bc_nlevels);
>  
> @@ -1702,7 +1697,6 @@ xfs_btree_decrement(
>  	union xfs_btree_ptr	ptr;
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGI(cur, level);
>  
>  	ASSERT(level < cur->bc_nlevels);
>  
> @@ -1882,7 +1876,6 @@ xfs_btree_lookup(
>  	union xfs_btree_ptr	ptr;	/* ptr to btree block */
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGI(cur, dir);
>  
>  	XFS_BTREE_STATS_INC(cur, lookup);
>  
> @@ -2225,7 +2218,6 @@ xfs_btree_update_keys(
>  		return __xfs_btree_updkeys(cur, level, block, bp, false);
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);
>  
>  	/*
>  	 * Go up the tree from this level toward the root.
> @@ -2273,7 +2265,6 @@ xfs_btree_update(
>  	union xfs_btree_rec	*rp;
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGR(cur, rec);
>  
>  	/* Pick up the current block. */
>  	block = xfs_btree_get_block(cur, 0, &bp);
> @@ -2340,7 +2331,6 @@ xfs_btree_lshift(
>  	int			i;
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGI(cur, level);
>  
>  	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
>  	    level == cur->bc_nlevels - 1)
> @@ -2542,7 +2532,6 @@ xfs_btree_rshift(
>  	int			i;		/* loop counter */
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGI(cur, level);
>  
>  	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
>  	    (level == cur->bc_nlevels - 1))
> @@ -2727,8 +2716,6 @@ __xfs_btree_split(
>  #endif
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGIPK(cur, level, *ptrp, key);
> -
>  	XFS_BTREE_STATS_INC(cur, split);
>  
>  	/* Set up left block (current one). */
> @@ -3310,7 +3297,6 @@ xfs_btree_insrec(
>  	xfs_daddr_t		old_bn;
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGIPR(cur, level, *ptrp, &rec);
>  
>  	ncur = NULL;
>  	lkey = &nkey;
> @@ -3781,7 +3767,6 @@ xfs_btree_delrec(
>  	int			numrecs;	/* temporary numrec count */
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> -	XFS_BTREE_TRACE_ARGI(cur, level);
>  
>  	tcur = NULL;
>  
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 50440b5618e8..7d4e6b16981d 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -483,13 +483,6 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
>   * r = btree record
>   * k = btree key
>   */
> -#define	XFS_BTREE_TRACE_ARGBI(c, b, i)
> -#define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)
> -#define	XFS_BTREE_TRACE_ARGI(c, i)
> -#define	XFS_BTREE_TRACE_ARGIPK(c, i, p, s)
> -#define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)
> -#define	XFS_BTREE_TRACE_ARGIK(c, i, k)
> -#define XFS_BTREE_TRACE_ARGR(c, r)
>  #define	XFS_BTREE_TRACE_CURSOR(c, t)
>  
>  xfs_failaddr_t xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

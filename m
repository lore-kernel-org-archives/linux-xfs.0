Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23608 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751501AbcISXtF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Sep 2016 19:49:05 -0400
Date: Tue, 20 Sep 2016 09:49:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: make xfs btree stats less huge
Message-ID: <20160919234900.GE340@dastard>
References: <1473755322-883-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473755322-883-1-git-send-email-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

Ping?

On Tue, Sep 13, 2016 at 06:28:42PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Embedding a switch statement in every btree stats inc/add adds a lot
> of code overhead to the core btree infrastructure paths. Stats are
> supposed to be small and lightweight, but the btree stats have
> become big and bloated as we've added more btrees. It needs fixing
> because the reflink code will just add more overhead again.
> 
> Convert the v2 btree stats to arrays instead of independent
> variables, and instead use the type to index the specific btree
> array via an enum. This allows us to use array based indexing
> to update the stats, rather than having to derefence variables
> specific to the btree type.
> 
> If we then wrap the xfsstats structure in a union and place uint32_t
> array beside it, and calculate the correct btree stats array base
> array index when creating a btree cursor,  we can easily access
> entries in the stats structure without having to switch names based
> on the btree type.
> 
> We then replace with the switch statement with a simple set of stats
> wrapper macros, resulting in a significant simplification of the
> btree stats code, and:
> 
>    text	   data	    bss	    dec	    hex	filename
>   46485	    144	      8	  46637	   b62d fs/xfs/libxfs/xfs_btree.o.old
>   35957	    144	      8	  36109	   8d0d	fs/xfs/libxfs/xfs_btree.o
> 
> it reduces the core btree infrastructure code size by close to 25%!
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c  |   4 +
>  fs/xfs/libxfs/xfs_bmap_btree.c   |   1 +
>  fs/xfs/libxfs/xfs_btree.h        |  40 +--------
>  fs/xfs/libxfs/xfs_ialloc_btree.c |   2 +
>  fs/xfs/libxfs/xfs_rmap_btree.c   |   1 +
>  fs/xfs/xfs_stats.c               |  10 +--
>  fs/xfs/xfs_stats.h               | 174 ++++++++++++++++-----------------------
>  7 files changed, 88 insertions(+), 144 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 5ba2dac..44cfcd0 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -428,6 +428,10 @@ xfs_allocbt_init_cursor(
>  	cur->bc_btnum = btnum;
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
>  	cur->bc_ops = &xfs_allocbt_ops;
> +	if (btnum == XFS_BTNUM_BNO)
> +		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
> +	else
> +		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
>  
>  	if (btnum == XFS_BTNUM_CNT) {
>  		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index cd85274..5c32e65 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -785,6 +785,7 @@ xfs_bmbt_init_cursor(
>  	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
>  	cur->bc_btnum = XFS_BTNUM_BMAP;
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> +	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
>  
>  	cur->bc_ops = &xfs_bmbt_ops;
>  	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 04d0865..c464cb3 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -105,43 +105,10 @@ union xfs_btree_rec {
>  /*
>   * Generic stats interface
>   */
> -#define __XFS_BTREE_STATS_INC(mp, type, stat) \
> -	XFS_STATS_INC(mp, xs_ ## type ## _2_ ## stat)
>  #define XFS_BTREE_STATS_INC(cur, stat)	\
> -do {    \
> -	struct xfs_mount *__mp = cur->bc_mp; \
> -	switch (cur->bc_btnum) {  \
> -	case XFS_BTNUM_BNO: __XFS_BTREE_STATS_INC(__mp, abtb, stat); break; \
> -	case XFS_BTNUM_CNT: __XFS_BTREE_STATS_INC(__mp, abtc, stat); break; \
> -	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(__mp, bmbt, stat); break; \
> -	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
> -	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
> -	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(__mp, rmap, stat); break; \
> -	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
> -	}       \
> -} while (0)
> -
> -#define __XFS_BTREE_STATS_ADD(mp, type, stat, val) \
> -	XFS_STATS_ADD(mp, xs_ ## type ## _2_ ## stat, val)
> -#define XFS_BTREE_STATS_ADD(cur, stat, val)  \
> -do {    \
> -	struct xfs_mount *__mp = cur->bc_mp; \
> -	switch (cur->bc_btnum) {  \
> -	case XFS_BTNUM_BNO:	\
> -		__XFS_BTREE_STATS_ADD(__mp, abtb, stat, val); break; \
> -	case XFS_BTNUM_CNT:	\
> -		__XFS_BTREE_STATS_ADD(__mp, abtc, stat, val); break; \
> -	case XFS_BTNUM_BMAP:	\
> -		__XFS_BTREE_STATS_ADD(__mp, bmbt, stat, val); break; \
> -	case XFS_BTNUM_INO:	\
> -		__XFS_BTREE_STATS_ADD(__mp, ibt, stat, val); break; \
> -	case XFS_BTNUM_FINO:	\
> -		__XFS_BTREE_STATS_ADD(__mp, fibt, stat, val); break; \
> -	case XFS_BTNUM_RMAP:	\
> -		__XFS_BTREE_STATS_ADD(__mp, rmap, stat, val); break; \
> -	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break; \
> -	}       \
> -} while (0)
> +	XFS_STATS_INC_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat)
> +#define XFS_BTREE_STATS_ADD(cur, stat, val)	\
> +	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
>  
>  #define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
>  
> @@ -250,6 +217,7 @@ typedef struct xfs_btree_cur
>  	__uint8_t	bc_nlevels;	/* number of levels in the tree */
>  	__uint8_t	bc_blocklog;	/* log2(blocksize) of btree blocks */
>  	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
> +	int		bc_statoff;	/* offset of btre stats array */
>  	union {
>  		struct {			/* needed for BNO, CNT, INO */
>  			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 31ca220..f93c288 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -365,9 +365,11 @@ xfs_inobt_init_cursor(
>  	if (btnum == XFS_BTNUM_INO) {
>  		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
>  		cur->bc_ops = &xfs_inobt_ops;
> +		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
>  	} else {
>  		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
>  		cur->bc_ops = &xfs_finobt_ops;
> +		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
>  	}
>  
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 17b8eeb..a749d3b 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -483,6 +483,7 @@ xfs_rmapbt_init_cursor(
>  	cur->bc_blocklog = mp->m_sb.sb_blocklog;
>  	cur->bc_ops = &xfs_rmapbt_ops;
>  	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
> +	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
>  
>  	cur->bc_private.a.agbp = agbp;
>  	cur->bc_private.a.agno = agno;
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 6e812fe0..6e021a7 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -79,9 +79,9 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  	}
>  	/* extra precision counters */
>  	for_each_possible_cpu(i) {
> -		xs_xstrat_bytes += per_cpu_ptr(stats, i)->xs_xstrat_bytes;
> -		xs_write_bytes += per_cpu_ptr(stats, i)->xs_write_bytes;
> -		xs_read_bytes += per_cpu_ptr(stats, i)->xs_read_bytes;
> +		xs_xstrat_bytes += per_cpu_ptr(stats, i)->s.xs_xstrat_bytes;
> +		xs_write_bytes += per_cpu_ptr(stats, i)->s.xs_write_bytes;
> +		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
>  	}
>  
>  	len += snprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
> @@ -105,9 +105,9 @@ void xfs_stats_clearall(struct xfsstats __percpu *stats)
>  	for_each_possible_cpu(c) {
>  		preempt_disable();
>  		/* save vn_active, it's a universal truth! */
> -		vn_active = per_cpu_ptr(stats, c)->vn_active;
> +		vn_active = per_cpu_ptr(stats, c)->s.vn_active;
>  		memset(per_cpu_ptr(stats, c), 0, sizeof(*stats));
> -		per_cpu_ptr(stats, c)->vn_active = vn_active;
> +		per_cpu_ptr(stats, c)->s.vn_active = vn_active;
>  		preempt_enable();
>  	}
>  }
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 657865f..7a57c01 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -21,10 +21,30 @@
>  
>  #include <linux/percpu.h>
>  
> +enum {
> +	__XBTS_lookup = 0,
> +	__XBTS_compare = 1,
> +	__XBTS_insrec = 2,
> +	__XBTS_delrec = 3,
> +	__XBTS_newroot = 4,
> +	__XBTS_killroot = 5,
> +	__XBTS_increment = 6,
> +	__XBTS_decrement = 7,
> +	__XBTS_lshift = 8,
> +	__XBTS_rshift = 9,
> +	__XBTS_split = 10,
> +	__XBTS_join = 11,
> +	__XBTS_alloc = 12,
> +	__XBTS_free = 13,
> +	__XBTS_moves = 14,
> +
> +	__XBTS_MAX = 15,
> +};
> +
>  /*
>   * XFS global statistics
>   */
> -struct xfsstats {
> +struct __xfsstats {
>  # define XFSSTAT_END_EXTENT_ALLOC	4
>  	__uint32_t		xs_allocx;
>  	__uint32_t		xs_allocb;
> @@ -117,102 +137,18 @@ struct xfsstats {
>  	__uint32_t		xb_page_found;
>  	__uint32_t		xb_get_read;
>  /* Version 2 btree counters */
> -#define XFSSTAT_END_ABTB_V2		(XFSSTAT_END_BUF+15)
> -	__uint32_t		xs_abtb_2_lookup;
> -	__uint32_t		xs_abtb_2_compare;
> -	__uint32_t		xs_abtb_2_insrec;
> -	__uint32_t		xs_abtb_2_delrec;
> -	__uint32_t		xs_abtb_2_newroot;
> -	__uint32_t		xs_abtb_2_killroot;
> -	__uint32_t		xs_abtb_2_increment;
> -	__uint32_t		xs_abtb_2_decrement;
> -	__uint32_t		xs_abtb_2_lshift;
> -	__uint32_t		xs_abtb_2_rshift;
> -	__uint32_t		xs_abtb_2_split;
> -	__uint32_t		xs_abtb_2_join;
> -	__uint32_t		xs_abtb_2_alloc;
> -	__uint32_t		xs_abtb_2_free;
> -	__uint32_t		xs_abtb_2_moves;
> -#define XFSSTAT_END_ABTC_V2		(XFSSTAT_END_ABTB_V2+15)
> -	__uint32_t		xs_abtc_2_lookup;
> -	__uint32_t		xs_abtc_2_compare;
> -	__uint32_t		xs_abtc_2_insrec;
> -	__uint32_t		xs_abtc_2_delrec;
> -	__uint32_t		xs_abtc_2_newroot;
> -	__uint32_t		xs_abtc_2_killroot;
> -	__uint32_t		xs_abtc_2_increment;
> -	__uint32_t		xs_abtc_2_decrement;
> -	__uint32_t		xs_abtc_2_lshift;
> -	__uint32_t		xs_abtc_2_rshift;
> -	__uint32_t		xs_abtc_2_split;
> -	__uint32_t		xs_abtc_2_join;
> -	__uint32_t		xs_abtc_2_alloc;
> -	__uint32_t		xs_abtc_2_free;
> -	__uint32_t		xs_abtc_2_moves;
> -#define XFSSTAT_END_BMBT_V2		(XFSSTAT_END_ABTC_V2+15)
> -	__uint32_t		xs_bmbt_2_lookup;
> -	__uint32_t		xs_bmbt_2_compare;
> -	__uint32_t		xs_bmbt_2_insrec;
> -	__uint32_t		xs_bmbt_2_delrec;
> -	__uint32_t		xs_bmbt_2_newroot;
> -	__uint32_t		xs_bmbt_2_killroot;
> -	__uint32_t		xs_bmbt_2_increment;
> -	__uint32_t		xs_bmbt_2_decrement;
> -	__uint32_t		xs_bmbt_2_lshift;
> -	__uint32_t		xs_bmbt_2_rshift;
> -	__uint32_t		xs_bmbt_2_split;
> -	__uint32_t		xs_bmbt_2_join;
> -	__uint32_t		xs_bmbt_2_alloc;
> -	__uint32_t		xs_bmbt_2_free;
> -	__uint32_t		xs_bmbt_2_moves;
> -#define XFSSTAT_END_IBT_V2		(XFSSTAT_END_BMBT_V2+15)
> -	__uint32_t		xs_ibt_2_lookup;
> -	__uint32_t		xs_ibt_2_compare;
> -	__uint32_t		xs_ibt_2_insrec;
> -	__uint32_t		xs_ibt_2_delrec;
> -	__uint32_t		xs_ibt_2_newroot;
> -	__uint32_t		xs_ibt_2_killroot;
> -	__uint32_t		xs_ibt_2_increment;
> -	__uint32_t		xs_ibt_2_decrement;
> -	__uint32_t		xs_ibt_2_lshift;
> -	__uint32_t		xs_ibt_2_rshift;
> -	__uint32_t		xs_ibt_2_split;
> -	__uint32_t		xs_ibt_2_join;
> -	__uint32_t		xs_ibt_2_alloc;
> -	__uint32_t		xs_ibt_2_free;
> -	__uint32_t		xs_ibt_2_moves;
> -#define XFSSTAT_END_FIBT_V2		(XFSSTAT_END_IBT_V2+15)
> -	__uint32_t		xs_fibt_2_lookup;
> -	__uint32_t		xs_fibt_2_compare;
> -	__uint32_t		xs_fibt_2_insrec;
> -	__uint32_t		xs_fibt_2_delrec;
> -	__uint32_t		xs_fibt_2_newroot;
> -	__uint32_t		xs_fibt_2_killroot;
> -	__uint32_t		xs_fibt_2_increment;
> -	__uint32_t		xs_fibt_2_decrement;
> -	__uint32_t		xs_fibt_2_lshift;
> -	__uint32_t		xs_fibt_2_rshift;
> -	__uint32_t		xs_fibt_2_split;
> -	__uint32_t		xs_fibt_2_join;
> -	__uint32_t		xs_fibt_2_alloc;
> -	__uint32_t		xs_fibt_2_free;
> -	__uint32_t		xs_fibt_2_moves;
> -#define XFSSTAT_END_RMAP_V2		(XFSSTAT_END_FIBT_V2+15)
> -	__uint32_t		xs_rmap_2_lookup;
> -	__uint32_t		xs_rmap_2_compare;
> -	__uint32_t		xs_rmap_2_insrec;
> -	__uint32_t		xs_rmap_2_delrec;
> -	__uint32_t		xs_rmap_2_newroot;
> -	__uint32_t		xs_rmap_2_killroot;
> -	__uint32_t		xs_rmap_2_increment;
> -	__uint32_t		xs_rmap_2_decrement;
> -	__uint32_t		xs_rmap_2_lshift;
> -	__uint32_t		xs_rmap_2_rshift;
> -	__uint32_t		xs_rmap_2_split;
> -	__uint32_t		xs_rmap_2_join;
> -	__uint32_t		xs_rmap_2_alloc;
> -	__uint32_t		xs_rmap_2_free;
> -	__uint32_t		xs_rmap_2_moves;
> +#define XFSSTAT_END_ABTB_V2		(XFSSTAT_END_BUF+__XBTS_MAX)
> +	__uint32_t		xs_abtb_2[__XBTS_MAX];
> +#define XFSSTAT_END_ABTC_V2		(XFSSTAT_END_ABTB_V2+__XBTS_MAX)
> +	__uint32_t		xs_abtc_2[__XBTS_MAX];
> +#define XFSSTAT_END_BMBT_V2		(XFSSTAT_END_ABTC_V2+__XBTS_MAX)
> +	__uint32_t		xs_bmbt_2[__XBTS_MAX];
> +#define XFSSTAT_END_IBT_V2		(XFSSTAT_END_BMBT_V2+__XBTS_MAX)
> +	__uint32_t		xs_ibt_2[__XBTS_MAX];
> +#define XFSSTAT_END_FIBT_V2		(XFSSTAT_END_IBT_V2+__XBTS_MAX)
> +	__uint32_t		xs_fibt_2[__XBTS_MAX];
> +#define XFSSTAT_END_RMAP_V2		(XFSSTAT_END_FIBT_V2+__XBTS_MAX)
> +	__uint32_t		xs_rmap_2[__XBTS_MAX];
>  #define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_RMAP_V2+6)
>  	__uint32_t		xs_qm_dqreclaims;
>  	__uint32_t		xs_qm_dqreclaim_misses;
> @@ -229,26 +165,58 @@ struct xfsstats {
>  	__uint64_t		xs_read_bytes;
>  };
>  
> +struct xfsstats {
> +	union {
> +		struct __xfsstats	s;
> +		uint32_t		a[XFSSTAT_END_XQMSTAT];
> +	};
> +};
> +
> +/*
> + * simple wrapper for getting the array index of s struct member offset
> + */
> +#define XFS_STATS_CALC_INDEX(member)	\
> +	(offsetof(struct __xfsstats, member) / (int)sizeof(__uint32_t))
> +
> +
>  int xfs_stats_format(struct xfsstats __percpu *stats, char *buf);
>  void xfs_stats_clearall(struct xfsstats __percpu *stats);
>  extern struct xstats xfsstats;
>  
>  #define XFS_STATS_INC(mp, v)					\
>  do {								\
> -	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v++;	\
> -	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->v++;	\
> +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->s.v++;	\
> +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->s.v++;	\
>  } while (0)
>  
>  #define XFS_STATS_DEC(mp, v)					\
>  do {								\
> -	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v--;	\
> -	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->v--;	\
> +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->s.v--;	\
> +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->s.v--;	\
>  } while (0)
>  
>  #define XFS_STATS_ADD(mp, v, inc)					\
>  do {									\
> -	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->v += (inc);	\
> -	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->v += (inc);	\
> +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->s.v += (inc);	\
> +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->s.v += (inc);	\
> +} while (0)
> +
> +#define XFS_STATS_INC_OFF(mp, off)				\
> +do {								\
> +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->a[off]++;	\
> +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->a[off]++;	\
> +} while (0)
> +
> +#define XFS_STATS_DEC_OFF(mp, off)					\
> +do {								\
> +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->a[off];	\
> +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->a[off];	\
> +} while (0)
> +
> +#define XFS_STATS_ADD_OFF(mp, off, inc)					\
> +do {									\
> +	per_cpu_ptr(xfsstats.xs_stats, current_cpu())->a[off] += (inc);	\
> +	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->a[off] += (inc);	\
>  } while (0)
>  
>  #if defined(CONFIG_PROC_FS)
> -- 
> 2.8.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com

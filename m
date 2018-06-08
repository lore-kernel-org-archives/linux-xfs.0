Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36690 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752411AbeFHQxp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jun 2018 12:53:45 -0400
Date: Fri, 8 Jun 2018 09:53:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: remove unused macros
Message-ID: <20180608165329.GR25007@magnolia>
References: <3793c1d5-6269-468b-f6f1-e50597879dcc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3793c1d5-6269-468b-f6f1-e50597879dcc@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Jun 08, 2018 at 11:48:01AM -0500, Eric Sandeen wrote:
> A lot of dead macros are lying around xfsprogs; some are just
> ancient cruft while others are the result of shifting libxfs
> interfaces, but we can remove them.
> 
> (I've left a few unused macros in place where they exist with
> other macros for symmetry or completeness.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
>  db/btblock.c              |    5 -----
>  db/metadump.c             |    8 --------
>  db/symlink.c              |    1 -
>  estimate/xfs_estimate.c   |    1 -
>  fsr/xfs_fsr.c             |    4 ----
>  include/xfs_trace.h       |    4 ----
>  libxfs/libxfs_api_defs.h  |    2 --
>  libxlog/xfs_log_recover.c |    2 --
>  repair/attr_repair.c      |    1 -
>  repair/incore.h           |    2 --
>  repair/incore_ext.c       |    8 --------
>  repair/scan.c             |    2 --
>  repair/slab.c             |    1 -
>  repair/xfs_repair.c       |    4 ----
>  15 files changed, 46 deletions(-)
> 
> 
> diff --git a/db/btblock.c b/db/btblock.c
> index 9f506df..0c76394 100644
> --- a/db/btblock.c
> +++ b/db/btblock.c
> @@ -728,8 +728,6 @@ const field_t	rmapbt_key_flds[] = {
>  #undef HI_KOFF
>  #undef KOFF
>  
> -#define	ROFF(f)	bitize(offsetof(struct xfs_rmap_rec, rm_ ## f))
> -
>  #define RMAPBT_STARTBLOCK_BITOFF	0
>  #define RMAPBT_BLOCKCOUNT_BITOFF	(RMAPBT_STARTBLOCK_BITOFF + RMAPBT_STARTBLOCK_BITLEN)
>  #define RMAPBT_OWNER_BITOFF		(RMAPBT_BLOCKCOUNT_BITOFF + RMAPBT_BLOCKCOUNT_BITLEN)
> @@ -752,7 +750,6 @@ const field_t	rmapbt_rec_flds[] = {
>  	  TYP_NONE },
>  	{ NULL }
>  };
> -#undef ROFF
>  
>  /* refcount btree blocks */
>  const field_t	refcbt_crc_hfld[] = {
> @@ -785,13 +782,11 @@ const field_t	refcbt_crc_flds[] = {
>  #define REFCNTBT_COWFLAG_BITOFF		0
>  #define REFCNTBT_STARTBLOCK_BITOFF	(REFCNTBT_COWFLAG_BITOFF + REFCNTBT_COWFLAG_BITLEN)
>  
> -#define	KOFF(f)	bitize(offsetof(struct xfs_refcount_key, rc_ ## f))
>  const field_t	refcbt_key_flds[] = {
>  	{ "startblock", FLDT_CAGBLOCK, OI(REFCNTBT_STARTBLOCK_BITOFF), C1, 0, TYP_DATA },
>  	{ "cowflag", FLDT_CCOWFLG, OI(REFCNTBT_COWFLAG_BITOFF), C1, 0, TYP_DATA },
>  	{ NULL }
>  };
> -#undef KOFF
>  
>  #define	ROFF(f)	bitize(offsetof(struct xfs_refcount_rec, rc_ ## f))
>  const field_t	refcbt_rec_flds[] = {
> diff --git a/db/metadump.c b/db/metadump.c
> index d33f901..d7613eb 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -34,14 +34,6 @@
>  
>  #define DEFAULT_MAX_EXT_SIZE	MAXEXTLEN
>  
> -/*
> - * It's possible that multiple files in a directory (or attributes
> - * in a file) produce the same obfuscated name.  If that happens, we
> - * try to create another one.  After several rounds of this though,
> - * we just give up and leave the original name as-is.
> - */
> -#define	DUP_MAX		5	/* Max duplicates before we give up */
> -
>  /* copy all metadata structures to/from a file */
>  
>  static int	metadump_f(int argc, char **argv);
> diff --git a/db/symlink.c b/db/symlink.c
> index c99b8ca..a81785c 100644
> --- a/db/symlink.c
> +++ b/db/symlink.c
> @@ -64,7 +64,6 @@ const struct field	symlink_crc_hfld[] = {
>  };
>  
>  #define	OFF(f)	bitize(offsetof(struct xfs_dsymlink_hdr, sl_ ## f))
> -#define	SZOF(f)	bitize(sizeof(struct xfs_dsymlink_hdr))
>  const struct field	symlink_crc_flds[] = {
>  	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
>  	{ "offset", FLDT_UINT32D, OI(OFF(offset)), C1, 0, TYP_NONE },
> diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
> index 323137c..1e1e1e3 100644
> --- a/estimate/xfs_estimate.c
> +++ b/estimate/xfs_estimate.c
> @@ -54,7 +54,6 @@ int ffn(const char *, const struct stat *, int, struct FTW *);
>  #define LOGSIZE		1000
>  
>  #define FBLOCKS(n)	((n)/blocksize)
> -#define RFBYTES(n)	((n) - (FBLOCKS(n) * blocksize))
>  
>  unsigned long long dirsize=0;		/* bytes */
>  unsigned long long logsize=LOGSIZE*BLOCKSIZE;	/* bytes */
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index b74a70b..11a7984 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -64,10 +64,6 @@ static int64_t		minimumfree = 2048;
>  #define NULLFD		-1
>  #define GRABSZ		64
>  #define TARGETRANGE	10
> -#define	V_NONE		0
> -#define	V_OVERVIEW	1
> -#define	V_ALL		2
> -#define BUFFER_SIZE	(1<<16)
>  #define BUFFER_MAX	(1<<24)
>  
>  static time_t howlong = 7200;		/* default seconds of reorganizing */
> diff --git a/include/xfs_trace.h b/include/xfs_trace.h
> index cfcd985..62c6839 100644
> --- a/include/xfs_trace.h
> +++ b/include/xfs_trace.h
> @@ -21,7 +21,6 @@
>  #define trace_xfs_alloc_exact_done(a)		((void) 0)
>  #define trace_xfs_alloc_exact_notfound(a)	((void) 0)
>  #define trace_xfs_alloc_exact_error(a)		((void) 0)
> -#define trace_xfs_alloc_near_nominleft(a)	((void) 0)
>  #define trace_xfs_alloc_near_first(a)		((void) 0)
>  #define trace_xfs_alloc_near_greater(a)		((void) 0)
>  #define trace_xfs_alloc_near_lesser(a)		((void) 0)
> @@ -44,8 +43,6 @@
>  #define trace_xfs_alloc_vextent_loopfailed(a)	((void) 0)
>  #define trace_xfs_alloc_vextent_allfailed(a)	((void) 0)
>  
> -#define trace_xfs_log_recover_item_reorder_head(a,b,c,d)	((void) 0)
> -#define trace_xfs_log_recover_item_reorder_tail(a,b,c,d)	((void) 0)
>  #define trace_xfs_log_recover_item_add_cont(a,b,c,d)	((void) 0)
>  #define trace_xfs_log_recover_item_add(a,b,c,d)	((void) 0)
>  
> @@ -273,7 +270,6 @@
>  #define trace_xfs_refcount_find_shared_error(...)	((void) 0)
>  
>  #define trace_xfs_bmap_remap_alloc(...)		((void) 0)
> -#define trace_xfs_bmap_remap_alloc_error(...)	((void) 0)
>  #define trace_xfs_bmap_deferred(...)		((void) 0)
>  #define trace_xfs_bmap_defer(...)		((void) 0)
>  
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 78daca0..75255a8 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -46,7 +46,6 @@
>  #define xfs_trans_iget			libxfs_trans_iget
>  #define xfs_trans_ichgtime		libxfs_trans_ichgtime
>  #define xfs_trans_ijoin			libxfs_trans_ijoin
> -#define xfs_trans_ijoin_ref		libxfs_trans_ijoin_ref
>  #define xfs_trans_init			libxfs_trans_init
>  #define xfs_trans_inode_alloc_buf	libxfs_trans_inode_alloc_buf
>  #define xfs_trans_dirty_buf		libxfs_trans_dirty_buf
> @@ -70,7 +69,6 @@
>  #define xfs_alloc_min_freelist		libxfs_alloc_min_freelist
>  #define xfs_alloc_read_agf		libxfs_alloc_read_agf
>  #define xfs_bmap_last_offset		libxfs_bmap_last_offset
> -#define xfs_bmap_search_extents		libxfs_bmap_search_extents
>  #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
>  #define xfs_bmapi_write			libxfs_bmapi_write
>  #define xfs_bmapi_read			libxfs_bmapi_read
> diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
> index 58d9182..51dd97e 100644
> --- a/libxlog/xfs_log_recover.c
> +++ b/libxlog/xfs_log_recover.c
> @@ -1035,8 +1035,6 @@ xlog_recover_add_item(
>  	list_add_tail(&item->ri_list, head);
>  }
>  
> -#define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
> -
>  STATIC int
>  xlog_recover_add_to_cont_trans(
>  	struct xlog		*log,
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 8b1b8a7..fe73fd6 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -35,7 +35,6 @@ static int xfs_mac_valid(xfs_mac_label_t *lp);
>   * dir v1 code, but that format is no longer supported yb the userspace
>   * utilities and hence is now specific to the attribute tree implementation.
>   */
> -#define XR_DA_LEAF_MAPSIZE	XFS_ATTR_LEAF_MAPSIZE
>  
>  typedef unsigned char	da_freemap_t;
>  
> diff --git a/repair/incore.h b/repair/incore.h
> index fd66084..620ed61 100644
> --- a/repair/incore.h
> +++ b/repair/incore.h
> @@ -113,8 +113,6 @@ typedef struct rt_extent_tree_node  {
>  /* separate state bit, OR'ed into high (4th) bit of ex_state field */
>  
>  #define XR_E_WRITTEN	0x8	/* extent has been written out, can't reclaim */
> -#define good_state(state)	(((state) & (~XR_E_WRITTEN)) >= XR_E_UNKNOWN && \
> -				((state) & (~XR_E_WRITTEN) < XF_E_BAD_STATE))
>  #define written(state)		((state) & XR_E_WRITTEN)
>  #define set_written(state)	(state) &= XR_E_WRITTEN
>  
> diff --git a/repair/incore_ext.c b/repair/incore_ext.c
> index 0a8138a..7ad883f 100644
> --- a/repair/incore_ext.c
> +++ b/repair/incore_ext.c
> @@ -267,14 +267,6 @@ get_bno_extent(xfs_agnumber_t agno, extent_tree_node_t *ext)
>  }
>  
>  /*
> - * normalizing constant for bcnt size -> address conversion (see avl ops)
> - * used by the AVL tree code to convert sizes and must be used when
> - * doing an AVL search in the tree (e.g. avl_findrange(s))
> - */
> -#define MAXBCNT		0xFFFFFFFF
> -#define BCNT_ADDR(cnt)	((unsigned int) MAXBCNT - (cnt))
> -
> -/*
>   * the next 4 routines manage the trees of free extents -- 2 trees
>   * per AG.  The first tree is sorted by block number.  The second
>   * tree is sorted by extent size.  This is the bcnt tree.
> diff --git a/repair/scan.c b/repair/scan.c
> index 0fc41f2..d25b6bf 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -2498,8 +2498,6 @@ out_free_sb:
>  		do_error(_("can't get %s for ag %d\n"), objname, agno);
>  }
>  
> -#define SCAN_THREADS 32
> -
>  void
>  scan_ags(
>  	struct xfs_mount	*mp,
> diff --git a/repair/slab.c b/repair/slab.c
> index b04c3b8..cb4f403 100644
> --- a/repair/slab.c
> +++ b/repair/slab.c
> @@ -101,7 +101,6 @@ struct xfs_bag {
>  	size_t			bg_inuse;	/* number of slots in use */
>  	void			**bg_ptrs;	/* pointers */
>  };
> -#define BAG_SIZE(nr)	(sizeof(struct xfs_bag) + ((nr) * sizeof(void *)))
>  #define BAG_END(bag)	(&(bag)->bg_ptrs[(bag)->bg_nr])
>  
>  /*
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index ff6a738..ff0c4ff 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -35,10 +35,6 @@
>  #include "slab.h"
>  #include "rmap.h"
>  
> -#define	rounddown(x, y)	(((x)/(y))*(y))
> -
> -#define		XR_MAX_SECT_SIZE	(64 * 1024)
> -
>  /*
>   * option tables for getsubopt calls
>   */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

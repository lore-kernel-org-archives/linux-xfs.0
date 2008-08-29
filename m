Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Aug 2008 23:57:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7T6vFk0011216
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2008 23:57:16 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA09658 for <xfs@oss.sgi.com>; Fri, 29 Aug 2008 16:58:39 +1000
Date: Fri, 29 Aug 2008 17:00:56 +1000
Subject: [REVIEW #2]  Update kernel code to compile in userspace (libxfs)
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugmy3u2o3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Mostly header changes associated with #ifdef __KERNEL__ stuff.

Some function prototypes had to be reordered to separate
shared and kernel only functions.

One thing I don't have clear confirmation on yet is this change:

  static inline int xfs_lowbit32(__uint32_t v)
  {
-	unsigned long	t = v;
-	return (v) ? find_first_bit(&t, 32) : -1;
+	return ffs(v) - 1;
  }


---
  fs/xfs/xfs_ag.h         |    2
  fs/xfs/xfs_alloc.c      |    2
  fs/xfs/xfs_alloc.h      |    4 +
  fs/xfs/xfs_arch.h       |   39 +++++++---
  fs/xfs/xfs_bit.h        |    3
  fs/xfs/xfs_bmap.h       |   35 +++++----
  fs/xfs/xfs_bmap_btree.h |    3
  fs/xfs/xfs_btree.h      |    4 -
  fs/xfs/xfs_da_btree.h   |    4 -
  fs/xfs/xfs_ialloc.h     |    3
  fs/xfs/xfs_imap.h       |    2
  fs/xfs/xfs_inode.h      |  178  
++++++++++++++++++++++++------------------------
  fs/xfs/xfs_inode_item.h |    5 -
  fs/xfs/xfs_mount.h      |    9 +-
  fs/xfs/xfs_trans.h      |    5 -
  15 files changed, 161 insertions(+), 137 deletions(-)

Index: 2.6.x-xfs/fs/xfs/xfs_ag.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_ag.h
+++ 2.6.x-xfs/fs/xfs/xfs_ag.h
@@ -196,11 +196,13 @@ typedef struct xfs_perag
  	spinlock_t	pagb_lock;	/* lock for pagb_list */
  #endif
  	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
+#ifdef __KERNEL__
  	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */

  	int		pag_ici_init;	/* incore inode cache initialised */
  	rwlock_t	pag_ici_lock;	/* incore inode lock */
  	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
+#endif
  } xfs_perag_t;

  #define	XFS_AG_MAXLEVELS(mp)		((mp)->m_ag_maxlevels)
Index: 2.6.x-xfs/fs/xfs/xfs_alloc.c
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_alloc.c
+++ 2.6.x-xfs/fs/xfs/xfs_alloc.c
@@ -2185,6 +2185,7 @@ xfs_alloc_read_agf(
  		be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC &&
  		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
  		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
+		be32_to_cpu(agf->agf_btreeblks) <= be32_to_cpu(agf->agf_length) &&
  		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
  		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
  		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);
@@ -2213,6 +2214,7 @@ xfs_alloc_read_agf(
  #ifdef DEBUG
  	else if (!XFS_FORCED_SHUTDOWN(mp)) {
  		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
+		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
  		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
  		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
  		ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
Index: 2.6.x-xfs/fs/xfs/xfs_alloc.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_alloc.h
+++ 2.6.x-xfs/fs/xfs/xfs_alloc.h
@@ -121,6 +121,8 @@ extern ktrace_t *xfs_alloc_trace_buf;
  #define	XFS_ALLOC_KTRACE_BUSYSEARCH	6
  #endif

+#endif	/* __KERNEL__ */
+
  /*
   * Compute and fill in value of m_ag_maxlevels.
   */
@@ -196,6 +198,8 @@ xfs_free_extent(
  	xfs_fsblock_t	bno,	/* starting block number of extent */
  	xfs_extlen_t	len);	/* length of extent */

+#ifdef __KERNEL__
+
  void
  xfs_alloc_mark_busy(xfs_trans_t *tp,
  		xfs_agnumber_t agno,
Index: 2.6.x-xfs/fs/xfs/xfs_arch.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_arch.h
+++ 2.6.x-xfs/fs/xfs/xfs_arch.h
@@ -41,21 +41,36 @@
  #endif

  #ifdef XFS_NATIVE_HOST
-#define cpu_to_be16(val)	((__be16)(val))
-#define cpu_to_be32(val)	((__be32)(val))
-#define cpu_to_be64(val)	((__be64)(val))
-#define be16_to_cpu(val)	((__uint16_t)(val))
-#define be32_to_cpu(val)	((__uint32_t)(val))
-#define be64_to_cpu(val)	((__uint64_t)(val))
+#define cpu_to_be16(val)	((__force __be16)(__u16)(val))
+#define cpu_to_be32(val)	((__force __be32)(__u32)(val))
+#define cpu_to_be64(val)	((__force __be64)(__u64)(val))
+#define be16_to_cpu(val)	((__force __u16)(__be16)(val))
+#define be32_to_cpu(val)	((__force __u32)(__be32)(val))
+#define be64_to_cpu(val)	((__force __u64)(__be64)(val))
  #else
-#define cpu_to_be16(val)	(__swab16((__uint16_t)(val)))
-#define cpu_to_be32(val)	(__swab32((__uint32_t)(val)))
-#define cpu_to_be64(val)	(__swab64((__uint64_t)(val)))
-#define be16_to_cpu(val)	(__swab16((__be16)(val)))
-#define be32_to_cpu(val)	(__swab32((__be32)(val)))
-#define be64_to_cpu(val)	(__swab64((__be64)(val)))
+#define cpu_to_be16(val)	((__force __be16)__swab16((__u16)(val)))
+#define cpu_to_be32(val)	((__force __be32)__swab32((__u32)(val)))
+#define cpu_to_be64(val)	((__force __be64)__swab64((__u64)(val)))
+#define be16_to_cpu(val)	(__swab16((__force __u16)(__be16)(val)))
+#define be32_to_cpu(val)	(__swab32((__force __u32)(__be32)(val)))
+#define be64_to_cpu(val)	(__swab64((__force __u64)(__be64)(val)))
  #endif

+static inline void be16_add_cpu(__be16 *a, __s16 b)
+{
+	*a = cpu_to_be16(be16_to_cpu(*a) + b);
+}
+
+static inline void be32_add_cpu(__be32 *a, __s32 b)
+{
+	*a = cpu_to_be32(be32_to_cpu(*a) + b);
+}
+
+static inline void be64_add_cpu(__be64 *a, __s64 b)
+{
+	*a = cpu_to_be64(be64_to_cpu(*a) + b);
+}
+
  #endif	/* __KERNEL__ */

  /* do we need conversion? */
Index: 2.6.x-xfs/fs/xfs/xfs_bit.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_bit.h
+++ 2.6.x-xfs/fs/xfs/xfs_bit.h
@@ -61,8 +61,7 @@ static inline int xfs_highbit64(__uint64
  /* Get low bit set out of 32-bit argument, -1 if none set */
  static inline int xfs_lowbit32(__uint32_t v)
  {
-	unsigned long	t = v;
-	return (v) ? find_first_bit(&t, 32) : -1;
+	return ffs(v) - 1;
  }

  /* Get low bit set out of 64-bit argument, -1 if none set */
Index: 2.6.x-xfs/fs/xfs/xfs_bmap.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_bmap.h
+++ 2.6.x-xfs/fs/xfs/xfs_bmap.h
@@ -137,9 +137,7 @@ typedef struct xfs_bmalloca {
  	char			conv;	/* overwriting unwritten extents */
  } xfs_bmalloca_t;

-#ifdef __KERNEL__
-
-#if defined(XFS_BMAP_TRACE)
+#if defined(__KERNEL__) && defined(XFS_BMAP_TRACE)
  /*
   * Trace operations for bmap extent tracing
   */
@@ -163,9 +161,12 @@ xfs_bmap_trace_exlist(
  	int			whichfork);	/* data or attr fork */
  #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)	\
  	xfs_bmap_trace_exlist(__func__,ip,c,w)
-#else
+
+#else	/* __KERNEL__ && XFS_BMAP_TRACE */
+
  #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)
-#endif
+
+#endif	/* __KERNEL__ && XFS_BMAP_TRACE */

  /*
   * Convert inode from non-attributed to attributed.
@@ -205,6 +206,7 @@ xfs_bmap_compute_maxlevels(
  	struct xfs_mount	*mp,	/* file system mount structure */
  	int			whichfork);	/* data or attr fork */

+#ifdef __KERNEL__
  /*
   * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
   * caller.  Frees all the extents that need freeing, which must be done
@@ -218,6 +220,7 @@ xfs_bmap_finish(
  	struct xfs_trans	**tp,		/* transaction pointer addr */
  	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
  	int			*committed);	/* xact committed or not */
+#endif

  /*
   * Returns the file-relative block number of the first unused block in  
the file.
@@ -344,6 +347,18 @@ xfs_bunmapi(
  	int			*done);		/* set if not done yet */

  /*
+ * Check an extent list, which has just been read, for
+ * any bit in the extent flag field.
+ */
+int
+xfs_check_nostate_extents(
+	struct xfs_ifork	*ifp,
+	xfs_extnum_t		idx,
+	xfs_extnum_t		num);
+
+#ifdef __KERNEL__
+
+/*
   * Fcntl interface to xfs_bmapi.
   */
  int						/* error code */
@@ -375,16 +390,6 @@ xfs_bmap_count_blocks(
  	int			*count);

  /*
- * Check an extent list, which has just been read, for
- * any bit in the extent flag field.
- */
-int
-xfs_check_nostate_extents(
-	struct xfs_ifork	*ifp,
-	xfs_extnum_t		idx,
-	xfs_extnum_t		num);
-
-/*
   * Search the extent records for the entry containing block bno.
   * If bno lies in a hole, point to the next entry.  If bno lies
   * past eof, *eofp will be set, and *prevp will contain the last
Index: 2.6.x-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_bmap_btree.h
+++ 2.6.x-xfs/fs/xfs/xfs_bmap_btree.h
@@ -250,6 +250,8 @@ typedef struct xfs_btree_lblock xfs_bmbt
  extern ktrace_t	*xfs_bmbt_trace_buf;
  #endif

+#endif	/* __KERNEL__ */
+
  /*
   * Prototypes for xfs_bmap.c to call.
   */
@@ -300,6 +302,5 @@ extern void xfs_bmbt_to_bmdr(xfs_bmbt_bl
  extern int xfs_bmbt_update(struct xfs_btree_cur *, xfs_fileoff_t,
  				xfs_fsblock_t, xfs_filblks_t, xfs_exntst_t);

-#endif	/* __KERNEL__ */

  #endif	/* __XFS_BMAP_BTREE_H__ */
Index: 2.6.x-xfs/fs/xfs/xfs_btree.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_btree.h
+++ 2.6.x-xfs/fs/xfs/xfs_btree.h
@@ -186,8 +186,6 @@ typedef struct xfs_btree_cur
  #define	XFS_BUF_TO_SBLOCK(bp)	((xfs_btree_sblock_t *)XFS_BUF_PTR(bp))


-#ifdef __KERNEL__
-
  #ifdef DEBUG
  /*
   * Debug routine: check that block header is ok.
@@ -436,8 +434,6 @@ xfs_btree_setbuf(
  	int			lev,	/* level in btree */
  	struct xfs_buf		*bp);	/* new buffer to set */

-#endif	/* __KERNEL__ */
-

  /*
   * Min and max functions for extlen, agblock, fileoff, and filblks types.
Index: 2.6.x-xfs/fs/xfs/xfs_da_btree.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_da_btree.h
+++ 2.6.x-xfs/fs/xfs/xfs_da_btree.h
@@ -206,9 +206,8 @@ struct xfs_nameops {
  };


-#ifdef __KERNEL__
  /*========================================================================
- * Function prototypes for the kernel.
+ * Function prototypes.
   *========================================================================*/

  /*
@@ -269,6 +268,5 @@ xfs_daddr_t xfs_da_blkno(xfs_dabuf_t *da

  extern struct kmem_zone *xfs_da_state_zone;
  extern struct kmem_zone *xfs_dabuf_zone;
-#endif	/* __KERNEL__ */

  #endif	/* __XFS_DA_BTREE_H__ */
Index: 2.6.x-xfs/fs/xfs/xfs_ialloc.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_ialloc.h
+++ 2.6.x-xfs/fs/xfs/xfs_ialloc.h
@@ -56,7 +56,6 @@ static inline int xfs_ialloc_find_free(x
  }


-#ifdef __KERNEL__
  /*
   * Allocate an inode on disk.
   * Mode is used to tell whether the new inode will need space, and whether
@@ -154,6 +153,4 @@ xfs_ialloc_pagi_init(
  	struct xfs_trans *tp,		/* transaction pointer */
          xfs_agnumber_t  agno);		/* allocation group number */

-#endif	/* __KERNEL__ */
-
  #endif	/* __XFS_IALLOC_H__ */
Index: 2.6.x-xfs/fs/xfs/xfs_imap.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_imap.h
+++ 2.6.x-xfs/fs/xfs/xfs_imap.h
@@ -30,11 +30,9 @@ typedef struct xfs_imap {
  	ushort		im_boffset;	/* inode offset in block in bytes */
  } xfs_imap_t;

-#ifdef __KERNEL__
  struct xfs_mount;
  struct xfs_trans;
  int	xfs_imap(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
  		 xfs_imap_t *, uint);
-#endif

  #endif	/* __XFS_IMAP_H__ */
Index: 2.6.x-xfs/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_inode.h
+++ 2.6.x-xfs/fs/xfs/xfs_inode.h
@@ -103,34 +103,6 @@ typedef struct xfs_ifork {
  #define XFS_IMAP_LOOKUP		0x1
  #define XFS_IMAP_BULKSTAT	0x2

-#ifdef __KERNEL__
-struct bhv_desc;
-struct cred;
-struct ktrace;
-struct xfs_buf;
-struct xfs_bmap_free;
-struct xfs_bmbt_irec;
-struct xfs_bmbt_block;
-struct xfs_inode;
-struct xfs_inode_log_item;
-struct xfs_mount;
-struct xfs_trans;
-struct xfs_dquot;
-
-#if defined(XFS_ILOCK_TRACE)
-#define XFS_ILOCK_KTRACE_SIZE	32
-extern ktrace_t *xfs_ilock_trace_buf;
-extern void xfs_ilock_trace(struct xfs_inode *, int, unsigned int, inst_t  
*);
-#else
-#define	xfs_ilock_trace(i,n,f,ra)
-#endif
-
-typedef struct dm_attrs_s {
-	__uint32_t	da_dmevmask;	/* DMIG event mask */
-	__uint16_t	da_dmstate;	/* DMIG state info */
-	__uint16_t	da_pad;		/* DMIG extra padding */
-} dm_attrs_t;
-
  /*
   * This is the xfs in-core inode structure.
   * Most of the on-disk inode is embedded in the i_d field.
@@ -191,6 +163,34 @@ typedef struct xfs_icdinode {
  	__uint32_t	di_gen;		/* generation number */
  } xfs_icdinode_t;

+#ifdef __KERNEL__
+struct bhv_desc;
+struct cred;
+struct ktrace;
+struct xfs_buf;
+struct xfs_bmap_free;
+struct xfs_bmbt_irec;
+struct xfs_bmbt_block;
+struct xfs_inode;
+struct xfs_inode_log_item;
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_dquot;
+
+#if defined(XFS_ILOCK_TRACE)
+#define XFS_ILOCK_KTRACE_SIZE	32
+extern ktrace_t *xfs_ilock_trace_buf;
+extern void xfs_ilock_trace(struct xfs_inode *, int, unsigned int, inst_t  
*);
+#else
+#define	xfs_ilock_trace(i,n,f,ra)
+#endif
+
+typedef struct dm_attrs_s {
+	__uint32_t	da_dmevmask;	/* DMIG event mask */
+	__uint16_t	da_dmstate;	/* DMIG state info */
+	__uint16_t	da_pad;		/* DMIG extra padding */
+} dm_attrs_t;
+
  typedef struct {
  	struct xfs_inode	*ip_mnext;	/* next inode in mount list */
  	struct xfs_inode	*ip_mprev;	/* ptr to prev inode */
@@ -327,6 +327,27 @@ xfs_iflags_test_and_clear(xfs_inode_t *i
  	spin_unlock(&ip->i_flags_lock);
  	return ret;
  }
+
+/*
+ * Manage the i_flush queue embedded in the inode.  This completion
+ * queue synchronizes processes attempting to flush the in-core
+ * inode back to disk.
+ */
+static inline void xfs_iflock(xfs_inode_t *ip)
+{
+	wait_for_completion(&ip->i_flush);
+}
+
+static inline int xfs_iflock_nowait(xfs_inode_t *ip)
+{
+	return try_wait_for_completion(&ip->i_flush);
+}
+
+static inline void xfs_ifunlock(xfs_inode_t *ip)
+{
+	complete(&ip->i_flush);
+}
+
  #endif	/* __KERNEL__ */


@@ -487,51 +508,24 @@ void		xfs_ireclaim(xfs_inode_t *);
  int		xfs_finish_reclaim(xfs_inode_t *, int, int);
  int		xfs_finish_reclaim_all(struct xfs_mount *, int);

+#endif /* __KERNEL__ */
+
  /*
   * xfs_inode.c prototypes.
   */
  int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
-			  xfs_inode_t *, struct xfs_dinode **, struct xfs_buf **,
-			  xfs_daddr_t, uint, uint);
-int		xfs_iread(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-			  xfs_inode_t **, xfs_daddr_t, uint);
-int		xfs_iread_extents(struct xfs_trans *, xfs_inode_t *, int);
-int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
-			   xfs_nlink_t, xfs_dev_t, struct cred *, xfs_prid_t,
-			   int, struct xfs_buf **, boolean_t *, xfs_inode_t **);
+			  struct xfs_inode *, struct xfs_dinode **,
+			  struct xfs_buf **, xfs_daddr_t, uint, uint);
+int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
  void		xfs_dinode_from_disk(struct xfs_icdinode *,
  				     struct xfs_dinode_core *);
  void		xfs_dinode_to_disk(struct xfs_dinode_core *,
  				   struct xfs_icdinode *);

-uint		xfs_ip2xflags(struct xfs_inode *);
-uint		xfs_dic2xflags(struct xfs_dinode *);
-int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
-			   struct xfs_bmap_free *);
-int		xfs_itruncate_start(xfs_inode_t *, uint, xfs_fsize_t);
-int		xfs_itruncate_finish(struct xfs_trans **, xfs_inode_t *,
-				     xfs_fsize_t, int, int);
-int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
-
-struct xfs_inode * xfs_inode_alloc(struct xfs_mount *, xfs_ino_t);
-void		xfs_idestroy_fork(xfs_inode_t *, int);
-void		xfs_idestroy(xfs_inode_t *);
-void		xfs_idata_realloc(xfs_inode_t *, int, int);
-void		xfs_iextract(xfs_inode_t *);
-void		xfs_iext_realloc(xfs_inode_t *, int, int);
-void		xfs_iroot_realloc(xfs_inode_t *, int, int);
-void		xfs_ipin(xfs_inode_t *);
-void		xfs_iunpin(xfs_inode_t *);
-int		xfs_iextents_copy(xfs_inode_t *, xfs_bmbt_rec_t *, int);
-int		xfs_iflush(xfs_inode_t *, uint);
-void		xfs_iflush_all(struct xfs_mount *);
-void		xfs_ichgtime(xfs_inode_t *, int);
-xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
-void		xfs_lock_inodes(xfs_inode_t **, int, uint);
-void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
-
-void		xfs_synchronize_atime(xfs_inode_t *);
-void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
+void		xfs_idestroy_fork(struct xfs_inode *, int);
+void		xfs_idata_realloc(struct xfs_inode *, int, int);
+void		xfs_iroot_realloc(struct xfs_inode *, int, int);
+int		xfs_iextents_copy(struct xfs_inode *, xfs_bmbt_rec_t *, int);

  xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
  void		xfs_iext_insert(xfs_ifork_t *, xfs_extnum_t, xfs_extnum_t,
@@ -559,6 +553,38 @@ void		xfs_iext_irec_compact_pages(xfs_if
  void		xfs_iext_irec_compact_full(xfs_ifork_t *);
  void		xfs_iext_irec_update_extoffs(xfs_ifork_t *, int, int);

+#ifdef __KERNEL__
+
+int		xfs_iread(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
+			  xfs_inode_t **, xfs_daddr_t, uint);
+int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
+			   xfs_nlink_t, xfs_dev_t, struct cred *, xfs_prid_t,
+			   int, struct xfs_buf **, boolean_t *, xfs_inode_t **);
+
+uint		xfs_ip2xflags(struct xfs_inode *);
+uint		xfs_dic2xflags(struct xfs_dinode *);
+int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
+			   struct xfs_bmap_free *);
+int		xfs_itruncate_start(xfs_inode_t *, uint, xfs_fsize_t);
+int		xfs_itruncate_finish(struct xfs_trans **, xfs_inode_t *,
+				     xfs_fsize_t, int, int);
+int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
+
+void		xfs_idestroy(xfs_inode_t *);
+void		xfs_iextract(xfs_inode_t *);
+void		xfs_iext_realloc(xfs_inode_t *, int, int);
+void		xfs_ipin(xfs_inode_t *);
+void		xfs_iunpin(xfs_inode_t *);
+int		xfs_iflush(xfs_inode_t *, uint);
+void		xfs_iflush_all(struct xfs_mount *);
+void		xfs_ichgtime(xfs_inode_t *, int);
+xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
+void		xfs_lock_inodes(xfs_inode_t **, int, uint);
+void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
+
+void		xfs_synchronize_atime(xfs_inode_t *);
+void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
+
  #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))

  #ifdef DEBUG
@@ -567,6 +593,8 @@ void		xfs_isize_check(struct xfs_mount *
  #define xfs_isize_check(mp, ip, isize)
  #endif	/* DEBUG */

+#endif	/* __KERNEL__ */
+
  #if defined(DEBUG)
  void		xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
  #else
@@ -577,26 +605,4 @@ extern struct kmem_zone	*xfs_ifork_zone;
  extern struct kmem_zone	*xfs_inode_zone;
  extern struct kmem_zone	*xfs_ili_zone;

-/*
- * Manage the i_flush queue embedded in the inode.  This completion
- * queue synchronizes processes attempting to flush the in-core
- * inode back to disk.
- */
-static inline void xfs_iflock(xfs_inode_t *ip)
-{
-	wait_for_completion(&ip->i_flush);
-}
-
-static inline int xfs_iflock_nowait(xfs_inode_t *ip)
-{
-	return try_wait_for_completion(&ip->i_flush);
-}
-
-static inline void xfs_ifunlock(xfs_inode_t *ip)
-{
-	complete(&ip->i_flush);
-}
-
-#endif	/* __KERNEL__ */
-
  #endif	/* __XFS_INODE_H__ */
Index: 2.6.x-xfs/fs/xfs/xfs_inode_item.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_inode_item.h
+++ 2.6.x-xfs/fs/xfs/xfs_inode_item.h
@@ -168,6 +168,8 @@ static inline int xfs_ilog_fext(int w)
  	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
  }

+#ifdef __KERNEL__
+
  static inline int xfs_inode_clean(xfs_inode_t *ip)
  {
  	return (!ip->i_itemp ||
@@ -175,9 +177,6 @@ static inline int xfs_inode_clean(xfs_in
  	       !ip->i_update_core;
  }

-
-#ifdef __KERNEL__
-
  extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
  extern void xfs_inode_item_destroy(struct xfs_inode *);
  extern void xfs_iflush_done(struct xfs_buf *, xfs_inode_log_item_t *);
Index: 2.6.x-xfs/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_mount.h
+++ 2.6.x-xfs/fs/xfs/xfs_mount.h
@@ -508,7 +508,6 @@ typedef struct xfs_mod_sb {
  #define	XFS_MOUNT_ILOCK(mp)	mutex_lock(&((mp)->m_ilock))
  #define	XFS_MOUNT_IUNLOCK(mp)	mutex_unlock(&((mp)->m_ilock))

-extern void	xfs_mod_sb(xfs_trans_t *, __int64_t);
  extern int	xfs_log_sbcount(xfs_mount_t *, uint);
  extern int	xfs_mountfs(xfs_mount_t *mp);
  extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
@@ -527,9 +526,6 @@ extern void	xfs_freesb(xfs_mount_t *);
  extern int	xfs_fs_writable(xfs_mount_t *);
  extern int	xfs_syncsub(xfs_mount_t *, int, int *);
  extern int	xfs_sync_inodes(xfs_mount_t *, int, int *);
-extern xfs_agnumber_t	xfs_initialize_perag(xfs_mount_t *, xfs_agnumber_t);
-extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
-extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
  extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);

  extern int	xfs_dmops_get(struct xfs_mount *, struct xfs_mount_args *);
@@ -541,4 +537,9 @@ extern struct xfs_dmops xfs_dmcore_xfs;

  #endif	/* __KERNEL__ */

+extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
+extern xfs_agnumber_t	xfs_initialize_perag(struct xfs_mount *,  
xfs_agnumber_t);
+extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
+extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
+
  #endif	/* __XFS_MOUNT_H__ */
Index: 2.6.x-xfs/fs/xfs/xfs_trans.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_trans.h
+++ 2.6.x-xfs/fs/xfs/xfs_trans.h
@@ -928,7 +928,6 @@ typedef struct xfs_trans {
  /*
   * XFS transaction mechanism exported interfaces.
   */
-void		xfs_trans_init(struct xfs_mount *);
  xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
  xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint);
  xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
@@ -975,7 +974,6 @@ int		_xfs_trans_commit(xfs_trans_t *,
  				  int *);
  #define xfs_trans_commit(tp, flags)	_xfs_trans_commit(tp, flags, NULL)
  void		xfs_trans_cancel(xfs_trans_t *, int);
-int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
  int		xfs_trans_ail_init(struct xfs_mount *);
  void		xfs_trans_ail_destroy(struct xfs_mount *);
  void		xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
@@ -990,4 +988,7 @@ extern kmem_zone_t	*xfs_trans_zone;

  #endif	/* __KERNEL__ */

+void		xfs_trans_init(struct xfs_mount *);
+int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
+
  #endif	/* __XFS_TRANS_H__ */

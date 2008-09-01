Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 31 Aug 2008 21:52:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m814qBPH026267
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 21:52:17 -0700
Date: Mon, 01 Sep 2008 14:55:24 +1000
Subject: Re: [REVIEW #2]  Update kernel code to compile in userspace (libxfs)
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.ugmy3u2o3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <op.ugm1ttzb3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <20080829181120.GA9455@infradead.org>
 <op.ugr4zpyv3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <20080901015950.GA16825@infradead.org>
 <op.ugr5hsao3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <20080901020826.GA31724@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugsdamyd3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080901020826.GA31724@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, 01 Sep 2008 12:08:27 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Mon, Sep 01, 2008 at 12:06:54PM +1000, Barry Naujok wrote:
>>> Looks good.
>>>
>>
>> What about the rest ;)
>
> Same comments apply - looks good except that in a few places less
> ifdef blocks would be nice.  But we can do thes later if this helps you.

Ok, updates based on that principle.

Changes since first patch:

xfs_ag.h - moved pagb_list to before the #ifdef __KERNEL__

xfs_alloc.h - moved xfs_alloc_xxx_busy to the first (and now only)
		#ifdef __KERNEL__ block

xfs_bmap.h - moved xfs_bmap_finish to the start of the __KERNEL__
		block.

xfs_inode.h - had to use struct xfs_inode instead of xfs_inode_t for
		shared function prototypes (and unified kernel only
		code into one block).

xfs_inode_item.h - move xfs_ilog_xxx functions before __KERNEL__
		block.

xfs_mount.h - clarified #ifndef __KERNEL__/#else at start.

xfs_trans.h - unified kernel structures, constants, flags and function
		prototypes into one section.

---
  fs/xfs/xfs_ag.h         |    5
  fs/xfs/xfs_alloc.c      |    2
  fs/xfs/xfs_alloc.h      |   27 +---
  fs/xfs/xfs_arch.h       |   39 ++++-
  fs/xfs/xfs_bit.h        |    3
  fs/xfs/xfs_bmap.h       |   61 ++++-----
  fs/xfs/xfs_bmap_btree.h |    3
  fs/xfs/xfs_btree.h      |    4
  fs/xfs/xfs_da_btree.h   |    4
  fs/xfs/xfs_ialloc.h     |    3
  fs/xfs/xfs_imap.h       |    2
  fs/xfs/xfs_inode.h      |  244 ++++++++++++++++++------------------
  fs/xfs/xfs_inode_item.h |   41 ++----
  fs/xfs/xfs_mount.h      |   17 +-
  fs/xfs/xfs_trans.h      |  317  
+++++++++++++++++++++++-------------------------
  15 files changed, 386 insertions(+), 386 deletions(-)

Index: 2.6.x-xfs/fs/xfs/xfs_ag.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_ag.h
+++ 2.6.x-xfs/fs/xfs/xfs_ag.h
@@ -192,15 +192,16 @@ typedef struct xfs_perag
  	xfs_agino_t	pagi_freecount;	/* number of free inodes */
  	xfs_agino_t	pagi_count;	/* number of allocated inodes */
  	int		pagb_count;	/* pagb slots in use */
+	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
  #ifdef __KERNEL__
  	spinlock_t	pagb_lock;	/* lock for pagb_list */
-#endif
-	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
+
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
@@ -121,6 +121,19 @@ extern ktrace_t *xfs_alloc_trace_buf;
  #define	XFS_ALLOC_KTRACE_BUSYSEARCH	6
  #endif

+void
+xfs_alloc_mark_busy(xfs_trans_t *tp,
+		xfs_agnumber_t agno,
+		xfs_agblock_t bno,
+		xfs_extlen_t len);
+
+void
+xfs_alloc_clear_busy(xfs_trans_t *tp,
+		xfs_agnumber_t ag,
+		int idx);
+
+#endif	/* __KERNEL__ */
+
  /*
   * Compute and fill in value of m_ag_maxlevels.
   */
@@ -196,18 +209,4 @@ xfs_free_extent(
  	xfs_fsblock_t	bno,	/* starting block number of extent */
  	xfs_extlen_t	len);	/* length of extent */

-void
-xfs_alloc_mark_busy(xfs_trans_t *tp,
-		xfs_agnumber_t agno,
-		xfs_agblock_t bno,
-		xfs_extlen_t len);
-
-void
-xfs_alloc_clear_busy(xfs_trans_t *tp,
-		xfs_agnumber_t ag,
-		int idx);
-
-
-#endif	/* __KERNEL__ */
-
  #endif	/* __XFS_ALLOC_H__ */
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
@@ -206,20 +207,6 @@ xfs_bmap_compute_maxlevels(
  	int			whichfork);	/* data or attr fork */

  /*
- * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
- * caller.  Frees all the extents that need freeing, which must be done
- * last due to locking considerations.
- *
- * Return 1 if the given transaction was committed and a new one  
allocated,
- * and 0 otherwise.
- */
-int						/* error */
-xfs_bmap_finish(
-	struct xfs_trans	**tp,		/* transaction pointer addr */
-	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	int			*committed);	/* xact committed or not */
-
-/*
   * Returns the file-relative block number of the first unused block in  
the file.
   * This is the lowest-address hole if the file has holes, else the first  
block
   * past the end of file.
@@ -344,6 +331,32 @@ xfs_bunmapi(
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
+ * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
+ * caller.  Frees all the extents that need freeing, which must be done
+ * last due to locking considerations.
+ *
+ * Return 1 if the given transaction was committed and a new one  
allocated,
+ * and 0 otherwise.
+ */
+int						/* error */
+xfs_bmap_finish(
+	struct xfs_trans	**tp,		/* transaction pointer addr */
+	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
+	int			*committed);	/* xact committed or not */
+
+/*
   * Fcntl interface to xfs_bmapi.
   */
  int						/* error code */
@@ -375,16 +388,6 @@ xfs_bmap_count_blocks(
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
@@ -20,7 +20,7 @@

  struct xfs_dinode;
  struct xfs_dinode_core;
-
+struct xfs_inode;

  /*
   * Fork identifiers.
@@ -84,54 +84,6 @@ typedef struct xfs_ifork {
  } xfs_ifork_t;

  /*
- * Flags for xfs_ichgtime().
- */
-#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
-#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
-
-/*
- * Per-fork incore inode flags.
- */
-#define	XFS_IFINLINE	0x01	/* Inline data is read in */
-#define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
-#define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
-#define	XFS_IFEXTIREC	0x08	/* Indirection array of extent blocks */
-
-/*
- * Flags for xfs_itobp(), xfs_imap() and xfs_dilocate().
- */
-#define XFS_IMAP_LOOKUP		0x1
-#define XFS_IMAP_BULKSTAT	0x2
-
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
-/*
   * This is the xfs in-core inode structure.
   * Most of the on-disk inode is embedded in the i_d field.
   *
@@ -191,6 +143,96 @@ typedef struct xfs_icdinode {
  	__uint32_t	di_gen;		/* generation number */
  } xfs_icdinode_t;

+/*
+ * Flags for xfs_ichgtime().
+ */
+#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
+#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
+
+/*
+ * Per-fork incore inode flags.
+ */
+#define	XFS_IFINLINE	0x01	/* Inline data is read in */
+#define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
+#define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
+#define	XFS_IFEXTIREC	0x08	/* Indirection array of extent blocks */
+
+/*
+ * Flags for xfs_itobp(), xfs_imap() and xfs_dilocate().
+ */
+#define XFS_IMAP_LOOKUP		0x1
+#define XFS_IMAP_BULKSTAT	0x2
+
+/*
+ * Fork handling.
+ */
+
+#define XFS_IFORK_Q(ip)			((ip)->i_d.di_forkoff != 0)
+#define XFS_IFORK_BOFF(ip)		((int)((ip)->i_d.di_forkoff << 3))
+
+#define XFS_IFORK_PTR(ip,w)		\
+	((w) == XFS_DATA_FORK ? \
+		&(ip)->i_df : \
+		(ip)->i_afp)
+#define XFS_IFORK_DSIZE(ip) \
+	(XFS_IFORK_Q(ip) ? \
+		XFS_IFORK_BOFF(ip) : \
+		XFS_LITINO((ip)->i_mount))
+#define XFS_IFORK_ASIZE(ip) \
+	(XFS_IFORK_Q(ip) ? \
+		XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : \
+		0)
+#define XFS_IFORK_SIZE(ip,w) \
+	((w) == XFS_DATA_FORK ? \
+		XFS_IFORK_DSIZE(ip) : \
+		XFS_IFORK_ASIZE(ip))
+#define XFS_IFORK_FORMAT(ip,w) \
+	((w) == XFS_DATA_FORK ? \
+		(ip)->i_d.di_format : \
+		(ip)->i_d.di_aformat)
+#define XFS_IFORK_FMT_SET(ip,w,n) \
+	((w) == XFS_DATA_FORK ? \
+		((ip)->i_d.di_format = (n)) : \
+		((ip)->i_d.di_aformat = (n)))
+#define XFS_IFORK_NEXTENTS(ip,w) \
+	((w) == XFS_DATA_FORK ? \
+		(ip)->i_d.di_nextents : \
+		(ip)->i_d.di_anextents)
+#define XFS_IFORK_NEXT_SET(ip,w,n) \
+	((w) == XFS_DATA_FORK ? \
+		((ip)->i_d.di_nextents = (n)) : \
+		((ip)->i_d.di_anextents = (n)))
+
+
+
+#ifdef __KERNEL__
+
+struct bhv_desc;
+struct cred;
+struct ktrace;
+struct xfs_buf;
+struct xfs_bmap_free;
+struct xfs_bmbt_irec;
+struct xfs_bmbt_block;
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
@@ -327,50 +369,26 @@ xfs_iflags_test_and_clear(xfs_inode_t *i
  	spin_unlock(&ip->i_flags_lock);
  	return ret;
  }
-#endif	/* __KERNEL__ */
-

  /*
- * Fork handling.
+ * Manage the i_flush queue embedded in the inode.  This completion
+ * queue synchronizes processes attempting to flush the in-core
+ * inode back to disk.
   */
+static inline void xfs_iflock(xfs_inode_t *ip)
+{
+	wait_for_completion(&ip->i_flush);
+}

-#define XFS_IFORK_Q(ip)			((ip)->i_d.di_forkoff != 0)
-#define XFS_IFORK_BOFF(ip)		((int)((ip)->i_d.di_forkoff << 3))
-
-#define XFS_IFORK_PTR(ip,w)		\
-	((w) == XFS_DATA_FORK ? \
-		&(ip)->i_df : \
-		(ip)->i_afp)
-#define XFS_IFORK_DSIZE(ip) \
-	(XFS_IFORK_Q(ip) ? \
-		XFS_IFORK_BOFF(ip) : \
-		XFS_LITINO((ip)->i_mount))
-#define XFS_IFORK_ASIZE(ip) \
-	(XFS_IFORK_Q(ip) ? \
-		XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : \
-		0)
-#define XFS_IFORK_SIZE(ip,w) \
-	((w) == XFS_DATA_FORK ? \
-		XFS_IFORK_DSIZE(ip) : \
-		XFS_IFORK_ASIZE(ip))
-#define XFS_IFORK_FORMAT(ip,w) \
-	((w) == XFS_DATA_FORK ? \
-		(ip)->i_d.di_format : \
-		(ip)->i_d.di_aformat)
-#define XFS_IFORK_FMT_SET(ip,w,n) \
-	((w) == XFS_DATA_FORK ? \
-		((ip)->i_d.di_format = (n)) : \
-		((ip)->i_d.di_aformat = (n)))
-#define XFS_IFORK_NEXTENTS(ip,w) \
-	((w) == XFS_DATA_FORK ? \
-		(ip)->i_d.di_nextents : \
-		(ip)->i_d.di_anextents)
-#define XFS_IFORK_NEXT_SET(ip,w,n) \
-	((w) == XFS_DATA_FORK ? \
-		((ip)->i_d.di_nextents = (n)) : \
-		((ip)->i_d.di_anextents = (n)))
+static inline int xfs_iflock_nowait(xfs_inode_t *ip)
+{
+	return try_wait_for_completion(&ip->i_flush);
+}

-#ifdef __KERNEL__
+static inline void xfs_ifunlock(xfs_inode_t *ip)
+{
+	complete(&ip->i_flush);
+}

  /*
   * In-core inode flags.
@@ -490,19 +508,12 @@ int		xfs_finish_reclaim_all(struct xfs_m
  /*
   * xfs_inode.c prototypes.
   */
-int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
-			  xfs_inode_t *, struct xfs_dinode **, struct xfs_buf **,
-			  xfs_daddr_t, uint, uint);
  int		xfs_iread(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
  			  xfs_inode_t **, xfs_daddr_t, uint);
  int		xfs_iread_extents(struct xfs_trans *, xfs_inode_t *, int);
  int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
  			   xfs_nlink_t, xfs_dev_t, struct cred *, xfs_prid_t,
  			   int, struct xfs_buf **, boolean_t *, xfs_inode_t **);
-void		xfs_dinode_from_disk(struct xfs_icdinode *,
-				     struct xfs_dinode_core *);
-void		xfs_dinode_to_disk(struct xfs_dinode_core *,
-				   struct xfs_icdinode *);

  uint		xfs_ip2xflags(struct xfs_inode *);
  uint		xfs_dic2xflags(struct xfs_dinode *);
@@ -514,15 +525,11 @@ int		xfs_itruncate_finish(struct xfs_tra
  int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);

  struct xfs_inode * xfs_inode_alloc(struct xfs_mount *, xfs_ino_t);
-void		xfs_idestroy_fork(xfs_inode_t *, int);
  void		xfs_idestroy(xfs_inode_t *);
-void		xfs_idata_realloc(xfs_inode_t *, int, int);
  void		xfs_iextract(xfs_inode_t *);
  void		xfs_iext_realloc(xfs_inode_t *, int, int);
-void		xfs_iroot_realloc(xfs_inode_t *, int, int);
  void		xfs_ipin(xfs_inode_t *);
  void		xfs_iunpin(xfs_inode_t *);
-int		xfs_iextents_copy(xfs_inode_t *, xfs_bmbt_rec_t *, int);
  int		xfs_iflush(xfs_inode_t *, uint);
  void		xfs_iflush_all(struct xfs_mount *);
  void		xfs_ichgtime(xfs_inode_t *, int);
@@ -533,6 +540,20 @@ void		xfs_lock_two_inodes(xfs_inode_t *,
  void		xfs_synchronize_atime(xfs_inode_t *);
  void		xfs_mark_inode_dirty_sync(xfs_inode_t *);

+#endif /* __KERNEL__ */
+
+int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
+			  struct xfs_inode *, struct xfs_dinode **,
+			  struct xfs_buf **, xfs_daddr_t, uint, uint);
+void		xfs_dinode_from_disk(struct xfs_icdinode *,
+				     struct xfs_dinode_core *);
+void		xfs_dinode_to_disk(struct xfs_dinode_core *,
+				   struct xfs_icdinode *);
+void		xfs_idestroy_fork(struct xfs_inode *, int);
+void		xfs_idata_realloc(struct xfs_inode *, int, int);
+void		xfs_iroot_realloc(struct xfs_inode *, int, int);
+int		xfs_iextents_copy(struct xfs_inode *, xfs_bmbt_rec_t *, int);
+
  xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
  void		xfs_iext_insert(xfs_ifork_t *, xfs_extnum_t, xfs_extnum_t,
  				xfs_bmbt_irec_t *);
@@ -562,7 +583,8 @@ void		xfs_iext_irec_update_extoffs(xfs_i
  #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))

  #ifdef DEBUG
-void		xfs_isize_check(struct xfs_mount *, xfs_inode_t *, xfs_fsize_t);
+void		xfs_isize_check(struct xfs_mount *, struct xfs_inode *,
+				xfs_fsize_t);
  #else	/* DEBUG */
  #define xfs_isize_check(mp, ip, isize)
  #endif	/* DEBUG */
@@ -577,26 +599,4 @@ extern struct kmem_zone	*xfs_ifork_zone;
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
@@ -112,6 +112,24 @@ typedef struct xfs_inode_log_format_64 {
  #define	XFS_ILI_IOLOCKED_ANY   (XFS_ILI_IOLOCKED_EXCL |  
XFS_ILI_IOLOCKED_SHARED)


+#define	XFS_ILOG_FBROOT(w)	xfs_ilog_fbroot(w)
+static inline int xfs_ilog_fbroot(int w)
+{
+	return (w == XFS_DATA_FORK ? XFS_ILOG_DBROOT : XFS_ILOG_ABROOT);
+}
+
+#define	XFS_ILOG_FEXT(w)	xfs_ilog_fext(w)
+static inline int xfs_ilog_fext(int w)
+{
+	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
+}
+
+#define	XFS_ILOG_FDATA(w)	xfs_ilog_fdata(w)
+static inline int xfs_ilog_fdata(int w)
+{
+	return (w == XFS_DATA_FORK ? XFS_ILOG_DDATA : XFS_ILOG_ADATA);
+}
+
  #ifdef __KERNEL__

  struct xfs_buf;
@@ -148,26 +166,6 @@ typedef struct xfs_inode_log_item {
  } xfs_inode_log_item_t;


-#define	XFS_ILOG_FDATA(w)	xfs_ilog_fdata(w)
-static inline int xfs_ilog_fdata(int w)
-{
-	return (w == XFS_DATA_FORK ? XFS_ILOG_DDATA : XFS_ILOG_ADATA);
-}
-
-#endif	/* __KERNEL__ */
-
-#define	XFS_ILOG_FBROOT(w)	xfs_ilog_fbroot(w)
-static inline int xfs_ilog_fbroot(int w)
-{
-	return (w == XFS_DATA_FORK ? XFS_ILOG_DBROOT : XFS_ILOG_ABROOT);
-}
-
-#define	XFS_ILOG_FEXT(w)	xfs_ilog_fext(w)
-static inline int xfs_ilog_fext(int w)
-{
-	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
-}
-
  static inline int xfs_inode_clean(xfs_inode_t *ip)
  {
  	return (!ip->i_itemp ||
@@ -175,9 +173,6 @@ static inline int xfs_inode_clean(xfs_in
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
@@ -44,14 +44,14 @@ typedef struct xfs_trans_reservations {
  } xfs_trans_reservations_t;

  #ifndef __KERNEL__
-/*
- * Moved here from xfs_ag.h to avoid reordering header files
- */
+
  #define XFS_DADDR_TO_AGNO(mp,d) \
  	((xfs_agnumber_t)(XFS_BB_TO_FSBT(mp, d) / (mp)->m_sb.sb_agblocks))
  #define XFS_DADDR_TO_AGBNO(mp,d) \
  	((xfs_agblock_t)(XFS_BB_TO_FSBT(mp, d) % (mp)->m_sb.sb_agblocks))
-#else
+
+#else /* __KERNEL__ */
+
  struct cred;
  struct log;
  struct xfs_mount_args;
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
@@ -18,6 +18,8 @@
  #ifndef	__XFS_TRANS_H__
  #define	__XFS_TRANS_H__

+struct xfs_log_item;
+
  /*
   * This is the structure written in the log at the head of
   * every transaction. It identifies the type and id of the
@@ -98,76 +100,6 @@ typedef struct xfs_trans_header {
  #define	XFS_TRANS_TYPE_MAX		41
  /* new transaction types need to be reflected in xfs_logprint(8) */

-
-#ifdef __KERNEL__
-struct xfs_buf;
-struct xfs_buftarg;
-struct xfs_efd_log_item;
-struct xfs_efi_log_item;
-struct xfs_inode;
-struct xfs_item_ops;
-struct xfs_log_iovec;
-struct xfs_log_item;
-struct xfs_log_item_desc;
-struct xfs_mount;
-struct xfs_trans;
-struct xfs_dquot_acct;
-
-typedef struct xfs_log_item {
-	struct list_head		li_ail;		/* AIL pointers */
-	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
-	struct xfs_log_item_desc	*li_desc;	/* ptr to current desc*/
-	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
-	uint				li_type;	/* item type */
-	uint				li_flags;	/* misc flags */
-	struct xfs_log_item		*li_bio_list;	/* buffer item list */
-	void				(*li_cb)(struct xfs_buf *,
-						 struct xfs_log_item *);
-							/* buffer item iodone */
-							/* callback func */
-	struct xfs_item_ops		*li_ops;	/* function list */
-} xfs_log_item_t;
-
-#define	XFS_LI_IN_AIL	0x1
-#define XFS_LI_ABORTED	0x2
-
-typedef struct xfs_item_ops {
-	uint (*iop_size)(xfs_log_item_t *);
-	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
-	void (*iop_pin)(xfs_log_item_t *);
-	void (*iop_unpin)(xfs_log_item_t *, int);
-	void (*iop_unpin_remove)(xfs_log_item_t *, struct xfs_trans *);
-	uint (*iop_trylock)(xfs_log_item_t *);
-	void (*iop_unlock)(xfs_log_item_t *);
-	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
-	void (*iop_push)(xfs_log_item_t *);
-	void (*iop_pushbuf)(xfs_log_item_t *);
-	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
-} xfs_item_ops_t;
-
-#define IOP_SIZE(ip)		(*(ip)->li_ops->iop_size)(ip)
-#define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)
-#define IOP_PIN(ip)		(*(ip)->li_ops->iop_pin)(ip)
-#define IOP_UNPIN(ip, flags)	(*(ip)->li_ops->iop_unpin)(ip, flags)
-#define IOP_UNPIN_REMOVE(ip,tp) (*(ip)->li_ops->iop_unpin_remove)(ip, tp)
-#define IOP_TRYLOCK(ip)		(*(ip)->li_ops->iop_trylock)(ip)
-#define IOP_UNLOCK(ip)		(*(ip)->li_ops->iop_unlock)(ip)
-#define IOP_COMMITTED(ip, lsn)	(*(ip)->li_ops->iop_committed)(ip, lsn)
-#define IOP_PUSH(ip)		(*(ip)->li_ops->iop_push)(ip)
-#define IOP_PUSHBUF(ip)		(*(ip)->li_ops->iop_pushbuf)(ip)
-#define IOP_COMMITTING(ip, lsn) (*(ip)->li_ops->iop_committing)(ip, lsn)
-
-/*
- * Return values for the IOP_TRYLOCK() routines.
- */
-#define	XFS_ITEM_SUCCESS	0
-#define	XFS_ITEM_PINNED		1
-#define	XFS_ITEM_LOCKED		2
-#define	XFS_ITEM_FLUSHING	3
-#define XFS_ITEM_PUSHBUF	4
-
-#endif	/* __KERNEL__ */
-
  /*
   * This structure is used to track log items associated with
   * a transaction.  It points to the log item and keeps some
@@ -176,7 +108,7 @@ typedef struct xfs_item_ops {
   * once we get to commit processing (see xfs_trans_commit()).
   */
  typedef struct xfs_log_item_desc {
-	xfs_log_item_t	*lid_item;
+	struct xfs_log_item	*lid_item;
  	ushort		lid_size;
  	unsigned char	lid_flags;
  	unsigned char	lid_index;
@@ -276,94 +208,6 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_
  		(xfs_caddr_t)(((xfs_log_item_chunk_t*)0)->lic_descs));
  }

-#ifdef __KERNEL__
-/*
- * This structure is used to maintain a list of block ranges that have  
been
- * freed in the transaction.  The ranges are listed in the perag[] busy  
list
- * between when they're freed and the transaction is committed to disk.
- */
-
-typedef struct xfs_log_busy_slot {
-	xfs_agnumber_t		lbc_ag;
-	ushort			lbc_idx;	/* index in perag.busy[] */
-} xfs_log_busy_slot_t;
-
-#define XFS_LBC_NUM_SLOTS	31
-typedef struct xfs_log_busy_chunk {
-	struct xfs_log_busy_chunk	*lbc_next;
-	uint				lbc_free;	/* free slots bitmask */
-	ushort				lbc_unused;	/* first unused */
-	xfs_log_busy_slot_t		lbc_busy[XFS_LBC_NUM_SLOTS];
-} xfs_log_busy_chunk_t;
-
-#define	XFS_LBC_MAX_SLOT	(XFS_LBC_NUM_SLOTS - 1)
-#define	XFS_LBC_FREEMASK	((1U << XFS_LBC_NUM_SLOTS) - 1)
-
-#define	XFS_LBC_INIT(cp)	((cp)->lbc_free = XFS_LBC_FREEMASK)
-#define	XFS_LBC_CLAIM(cp, slot)	((cp)->lbc_free &= ~(1 << (slot)))
-#define	XFS_LBC_SLOT(cp, slot)	(&((cp)->lbc_busy[(slot)]))
-#define	XFS_LBC_VACANCY(cp)	(((cp)->lbc_free) & XFS_LBC_FREEMASK)
-#define	XFS_LBC_ISFREE(cp, slot) ((cp)->lbc_free & (1 << (slot)))
-
-/*
- * This is the type of function which can be given to xfs_trans_callback()
- * to be called upon the transaction's commit to disk.
- */
-typedef void (*xfs_trans_callback_t)(struct xfs_trans *, void *);
-
-/*
- * This is the structure maintained for every active transaction.
- */
-typedef struct xfs_trans {
-	unsigned int		t_magic;	/* magic number */
-	xfs_log_callback_t	t_logcb;	/* log callback struct */
-	unsigned int		t_type;		/* transaction type */
-	unsigned int		t_log_res;	/* amt of log space resvd */
-	unsigned int		t_log_count;	/* count for perm log res */
-	unsigned int		t_blk_res;	/* # of blocks resvd */
-	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
-	unsigned int		t_rtx_res;	/* # of rt extents resvd */
-	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
-	xfs_log_ticket_t	t_ticket;	/* log mgr ticket */
-	xfs_lsn_t		t_lsn;		/* log seq num of start of
-						 * transaction. */
-	xfs_lsn_t		t_commit_lsn;	/* log seq num of end of
-						 * transaction. */
-	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
-	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
-	xfs_trans_callback_t	t_callback;	/* transaction callback */
-	void			*t_callarg;	/* callback arg */
-	unsigned int		t_flags;	/* misc flags */
-	int64_t			t_icount_delta;	/* superblock icount change */
-	int64_t			t_ifree_delta;	/* superblock ifree change */
-	int64_t			t_fdblocks_delta; /* superblock fdblocks chg */
-	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
-	int64_t			t_frextents_delta;/* superblock freextents chg*/
-	int64_t			t_res_frextents_delta; /* on-disk only chg */
-#ifdef DEBUG
-	int64_t			t_ag_freeblks_delta; /* debugging counter */
-	int64_t			t_ag_flist_delta; /* debugging counter */
-	int64_t			t_ag_btree_delta; /* debugging counter */
-#endif
-	int64_t			t_dblocks_delta;/* superblock dblocks change */
-	int64_t			t_agcount_delta;/* superblock agcount change */
-	int64_t			t_imaxpct_delta;/* superblock imaxpct change */
-	int64_t			t_rextsize_delta;/* superblock rextsize chg */
-	int64_t			t_rbmblocks_delta;/* superblock rbmblocks chg */
-	int64_t			t_rblocks_delta;/* superblock rblocks change */
-	int64_t			t_rextents_delta;/* superblocks rextents chg */
-	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
-	unsigned int		t_items_free;	/* log item descs free */
-	xfs_log_item_chunk_t	t_items;	/* first log item desc chunk */
-	xfs_trans_header_t	t_header;	/* header for in-log trans */
-	unsigned int		t_busy_free;	/* busy descs free */
-	xfs_log_busy_chunk_t	t_busy;		/* busy/async free blocks */
-	unsigned long		t_pflags;	/* saved process flags state */
-} xfs_trans_t;
-
-#endif	/* __KERNEL__ */
-
-
  #define	XFS_TRANS_MAGIC		0x5452414E	/* 'TRAN' */
  /*
   * Values for t_flags.
@@ -906,6 +750,156 @@ typedef struct xfs_trans {
  #define	XFS_DQUOT_REF		1

  #ifdef __KERNEL__
+
+struct xfs_buf;
+struct xfs_buftarg;
+struct xfs_efd_log_item;
+struct xfs_efi_log_item;
+struct xfs_inode;
+struct xfs_item_ops;
+struct xfs_log_iovec;
+struct xfs_log_item_desc;
+struct xfs_mount;
+struct xfs_trans;
+struct xfs_dquot_acct;
+
+typedef struct xfs_log_item {
+	struct list_head		li_ail;		/* AIL pointers */
+	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
+	struct xfs_log_item_desc	*li_desc;	/* ptr to current desc*/
+	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
+	uint				li_type;	/* item type */
+	uint				li_flags;	/* misc flags */
+	struct xfs_log_item		*li_bio_list;	/* buffer item list */
+	void				(*li_cb)(struct xfs_buf *,
+						 struct xfs_log_item *);
+							/* buffer item iodone */
+							/* callback func */
+	struct xfs_item_ops		*li_ops;	/* function list */
+} xfs_log_item_t;
+
+#define	XFS_LI_IN_AIL	0x1
+#define XFS_LI_ABORTED	0x2
+
+typedef struct xfs_item_ops {
+	uint (*iop_size)(xfs_log_item_t *);
+	void (*iop_format)(xfs_log_item_t *, struct xfs_log_iovec *);
+	void (*iop_pin)(xfs_log_item_t *);
+	void (*iop_unpin)(xfs_log_item_t *, int);
+	void (*iop_unpin_remove)(xfs_log_item_t *, struct xfs_trans *);
+	uint (*iop_trylock)(xfs_log_item_t *);
+	void (*iop_unlock)(xfs_log_item_t *);
+	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
+	void (*iop_push)(xfs_log_item_t *);
+	void (*iop_pushbuf)(xfs_log_item_t *);
+	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
+} xfs_item_ops_t;
+
+#define IOP_SIZE(ip)		(*(ip)->li_ops->iop_size)(ip)
+#define IOP_FORMAT(ip,vp)	(*(ip)->li_ops->iop_format)(ip, vp)
+#define IOP_PIN(ip)		(*(ip)->li_ops->iop_pin)(ip)
+#define IOP_UNPIN(ip, flags)	(*(ip)->li_ops->iop_unpin)(ip, flags)
+#define IOP_UNPIN_REMOVE(ip,tp) (*(ip)->li_ops->iop_unpin_remove)(ip, tp)
+#define IOP_TRYLOCK(ip)		(*(ip)->li_ops->iop_trylock)(ip)
+#define IOP_UNLOCK(ip)		(*(ip)->li_ops->iop_unlock)(ip)
+#define IOP_COMMITTED(ip, lsn)	(*(ip)->li_ops->iop_committed)(ip, lsn)
+#define IOP_PUSH(ip)		(*(ip)->li_ops->iop_push)(ip)
+#define IOP_PUSHBUF(ip)		(*(ip)->li_ops->iop_pushbuf)(ip)
+#define IOP_COMMITTING(ip, lsn) (*(ip)->li_ops->iop_committing)(ip, lsn)
+
+/*
+ * Return values for the IOP_TRYLOCK() routines.
+ */
+#define	XFS_ITEM_SUCCESS	0
+#define	XFS_ITEM_PINNED		1
+#define	XFS_ITEM_LOCKED		2
+#define	XFS_ITEM_FLUSHING	3
+#define XFS_ITEM_PUSHBUF	4
+
+/*
+ * This structure is used to maintain a list of block ranges that have  
been
+ * freed in the transaction.  The ranges are listed in the perag[] busy  
list
+ * between when they're freed and the transaction is committed to disk.
+ */
+
+typedef struct xfs_log_busy_slot {
+	xfs_agnumber_t		lbc_ag;
+	ushort			lbc_idx;	/* index in perag.busy[] */
+} xfs_log_busy_slot_t;
+
+#define XFS_LBC_NUM_SLOTS	31
+typedef struct xfs_log_busy_chunk {
+	struct xfs_log_busy_chunk	*lbc_next;
+	uint				lbc_free;	/* free slots bitmask */
+	ushort				lbc_unused;	/* first unused */
+	xfs_log_busy_slot_t		lbc_busy[XFS_LBC_NUM_SLOTS];
+} xfs_log_busy_chunk_t;
+
+#define	XFS_LBC_MAX_SLOT	(XFS_LBC_NUM_SLOTS - 1)
+#define	XFS_LBC_FREEMASK	((1U << XFS_LBC_NUM_SLOTS) - 1)
+
+#define	XFS_LBC_INIT(cp)	((cp)->lbc_free = XFS_LBC_FREEMASK)
+#define	XFS_LBC_CLAIM(cp, slot)	((cp)->lbc_free &= ~(1 << (slot)))
+#define	XFS_LBC_SLOT(cp, slot)	(&((cp)->lbc_busy[(slot)]))
+#define	XFS_LBC_VACANCY(cp)	(((cp)->lbc_free) & XFS_LBC_FREEMASK)
+#define	XFS_LBC_ISFREE(cp, slot) ((cp)->lbc_free & (1 << (slot)))
+
+/*
+ * This is the type of function which can be given to xfs_trans_callback()
+ * to be called upon the transaction's commit to disk.
+ */
+typedef void (*xfs_trans_callback_t)(struct xfs_trans *, void *);
+
+/*
+ * This is the structure maintained for every active transaction.
+ */
+typedef struct xfs_trans {
+	unsigned int		t_magic;	/* magic number */
+	xfs_log_callback_t	t_logcb;	/* log callback struct */
+	unsigned int		t_type;		/* transaction type */
+	unsigned int		t_log_res;	/* amt of log space resvd */
+	unsigned int		t_log_count;	/* count for perm log res */
+	unsigned int		t_blk_res;	/* # of blocks resvd */
+	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
+	unsigned int		t_rtx_res;	/* # of rt extents resvd */
+	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
+	xfs_log_ticket_t	t_ticket;	/* log mgr ticket */
+	xfs_lsn_t		t_lsn;		/* log seq num of start of
+						 * transaction. */
+	xfs_lsn_t		t_commit_lsn;	/* log seq num of end of
+						 * transaction. */
+	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
+	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
+	xfs_trans_callback_t	t_callback;	/* transaction callback */
+	void			*t_callarg;	/* callback arg */
+	unsigned int		t_flags;	/* misc flags */
+	int64_t			t_icount_delta;	/* superblock icount change */
+	int64_t			t_ifree_delta;	/* superblock ifree change */
+	int64_t			t_fdblocks_delta; /* superblock fdblocks chg */
+	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
+	int64_t			t_frextents_delta;/* superblock freextents chg*/
+	int64_t			t_res_frextents_delta; /* on-disk only chg */
+#ifdef DEBUG
+	int64_t			t_ag_freeblks_delta; /* debugging counter */
+	int64_t			t_ag_flist_delta; /* debugging counter */
+	int64_t			t_ag_btree_delta; /* debugging counter */
+#endif
+	int64_t			t_dblocks_delta;/* superblock dblocks change */
+	int64_t			t_agcount_delta;/* superblock agcount change */
+	int64_t			t_imaxpct_delta;/* superblock imaxpct change */
+	int64_t			t_rextsize_delta;/* superblock rextsize chg */
+	int64_t			t_rbmblocks_delta;/* superblock rbmblocks chg */
+	int64_t			t_rblocks_delta;/* superblock rblocks change */
+	int64_t			t_rextents_delta;/* superblocks rextents chg */
+	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
+	unsigned int		t_items_free;	/* log item descs free */
+	xfs_log_item_chunk_t	t_items;	/* first log item desc chunk */
+	xfs_trans_header_t	t_header;	/* header for in-log trans */
+	unsigned int		t_busy_free;	/* busy descs free */
+	xfs_log_busy_chunk_t	t_busy;		/* busy/async free blocks */
+	unsigned long		t_pflags;	/* saved process flags state */
+} xfs_trans_t;
+
  /*
   * XFS transaction mechanism exported interfaces that are
   * actually macros.
@@ -928,7 +922,6 @@ typedef struct xfs_trans {
  /*
   * XFS transaction mechanism exported interfaces.
   */
-void		xfs_trans_init(struct xfs_mount *);
  xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
  xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint);
  xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
@@ -975,7 +968,6 @@ int		_xfs_trans_commit(xfs_trans_t *,
  				  int *);
  #define xfs_trans_commit(tp, flags)	_xfs_trans_commit(tp, flags, NULL)
  void		xfs_trans_cancel(xfs_trans_t *, int);
-int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
  int		xfs_trans_ail_init(struct xfs_mount *);
  void		xfs_trans_ail_destroy(struct xfs_mount *);
  void		xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
@@ -990,4 +982,7 @@ extern kmem_zone_t	*xfs_trans_zone;

  #endif	/* __KERNEL__ */

+void		xfs_trans_init(struct xfs_mount *);
+int		xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
+
  #endif	/* __XFS_TRANS_H__ */

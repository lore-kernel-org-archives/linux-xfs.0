Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 31 Aug 2008 18:54:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m811raHo009314
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 18:53:37 -0700
Date: Mon, 01 Sep 2008 11:56:03 +1000
Subject: Re: [REVIEW #2]  Update kernel code to compile in userspace (libxfs)
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.ugmy3u2o3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <op.ugm1ttzb3jf8g2@pc-bnaujok.melbourne.sgi.com>
 <20080829181120.GA9455@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugr4zpyv3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080829181120.GA9455@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, 30 Aug 2008 04:11:20 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Fri, Aug 29, 2008 at 05:59:43PM +1000, Barry Naujok wrote:
>> On Fri, 29 Aug 2008 17:00:56 +1000, Barry Naujok <bnaujok@sgi.com>  
>> wrote:
>>
>>> Mostly header changes associated with #ifdef __KERNEL__ stuff.
>>>
>>> Some function prototypes had to be reordered to separate
>>> shared and kernel only functions.
>>
>> fs/xfs/xfs_inode.h patch looked pretty horrid (and there was a missing
>> declaration), here's a better version:
>
> I still don't like it very much :)  What about just moving the
> xfs_ictimestamp and xfs_icdinode defintions next to the ifork
> so that we can save one ifdef __KERNEL__?  Also might be worth
> to move the xfs_iflock & co inlines before the end of that __KERNEL__
> block to save another ifdef.

Ok, this now only has one blob of #ifdef __KERNEL__ in it now:

Index: 2.6.x-xfs/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs.orig/fs/xfs/xfs_inode.h
+++ 2.6.x-xfs/fs/xfs/xfs_inode.h
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
@@ -191,6 +143,97 @@ typedef struct xfs_icdinode {
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
@@ -327,50 +370,26 @@ xfs_iflags_test_and_clear(xfs_inode_t *i
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
@@ -490,19 +509,12 @@ int		xfs_finish_reclaim_all(struct xfs_m
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
@@ -514,15 +526,11 @@ int		xfs_itruncate_finish(struct xfs_tra
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
@@ -533,6 +541,20 @@ void		xfs_lock_two_inodes(xfs_inode_t *,
  void		xfs_synchronize_atime(xfs_inode_t *);
  void		xfs_mark_inode_dirty_sync(xfs_inode_t *);

+#endif /* __KERNEL__ */
+
+int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
+			  xfs_inode_t *, struct xfs_dinode **, struct xfs_buf **,
+			  xfs_daddr_t, uint, uint);
+void		xfs_dinode_from_disk(struct xfs_icdinode *,
+				     struct xfs_dinode_core *);
+void		xfs_dinode_to_disk(struct xfs_dinode_core *,
+				   struct xfs_icdinode *);
+void		xfs_idestroy_fork(xfs_inode_t *, int);
+void		xfs_idata_realloc(xfs_inode_t *, int, int);
+void		xfs_iroot_realloc(xfs_inode_t *, int, int);
+int		xfs_iextents_copy(xfs_inode_t *, xfs_bmbt_rec_t *, int);
+
  xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
  void		xfs_iext_insert(xfs_ifork_t *, xfs_extnum_t, xfs_extnum_t,
  				xfs_bmbt_irec_t *);
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

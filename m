Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfEPRnf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 May 2019 13:43:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 300A63082B6B
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 17:43:35 +0000 (UTC)
Received: from Liberator-6.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 018EB5D978
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 17:43:34 +0000 (UTC)
Subject: [PATCH 1/3] libxfs: rename shared kernel functions from libxfs_ to
 xfs_
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <bef9aa18-a9b1-4743-342d-b6f77c26b67b@redhat.com>
Date: Thu, 16 May 2019 12:43:34 -0500
MIME-Version: 1.0
In-Reply-To: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The libxfs_* function namespace has gotten a bit confused and
muddled; the general idea is that functions called from userspace
utilities should use the libxfs_* namespace.  In many cases
we use #defines to define xfs_* namespace to libxfs_*; in other
cases we have explicitly defined libxfs_* functions which are clear
counterparts or even clones of kernel libxfs/* functions.

For any function definitions within libxfs/* which match kernel
names, give them standard xfs_* names to further reduce differnces
between userspace and kernel libxfs/* code.

Then add #defines to libxfs_* for any functions which are needed
by utilities, as is done with other core functionality.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/libxfs.h b/include/libxfs.h
index 230bc3e8..ceebccdc 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -151,7 +151,7 @@ extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
 
 /* Shared utility routines */
 
-extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
+extern int	xfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
 				xfs_off_t, int, int);
 
 /* XXX: this is messy and needs fixing */
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 88b58ac3..3e7e80ea 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -139,21 +139,21 @@ typedef struct cred {
 	gid_t	cr_gid;
 } cred_t;
 
-extern int	libxfs_inode_alloc (struct xfs_trans **, struct xfs_inode *,
+extern int	xfs_inode_alloc (struct xfs_trans **, struct xfs_inode *,
 				mode_t, nlink_t, xfs_dev_t, struct cred *,
 				struct fsxattr *, struct xfs_inode **);
-extern void	libxfs_trans_inode_alloc_buf (struct xfs_trans *,
+extern void	xfs_trans_inode_alloc_buf (struct xfs_trans *,
 				struct xfs_buf *);
 
-extern void	libxfs_trans_ichgtime(struct xfs_trans *,
+extern void	xfs_trans_ichgtime(struct xfs_trans *,
 				struct xfs_inode *, int);
-extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
+extern int	xfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
 /* Inode Cache Interfaces */
-extern bool	libxfs_inode_verify_forks(struct xfs_inode *ip);
-extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
+extern bool	xfs_inode_verify_forks(struct xfs_inode *ip);
+extern int	xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 				uint, struct xfs_inode **,
 				struct xfs_ifork_ops *);
-extern void	libxfs_irele(struct xfs_inode *ip);
+extern void	xfs_irele(struct xfs_inode *ip);
 
 #endif /* __XFS_INODE_H__ */
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 10b74538..d32acc9e 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -75,46 +75,46 @@ typedef struct xfs_trans {
 void	xfs_trans_init(struct xfs_mount *);
 int	xfs_trans_roll(struct xfs_trans **);
 
-int	libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
+int	xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 			   uint blocks, uint rtextents, uint flags,
 			   struct xfs_trans **tpp);
 int	libxfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
 				    struct xfs_trans **tpp);
-int	libxfs_trans_alloc_empty(struct xfs_mount *mp, struct xfs_trans **tpp);
-int	libxfs_trans_commit(struct xfs_trans *);
-void	libxfs_trans_cancel(struct xfs_trans *);
+int	xfs_trans_alloc_empty(struct xfs_mount *mp, struct xfs_trans **tpp);
+int	xfs_trans_commit(struct xfs_trans *);
+void	xfs_trans_cancel(struct xfs_trans *);
 
 /* cancel dfops associated with a transaction */
 void xfs_defer_cancel(struct xfs_trans *);
 
-struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *, struct xfs_mount *, int);
+struct xfs_buf *xfs_trans_getsb(struct xfs_trans *, struct xfs_mount *, int);
 
-void	libxfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
-void	libxfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
+void	xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
+void	xfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
 				uint);
-int	libxfs_trans_roll_inode (struct xfs_trans **, struct xfs_inode *);
-
-void	libxfs_trans_brelse(struct xfs_trans *, struct xfs_buf *);
-void	libxfs_trans_binval(struct xfs_trans *, struct xfs_buf *);
-void	libxfs_trans_bjoin(struct xfs_trans *, struct xfs_buf *);
-void	libxfs_trans_bhold(struct xfs_trans *, struct xfs_buf *);
-void	libxfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
-void	libxfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *,
+int	xfs_trans_roll_inode (struct xfs_trans **, struct xfs_inode *);
+
+void	xfs_trans_brelse(struct xfs_trans *, struct xfs_buf *);
+void	xfs_trans_binval(struct xfs_trans *, struct xfs_buf *);
+void	xfs_trans_bjoin(struct xfs_trans *, struct xfs_buf *);
+void	xfs_trans_bhold(struct xfs_trans *, struct xfs_buf *);
+void	xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
+void	xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *,
 				uint, uint);
-bool	libxfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
+bool	xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 
-struct xfs_buf	*libxfs_trans_get_buf_map(struct xfs_trans *tp,
+struct xfs_buf	*xfs_trans_get_buf_map(struct xfs_trans *tp,
 					struct xfs_buftarg *btp,
 					struct xfs_buf_map *map, int nmaps,
 					uint flags);
 
-int	libxfs_trans_read_buf_map(struct xfs_mount *mp, struct xfs_trans *tp,
+int	xfs_trans_read_buf_map(struct xfs_mount *mp, struct xfs_trans *tp,
 				  struct xfs_buftarg *btp,
 				  struct xfs_buf_map *map, int nmaps,
 				  uint flags, struct xfs_buf **bpp,
 				  const struct xfs_buf_ops *ops);
 static inline struct xfs_buf *
-libxfs_trans_get_buf(
+xfs_trans_get_buf(
 	struct xfs_trans	*tp,
 	struct xfs_buftarg	*btp,
 	xfs_daddr_t		blkno,
@@ -122,11 +122,11 @@ libxfs_trans_get_buf(
 	uint			flags)
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return libxfs_trans_get_buf_map(tp, btp, &map, 1, flags);
+	return xfs_trans_get_buf_map(tp, btp, &map, 1, flags);
 }
 
 static inline int
-libxfs_trans_read_buf(
+xfs_trans_read_buf(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_buftarg	*btp,
@@ -137,7 +137,7 @@ libxfs_trans_read_buf(
 	const struct xfs_buf_ops *ops)
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return libxfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
+	return xfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
 }
 
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/init.c b/libxfs/init.c
index 2f6decc8..4b402a6e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -449,7 +449,7 @@ rtmount_init(
 }
 
 static int
-libxfs_initialize_perag(
+xfs_initialize_perag(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agcount,
 	xfs_agnumber_t	*maxagi)
@@ -790,7 +790,7 @@ libxfs_mount(
 	}
 
 	/*
-	 * libxfs_initialize_perag will allocate a perag structure for each ag.
+	 * xfs_initialize_perag will allocate a perag structure for each ag.
 	 * If agcount is corrupted and insanely high, this will OOM the box.
 	 * If the agount seems (arbitrarily) high, try to read what would be
 	 * the last AG, and if that fails for a relatively high agcount, just
@@ -812,7 +812,7 @@ libxfs_mount(
 		libxfs_putbuf(bp);
 	}
 
-	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
+	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
 	if (error) {
 		fprintf(stderr, _("%s: perag init failed\n"),
 			progname);
@@ -826,9 +826,9 @@ void
 libxfs_rtmount_destroy(xfs_mount_t *mp)
 {
 	if (mp->m_rsumip)
-		libxfs_irele(mp->m_rsumip);
+		xfs_irele(mp->m_rsumip);
 	if (mp->m_rbmip)
-		libxfs_irele(mp->m_rbmip);
+		xfs_irele(mp->m_rbmip);
 	mp->m_rsumip = mp->m_rbmip = NULL;
 }
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 1150ec93..2b8ac5ab 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -17,6 +17,7 @@
 #define xfs_highbit64			libxfs_highbit64
 
 #define xfs_trans_alloc			libxfs_trans_alloc
+#define xfs_trans_alloc_rollable	libxfs_trans_alloc_rollable
 #define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
 #define xfs_trans_add_item		libxfs_trans_add_item
 #define xfs_trans_bhold			libxfs_trans_bhold
@@ -90,6 +91,9 @@
 #define xfs_idestroy_fork		libxfs_idestroy_fork
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
+#define xfs_inode_alloc			libxfs_inode_alloc
+#define xfs_iflush_int			libxfs_iflush_int
+#define xfs_alloc_file_space		libxfs_alloc_file_space
 
 #define xfs_rmap_alloc			libxfs_rmap_alloc
 #define xfs_rmap_query_range		libxfs_rmap_query_range
@@ -144,4 +148,9 @@
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_init_local_fork		libxfs_init_local_fork
 
+#define xfs_getsb			libxfs_getsb
+#define xfs_irele			libxfs_irele
+#define xfs_iget			libxfs_iget
+#define xfs_inode_verify_forks		libxfs_inode_verify_forks
+
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 79ffd470..8fa2c2c5 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -177,7 +177,7 @@ extern void	libxfs_putbuf (xfs_buf_t *);
 
 extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
 			const struct xfs_buf_ops *ops);
-extern xfs_buf_t *libxfs_getsb(struct xfs_mount *, int);
+extern xfs_buf_t *xfs_getsb(struct xfs_mount *, int);
 extern void	libxfs_bcache_purge(void);
 extern void	libxfs_bcache_free(void);
 extern void	libxfs_bcache_flush(void);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index d668a157..157a99d6 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -559,7 +559,7 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 	struct xfs_rtalloc_rec	*rec,
 	void			*priv);
 
-int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
+int xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
                         xfs_off_t count_fsb);
 
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index e3ff5842..8d6f958a 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -476,7 +476,7 @@ libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
 
 
 xfs_buf_t *
-libxfs_getsb(xfs_mount_t *mp, int flags)
+xfs_getsb(xfs_mount_t *mp, int flags)
 {
 	return libxfs_readbuf(mp->m_ddev_targp, XFS_SB_DADDR,
 				XFS_FSS_TO_BB(mp, 1), flags, &xfs_sb_buf_ops);
@@ -1374,7 +1374,7 @@ extern kmem_zone_t	*xfs_ili_zone;
  * make sure they're not corrupt.
  */
 bool
-libxfs_inode_verify_forks(
+xfs_inode_verify_forks(
 	struct xfs_inode	*ip)
 {
 	struct xfs_ifork	*ifp;
@@ -1403,7 +1403,7 @@ libxfs_inode_verify_forks(
 }
 
 int
-libxfs_iget(
+xfs_iget(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_ino_t		ino,
@@ -1428,8 +1428,8 @@ libxfs_iget(
 	}
 
 	ip->i_fork_ops = ifork_ops;
-	if (!libxfs_inode_verify_forks(ip)) {
-		libxfs_irele(ip);
+	if (!xfs_inode_verify_forks(ip)) {
+		xfs_irele(ip);
 		return -EFSCORRUPTED;
 	}
 
@@ -1446,26 +1446,26 @@ libxfs_iget(
 }
 
 static void
-libxfs_idestroy(xfs_inode_t *ip)
+xfs_idestroy(xfs_inode_t *ip)
 {
 	switch (VFS_I(ip)->i_mode & S_IFMT) {
 		case S_IFREG:
 		case S_IFDIR:
 		case S_IFLNK:
-			libxfs_idestroy_fork(ip, XFS_DATA_FORK);
+			xfs_idestroy_fork(ip, XFS_DATA_FORK);
 			break;
 	}
 	if (ip->i_afp)
-		libxfs_idestroy_fork(ip, XFS_ATTR_FORK);
+		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
 	if (ip->i_cowfp)
 		xfs_idestroy_fork(ip, XFS_COW_FORK);
 }
 
 void
-libxfs_irele(
+xfs_irele(
 	struct xfs_inode	*ip)
 {
 	ASSERT(ip->i_itemp == NULL);
-	libxfs_idestroy(ip);
+	xfs_idestroy(ip);
 	kmem_zone_free(xfs_inode_zone, ip);
 }
diff --git a/libxfs/trans.c b/libxfs/trans.c
index cb15552c..5ef0c055 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -36,7 +36,7 @@ kmem_zone_t	*xfs_trans_zone;
  * in the mount structure.
  */
 void
-libxfs_trans_init(
+xfs_trans_init(
 	struct xfs_mount	*mp)
 {
 	xfs_trans_resv_calc(mp, &mp->m_resv);
@@ -46,7 +46,7 @@ libxfs_trans_init(
  * Add the given log item to the transaction's list of log items.
  */
 void
-libxfs_trans_add_item(
+xfs_trans_add_item(
 	struct xfs_trans	*tp,
 	struct xfs_log_item	*lip)
 {
@@ -62,7 +62,7 @@ libxfs_trans_add_item(
  * Unlink and free the given descriptor.
  */
 void
-libxfs_trans_del_item(
+xfs_trans_del_item(
 	struct xfs_log_item	*lip)
 {
 	clear_bit(XFS_LI_DIRTY, &lip->li_flags);
@@ -77,7 +77,7 @@ libxfs_trans_del_item(
  * chunk we've been working on and get a new transaction to continue.
  */
 int
-libxfs_trans_roll(
+xfs_trans_roll(
 	struct xfs_trans	**tpp)
 {
 	struct xfs_trans	*trans = *tpp;
@@ -245,7 +245,7 @@ undo_blocks:
 }
 
 int
-libxfs_trans_alloc(
+xfs_trans_alloc(
 	struct xfs_mount	*mp,
 	struct xfs_trans_res	*resp,
 	unsigned int		blocks,
@@ -289,7 +289,7 @@ libxfs_trans_alloc(
  * without any dirty data.
  */
 int
-libxfs_trans_alloc_empty(
+xfs_trans_alloc_empty(
 	struct xfs_mount		*mp,
 	struct xfs_trans		**tpp)
 {
@@ -304,17 +304,17 @@ libxfs_trans_alloc_empty(
  * permanent log reservation flag to avoid blowing asserts.
  */
 int
-libxfs_trans_alloc_rollable(
+xfs_trans_alloc_rollable(
 	struct xfs_mount	*mp,
 	unsigned int		blocks,
 	struct xfs_trans	**tpp)
 {
-	return libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, blocks,
+	return xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, blocks,
 			0, 0, tpp);
 }
 
 void
-libxfs_trans_cancel(
+xfs_trans_cancel(
 	struct xfs_trans	*tp)
 {
 #ifdef XACT_DEBUG
@@ -337,7 +337,7 @@ out:
 }
 
 void
-libxfs_trans_ijoin(
+xfs_trans_ijoin(
 	xfs_trans_t		*tp,
 	xfs_inode_t		*ip,
 	uint			lock_flags)
@@ -360,7 +360,7 @@ libxfs_trans_ijoin(
 }
 
 void
-libxfs_trans_inode_alloc_buf(
+xfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
@@ -407,7 +407,7 @@ xfs_trans_log_inode(
 }
 
 int
-libxfs_trans_roll_inode(
+xfs_trans_roll_inode(
 	struct xfs_trans	**tpp,
 	struct xfs_inode	*ip)
 {
@@ -425,7 +425,7 @@ libxfs_trans_roll_inode(
  * Mark a buffer dirty in the transaction.
  */
 void
-libxfs_trans_dirty_buf(
+xfs_trans_dirty_buf(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp)
 {
@@ -451,7 +451,7 @@ libxfs_trans_dirty_buf(
  * value of b_blkno.
  */
 void
-libxfs_trans_log_buf(
+xfs_trans_log_buf(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	uint			first,
@@ -473,7 +473,7 @@ libxfs_trans_log_buf(
  * If the buffer is already dirty, trigger the "already logged" return condition.
  */
 bool
-libxfs_trans_ordered_buf(
+xfs_trans_ordered_buf(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp)
 {
@@ -481,7 +481,7 @@ libxfs_trans_ordered_buf(
 	bool			ret;
 
 	ret = test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
-	libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount);
+	xfs_trans_log_buf(tp, bp, 0, bp->b_bcount);
 	return ret;
 }
 
@@ -496,7 +496,7 @@ xfs_buf_item_put(
 }
 
 void
-libxfs_trans_brelse(
+xfs_trans_brelse(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
@@ -531,7 +531,7 @@ libxfs_trans_brelse(
 }
 
 void
-libxfs_trans_binval(
+xfs_trans_binval(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
@@ -556,7 +556,7 @@ libxfs_trans_binval(
 }
 
 void
-libxfs_trans_bjoin(
+xfs_trans_bjoin(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
@@ -574,7 +574,7 @@ libxfs_trans_bjoin(
 }
 
 void
-libxfs_trans_bhold(
+xfs_trans_bhold(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
@@ -590,7 +590,7 @@ libxfs_trans_bhold(
 }
 
 xfs_buf_t *
-libxfs_trans_get_buf_map(
+xfs_trans_get_buf_map(
 	xfs_trans_t		*tp,
 	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map,
@@ -619,14 +619,14 @@ libxfs_trans_get_buf_map(
 	fprintf(stderr, "trans_get_buf buffer %p, transaction %p\n", bp, tp);
 #endif
 
-	libxfs_trans_bjoin(tp, bp);
+	xfs_trans_bjoin(tp, bp);
 	bip = bp->b_log_item;
 	bip->bli_recur = 0;
 	return bp;
 }
 
 xfs_buf_t *
-libxfs_trans_getsb(
+xfs_trans_getsb(
 	xfs_trans_t		*tp,
 	xfs_mount_t		*mp,
 	int			flags)
@@ -637,7 +637,7 @@ libxfs_trans_getsb(
 	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
 
 	if (tp == NULL)
-		return libxfs_getsb(mp, flags);
+		return xfs_getsb(mp, flags);
 
 	bp = xfs_trans_buf_item_match(tp, mp->m_dev, &map, 1);
 	if (bp != NULL) {
@@ -648,19 +648,19 @@ libxfs_trans_getsb(
 		return bp;
 	}
 
-	bp = libxfs_getsb(mp, flags);
+	bp = xfs_getsb(mp, flags);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "trans_get_sb buffer %p, transaction %p\n", bp, tp);
 #endif
 
-	libxfs_trans_bjoin(tp, bp);
+	xfs_trans_bjoin(tp, bp);
 	bip = bp->b_log_item;
 	bip->bli_recur = 0;
 	return bp;
 }
 
 int
-libxfs_trans_read_buf_map(
+xfs_trans_read_buf_map(
 	xfs_mount_t		*mp,
 	xfs_trans_t		*tp,
 	struct xfs_buftarg	*btp,
@@ -728,7 +728,7 @@ out_relse:
  * Originally derived from xfs_trans_mod_sb().
  */
 void
-libxfs_trans_mod_sb(
+xfs_trans_mod_sb(
 	xfs_trans_t		*tp,
 	uint			field,
 	long			delta)
@@ -814,7 +814,7 @@ inode_item_done(
 	 * of whether the flush succeed or not. If we fail the flush, make sure
 	 * we still release the buffer reference we currently hold.
 	 */
-	error = libxfs_iflush_int(ip, bp);
+	error = xfs_iflush_int(ip, bp);
 	bp->b_transp = NULL;	/* remove xact ptr */
 
 	if (error) {
@@ -989,7 +989,7 @@ out_unreserve:
 }
 
 int
-libxfs_trans_commit(
+xfs_trans_commit(
 	struct xfs_trans	*tp)
 {
 	return __xfs_trans_commit(tp, false);
diff --git a/libxfs/util.c b/libxfs/util.c
index 8c9954f6..4901123a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -143,7 +143,7 @@ xfs_log_calc_unit_res(
  * where it's no longer worth the hassle of maintaining common code.
  */
 void
-libxfs_trans_ichgtime(
+xfs_trans_ichgtime(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	int			flags)
@@ -232,7 +232,7 @@ xfs_flags2diflags2(
  * where it's no longer worth the hassle of maintaining common code.
  */
 static int
-libxfs_ialloc(
+xfs_ialloc(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*pip,
 	mode_t		mode,
@@ -262,7 +262,7 @@ libxfs_ialloc(
 	}
 	ASSERT(*ialloc_context == NULL);
 
-	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip,
+	error = xfs_iget(tp->t_mountp, tp, ino, 0, &ip,
 			&xfs_default_ifork_ops);
 	if (error != 0)
 		return error;
@@ -388,7 +388,7 @@ libxfs_ialloc(
  * Originally based on xfs_iflush_int() from xfs_inode.c in the kernel.
  */
 int
-libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
+xfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 {
 	xfs_inode_log_item_t	*iip;
 	xfs_dinode_t		*dip;
@@ -421,7 +421,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 		VFS_I(ip)->i_version++;
 
 	/* Check the inline fork data before we write out. */
-	if (!libxfs_inode_verify_forks(ip))
+	if (!xfs_inode_verify_forks(ip))
 		return -EFSCORRUPTED;
 
 	/*
@@ -467,10 +467,9 @@ libxfs_mod_incore_sb(
 
 /*
  * This routine allocates disk space for the given file.
- * Originally derived from xfs_alloc_file_space().
  */
 int
-libxfs_alloc_file_space(
+xfs_alloc_file_space(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	xfs_off_t	len,
@@ -547,14 +546,14 @@ error0:	/* Cancel bmap, cancel trans */
 }
 
 /*
- * Wrapper around call to libxfs_ialloc. Takes care of committing and
+ * Wrapper around call to xfs_ialloc. Takes care of committing and
  * allocating a new transaction as needed.
  *
  * Originally there were two copies of this code - one in mkfs, the
  * other in repair - now there is just the one.
  */
 int
-libxfs_inode_alloc(
+xfs_inode_alloc(
 	xfs_trans_t	**tp,
 	xfs_inode_t	*pip,
 	mode_t		mode,
@@ -569,7 +568,7 @@ libxfs_inode_alloc(
 	int		error;
 
 	ialloc_context = (xfs_buf_t *)0;
-	error = libxfs_ialloc(*tp, pip, mode, nlink, rdev, cr, fsx,
+	error = xfs_ialloc(*tp, pip, mode, nlink, rdev, cr, fsx,
 			   &ialloc_context, &ip);
 	if (error) {
 		*ipp = NULL;
@@ -591,7 +590,7 @@ libxfs_inode_alloc(
 			exit(1);
 		}
 		xfs_trans_bjoin(*tp, ialloc_context);
-		error = libxfs_ialloc(*tp, pip, mode, nlink, rdev, cr,
+		error = xfs_ialloc(*tp, pip, mode, nlink, rdev, cr,
 				   fsx, &ialloc_context, &ip);
 		if (!ip)
 			error = -ENOSPC;
@@ -712,7 +711,7 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 }
 
 int
-libxfs_zero_extent(
+xfs_zero_extent(
 	struct xfs_inode *ip,
 	xfs_fsblock_t	start_fsb,
 	xfs_off_t	count_fsb)

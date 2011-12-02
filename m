Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2HlkKU092716 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 11:47:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 158384D4EED
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 09:47:44 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NgWj3qZ3uUJNnuTH for <xfs@oss.sgi.com>;
	Fri, 02 Dec 2011 09:47:44 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RWXD5-0000oB-OF
	for xfs@oss.sgi.com; Fri, 02 Dec 2011 17:47:43 +0000
Message-Id: <20111202174743.697687824@bombadil.infradead.org>
Date: Fri, 02 Dec 2011 12:46:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/12] repair: cleanup inode record macros
References: <20111202174619.179530033@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-cleanup-irec-macros
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Remove indirections in the inode record bit manipulation macros and flatten
them to a single level of inlines.  Also use a common IREC_MASK define
instead of duplicating it for every bitmask.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/incore.h
===================================================================
--- xfsprogs-dev.orig/repair/incore.h	2011-12-02 11:04:59.000000000 +0000
+++ xfsprogs-dev/repair/incore.h	2011-12-02 11:17:31.000000000 +0000
@@ -289,6 +289,9 @@ typedef struct ino_tree_node  {
 	} ino_un;
 } ino_tree_node_t;
 
+#define INOS_PER_IREC	(sizeof(__uint64_t) * NBBY)
+#define	IREC_MASK(i)	((__uint64_t)1 << (i))
+
 typedef struct nlink_ops {
 	const int	nlink_size;
 	void		(*disk_nlink_set)(ino_tree_node_t *, int, __uint32_t);
@@ -299,7 +302,6 @@ typedef struct nlink_ops {
 } nlink_ops_t;
 
 
-#define INOS_PER_IREC		(sizeof(__uint64_t) * NBBY)
 void		add_ino_ex_data(xfs_mount_t *mp);
 
 /*
@@ -381,92 +383,73 @@ void			clear_uncertain_ino_cache(xfs_agn
 		((ino_tree_node_t *) ((ino_node_ptr)->avl_node.avl_forw))
 
 /*
- * Bit manipulations for processed field
+ * Has an inode been processed for phase 6 (reference count checking)?
+ *
+ * add_inode_refchecked() is set on an inode when it gets traversed
+ * during the reference count phase (6).  It's set so that if the inode
+ * is a directory, it's traversed (and it's links counted) only once.
  */
-#define	XFS_INOPROC_MASK(i)	((__uint64_t)1 << (i))
-#define	XFS_INOPROC_MASKN(i,n)	((__uint64_t)((1 << (n)) - 1) << (i))
+static inline void add_inode_refchecked(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_un.ex_data->ino_processed |= IREC_MASK(offset);
+}
 
-#define	XFS_INOPROC_IS_PROC(rp, i) \
-	(((rp)->ino_un.ex_data->ino_processed & XFS_INOPROC_MASK((i))) == 0LL \
-		? 0 : 1)
-#define	XFS_INOPROC_SET_PROC(rp, i) \
-	((rp)->ino_un.ex_data->ino_processed |= XFS_INOPROC_MASK((i)))
-/*
-#define	XFS_INOPROC_CLR_PROC(rp, i) \
-	((rp)->ino_un.ex_data->ino_processed &= ~XFS_INOPROC_MASK((i)))
-*/
+static inline int is_inode_refchecked(struct ino_tree_node *irec, int offset)
+{
+	return (irec->ino_un.ex_data->ino_processed & IREC_MASK(offset)) != 0;
+}
 
 /*
- * same for ir_confirmed.
+ * set/test is inode known to be valid (although perhaps corrupt)
  */
-#define	XFS_INOCF_MASK(i)	((__uint64_t)1 << (i))
-#define	XFS_INOCF_MASKN(i,n)	((__uint64_t)((1 << (n)) - 1) << (i))
-
-#define	XFS_INOCF_IS_CF(rp, i) \
-		(((rp)->ino_confirmed & XFS_INOCF_MASK((i))) == 0LL \
-			? 0 : 1)
-#define	XFS_INOCF_SET_CF(rp, i) \
-			((rp)->ino_confirmed |= XFS_INOCF_MASK((i)))
-#define	XFS_INOCF_CLR_CF(rp, i) \
-			((rp)->ino_confirmed &= ~XFS_INOCF_MASK((i)))
+static inline void set_inode_confirmed(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_confirmed |= IREC_MASK(offset);
+}
 
-/*
- * same for backptr->ino_reached
- */
-#define	XFS_INO_RCHD_MASK(i)	((__uint64_t)1 << (i))
+static inline int is_inode_confirmed(struct ino_tree_node *irec, int offset)
+{
+	return (irec->ino_confirmed & IREC_MASK(offset)) != 0;
+}
 
-#define	XFS_INO_RCHD_IS_RCHD(rp, i) \
-	(((rp)->ino_un.ex_data->ino_reached & XFS_INO_RCHD_MASK((i))) == 0LL \
-		? 0 : 1)
-#define	XFS_INO_RCHD_SET_RCHD(rp, i) \
-		((rp)->ino_un.ex_data->ino_reached |= XFS_INO_RCHD_MASK((i)))
-#define	XFS_INO_RCHD_CLR_RCHD(rp, i) \
-		((rp)->ino_un.ex_data->ino_reached &= ~XFS_INO_RCHD_MASK((i)))
 /*
  * set/clear/test is inode a directory inode
  */
-#define	XFS_INO_ISADIR_MASK(i)	((__uint64_t)1 << (i))
-
-#define inode_isadir(ino_rec, ino_offset) \
-	(((ino_rec)->ino_isa_dir & XFS_INO_ISADIR_MASK((ino_offset))) == 0LL \
-		? 0 : 1)
-#define set_inode_isadir(ino_rec, ino_offset) \
-		((ino_rec)->ino_isa_dir |= XFS_INO_ISADIR_MASK((ino_offset)))
-#define clear_inode_isadir(ino_rec, ino_offset) \
-		((ino_rec)->ino_isa_dir &= ~XFS_INO_ISADIR_MASK((ino_offset)))
-
-
-/*
- * set/clear/test is inode known to be valid (although perhaps corrupt)
- */
-#define clear_inode_confirmed(ino_rec, ino_offset) \
-			XFS_INOCF_CLR_CF((ino_rec), (ino_offset))
+static inline void set_inode_isadir(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_isa_dir |= IREC_MASK(offset);
+}
 
-#define set_inode_confirmed(ino_rec, ino_offset) \
-			XFS_INOCF_SET_CF((ino_rec), (ino_offset))
+static inline void clear_inode_isadir(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_isa_dir &= ~IREC_MASK(offset);
+}
 
-#define is_inode_confirmed(ino_rec, ino_offset) \
-			XFS_INOCF_IS_CF(ino_rec, ino_offset)
+static inline int inode_isadir(struct ino_tree_node *irec, int offset)
+{
+	return (irec->ino_isa_dir & IREC_MASK(offset)) != 0;
+}
 
 /*
  * set/clear/test is inode free or used
  */
-#define set_inode_free(ino_rec, ino_offset) \
-	XFS_INOCF_SET_CF((ino_rec), (ino_offset)), \
-	XFS_INOBT_SET_FREE((ino_rec), (ino_offset))
-
-#define set_inode_used(ino_rec, ino_offset) \
-	XFS_INOCF_SET_CF((ino_rec), (ino_offset)), \
-	XFS_INOBT_CLR_FREE((ino_rec), (ino_offset))
+static inline void set_inode_free(struct ino_tree_node *irec, int offset)
+{
+	set_inode_confirmed(irec, offset);
+	irec->ir_free |= XFS_INOBT_MASK(offset);
 
-#define XFS_INOBT_IS_FREE(ino_rec, ino_offset) \
-	(((ino_rec)->ir_free & XFS_INOBT_MASK(ino_offset)) != 0)
+}
 
-#define is_inode_used(ino_rec, ino_offset)	\
-	!XFS_INOBT_IS_FREE((ino_rec), (ino_offset))
+static inline void set_inode_used(struct ino_tree_node *irec, int offset)
+{
+	set_inode_confirmed(irec, offset);
+	irec->ir_free &= ~XFS_INOBT_MASK(offset);
+}
 
-#define is_inode_free(ino_rec, ino_offset)	\
-	XFS_INOBT_IS_FREE((ino_rec), (ino_offset))
+static inline int is_inode_free(struct ino_tree_node *irec, int offset)
+{
+	return (irec->ir_free & XFS_INOBT_MASK(offset)) != 0;
+}
 
 /*
  * add_inode_reached() is set on inode I only if I has been reached
@@ -478,88 +461,54 @@ void			clear_uncertain_ino_cache(xfs_agn
  * an inode that we've counted is removed.
  */
 
-static inline int
-is_inode_reached(ino_tree_node_t *ino_rec, int ino_offset)
-{
-	ASSERT(ino_rec->ino_un.ex_data != NULL);
-	return(XFS_INO_RCHD_IS_RCHD(ino_rec, ino_offset));
-}
-
-static inline void
-add_inode_reached(ino_tree_node_t *ino_rec, int ino_offset)
+static inline void add_inode_ref(struct ino_tree_node *irec, int offset)
 {
-	ASSERT(ino_rec->ino_un.ex_data != NULL);
-
-	(*ino_rec->nlinkops->counted_nlink_inc)(ino_rec, ino_offset);
-	XFS_INO_RCHD_SET_RCHD(ino_rec, ino_offset);
+	ASSERT(irec->ino_un.ex_data != NULL);
 
-	ASSERT(is_inode_reached(ino_rec, ino_offset));
+	irec->nlinkops->counted_nlink_inc(irec, offset);
 }
 
-static inline void
-add_inode_ref(ino_tree_node_t *ino_rec, int ino_offset)
+static inline void drop_inode_ref(struct ino_tree_node *irec, int offset)
 {
-	ASSERT(ino_rec->ino_un.ex_data != NULL);
+	ASSERT(irec->ino_un.ex_data != NULL);
 
-	(*ino_rec->nlinkops->counted_nlink_inc)(ino_rec, ino_offset);
+	if (irec->nlinkops->counted_nlink_dec(irec, offset) == 0)
+		irec->ino_un.ex_data->ino_reached &= ~IREC_MASK(offset);
 }
 
-static inline void
-drop_inode_ref(ino_tree_node_t *ino_rec, int ino_offset)
+static inline __uint32_t num_inode_references(struct ino_tree_node *irec,
+		int offset)
 {
-	ASSERT(ino_rec->ino_un.ex_data != NULL);
+	ASSERT(irec->ino_un.ex_data != NULL);
 
-	if ((*ino_rec->nlinkops->counted_nlink_dec)(ino_rec, ino_offset) == 0)
-		XFS_INO_RCHD_CLR_RCHD(ino_rec, ino_offset);
+	return irec->nlinkops->counted_nlink_get(irec, offset);
 }
 
-static inline int
-is_inode_referenced(ino_tree_node_t *ino_rec, int ino_offset)
+static inline int is_inode_reached(struct ino_tree_node *irec, int offset)
 {
-	ASSERT(ino_rec->ino_un.ex_data != NULL);
-
-	return (*ino_rec->nlinkops->counted_nlink_get)(ino_rec, ino_offset) > 0;
+	ASSERT(irec->ino_un.ex_data != NULL);
+	return (irec->ino_un.ex_data->ino_reached & IREC_MASK(offset)) != 0;
 }
 
-static inline __uint32_t
-num_inode_references(ino_tree_node_t *ino_rec, int ino_offset)
+static inline void add_inode_reached(struct ino_tree_node *irec, int offset)
 {
-	ASSERT(ino_rec->ino_un.ex_data != NULL);
-
-	return (*ino_rec->nlinkops->counted_nlink_get)(ino_rec, ino_offset);
+	add_inode_ref(irec, offset);
+	irec->ino_un.ex_data->ino_reached |= IREC_MASK(offset);
 }
 
-static inline void
-set_inode_disk_nlinks(ino_tree_node_t *ino_rec, int ino_offset, __uint32_t nlinks)
+static inline void set_inode_disk_nlinks(struct ino_tree_node *irec, int offset,
+		__uint32_t nlinks)
 {
-	(*ino_rec->nlinkops->disk_nlink_set)(ino_rec, ino_offset, nlinks);
+	irec->nlinkops->disk_nlink_set(irec, offset, nlinks);
 }
 
-static inline __uint32_t
-get_inode_disk_nlinks(ino_tree_node_t *ino_rec, int ino_offset)
+static inline __uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec,
+		int offset)
 {
-	return (*ino_rec->nlinkops->disk_nlink_get)(ino_rec, ino_offset);
+	return irec->nlinkops->disk_nlink_get(irec, offset);
 }
 
 /*
- * has an inode been processed for phase 6 (reference count checking)?
- * add_inode_refchecked() is set on an inode when it gets traversed
- * during the reference count phase (6).  It's set so that if the inode
- * is a directory, it's traversed (and it's links counted) only once.
- */
-#ifndef XR_INO_REF_DEBUG
-#define add_inode_refchecked(ino, ino_rec, ino_offset) \
-		XFS_INOPROC_SET_PROC((ino_rec), (ino_offset))
-#define is_inode_refchecked(ino, ino_rec, ino_offset) \
-		(XFS_INOPROC_IS_PROC(ino_rec, ino_offset) != 0LL)
-#else
-void add_inode_refchecked(xfs_ino_t ino,
-			ino_tree_node_t *ino_rec, int ino_offset);
-int is_inode_refchecked(xfs_ino_t ino,
-			ino_tree_node_t *ino_rec, int ino_offset);
-#endif /* XR_INO_REF_DEBUG */
-
-/*
  * set/get inode number of parent -- works for directory inodes only
  */
 void		set_inode_parent(ino_tree_node_t *irec, int ino_offset,
Index: xfsprogs-dev/repair/incore_ino.c
===================================================================
--- xfsprogs-dev.orig/repair/incore_ino.c	2011-12-02 11:04:59.000000000 +0000
+++ xfsprogs-dev/repair/incore_ino.c	2011-12-02 11:05:19.000000000 +0000
@@ -784,19 +784,3 @@ incore_ino_init(xfs_mount_t *mp)
 
 	full_ino_ex_data = 0;
 }
-
-#ifdef XR_INO_REF_DEBUG
-void
-add_inode_refchecked(xfs_ino_t ino, ino_tree_node_t *ino_rec, int ino_offset)
-{
-	XFS_INOPROC_SET_PROC((ino_rec), (ino_offset));
-
-	ASSERT(is_inode_refchecked(ino, ino_rec, ino_offset));
-}
-
-int
-is_inode_refchecked(xfs_ino_t ino, ino_tree_node_t *ino_rec, int ino_offset)
-{
-	return(XFS_INOPROC_IS_PROC(ino_rec, ino_offset) == 0LL ? 0 : 1);
-}
-#endif /* XR_INO_REF_DEBUG */
Index: xfsprogs-dev/include/libxfs.h
===================================================================
--- xfsprogs-dev.orig/include/libxfs.h	2011-12-02 11:04:59.000000000 +0000
+++ xfsprogs-dev/include/libxfs.h	2011-12-02 11:05:19.000000000 +0000
@@ -503,8 +503,6 @@ extern unsigned long	libxfs_physmem(void
 #include <xfs/xfs_log.h>
 #include <xfs/xfs_log_priv.h>
 
-#define XFS_INOBT_CLR_FREE(rp,i)	((rp)->ir_free &= ~XFS_INOBT_MASK(i))
-#define XFS_INOBT_SET_FREE(rp,i)	((rp)->ir_free |= XFS_INOBT_MASK(i))
 #define XFS_INOBT_IS_FREE_DISK(rp,i)		\
 			((be64_to_cpu((rp)->ir_free) & XFS_INOBT_MASK(i)) != 0)
 
Index: xfsprogs-dev/repair/phase6.c
===================================================================
--- xfsprogs-dev.orig/repair/phase6.c	2011-12-02 11:04:59.000000000 +0000
+++ xfsprogs-dev/repair/phase6.c	2011-12-02 11:05:19.000000000 +0000
@@ -3258,7 +3258,7 @@ process_dir_inode(
 	 * remaining illegal directory entries.
 	 */
 
-	ASSERT(!is_inode_refchecked(ino, irec, ino_offset) || dotdot_update);
+	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
 
 	error = libxfs_iget(mp, NULL, ino, 0, &ip, 0);
 	if (error) {
@@ -3282,7 +3282,7 @@ process_dir_inode(
 			}
 		}
 
-		add_inode_refchecked(ino, irec, 0);
+		add_inode_refchecked(irec, 0);
 		return;
 	}
 
@@ -3300,7 +3300,7 @@ process_dir_inode(
 		add_inode_reached(irec, ino_offset);
 	}
 
-	add_inode_refchecked(ino, irec, ino_offset);
+	add_inode_refchecked(irec, ino_offset);
 
 	hashtab = dir_hash_init(ip->i_d.di_size);
 
Index: xfsprogs-dev/repair/phase7.c
===================================================================
--- xfsprogs-dev.orig/repair/phase7.c	2011-12-02 11:16:58.000000000 +0000
+++ xfsprogs-dev/repair/phase7.c	2011-12-02 11:17:27.000000000 +0000
@@ -143,10 +143,9 @@ phase7(xfs_mount_t *mp)
 					continue;
 
 				ASSERT(no_modify || is_inode_reached(irec, j));
-				ASSERT(no_modify ||
-						is_inode_referenced(irec, j));
 
 				nrefs = num_inode_references(irec, j);
+				ASSERT(no_modify || nrefs > 0);
 
 				if (get_inode_disk_nlinks(irec, j) != nrefs)
 					update_inode_nlinks(mp,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

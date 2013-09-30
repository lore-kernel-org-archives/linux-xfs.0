Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 12A937F88
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:07:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 89EC2AC001
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:07:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1sdWFDWv8Ku0rU2r for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:07:34 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTpO-0006Le-PI
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTpO-0002CB-OR
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:07:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/16] xfs: vectorise directory data operations
Date: Mon, 30 Sep 2013 13:07:06 +1000
Message-Id: <1380510433-8353-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510433-8353-1-git-send-email-david@fromorbit.com>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Following from the initial patches to vectorise the shortform
directory encode/decode operations, convert half the data block
operations to use the vector. The rest will be done in a second
patch.

This further reduces the size of the built binary:

   text    data     bss     dec     hex filename
 794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
 792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
 792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
 789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_format.c    | 218 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_da_format.h    | 123 --------------------------
 fs/xfs/xfs_dir2.h         |  22 ++++-
 fs/xfs/xfs_dir2_block.c   |  54 ++++++------
 fs/xfs/xfs_dir2_data.c    |  38 +++++---
 fs/xfs/xfs_dir2_leaf.c    |  22 ++---
 fs/xfs/xfs_dir2_node.c    |  23 ++---
 fs/xfs/xfs_dir2_readdir.c |  14 +--
 fs/xfs/xfs_dir2_sf.c      |  20 ++---
 9 files changed, 329 insertions(+), 205 deletions(-)

diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index 62f55a0..d0285fd 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -28,7 +28,9 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 
-
+/*
+ * Shortform directory ops
+ */
 static int
 xfs_dir2_sf_entsize(
 	struct xfs_dir2_sf_hdr	*hdr,
@@ -203,6 +205,184 @@ xfs_dir3_sfe_put_ino(
 			(xfs_dir2_inou_t *)&sfep->name[sfep->namelen + 1], ino);
 }
 
+
+/*
+ * Directory data block operations
+ */
+static int
+__xfs_dir3_data_entsize(
+	bool	ftype,
+	int	n)
+{
+	int	size = offsetof(struct xfs_dir2_data_entry, name[0]);
+
+	size += n;
+	size += sizeof(xfs_dir2_data_off_t);
+	if (ftype)
+		size += sizeof(__uint8_t);
+	return roundup(size, XFS_DIR2_DATA_ALIGN);
+}
+
+static int
+xfs_dir2_data_entsize(
+	int			n)
+{
+	return __xfs_dir3_data_entsize(false, n);
+}
+static int
+xfs_dir3_data_entsize(
+	int			n)
+{
+	return __xfs_dir3_data_entsize(true, n);
+}
+
+static __uint8_t
+xfs_dir2_data_get_ftype(
+	struct xfs_dir2_data_entry *dep)
+{
+	return XFS_DIR3_FT_UNKNOWN;
+}
+
+static void
+xfs_dir2_data_put_ftype(
+	struct xfs_dir2_data_entry *dep,
+	__uint8_t		ftype)
+{
+	ASSERT(ftype < XFS_DIR3_FT_MAX);
+}
+
+static __uint8_t
+xfs_dir3_data_get_ftype(
+	struct xfs_dir2_data_entry *dep)
+{
+	__uint8_t	ftype = dep->name[dep->namelen];
+
+	ASSERT(ftype < XFS_DIR3_FT_MAX);
+	if (ftype >= XFS_DIR3_FT_MAX)
+		return XFS_DIR3_FT_UNKNOWN;
+	return ftype;
+}
+
+static void
+xfs_dir3_data_put_ftype(
+	struct xfs_dir2_data_entry *dep,
+	__uint8_t		type)
+{
+	ASSERT(type < XFS_DIR3_FT_MAX);
+	ASSERT(dep->namelen != 0);
+
+	dep->name[dep->namelen] = type;
+}
+
+/*
+ * Pointer to an entry's tag word.
+ */
+static __be16 *
+xfs_dir2_data_entry_tag_p(
+	struct xfs_dir2_data_entry *dep)
+{
+	return (__be16 *)((char *)dep +
+		xfs_dir2_data_entsize(dep->namelen) - sizeof(__be16));
+}
+
+static __be16 *
+xfs_dir3_data_entry_tag_p(
+	struct xfs_dir2_data_entry *dep)
+{
+	return (__be16 *)((char *)dep +
+		xfs_dir3_data_entsize(dep->namelen) - sizeof(__be16));
+}
+
+/*
+ * Offsets of . and .. in data space (always block 0)
+ */
+static xfs_dir2_data_aoff_t
+xfs_dir2_data_dot_offset(void)
+{
+	return sizeof(struct xfs_dir2_data_hdr);
+}
+
+static xfs_dir2_data_aoff_t
+xfs_dir2_data_dotdot_offset(void)
+{
+	return xfs_dir2_data_dot_offset() + xfs_dir2_data_entsize(1);
+}
+
+static xfs_dir2_data_aoff_t
+xfs_dir2_data_first_offset(void)
+{
+	return xfs_dir2_data_dotdot_offset() + xfs_dir2_data_entsize(2);
+}
+
+static xfs_dir2_data_aoff_t
+xfs_dir3_data_dot_offset(void)
+{
+	return sizeof(struct xfs_dir3_data_hdr);
+}
+
+static xfs_dir2_data_aoff_t
+xfs_dir3_data_dotdot_offset(void)
+{
+	return xfs_dir3_data_dot_offset() + xfs_dir3_data_entsize(1);
+}
+
+static xfs_dir2_data_aoff_t
+xfs_dir3_data_first_offset(void)
+{
+	return xfs_dir3_data_dotdot_offset() + xfs_dir3_data_entsize(2);
+}
+
+/*
+ * location of . and .. in data space (always block 0)
+ */
+static struct xfs_dir2_data_entry *
+xfs_dir2_data_dot_entry_p(
+	struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir2_data_dot_offset());
+}
+
+static struct xfs_dir2_data_entry *
+xfs_dir2_data_dotdot_entry_p(
+	struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir2_data_dotdot_offset());
+}
+
+static struct xfs_dir2_data_entry *
+xfs_dir2_data_first_entry_p(
+	struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir2_data_first_offset());
+}
+
+static struct xfs_dir2_data_entry *
+xfs_dir3_data_dot_entry_p(
+	struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir3_data_dot_offset());
+}
+
+static struct xfs_dir2_data_entry *
+xfs_dir3_data_dotdot_entry_p(
+	struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir3_data_dotdot_offset());
+}
+
+static struct xfs_dir2_data_entry *
+xfs_dir3_data_first_entry_p(
+	struct xfs_dir2_data_hdr *hdr)
+{
+	return (struct xfs_dir2_data_entry *)
+		((char *)hdr + xfs_dir3_data_first_offset());
+}
+
 const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_entsize = xfs_dir2_sf_entsize,
 	.sf_nextentry = xfs_dir2_sf_nextentry,
@@ -212,6 +392,18 @@ const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_put_ino = xfs_dir2_sfe_put_ino,
 	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
 	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
+
+	.data_entsize = xfs_dir2_data_entsize,
+	.data_get_ftype = xfs_dir2_data_get_ftype,
+	.data_put_ftype = xfs_dir2_data_put_ftype,
+	.data_entry_tag_p = xfs_dir2_data_entry_tag_p,
+
+	.data_dot_offset = xfs_dir2_data_dot_offset,
+	.data_dotdot_offset = xfs_dir2_data_dotdot_offset,
+	.data_first_offset = xfs_dir2_data_first_offset,
+	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
+	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
+	.data_first_entry_p = xfs_dir2_data_first_entry_p,
 };
 
 const struct xfs_dir_ops xfs_dir2_ftype_ops = {
@@ -223,6 +415,18 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.sf_put_ino = xfs_dir3_sfe_put_ino,
 	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
 	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
+
+	.data_entsize = xfs_dir3_data_entsize,
+	.data_get_ftype = xfs_dir3_data_get_ftype,
+	.data_put_ftype = xfs_dir3_data_put_ftype,
+	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
+
+	.data_dot_offset = xfs_dir2_data_dot_offset,
+	.data_dotdot_offset = xfs_dir2_data_dotdot_offset,
+	.data_first_offset = xfs_dir2_data_first_offset,
+	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
+	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
+	.data_first_entry_p = xfs_dir2_data_first_entry_p,
 };
 
 const struct xfs_dir_ops xfs_dir3_ops = {
@@ -234,4 +438,16 @@ const struct xfs_dir_ops xfs_dir3_ops = {
 	.sf_put_ino = xfs_dir3_sfe_put_ino,
 	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
 	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
+
+	.data_entsize = xfs_dir3_data_entsize,
+	.data_get_ftype = xfs_dir3_data_get_ftype,
+	.data_put_ftype = xfs_dir3_data_put_ftype,
+	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
+
+	.data_dot_offset = xfs_dir3_data_dot_offset,
+	.data_dotdot_offset = xfs_dir3_data_dotdot_offset,
+	.data_first_offset = xfs_dir3_data_first_offset,
+	.data_dot_entry_p = xfs_dir3_data_dot_entry_p,
+	.data_dotdot_entry_p = xfs_dir3_data_dotdot_entry_p,
+	.data_first_entry_p = xfs_dir3_data_first_entry_p,
 };
diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
index 68c2ad5..5b72dd2 100644
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -456,72 +456,6 @@ typedef struct xfs_dir2_data_unused {
 } xfs_dir2_data_unused_t;
 
 /*
- * Size of a data entry.
- */
-static inline int
-__xfs_dir3_data_entsize(
-	bool	ftype,
-	int	n)
-{
-	int	size = offsetof(struct xfs_dir2_data_entry, name[0]);
-
-	size += n;
-	size += sizeof(xfs_dir2_data_off_t);
-	if (ftype)
-		size += sizeof(__uint8_t);
-	return roundup(size, XFS_DIR2_DATA_ALIGN);
-}
-static inline int
-xfs_dir3_data_entsize(
-	struct xfs_mount	*mp,
-	int			n)
-{
-	bool ftype = xfs_sb_version_hasftype(&mp->m_sb) ? true : false;
-	return __xfs_dir3_data_entsize(ftype, n);
-}
-
-static inline __uint8_t
-xfs_dir3_dirent_get_ftype(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_data_entry *dep)
-{
-	if (xfs_sb_version_hasftype(&mp->m_sb)) {
-		__uint8_t	type = dep->name[dep->namelen];
-
-		ASSERT(type < XFS_DIR3_FT_MAX);
-		if (type < XFS_DIR3_FT_MAX)
-			return type;
-
-	}
-	return XFS_DIR3_FT_UNKNOWN;
-}
-
-static inline void
-xfs_dir3_dirent_put_ftype(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_data_entry *dep,
-	__uint8_t		type)
-{
-	ASSERT(type < XFS_DIR3_FT_MAX);
-	ASSERT(dep->namelen != 0);
-
-	if (xfs_sb_version_hasftype(&mp->m_sb))
-		dep->name[dep->namelen] = type;
-}
-
-/*
- * Pointer to an entry's tag word.
- */
-static inline __be16 *
-xfs_dir3_data_entry_tag_p(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_data_entry *dep)
-{
-	return (__be16 *)((char *)dep +
-		xfs_dir3_data_entsize(mp, dep->namelen) - sizeof(__be16));
-}
-
-/*
  * Pointer to a freespace's tag word.
  */
 static inline __be16 *
@@ -562,63 +496,6 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 }
 
 /*
- * Offsets of . and .. in data space (always block 0)
- *
- * XXX: there is scope for significant optimisation of the logic here. Right
- * now we are checking for "dir3 format" over and over again. Ideally we should
- * only do it once for each operation.
- */
-static inline xfs_dir2_data_aoff_t
-xfs_dir3_data_dot_offset(struct xfs_mount *mp)
-{
-	return xfs_dir3_data_hdr_size(xfs_sb_version_hascrc(&mp->m_sb));
-}
-
-static inline xfs_dir2_data_aoff_t
-xfs_dir3_data_dotdot_offset(struct xfs_mount *mp)
-{
-	return xfs_dir3_data_dot_offset(mp) +
-		xfs_dir3_data_entsize(mp, 1);
-}
-
-static inline xfs_dir2_data_aoff_t
-xfs_dir3_data_first_offset(struct xfs_mount *mp)
-{
-	return xfs_dir3_data_dotdot_offset(mp) +
-		xfs_dir3_data_entsize(mp, 2);
-}
-
-/*
- * location of . and .. in data space (always block 0)
- */
-static inline struct xfs_dir2_data_entry *
-xfs_dir3_data_dot_entry_p(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir3_data_dot_offset(mp));
-}
-
-static inline struct xfs_dir2_data_entry *
-xfs_dir3_data_dotdot_entry_p(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir3_data_dotdot_offset(mp));
-}
-
-static inline struct xfs_dir2_data_entry *
-xfs_dir3_data_first_entry_p(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir3_data_first_offset(mp));
-}
-
-/*
  * Leaf block structures.
  *
  * A pure leaf block looks like the following drawing on disk:
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 0e94b3e..c0a4592 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -50,6 +50,22 @@ struct xfs_dir_ops {
 	xfs_ino_t (*sf_get_parent_ino)(struct xfs_dir2_sf_hdr *hdr);
 	void	(*sf_put_parent_ino)(struct xfs_dir2_sf_hdr *hdr,
 				     xfs_ino_t ino);
+
+	int	(*data_entsize)(int len);
+	__uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
+	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
+				__uint8_t ftype);
+	__be16 * (*data_entry_tag_p)(struct xfs_dir2_data_entry *dep);
+
+	xfs_dir2_data_aoff_t (*data_dot_offset)(void);
+	xfs_dir2_data_aoff_t (*data_dotdot_offset)(void);
+	xfs_dir2_data_aoff_t (*data_first_offset)(void);
+	struct xfs_dir2_data_entry *
+		(*data_dot_entry_p)(struct xfs_dir2_data_hdr *hdr);
+	struct xfs_dir2_data_entry *
+		(*data_dotdot_entry_p)(struct xfs_dir2_data_hdr *hdr);
+	struct xfs_dir2_data_entry *
+		(*data_first_entry_p)(struct xfs_dir2_data_hdr *hdr);
 };
 
 extern const struct xfs_dir_ops xfs_dir2_ops;
@@ -95,10 +111,10 @@ extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_buf *bp);
 
-extern void xfs_dir2_data_freescan(struct xfs_mount *mp,
+extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *hdr, int *loghead);
-extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_buf *bp,
-		struct xfs_dir2_data_entry *dep);
+extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_inode *dp,
+		struct xfs_buf *bp, struct xfs_dir2_data_entry *dep);
 extern void xfs_dir2_data_log_header(struct xfs_trans *tp,
 		struct xfs_buf *bp);
 extern void xfs_dir2_data_log_unused(struct xfs_trans *tp, struct xfs_buf *bp,
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 960f3ab..7d7a8cc 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -280,6 +280,7 @@ out:
 static void
 xfs_dir2_block_compact(
 	struct xfs_trans		*tp,
+	struct xfs_inode		*dp,
 	struct xfs_buf			*bp,
 	struct xfs_dir2_data_hdr	*hdr,
 	struct xfs_dir2_block_tail	*btp,
@@ -323,7 +324,7 @@ xfs_dir2_block_compact(
 	 * This needs to happen before the next call to use_free.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(tp->t_mountp, hdr, needlog);
+		xfs_dir2_data_freescan(dp, hdr, needlog);
 }
 
 /*
@@ -369,7 +370,7 @@ xfs_dir2_block_addname(
 	if (error)
 		return error;
 
-	len = xfs_dir3_data_entsize(mp, args->namelen);
+	len = dp->d_ops->data_entsize(args->namelen);
 
 	/*
 	 * Set up pointers to parts of the block.
@@ -418,7 +419,7 @@ xfs_dir2_block_addname(
 	 * If need to compact the leaf entries, do it now.
 	 */
 	if (compact) {
-		xfs_dir2_block_compact(tp, bp, hdr, btp, blp, &needlog,
+		xfs_dir2_block_compact(tp, dp, bp, hdr, btp, blp, &needlog,
 				      &lfloghigh, &lfloglow);
 		/* recalculate blp post-compaction */
 		blp = xfs_dir2_block_leaf_p(btp);
@@ -468,7 +469,7 @@ xfs_dir2_block_addname(
 		 * This needs to happen before the next call to use_free.
 		 */
 		if (needscan) {
-			xfs_dir2_data_freescan(mp, hdr, &needlog);
+			xfs_dir2_data_freescan(dp, hdr, &needlog);
 			needscan = 0;
 		}
 		/*
@@ -549,18 +550,18 @@ xfs_dir2_block_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, args->namelen);
-	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
-	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
+	dp->d_ops->data_put_ftype(dep, args->filetype);
+	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, bp);
 	xfs_dir2_block_log_tail(tp, bp);
-	xfs_dir2_data_log_entry(tp, bp, dep);
+	xfs_dir2_data_log_entry(tp, dp, bp, dep);
 	xfs_dir3_data_check(dp, bp);
 	return 0;
 }
@@ -642,7 +643,7 @@ xfs_dir2_block_lookup(
 	 * Fill in inode number, CI name if appropriate, release the block.
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
-	args->filetype = xfs_dir3_dirent_get_ftype(mp, dep);
+	args->filetype = dp->d_ops->data_get_ftype(dep);
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_trans_brelse(args->trans, bp);
 	return XFS_ERROR(error);
@@ -801,7 +802,7 @@ xfs_dir2_block_removename(
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, bp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
-		xfs_dir3_data_entsize(mp, dep->namelen), &needlog, &needscan);
+		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
 	/*
 	 * Fix up the block tail.
 	 */
@@ -816,7 +817,7 @@ xfs_dir2_block_removename(
 	 * Fix up bestfree, log the header if necessary.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, bp);
 	xfs_dir3_data_check(dp, bp);
@@ -875,8 +876,8 @@ xfs_dir2_block_replace(
 	 * Change the inode number to the new value.
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
-	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
-	xfs_dir2_data_log_entry(args->trans, bp, dep);
+	dp->d_ops->data_put_ftype(dep, args->filetype);
+	xfs_dir2_data_log_entry(args->trans, dp, bp, dep);
 	xfs_dir3_data_check(dp, bp);
 	return 0;
 }
@@ -1023,7 +1024,7 @@ xfs_dir2_leaf_to_block(
 	 * Scan the bestfree if we need it and log the data block header.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
 	/*
@@ -1158,32 +1159,32 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Create entry for .
 	 */
-	dep = xfs_dir3_data_dot_entry_p(mp, hdr);
+	dep = dp->d_ops->data_dot_entry_p(hdr);
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
-	xfs_dir3_dirent_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
-	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
+	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
+	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
-	xfs_dir2_data_log_entry(tp, bp, dep);
+	xfs_dir2_data_log_entry(tp, dp, bp, dep);
 	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
 	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 				(char *)dep - (char *)hdr));
 	/*
 	 * Create entry for ..
 	 */
-	dep = xfs_dir3_data_dotdot_entry_p(mp, hdr);
+	dep = dp->d_ops->data_dotdot_entry_p(hdr);
 	dep->inumber = cpu_to_be64(dp->d_ops->sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
-	xfs_dir3_dirent_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
-	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
+	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
+	tagp =dp->d_ops-> data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
-	xfs_dir2_data_log_entry(tp, bp, dep);
+	xfs_dir2_data_log_entry(tp, dp, bp, dep);
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
 	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 				(char *)dep - (char *)hdr));
-	offset = xfs_dir3_data_first_offset(mp);
+	offset = dp->d_ops->data_first_offset();
 	/*
 	 * Loop over existing entries, stuff them in.
 	 */
@@ -1224,12 +1225,11 @@ xfs_dir2_sf_to_block(
 		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
 		dep->inumber = cpu_to_be64(dp->d_ops->sf_get_ino(sfp, sfep));
 		dep->namelen = sfep->namelen;
-		xfs_dir3_dirent_put_ftype(mp, dep,
-					  dp->d_ops->sf_get_ftype(sfep));
+		dp->d_ops->data_put_ftype(dep, dp->d_ops->sf_get_ftype(sfep));
 		memcpy(dep->name, sfep->name, dep->namelen);
-		tagp = xfs_dir3_data_entry_tag_p(mp, dep);
+		tagp = dp->d_ops->data_entry_tag_p(dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
-		xfs_dir2_data_log_entry(tp, bp, dep);
+		xfs_dir2_data_log_entry(tp, dp, bp, dep);
 		name.name = sfep->name;
 		name.len = sfep->namelen;
 		blp[2 + i].hashval = cpu_to_be32(mp->m_dirnameops->
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index ccfeb4d..571e173 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -62,12 +62,26 @@ __xfs_dir3_data_check(
 	char			*p;		/* current data position */
 	int			stale;		/* count of stale leaves */
 	struct xfs_name		name;
+	const struct xfs_dir_ops *ops;
 
 	mp = bp->b_target->bt_mount;
 	hdr = bp->b_addr;
 	bf = xfs_dir3_data_bestfree_p(hdr);
 	p = (char *)xfs_dir3_data_entry_p(hdr);
 
+	/*
+	 * we can be passed a null dp here froma verifier, so manually configure
+	 * the ops here in that case.
+	 */
+	if (dp)
+		ops = dp->d_ops;
+	else if (xfs_sb_version_hascrc(&mp->m_sb))
+		ops = &xfs_dir3_ops;
+	else if (xfs_sb_version_hasftype(&mp->m_sb))
+		ops = &xfs_dir2_ftype_ops;
+	else
+		ops = &xfs_dir2_ops;
+
 	switch (hdr->magic) {
 	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
 	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
@@ -146,10 +160,10 @@ __xfs_dir3_data_check(
 		XFS_WANT_CORRUPTED_RETURN(
 			!xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)));
 		XFS_WANT_CORRUPTED_RETURN(
-			be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)) ==
+			be16_to_cpu(*ops->data_entry_tag_p(dep)) ==
 					       (char *)dep - (char *)hdr);
 		XFS_WANT_CORRUPTED_RETURN(
-			xfs_dir3_dirent_get_ftype(mp, dep) < XFS_DIR3_FT_MAX);
+				ops->data_get_ftype(dep) < XFS_DIR3_FT_MAX);
 		count++;
 		lastfree = 0;
 		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
@@ -167,7 +181,7 @@ __xfs_dir3_data_check(
 			}
 			XFS_WANT_CORRUPTED_RETURN(i < be32_to_cpu(btp->count));
 		}
-		p += xfs_dir3_data_entsize(mp, dep->namelen);
+		p += ops->data_entsize(dep->namelen);
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
@@ -485,9 +499,9 @@ xfs_dir2_data_freeremove(
  */
 void
 xfs_dir2_data_freescan(
-	xfs_mount_t		*mp,		/* filesystem mount point */
-	xfs_dir2_data_hdr_t	*hdr,		/* data block header */
-	int			*loghead)	/* out: log data header */
+	struct xfs_inode	*dp,
+	struct xfs_dir2_data_hdr *hdr,
+	int			*loghead)
 {
 	xfs_dir2_block_tail_t	*btp;		/* block tail */
 	xfs_dir2_data_entry_t	*dep;		/* active data entry */
@@ -513,10 +527,10 @@ xfs_dir2_data_freescan(
 	p = (char *)xfs_dir3_data_entry_p(hdr);
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
-		btp = xfs_dir2_block_tail_p(mp, hdr);
+		btp = xfs_dir2_block_tail_p(dp->i_mount, hdr);
 		endp = (char *)xfs_dir2_block_leaf_p(btp);
 	} else
-		endp = (char *)hdr + mp->m_dirblksize;
+		endp = (char *)hdr + dp->i_mount->m_dirblksize;
 	/*
 	 * Loop over the block's entries.
 	 */
@@ -537,8 +551,8 @@ xfs_dir2_data_freescan(
 		else {
 			dep = (xfs_dir2_data_entry_t *)p;
 			ASSERT((char *)dep - (char *)hdr ==
-			       be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)));
-			p += xfs_dir3_data_entsize(mp, dep->namelen);
+			       be16_to_cpu(*dp->d_ops->data_entry_tag_p(dep)));
+			p += dp->d_ops->data_entsize(dep->namelen);
 		}
 	}
 }
@@ -625,11 +639,11 @@ xfs_dir3_data_init(
 void
 xfs_dir2_data_log_entry(
 	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
 	struct xfs_buf		*bp,
 	xfs_dir2_data_entry_t	*dep)		/* data entry pointer */
 {
 	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
-	struct xfs_mount	*mp = tp->t_mountp;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
@@ -637,7 +651,7 @@ xfs_dir2_data_log_entry(
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
 	xfs_trans_log_buf(tp, bp, (uint)((char *)dep - (char *)hdr),
-		(uint)((char *)(xfs_dir3_data_entry_tag_p(mp, dep) + 1) -
+		(uint)((char *)(dp->d_ops->data_entry_tag_p(dep) + 1) -
 		       (char *)hdr - 1));
 }
 
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 51fdc11..dd19536 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -500,7 +500,7 @@ xfs_dir2_block_to_leaf(
 		hdr->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
 
 	if (needscan)
-		xfs_dir2_data_freescan(mp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	/*
 	 * Set up leaf tail and bests table.
 	 */
@@ -700,7 +700,7 @@ xfs_dir2_leaf_addname(
 	ents = xfs_dir3_leaf_ents_p(leaf);
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	length = xfs_dir3_data_entsize(mp, args->namelen);
+	length = dp->d_ops->data_entsize(args->namelen);
 
 	/*
 	 * See if there are any entries with the same hash value
@@ -901,20 +901,20 @@ xfs_dir2_leaf_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
-	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
-	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
+	dp->d_ops->data_put_ftype(dep, args->filetype);
+	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	/*
 	 * Need to log the data block's header.
 	 */
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
-	xfs_dir2_data_log_entry(tp, dbp, dep);
+	xfs_dir2_data_log_entry(tp, dp, dbp, dep);
 	/*
 	 * If the bests table needs to be changed, do it.
 	 * Log the change unless we've already done that.
@@ -1230,7 +1230,7 @@ xfs_dir2_leaf_lookup(
 	 * Return the found inode number & CI name if appropriate
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
-	args->filetype = xfs_dir3_dirent_get_ftype(dp->i_mount, dep);
+	args->filetype = dp->d_ops->data_get_ftype(dep);
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_trans_brelse(tp, dbp);
 	xfs_trans_brelse(tp, lbp);
@@ -1433,7 +1433,7 @@ xfs_dir2_leaf_removename(
 	 */
 	xfs_dir2_data_make_free(tp, dbp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
-		xfs_dir3_data_entsize(mp, dep->namelen), &needlog, &needscan);
+		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
 	/*
 	 * We just mark the leaf entry stale by putting a null in it.
 	 */
@@ -1449,7 +1449,7 @@ xfs_dir2_leaf_removename(
 	 * log the data block header if necessary.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
 	/*
@@ -1561,9 +1561,9 @@ xfs_dir2_leaf_replace(
 	 * Put the new inode number in, log it.
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
-	xfs_dir3_dirent_put_ftype(dp->i_mount, dep, args->filetype);
+	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tp = args->trans;
-	xfs_dir2_data_log_entry(tp, dbp, dep);
+	xfs_dir2_data_log_entry(tp, dp, dbp, dep);
 	xfs_dir3_leaf_check(dp->i_mount, lbp);
 	xfs_trans_brelse(tp, lbp);
 	return 0;
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 7d21125..c45d452 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -604,7 +604,7 @@ xfs_dir2_leafn_lookup_for_addname(
 		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 		       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 	}
-	length = xfs_dir3_data_entsize(mp, args->namelen);
+	length = dp->d_ops->data_entsize(args->namelen);
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
@@ -815,7 +815,7 @@ xfs_dir2_leafn_lookup_for_entry(
 				xfs_trans_brelse(tp, state->extrablk.bp);
 			args->cmpresult = cmp;
 			args->inumber = be64_to_cpu(dep->inumber);
-			args->filetype = xfs_dir3_dirent_get_ftype(mp, dep);
+			args->filetype = dp->d_ops->data_get_ftype(dep);
 			*indexp = index;
 			state->extravalid = 1;
 			state->extrablk.bp = curbp;
@@ -1259,13 +1259,13 @@ xfs_dir2_leafn_remove(
 	longest = be16_to_cpu(bf[0].length);
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, dbp, off,
-		xfs_dir3_data_entsize(mp, dep->namelen), &needlog, &needscan);
+		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
 	/*
 	 * Rescan the data block freespaces for bestfree.
 	 * Log the data block header if needed.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	if (needlog)
 		xfs_dir2_data_log_header(tp, dbp);
 	xfs_dir3_data_check(dp, dbp);
@@ -1711,7 +1711,7 @@ xfs_dir2_node_addname_int(
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
-	length = xfs_dir3_data_entsize(mp, args->namelen);
+	length = dp->d_ops->data_entsize(args->namelen);
 	/*
 	 * If we came in with a freespace block that means that lookup
 	 * found an entry with our hash value.  This is the freespace
@@ -2007,15 +2007,15 @@ xfs_dir2_node_addname_int(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
-	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
-	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
+	dp->d_ops->data_put_ftype(dep, args->filetype);
+	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
-	xfs_dir2_data_log_entry(tp, dbp, dep);
+	xfs_dir2_data_log_entry(tp, dp, dbp, dep);
 	/*
 	 * Rescan the block for bestfree if needed.
 	 */
 	if (needscan)
-		xfs_dir2_data_freescan(mp, hdr, &needlog);
+		xfs_dir2_data_freescan(dp, hdr, &needlog);
 	/*
 	 * Log the data block header if needed.
 	 */
@@ -2228,8 +2228,9 @@ xfs_dir2_node_replace(
 		 * Fill in the new inode number and log the entry.
 		 */
 		dep->inumber = cpu_to_be64(inum);
-		xfs_dir3_dirent_put_ftype(state->mp, dep, args->filetype);
-		xfs_dir2_data_log_entry(args->trans, state->extrablk.bp, dep);
+		args->dp->d_ops->data_put_ftype(dep, args->filetype);
+		xfs_dir2_data_log_entry(args->trans, args->dp,
+					state->extrablk.bp, dep);
 		rval = 0;
 	}
 	/*
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 2d2c8fb..b99aa7d 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -119,9 +119,9 @@ xfs_dir2_sf_getdents(
 	 * mp->m_dirdatablk.
 	 */
 	dot_offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-					     xfs_dir3_data_dot_offset(mp));
+						dp->d_ops->data_dot_offset());
 	dotdot_offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-						xfs_dir3_data_dotdot_offset(mp));
+						dp->d_ops->data_dotdot_offset());
 
 	/*
 	 * Put . entry unless we're starting past it.
@@ -237,7 +237,7 @@ xfs_dir2_block_getdents(
 		/*
 		 * Bump pointer for the next iteration.
 		 */
-		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
+		ptr += dp->d_ops->data_entsize(dep->namelen);
 		/*
 		 * The entry is before the desired starting point, skip it.
 		 */
@@ -248,7 +248,7 @@ xfs_dir2_block_getdents(
 					    (char *)dep - (char *)hdr);
 
 		ctx->pos = cook & 0x7fffffff;
-		filetype = xfs_dir3_dirent_get_ftype(mp, dep);
+		filetype = dp->d_ops->data_get_ftype(dep);
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
@@ -601,7 +601,7 @@ xfs_dir2_leaf_getdents(
 					}
 					dep = (xfs_dir2_data_entry_t *)ptr;
 					length =
-					   xfs_dir3_data_entsize(mp, dep->namelen);
+					   dp->d_ops->data_entsize(dep->namelen);
 					ptr += length;
 				}
 				/*
@@ -632,8 +632,8 @@ xfs_dir2_leaf_getdents(
 		}
 
 		dep = (xfs_dir2_data_entry_t *)ptr;
-		length = xfs_dir3_data_entsize(mp, dep->namelen);
-		filetype = xfs_dir3_dirent_get_ftype(mp, dep);
+		length = dp->d_ops->data_entsize(dep->namelen);
+		filetype = dp->d_ops->data_get_ftype(dep);
 
 		ctx->pos = xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff;
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index ec0d39b..953e194 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -251,11 +251,11 @@ xfs_dir2_block_to_sf(
 			dp->d_ops->sf_put_ino(sfp, sfep,
 					      be64_to_cpu(dep->inumber));
 			dp->d_ops->sf_put_ftype(sfep,
-					xfs_dir3_dirent_get_ftype(mp, dep));
+					dp->d_ops->data_get_ftype(dep));
 
 			sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 		}
-		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
+		ptr += dp->d_ops->data_entsize(dep->namelen);
 	}
 	ASSERT((char *)sfep - (char *)sfp == size);
 	xfs_dir2_sf_check(args);
@@ -473,12 +473,12 @@ xfs_dir2_sf_addname_hard(
 	 * to insert the new entry.
 	 * If it's going to end up at the end then oldsfep will point there.
 	 */
-	for (offset = xfs_dir3_data_first_offset(mp),
+	for (offset = dp->d_ops->data_first_offset(),
 	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
-	      add_datasize = xfs_dir3_data_entsize(mp, args->namelen),
+	      add_datasize = dp->d_ops->data_entsize(args->namelen),
 	      eof = (char *)oldsfep == &buf[old_isize];
 	     !eof;
-	     offset = new_offset + xfs_dir3_data_entsize(mp, oldsfep->namelen),
+	     offset = new_offset + dp->d_ops->data_entsize(oldsfep->namelen),
 	      oldsfep = dp->d_ops->sf_nextentry(oldsfp, oldsfep),
 	      eof = (char *)oldsfep == &buf[old_isize]) {
 		new_offset = xfs_dir2_sf_get_offset(oldsfep);
@@ -555,8 +555,8 @@ xfs_dir2_sf_addname_pick(
 	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	size = xfs_dir3_data_entsize(mp, args->namelen);
-	offset = xfs_dir3_data_first_offset(mp);
+	size = dp->d_ops->data_entsize(args->namelen);
+	offset = dp->d_ops->data_first_offset();
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
 	/*
@@ -568,7 +568,7 @@ xfs_dir2_sf_addname_pick(
 		if (!holefit)
 			holefit = offset + size <= xfs_dir2_sf_get_offset(sfep);
 		offset = xfs_dir2_sf_get_offset(sfep) +
-			 xfs_dir3_data_entsize(mp, sfep->namelen);
+			 dp->d_ops->data_entsize(sfep->namelen);
 		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 	}
 	/*
@@ -629,7 +629,7 @@ xfs_dir2_sf_check(
 	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	offset = xfs_dir3_data_first_offset(mp);
+	offset = dp->d_ops->data_first_offset();
 	ino = dp->d_ops->sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
@@ -641,7 +641,7 @@ xfs_dir2_sf_check(
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
 		offset =
 			xfs_dir2_sf_get_offset(sfep) +
-			xfs_dir3_data_entsize(mp, sfep->namelen);
+			dp->d_ops->data_entsize(sfep->namelen);
 		ASSERT(dp->d_ops->sf_get_ftype(sfep) < XFS_DIR3_FT_MAX);
 	}
 	ASSERT(i8count == sfp->i8count);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

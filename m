Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20532 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdDHDEG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 23:04:06 -0400
Subject: [PATCH 3/4] xfs_db: complain about dir/attr blocks with bad magics
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Apr 2017 20:04:01 -0700
Message-ID: <149162064132.22901.4527238530152226772.stgit@birch.djwong.org>
In-Reply-To: <149162062276.22901.7801103937404880951.stgit@birch.djwong.org>
References: <149162062276.22901.7801103937404880951.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The directory and attribute manipulation code also use the block's magic
number to figure out the real type of the block we're analyzing.  If the
magic doesn't match any of the known magics, we end up with the field
type set to the raw attr3/dir3 type and no child type to descend into.
Since there's no print function, we trip over the assertion about
FTARG_OKEMPTY and crash.  Instead provide a print function that
complains about the bad magic number.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attr.c  |   21 +++++++++++++++++++++
 db/attr.h  |    3 +++
 db/dir2.c  |   21 +++++++++++++++++++++
 db/dir2.h  |    3 +++
 db/field.c |   16 ++++++++--------
 5 files changed, 56 insertions(+), 8 deletions(-)


diff --git a/db/attr.c b/db/attr.c
index e26ac67..68a3116 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -574,3 +574,24 @@ const struct xfs_buf_ops xfs_attr3_db_buf_ops = {
 	.verify_read = xfs_attr3_db_read_verify,
 	.verify_write = xfs_attr3_db_write_verify,
 };
+
+int
+attr_print_func(
+	void		*obj,
+	int		bit,
+	int		count,
+	char		*fmtstr,
+	int		size,
+	int		arg,
+	int		base,
+	int		array)
+{
+	__be32			magic32;
+	__be16			magic16;
+
+	magic32 = *(__be32 *)obj;
+	magic16 = ((struct xfs_da_blkinfo *)obj)->magic;
+	dbprintf(_("Unknown attribute buffer magic (0x%x:0x%x)!\n"),
+		magic32, magic16);
+	return 0;
+}
diff --git a/db/attr.h b/db/attr.h
index bc3431f..525b144 100644
--- a/db/attr.h
+++ b/db/attr.h
@@ -35,3 +35,6 @@ extern int	attr_leaf_name_size(void *obj, int startoff, int idx);
 extern int	attr_size(void *obj, int startoff, int idx);
 
 extern const struct xfs_buf_ops xfs_attr3_db_buf_ops;
+
+extern int	attr_print_func(void *obj, int bit, int count, char *fmtstr,
+		int size, int arg, int base, int array);
diff --git a/db/dir2.c b/db/dir2.c
index 533f705..3b89330 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -1041,3 +1041,24 @@ const struct xfs_buf_ops xfs_dir3_db_buf_ops = {
 	.verify_read = xfs_dir3_db_read_verify,
 	.verify_write = xfs_dir3_db_write_verify,
 };
+
+int
+dir2_print_func(
+	void		*obj,
+	int		bit,
+	int		count,
+	char		*fmtstr,
+	int		size,
+	int		arg,
+	int		base,
+	int		array)
+{
+	__be32			magic32;
+	__be16			magic16;
+
+	magic32 = *(__be32 *)obj;
+	magic16 = ((struct xfs_da_blkinfo *)obj)->magic;
+	dbprintf(_("Unknown directory buffer magic (0x%x:0x%x)!\n"),
+		magic32, magic16);
+	return 0;
+}
diff --git a/db/dir2.h b/db/dir2.h
index 0c2a62e..6d12cc1 100644
--- a/db/dir2.h
+++ b/db/dir2.h
@@ -62,3 +62,6 @@ extern int	dir2_data_union_size(void *obj, int startoff, int idx);
 extern int	dir2_size(void *obj, int startoff, int idx);
 
 extern const struct xfs_buf_ops xfs_dir3_db_buf_ops;
+
+extern int	dir2_print_func(void *obj, int bit, int count, char *fmtstr,
+		int size, int arg, int base, int array);
diff --git a/db/field.c b/db/field.c
index 1968dd5..5496789 100644
--- a/db/field.c
+++ b/db/field.c
@@ -59,8 +59,8 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_DONULL, NULL, NULL },
 
 /* attr fields */
-	{ FLDT_ATTR, "attr", NULL, (char *)attr_flds, attr_size, FTARG_SIZE,
-	  NULL, attr_flds },
+	{ FLDT_ATTR, "attr", attr_print_func, (char *)attr_flds, attr_size,
+	  FTARG_SIZE, NULL, attr_flds },
 	{ FLDT_ATTR_BLKINFO, "attr_blkinfo", NULL, (char *)attr_blkinfo_flds,
 	  SI(bitsz(struct xfs_da_blkinfo)), 0, NULL, attr_blkinfo_flds },
 	{ FLDT_ATTR_LEAF_ENTRY, "attr_leaf_entry", fp_sarray,
@@ -89,8 +89,8 @@ const ftattr_t	ftattrtab[] = {
 	  attrshort_size, FTARG_SIZE, NULL, attr_shortform_flds },
 
 /* attr3 specific fields */
-	{ FLDT_ATTR3, "attr3", NULL, (char *)attr3_flds, attr_size, FTARG_SIZE,
-	  NULL, attr3_flds },
+	{ FLDT_ATTR3, "attr3", attr_print_func, (char *)attr3_flds, attr_size,
+	  FTARG_SIZE, NULL, attr3_flds },
 	{ FLDT_ATTR3_LEAF_HDR, "attr3_leaf_hdr", NULL,
 	  (char *)attr3_leaf_hdr_flds, SI(bitsz(struct xfs_attr3_leaf_hdr)),
 	  0, NULL, attr3_leaf_hdr_flds },
@@ -219,8 +219,8 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(xfs_dinode_t)), 0, NULL, inode_v3_flds },
 
 /* dir v2 fields */
-	{ FLDT_DIR2, "dir2", NULL, (char *)dir2_flds, dir2_size, FTARG_SIZE,
-	  NULL, dir2_flds },
+	{ FLDT_DIR2, "dir2", dir2_print_func, (char *)dir2_flds, dir2_size,
+	  FTARG_SIZE, NULL, dir2_flds },
 	{ FLDT_DIR2_BLOCK_TAIL, "dir2_block_tail", NULL,
 	  (char *)dir2_block_tail_flds, SI(bitsz(xfs_dir2_block_tail_t)), 0,
 	  NULL, dir2_block_tail_flds },
@@ -262,8 +262,8 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_SIZE, NULL, dir2sf_flds },
 
 /* dir v3 fields */
-	{ FLDT_DIR3, "dir3", NULL, (char *)dir3_flds, dir2_size, FTARG_SIZE,
-	  NULL, dir3_flds },
+	{ FLDT_DIR3, "dir3", dir2_print_func, (char *)dir3_flds, dir2_size,
+	  FTARG_SIZE, NULL, dir3_flds },
 	{ FLDT_DIR3_BLKHDR, "dir3_blk_hdr", NULL, (char *)dir3_blkhdr_flds,
 	  SI(bitsz(struct xfs_dir3_blk_hdr)), 0, NULL, dir3_blkhdr_flds },
 	{ FLDT_DIR3_DATA_HDR, "dir3_data_hdr", NULL, (char *)dir3_data_hdr_flds,


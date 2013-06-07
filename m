Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C14D87F53
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8469C304087
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:15 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YCuRSmCrkx7i6nIA for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:27:13 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkWE-0003wY-7m
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkW9-0001MD-0u
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 33/48] xfs_db: factor some common dir2 field parsing code.
Date: Fri,  7 Jun 2013 10:25:56 +1000
Message-Id: <1370564771-4929-34-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

Why duplicate it?

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/dir2.c |  172 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 84 insertions(+), 88 deletions(-)

diff --git a/db/dir2.c b/db/dir2.c
index 90378e6..594d9d2 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -189,6 +189,72 @@ const field_t	da_node_hdr_flds[] = {
 	{ NULL }
 };
 
+/*
+ * Worker functions shared between either dir2/dir3 or block/data formats
+ */
+static int
+__dir2_block_tail_offset(
+	struct xfs_dir2_data_hdr *block,
+	int			startoff,
+	int			idx)
+{
+	struct xfs_dir2_block_tail *btp;
+
+	ASSERT(startoff == 0);
+	ASSERT(idx == 0);
+	btp = xfs_dir2_block_tail_p(mp, block);
+	return bitize((int)((char *)btp - (char *)block));
+}
+
+static int
+__dir2_data_entries_count(
+	char	*ptr,
+	char	*endptr)
+{
+	int	i;
+
+	for (i = 0; ptr < endptr; i++) {
+		struct xfs_dir2_data_entry *dep;
+		struct xfs_dir2_data_unused *dup;
+
+		dup = (xfs_dir2_data_unused_t *)ptr;
+		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG)
+			ptr += be16_to_cpu(dup->length);
+		else {
+			dep = (xfs_dir2_data_entry_t *)ptr;
+			ptr += xfs_dir2_data_entsize(dep->namelen);
+		}
+	}
+	return i;
+}
+
+static char *
+__dir2_data_entry_offset(
+	char	*ptr,
+	char	*endptr,
+	int	idx)
+{
+	int	i;
+
+	for (i = 0; i < idx; i++) {
+		struct xfs_dir2_data_entry *dep;
+		struct xfs_dir2_data_unused *dup;
+
+		ASSERT(ptr < endptr);
+		dup = (xfs_dir2_data_unused_t *)ptr;
+		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG)
+			ptr += be16_to_cpu(dup->length);
+		else {
+			dep = (xfs_dir2_data_entry_t *)ptr;
+			ptr += xfs_dir2_data_entsize(dep->namelen);
+		}
+	}
+	return ptr;
+}
+
+/*
+ * Block format functions
+ */
 static int
 dir2_block_hdr_count(
 	void			*obj,
@@ -254,86 +320,50 @@ dir2_block_tail_offset(
 	int			startoff,
 	int			idx)
 {
-	struct xfs_dir2_data_hdr *block;
-	struct xfs_dir2_block_tail *btp;
+	struct xfs_dir2_data_hdr *block = obj;
 
-	ASSERT(startoff == 0);
-	ASSERT(idx == 0);
-	block = obj;
 	ASSERT(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC);
-	btp = xfs_dir2_block_tail_p(mp, block);
-	return bitize((int)((char *)btp - (char *)block));
+	return __dir2_block_tail_offset(block, startoff, idx);
 }
 
-/*ARGSUSED*/
 static int
 dir2_block_u_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_data_hdr *block;
+	struct xfs_dir2_data_hdr *block = obj;
 	struct xfs_dir2_block_tail *btp;
-	char			*endptr;
-	int			i;
-	char			*ptr;
 
 	ASSERT(startoff == 0);
-	block = obj;
 	if (be32_to_cpu(block->magic) != XFS_DIR2_BLOCK_MAGIC)
 		return 0;
-	btp = xfs_dir2_block_tail_p(mp, block);
-	ptr = (char *)xfs_dir3_data_unused_p(block);
-	endptr = (char *)xfs_dir2_block_leaf_p(btp);
-	for (i = 0; ptr < endptr; i++) {
-		struct xfs_dir2_data_entry *dep;
-		struct xfs_dir2_data_unused *dup;
 
-		dup = (xfs_dir2_data_unused_t *)ptr;
-		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG)
-			ptr += be16_to_cpu(dup->length);
-		else {
-			dep = (xfs_dir2_data_entry_t *)ptr;
-			ptr += xfs_dir2_data_entsize(dep->namelen);
-		}
-	}
-	return i;
+	btp = xfs_dir2_block_tail_p(mp, block);
+	return __dir2_data_entries_count((char *)xfs_dir3_data_unused_p(block),
+					 (char *)xfs_dir2_block_leaf_p(btp));
 }
 
-/*ARGSUSED*/
 static int
 dir2_block_u_offset(
 	void			*obj,
 	int			startoff,
 	int			idx)
 {
-	struct xfs_dir2_data_hdr *block;
+	struct xfs_dir2_data_hdr *block = obj;
 	struct xfs_dir2_block_tail *btp;
-	char			*endptr;
-	int			i;
 	char			*ptr;
 
 	ASSERT(startoff == 0);
-	block = obj;
 	ASSERT(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC);
 	btp = xfs_dir2_block_tail_p(mp, block);
-	ptr = (char *)xfs_dir3_data_unused_p(block);
-	endptr = (char *)xfs_dir2_block_leaf_p(btp);
-	for (i = 0; i < idx; i++) {
-		struct xfs_dir2_data_entry *dep;
-		struct xfs_dir2_data_unused *dup;
-
-		ASSERT(ptr < endptr);
-		dup = (xfs_dir2_data_unused_t *)ptr;
-		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG)
-			ptr += be16_to_cpu(dup->length);
-		else {
-			dep = (xfs_dir2_data_entry_t *)ptr;
-			ptr += xfs_dir2_data_entsize(dep->namelen);
-		}
-	}
+	ptr = __dir2_data_entry_offset((char *)xfs_dir3_data_unused_p(block),
+				       (char *)xfs_dir2_block_leaf_p(btp), idx);
 	return bitize((int)(ptr - (char *)block));
 }
 
+/*
+ * Data block format functions
+ */
 static int
 dir2_data_union_freetag_count(
 	void			*obj,
@@ -489,66 +519,32 @@ dir2_data_u_count(
 	void			*obj,
 	int			startoff)
 {
-	struct xfs_dir2_data_hdr *data;
-	char			*endptr;
-	int			i;
-	char			*ptr;
+	struct xfs_dir2_data_hdr *data = obj;
 
 	ASSERT(startoff == 0);
-	data = obj;
 	if (be32_to_cpu(data->magic) != XFS_DIR2_DATA_MAGIC)
 		return 0;
-	ptr = (char *)xfs_dir3_data_unused_p(data);
-	endptr = (char *)data + mp->m_dirblksize;
-	for (i = 0; ptr < endptr; i++) {
-		struct xfs_dir2_data_entry *dep;
-		struct xfs_dir2_data_unused *dup;
 
-		dup = (xfs_dir2_data_unused_t *)ptr;
-		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG)
-			ptr += be16_to_cpu(dup->length);
-		else {
-			dep = (xfs_dir2_data_entry_t *)ptr;
-			ptr += xfs_dir2_data_entsize(dep->namelen);
-		}
-	}
-	return i;
+	return __dir2_data_entries_count((char *)xfs_dir3_data_unused_p(data),
+					 (char *)data + mp->m_dirblksize);
 }
 
-/*ARGSUSED*/
 static int
 dir2_data_u_offset(
 	void			*obj,
 	int			startoff,
 	int			idx)
 {
-	struct xfs_dir2_data_hdr *data;
-	char			*endptr;
-	int			i;
+	struct xfs_dir2_data_hdr *data = obj;
 	char			*ptr;
 
 	ASSERT(startoff == 0);
-	data = obj;
 	ASSERT(be32_to_cpu(data->magic) == XFS_DIR2_DATA_MAGIC);
-	ptr = (char *)xfs_dir3_data_unused_p(data);
-	endptr = (char *)data + mp->m_dirblksize;
-	for (i = 0; i < idx; i++) {
-		struct xfs_dir2_data_entry *dep;
-		struct xfs_dir2_data_unused *dup;
-
-		ASSERT(ptr < endptr);
-		dup = (xfs_dir2_data_unused_t *)ptr;
-		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG)
-			ptr += be16_to_cpu(dup->length);
-		else {
-			dep = (xfs_dir2_data_entry_t *)ptr;
-			ptr += xfs_dir2_data_entsize(dep->namelen);
-		}
-	}
+	ptr = __dir2_data_entry_offset((char *)xfs_dir3_data_unused_p(data),
+				       (char *)data + mp->m_dirblksize, idx);
 	return bitize((int)(ptr - (char *)data));
 }
 
-/*ARGSUSED*/
 int
 dir2_data_union_size(
 	void			*obj,
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

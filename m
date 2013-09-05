Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA97D7F6C
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 07:13:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48DDAAC005
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 05:13:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vGyDWGxUUeTmKG1h for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 05:13:47 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHYRM-0001GW-P7
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 22:13:36 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHYRM-0004Er-Nn
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 22:13:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 10/12] db: add a special directory buffer verifier
Date: Thu,  5 Sep 2013 22:13:31 +1000
Message-Id: <1378383213-16155-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1378383213-16155-1-git-send-email-david@fromorbit.com>
References: <1378383213-16155-1-git-send-email-david@fromorbit.com>
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

Because we only have a single directory type that is used for all
the different buffer types, we need to provide a special verifier
for the read code. That verifier needs to know all the directory
types and when it find one it knows about, switch to the correct
verifier and call it.

We already do this for certain readahead cases in the directory
code, so there is precedence for this. If we don't find a magic
number we recognise, the verifier fails...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/dir2.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/dir2.h |  2 ++
 db/type.c |  3 ++-
 3 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/db/dir2.c b/db/dir2.c
index 2ec64e0..5a10955 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -24,6 +24,7 @@
 #include "field.h"
 #include "dir2.h"
 #include "init.h"
+#include "output.h"
 
 static int	dir2_block_hdr_count(void *obj, int startoff);
 static int	dir2_block_leaf_count(void *obj, int startoff);
@@ -975,3 +976,63 @@ const field_t	da3_node_hdr_flds[] = {
 	{ "pad", FLDT_UINT32D, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
 	{ NULL }
 };
+
+/*
+ * Special read verifier for directory buffers. detect the magic number
+ * appropriately and set the correct verifier and call it.
+ */
+static void
+xfs_dir3_db_read_verify(
+	struct xfs_buf		*bp)
+{
+	__be32			magic32;
+	__be16			magic16;
+
+	magic32 = *(__be32 *)bp->b_addr;
+	magic16 = ((struct xfs_da_blkinfo *)bp->b_addr)->magic;
+
+	switch (magic32) {
+	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
+		bp->b_ops = &xfs_dir3_block_buf_ops;
+		goto verify;
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
+		bp->b_ops = &xfs_dir3_data_buf_ops;
+		goto verify;
+	case cpu_to_be32(XFS_DIR3_FREE_MAGIC):
+		bp->b_ops = &xfs_dir3_free_buf_ops;
+		goto verify;
+	default:
+		break;
+	}
+
+	switch (magic16) {
+	case cpu_to_be16(XFS_DIR3_LEAF1_MAGIC):
+		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
+		break;
+	case cpu_to_be16(XFS_DIR3_LEAFN_MAGIC):
+		bp->b_ops = &xfs_dir3_leafn_buf_ops;
+		break;
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		bp->b_ops = &xfs_da3_node_buf_ops;
+		break;
+	default:
+		dbprintf(_("Unknown directory buffer type!\n"));
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+verify:
+	bp->b_ops->verify_read(bp);
+}
+
+static void
+xfs_dir3_db_write_verify(
+	struct xfs_buf		*bp)
+{
+	dbprintf(_("Writing unknown directory buffer type!\n"));
+	xfs_buf_ioerror(bp, EFSCORRUPTED);
+}
+
+const struct xfs_buf_ops xfs_dir3_db_buf_ops = {
+	.verify_read = xfs_dir3_db_read_verify,
+	.verify_write = xfs_dir3_db_write_verify,
+};
diff --git a/db/dir2.h b/db/dir2.h
index b3651d5..5054493 100644
--- a/db/dir2.h
+++ b/db/dir2.h
@@ -60,3 +60,5 @@ static inline xfs_dir2_inou_t *xfs_dir2_sf_inumberp(xfs_dir2_sf_entry_t *sfep)
 
 extern int	dir2_data_union_size(void *obj, int startoff, int idx);
 extern int	dir2_size(void *obj, int startoff, int idx);
+
+extern const struct xfs_buf_ops xfs_dir3_db_buf_ops;
diff --git a/db/type.c b/db/type.c
index b3f3d87..2c3431e 100644
--- a/db/type.c
+++ b/db/type.c
@@ -87,7 +87,8 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_crc_hfld,
 		&xfs_allocbt_buf_ops },
 	{ TYP_DATA, "data", handle_block, NULL, NULL },
-	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld, NULL },
+	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
+		&xfs_dir3_db_buf_ops },
 	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld,
 		&xfs_dquot_buf_ops },
 	{ TYP_INOBT, "inobt", handle_struct, inobt_crc_hfld,
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

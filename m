Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 50CCF29E28
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CBF05AC002
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:44 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Hmbk9tYylVnCFFGg for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:42 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003Ob-FG
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-0008W0-EF
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 26/37] db: add a special attribute buffer verifier
Date: Wed,  6 Nov 2013 12:07:12 +1100
Message-Id: <1383700043-32305-27-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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

Because we only have a single attribute type that is used for all
the attribute buffer types, we need to provide a special verifier
for the read code. That verifier needs to know all the attribute
types and when it find one it knows about, switch to the correct
verifier and call it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/attr.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 db/attr.h |  2 ++
 db/type.c |  3 ++-
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/db/attr.c b/db/attr.c
index cd95a0a..359af7b 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -25,6 +25,7 @@
 #include "attr.h"
 #include "io.h"
 #include "init.h"
+#include "output.h"
 
 static int	attr_leaf_entries_count(void *obj, int startoff);
 static int	attr_leaf_hdr_count(void *obj, int startoff);
@@ -522,3 +523,53 @@ const field_t	attr3_leaf_hdr_flds[] = {
 	{ NULL }
 };
 
+/*
+ * Special read verifier for attribute buffers. detect the magic number
+ * appropriately and set the correct verifier and call it.
+ */
+static void
+xfs_attr3_db_read_verify(
+	struct xfs_buf		*bp)
+{
+	__be32			magic32;
+	__be16			magic16;
+
+	magic32 = *(__be32 *)bp->b_addr;
+	magic16 = ((struct xfs_da_blkinfo *)bp->b_addr)->magic;
+
+	switch (magic16) {
+	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
+		bp->b_ops = &xfs_attr3_leaf_buf_ops;
+		goto verify;
+	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
+		bp->b_ops = &xfs_da3_node_buf_ops;
+		goto verify;
+	default:
+		break;
+	}
+
+	switch (magic32) {
+	case cpu_to_be32(XFS_ATTR3_RMT_MAGIC):
+		bp->b_ops = &xfs_attr3_rmt_buf_ops;
+		break;
+	default:
+		dbprintf(_("Unknown attribute buffer type!\n"));
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+verify:
+	bp->b_ops->verify_read(bp);
+}
+
+static void
+xfs_attr3_db_write_verify(
+	struct xfs_buf		*bp)
+{
+	dbprintf(_("Writing unknown attribute buffer type!\n"));
+	xfs_buf_ioerror(bp, EFSCORRUPTED);
+}
+
+const struct xfs_buf_ops xfs_attr3_db_buf_ops = {
+	.verify_read = xfs_attr3_db_read_verify,
+	.verify_write = xfs_attr3_db_write_verify,
+};
diff --git a/db/attr.h b/db/attr.h
index 3065372..bc3431f 100644
--- a/db/attr.h
+++ b/db/attr.h
@@ -33,3 +33,5 @@ extern const field_t	attr3_node_hdr_flds[];
 
 extern int	attr_leaf_name_size(void *obj, int startoff, int idx);
 extern int	attr_size(void *obj, int startoff, int idx);
+
+extern const struct xfs_buf_ops xfs_attr3_db_buf_ops;
diff --git a/db/type.c b/db/type.c
index 2c3431e..04d0d56 100644
--- a/db/type.c
+++ b/db/type.c
@@ -77,7 +77,8 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_AGF, "agf", handle_struct, agf_hfld, &xfs_agf_buf_ops },
 	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld, &xfs_agfl_buf_ops },
 	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agfl_buf_ops },
-	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld, NULL },
+	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld,
+		&xfs_attr3_db_buf_ops },
 	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld,
 		&xfs_bmbt_buf_ops },
 	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_crc_hfld,
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

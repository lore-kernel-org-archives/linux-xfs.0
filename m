Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21843 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbdF2Tx5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2017 15:53:57 -0400
Date: Thu, 29 Jun 2017 12:53:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: identify attr dabtree field types correctly
Message-ID: <20170629195351.GI5874@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

For whatever reason, the v5 xattr dabtree header fields are mapped to
the directory dabtree header fields, which means that the types are
wrong and hence we cannot use the 'addr' command to step through the
tree.  Since the v4 attr dabtree does this correctly, simply port the v5
fields to the attr code too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attr.c  |   24 ++++++++++++++++++++++--
 db/attr.h  |    2 ++
 db/field.c |    6 ++++--
 db/field.h |    1 +
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/db/attr.c b/db/attr.c
index 6f56953..2b7b164 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -499,7 +499,7 @@ const field_t	attr3_hfld[] = {
 const field_t	attr3_flds[] = {
 	{ "hdr", FLDT_ATTR3_LEAF_HDR, OI(L3OFF(hdr)), attr3_leaf_hdr_count,
 	  FLD_COUNT, TYP_NONE },
-	{ "hdr", FLDT_DA3_NODE_HDR, OI(N3OFF(hdr)), attr3_node_hdr_count,
+	{ "hdr", FLDT_ATTR3_NODE_HDR, OI(N3OFF(hdr)), attr3_node_hdr_count,
 	  FLD_COUNT, TYP_NONE },
 	{ "entries", FLDT_ATTR_LEAF_ENTRY, OI(L3OFF(entries)),
 	  attr3_leaf_entries_count, FLD_ARRAY|FLD_COUNT, TYP_NONE },
@@ -512,7 +512,7 @@ const field_t	attr3_flds[] = {
 
 #define	LH3OFF(f)	bitize(offsetof(struct xfs_attr3_leaf_hdr, f))
 const field_t	attr3_leaf_hdr_flds[] = {
-	{ "info", FLDT_DA3_BLKINFO, OI(LH3OFF(info)), C1, 0, TYP_NONE },
+	{ "info", FLDT_ATTR3_BLKINFO, OI(LH3OFF(info)), C1, 0, TYP_NONE },
 	{ "count", FLDT_UINT16D, OI(LH3OFF(count)), C1, 0, TYP_NONE },
 	{ "usedbytes", FLDT_UINT16D, OI(LH3OFF(usedbytes)), C1, 0, TYP_NONE },
 	{ "firstused", FLDT_UINT16D, OI(LH3OFF(firstused)), C1, 0, TYP_NONE },
@@ -523,6 +523,26 @@ const field_t	attr3_leaf_hdr_flds[] = {
 	{ NULL }
 };
 
+#define	DB3OFF(f)	bitize(offsetof(struct xfs_da3_blkinfo, f))
+const field_t	attr3_blkinfo_flds[] = {
+	{ "hdr", FLDT_ATTR_BLKINFO, OI(DB3OFF(hdr)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(DB3OFF(crc)), C1, 0, TYP_NONE },
+	{ "bno", FLDT_DFSBNO, OI(DB3OFF(blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(DB3OFF(lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(DB3OFF(uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(DB3OFF(owner)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	H3OFF(f)	bitize(offsetof(struct xfs_da3_node_hdr, f))
+const field_t	attr3_node_hdr_flds[] = {
+	{ "info", FLDT_ATTR3_BLKINFO, OI(H3OFF(info)), C1, 0, TYP_NONE },
+	{ "count", FLDT_UINT16D, OI(H3OFF(__count)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(H3OFF(__level)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT32D, OI(H3OFF(__pad32)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
 /*
  * Special read verifier for attribute buffers. Detect the magic number
  * appropriately and set the correct verifier and call it.
diff --git a/db/attr.h b/db/attr.h
index bc3431f..21848c1 100644
--- a/db/attr.h
+++ b/db/attr.h
@@ -30,6 +30,8 @@ extern const field_t	attr3_flds[];
 extern const field_t	attr3_hfld[];
 extern const field_t	attr3_leaf_hdr_flds[];
 extern const field_t	attr3_node_hdr_flds[];
+extern const field_t	attr3_blkinfo_flds[];
+extern const field_t	attr3_node_hdr_flds[];
 
 extern int	attr_leaf_name_size(void *obj, int startoff, int idx);
 extern int	attr_size(void *obj, int startoff, int idx);
diff --git a/db/field.c b/db/field.c
index 2a2197a..d0c8e04 100644
--- a/db/field.c
+++ b/db/field.c
@@ -91,12 +91,14 @@ const ftattr_t	ftattrtab[] = {
 /* attr3 specific fields */
 	{ FLDT_ATTR3, "attr3", NULL, (char *)attr3_flds, attr_size, FTARG_SIZE,
 	  NULL, attr3_flds },
+	{ FLDT_ATTR3_BLKINFO, "attr3_blkinfo", NULL, (char *)attr3_blkinfo_flds,
+	  SI(bitsz(struct xfs_da_blkinfo)), 0, NULL, attr3_blkinfo_flds },
 	{ FLDT_ATTR3_LEAF_HDR, "attr3_leaf_hdr", NULL,
 	  (char *)attr3_leaf_hdr_flds, SI(bitsz(struct xfs_attr3_leaf_hdr)),
 	  0, NULL, attr3_leaf_hdr_flds },
 	{ FLDT_ATTR3_NODE_HDR, "attr3_node_hdr", NULL,
-	  (char *)da3_node_hdr_flds, SI(bitsz(struct xfs_da3_node_hdr)),
-	  0, NULL, da3_node_hdr_flds },
+	  (char *)attr3_node_hdr_flds, SI(bitsz(struct xfs_da3_node_hdr)),
+	  0, NULL, attr3_node_hdr_flds },
 
 	{ FLDT_BMAPBTA, "bmapbta", NULL, (char *)bmapbta_flds, btblock_size,
 	  FTARG_SIZE, NULL, bmapbta_flds },
diff --git a/db/field.h b/db/field.h
index 53616f1..d1a7095 100644
--- a/db/field.h
+++ b/db/field.h
@@ -44,6 +44,7 @@ typedef enum fldt	{
 
 	/* attr 3 specific fields */
 	FLDT_ATTR3,
+	FLDT_ATTR3_BLKINFO,
 	FLDT_ATTR3_LEAF_HDR,
 	FLDT_ATTR3_NODE_HDR,
 

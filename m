Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19274 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754399AbcKEA2f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:28:35 -0400
Subject: [PATCH 37/39] xfs_db: print attribute remote value blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:28:32 -0700
Message-ID: <147830571210.4165.3288845909759920756.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Teach xfs_db how to print the contents of xattr remote value blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attr.c  |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/attr.h  |    1 +
 db/field.c |    3 +++
 db/field.h |    1 +
 4 files changed, 64 insertions(+)


diff --git a/db/attr.c b/db/attr.c
index e26ac67..0fffbc2 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -41,6 +41,9 @@ static int	attr_leaf_nvlist_offset(void *obj, int startoff, int idx);
 static int	attr_node_btree_count(void *obj, int startoff);
 static int	attr_node_hdr_count(void *obj, int startoff);
 
+static int	attr_remote_count(void *obj, int startoff);
+static int	attr3_remote_count(void *obj, int startoff);
+
 const field_t	attr_hfld[] = {
 	{ "", FLDT_ATTR, OI(0), C1, 0, TYP_NONE },
 	{ NULL }
@@ -53,6 +56,7 @@ const field_t	attr_flds[] = {
 	  FLD_COUNT, TYP_NONE },
 	{ "hdr", FLDT_ATTR_NODE_HDR, OI(NOFF(hdr)), attr_node_hdr_count,
 	  FLD_COUNT, TYP_NONE },
+	{ "data", FLDT_CHARNS, OI(0), attr_remote_count, FLD_COUNT, TYP_NONE },
 	{ "entries", FLDT_ATTR_LEAF_ENTRY, OI(LOFF(entries)),
 	  attr_leaf_entries_count, FLD_ARRAY|FLD_COUNT, TYP_NONE },
 	{ "btree", FLDT_ATTR_NODE_ENTRY, OI(NOFF(__btree)), attr_node_btree_count,
@@ -197,6 +201,33 @@ attr3_leaf_hdr_count(
 	return be16_to_cpu(leaf->hdr.info.hdr.magic) == XFS_ATTR3_LEAF_MAGIC;
 }
 
+static int
+attr_remote_count(
+	void		*obj,
+	int		startoff)
+{
+	if (attr_leaf_hdr_count(obj, startoff) == 0 &&
+	    attr_node_hdr_count(obj, startoff) == 0)
+		return mp->m_sb.sb_blocksize;
+	return 0;
+}
+
+static int
+attr3_remote_count(
+	void		*obj,
+	int		startoff)
+{
+	struct xfs_attr3_rmt_hdr	*hdr = obj;
+
+	ASSERT(startoff == 0);
+
+	if (hdr->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
+		return 0;
+	if (be32_to_cpu(hdr->rm_bytes) + sizeof(*hdr) > mp->m_sb.sb_blocksize)
+		return mp->m_sb.sb_blocksize - sizeof(*hdr);
+	return be32_to_cpu(hdr->rm_bytes);
+}
+
 typedef int (*attr_leaf_entry_walk_f)(struct xfs_attr_leafblock *,
 				      struct xfs_attr_leaf_entry *, int);
 static int
@@ -477,6 +508,17 @@ attr3_node_hdr_count(
 	return be16_to_cpu(node->hdr.info.hdr.magic) == XFS_DA3_NODE_MAGIC;
 }
 
+static int
+attr3_remote_hdr_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_attr3_rmt_hdr	*node = obj;
+
+	ASSERT(startoff == 0);
+	return be32_to_cpu(node->rm_magic) == XFS_ATTR3_RMT_MAGIC;
+}
+
 int
 attr_size(
 	void	*obj,
@@ -501,6 +543,8 @@ const field_t	attr3_flds[] = {
 	  FLD_COUNT, TYP_NONE },
 	{ "hdr", FLDT_DA3_NODE_HDR, OI(N3OFF(hdr)), attr3_node_hdr_count,
 	  FLD_COUNT, TYP_NONE },
+	{ "hdr", FLDT_ATTR3_REMOTE_HDR, OI(0), attr3_remote_hdr_count,
+	  FLD_COUNT, TYP_NONE },
 	{ "entries", FLDT_ATTR_LEAF_ENTRY, OI(L3OFF(entries)),
 	  attr3_leaf_entries_count, FLD_ARRAY|FLD_COUNT, TYP_NONE },
 	{ "btree", FLDT_ATTR_NODE_ENTRY, OI(N3OFF(__btree)),
@@ -523,6 +567,21 @@ const field_t	attr3_leaf_hdr_flds[] = {
 	{ NULL }
 };
 
+#define	RM3OFF(f)	bitize(offsetof(struct xfs_attr3_rmt_hdr, rm_ ## f))
+const struct field	attr3_remote_crc_flds[] = {
+	{ "magic", FLDT_UINT32X, OI(RM3OFF(magic)), C1, 0, TYP_NONE },
+	{ "offset", FLDT_UINT32D, OI(RM3OFF(offset)), C1, 0, TYP_NONE },
+	{ "bytes", FLDT_UINT32D, OI(RM3OFF(bytes)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(RM3OFF(crc)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(RM3OFF(uuid)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(RM3OFF(owner)), C1, 0, TYP_NONE },
+	{ "bno", FLDT_DFSBNO, OI(RM3OFF(blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(RM3OFF(lsn)), C1, 0, TYP_NONE },
+	{ "data", FLDT_CHARNS, OI(bitize(sizeof(struct xfs_attr3_rmt_hdr))),
+		attr3_remote_count, FLD_COUNT, TYP_NONE },
+	{ NULL }
+};
+
 /*
  * Special read verifier for attribute buffers. Detect the magic number
  * appropriately and set the correct verifier and call it.
diff --git a/db/attr.h b/db/attr.h
index bc3431f..d7bb579 100644
--- a/db/attr.h
+++ b/db/attr.h
@@ -30,6 +30,7 @@ extern const field_t	attr3_flds[];
 extern const field_t	attr3_hfld[];
 extern const field_t	attr3_leaf_hdr_flds[];
 extern const field_t	attr3_node_hdr_flds[];
+extern const field_t	attr3_remote_crc_flds[];
 
 extern int	attr_leaf_name_size(void *obj, int startoff, int idx);
 extern int	attr_size(void *obj, int startoff, int idx);
diff --git a/db/field.c b/db/field.c
index 1968dd5..e8bbbe3 100644
--- a/db/field.c
+++ b/db/field.c
@@ -97,6 +97,9 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_ATTR3_NODE_HDR, "attr3_node_hdr", NULL,
 	  (char *)da3_node_hdr_flds, SI(bitsz(struct xfs_da3_node_hdr)),
 	  0, NULL, da3_node_hdr_flds },
+	{ FLDT_ATTR3_REMOTE_HDR, "attr3_remote_hdr", NULL,
+	  (char *)attr3_remote_crc_flds, attr_size, FTARG_SIZE, NULL,
+	  attr3_remote_crc_flds },
 
 	{ FLDT_BMAPBTA, "bmapbta", NULL, (char *)bmapbta_flds, btblock_size,
 	  FTARG_SIZE, NULL, bmapbta_flds },
diff --git a/db/field.h b/db/field.h
index 53616f1..e5a943b 100644
--- a/db/field.h
+++ b/db/field.h
@@ -46,6 +46,7 @@ typedef enum fldt	{
 	FLDT_ATTR3,
 	FLDT_ATTR3_LEAF_HDR,
 	FLDT_ATTR3_NODE_HDR,
+	FLDT_ATTR3_REMOTE_HDR,
 
 	FLDT_BMAPBTA,
 	FLDT_BMAPBTA_CRC,


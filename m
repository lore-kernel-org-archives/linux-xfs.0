Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752532AbeDRJtq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Apr 2018 05:49:46 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A8D08818AAE8
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 09:49:45 +0000 (UTC)
Received: from odin.brq.redhat.com (unknown [10.43.17.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 491DB2166BAD
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 09:49:45 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [RFC PATCH] db: Stop core dumping on attr3 if block header is not recognized
Date: Wed, 18 Apr 2018 11:49:35 +0200
Message-Id: <20180418094935.12495-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

this is supposed to fix the issue while trying to print a non attr3
block using attr3 type, which ends up on an ASSERT, and crashing xfs_db.

This is based on Eric's suggestion, which an attempt to print the
possible magic number from the current block.

As Eric mentioned, there are other types which need such handling too,
but, this is supposed to be a RFC to get comments on the approach. Once
we agree how to fix it, I'll fix the remaining types accordingly.

This is the following output of an attempt to print a non attr3 type block,
with this patch:

xfs_db> fsblock 2
xfs_db> type attr3
Unknown attribute buffer type!
Unknown attribute buffer type!
xfs_db> p
Unrecognized attr3 block, possible magic number:
Unrecognized attr3 block, possible magic number:
hdr.magic = 0x41423343

While, printing a correct attr3 block, nothing is changed:

xfs_db> fsblock 11
xfs_db> type attr3
xfs_db> p
hdr.info.hdr.forw = 0
hdr.info.hdr.back = 0
hdr.info.hdr.magic = 0x3ebe
hdr.info.crc = 0x6f7911f7 (correct)
hdr.info.bno = 88
.
.
.

Comments?

Cheers

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 db/attr.c  | 22 ++++++++++++++++++++++
 db/attr.h  |  1 +
 db/field.c |  2 ++
 db/field.h |  1 +
 4 files changed, 26 insertions(+)

diff --git a/db/attr.c b/db/attr.c
index 9cbb20d3..b7692e9e 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -523,6 +523,21 @@ attr3_remote_hdr_count(
 	return be32_to_cpu(node->rm_magic) == XFS_ATTR3_RMT_MAGIC;
 }
 
+static int
+attr3_unkown_hdr_count(
+	void			*obj,
+	int			startoff)
+{
+	if (!attr3_leaf_hdr_count(obj, startoff) &&
+	    !attr3_node_hdr_count(obj, startoff) &&
+	    !attr3_remote_hdr_count(obj,startoff)) {
+		dbprintf(_("Unrecognized attr3 block, possible magic number:\n"));
+		return 1;
+	}
+
+	return 0;
+}
+
 int
 attr_size(
 	void	*obj,
@@ -549,6 +564,8 @@ const field_t	attr3_flds[] = {
 	  FLD_COUNT, TYP_NONE },
 	{ "hdr", FLDT_ATTR3_REMOTE_HDR, OI(0), attr3_remote_hdr_count,
 	  FLD_COUNT, TYP_NONE },
+	{ "hdr", FLDT_ATTR3_UNKOWN_HDR, OI(0), attr3_unkown_hdr_count,
+	  FLD_COUNT, TYP_NONE },
 	{ "data", FLDT_CHARNS, OI(bitize(sizeof(struct xfs_attr3_rmt_hdr))),
 	  attr3_remote_data_count, FLD_COUNT, TYP_NONE },
 	{ "entries", FLDT_ATTR_LEAF_ENTRY, OI(L3OFF(entries)),
@@ -606,6 +623,11 @@ const struct field	attr3_remote_crc_flds[] = {
 	{ NULL }
 };
 
+const struct field	attr3_unkown_flds[] = {
+	{ "magic", FLDT_UINT32X, 0, C1, 0, TYP_NONE},
+	{ NULL }
+};
+
 /* Set the CRC. */
 void
 xfs_attr3_set_crc(
diff --git a/db/attr.h b/db/attr.h
index ba23480c..a8566a8c 100644
--- a/db/attr.h
+++ b/db/attr.h
@@ -33,6 +33,7 @@ extern const field_t	attr3_node_hdr_flds[];
 extern const field_t	attr3_blkinfo_flds[];
 extern const field_t	attr3_node_hdr_flds[];
 extern const field_t	attr3_remote_crc_flds[];
+extern const field_t	attr3_unkown_flds[];
 
 extern int	attr_leaf_name_size(void *obj, int startoff, int idx);
 extern int	attr_size(void *obj, int startoff, int idx);
diff --git a/db/field.c b/db/field.c
index ae4c8057..388bcbe1 100644
--- a/db/field.c
+++ b/db/field.c
@@ -102,6 +102,8 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_ATTR3_REMOTE_HDR, "attr3_remote_hdr", NULL,
 	  (char *)attr3_remote_crc_flds, attr_size, FTARG_SIZE, NULL,
 	  attr3_remote_crc_flds },
+	{ FLDT_ATTR3_UNKOWN_HDR, "attr3_unkown_hdr", NULL,
+	  NULL, NULL, FTARG_SIZE, NULL, attr3_unkown_flds},
 
 	{ FLDT_BMAPBTA, "bmapbta", NULL, (char *)bmapbta_flds, btblock_size,
 	  FTARG_SIZE, NULL, bmapbta_flds },
diff --git a/db/field.h b/db/field.h
index a8df29bc..291ef2e5 100644
--- a/db/field.h
+++ b/db/field.h
@@ -48,6 +48,7 @@ typedef enum fldt	{
 	FLDT_ATTR3_LEAF_HDR,
 	FLDT_ATTR3_NODE_HDR,
 	FLDT_ATTR3_REMOTE_HDR,
+	FLDT_ATTR3_UNKOWN_HDR,
 
 	FLDT_BMAPBTA,
 	FLDT_BMAPBTA_CRC,
-- 
2.14.3


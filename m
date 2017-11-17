Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51987 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdKQT45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 14:56:57 -0500
Subject: [PATCH 2/5] xfs_db: add missing padding fields
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 11:56:53 -0800
Message-ID: <151094861330.27182.13544522894298156345.stgit@magnolia>
In-Reply-To: <151094860143.27182.12022983202520916281.stgit@magnolia>
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Several data structures are missing padding fields from their field
definitions.  Add them so that they will be printed out.

Fix the AGI field order to be consistent with the structure
definition while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/agi.c   |    3 ++-
 db/dir2.c  |    3 +++
 db/inode.c |    2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/db/agi.c b/db/agi.c
index fb69210..29d7ab5 100644
--- a/db/agi.c
+++ b/db/agi.c
@@ -55,8 +55,9 @@ const field_t	agi_flds[] = {
 	{ "unlinked", FLDT_AGINONN, OI(OFF(unlinked)),
 	  CI(XFS_AGI_UNLINKED_BUCKETS), FLD_ARRAY, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
-	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "pad32", FLDT_UINT32X, OI(OFF(pad32)), C1, 0, TYP_NONE },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "free_root", FLDT_AGBLOCK, OI(OFF(free_root)), C1, 0, TYP_FINOBT },
 	{ "free_level", FLDT_UINT32D, OI(OFF(free_level)), C1, 0, TYP_NONE },
 	{ NULL }
diff --git a/db/dir2.c b/db/dir2.c
index bd9c6aa..a866c3f 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -940,6 +940,7 @@ const field_t	dir3_data_hdr_flds[] = {
 	{ "hdr", FLDT_DIR3_BLKHDR, OI(DH3OFF(hdr)), C1, 0, TYP_NONE },
 	{ "bestfree", FLDT_DIR2_DATA_FREE, OI(DH3OFF(best_free)),
 	  CI(XFS_DIR2_DATA_FD_COUNT), FLD_ARRAY, TYP_NONE },
+	{ "pad", FLDT_UINT32X, OI(DH3OFF(pad)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
@@ -948,6 +949,7 @@ const field_t	dir3_leaf_hdr_flds[] = {
 	{ "info", FLDT_DA3_BLKINFO, OI(LH3OFF(info)), C1, 0, TYP_NONE },
 	{ "count", FLDT_UINT16D, OI(LH3OFF(count)), C1, 0, TYP_NONE },
 	{ "stale", FLDT_UINT16D, OI(LH3OFF(stale)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT32X, OI(LH3OFF(pad)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
@@ -957,6 +959,7 @@ const field_t	dir3_free_hdr_flds[] = {
 	{ "firstdb", FLDT_INT32D, OI(FH3OFF(firstdb)), C1, 0, TYP_NONE },
 	{ "nvalid", FLDT_INT32D, OI(FH3OFF(nvalid)), C1, 0, TYP_NONE },
 	{ "nused", FLDT_INT32D, OI(FH3OFF(nused)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT32X, OI(FH3OFF(pad)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/inode.c b/db/inode.c
index 6f971c6..0f5fb10 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -102,6 +102,7 @@ const field_t	inode_core_flds[] = {
 	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
 	{ "projid_hi", FLDT_UINT16D, OI(COFF(projid_hi)),
 	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
+	{ "pad", FLDT_UINT8X, OI(OFF(pad)), CI(6), FLD_ARRAY, TYP_NONE },
 	{ "uid", FLDT_UINT32D, OI(COFF(uid)), C1, 0, TYP_NONE },
 	{ "gid", FLDT_UINT32D, OI(COFF(gid)), C1, 0, TYP_NONE },
 	{ "flushiter", FLDT_UINT16D, OI(COFF(flushiter)), C1, 0, TYP_NONE },
@@ -173,6 +174,7 @@ const field_t	inode_v3_flds[] = {
 	{ "lsn", FLDT_UINT64X, OI(COFF(lsn)), C1, 0, TYP_NONE },
 	{ "flags2", FLDT_UINT64X, OI(COFF(flags2)), C1, 0, TYP_NONE },
 	{ "cowextsize", FLDT_EXTLEN, OI(COFF(cowextsize)), C1, 0, TYP_NONE },
+	{ "pad2", FLDT_UINT8X, OI(OFF(pad2)), CI(12), FLD_ARRAY, TYP_NONE },
 	{ "crtime", FLDT_TIMESTAMP, OI(COFF(crtime)), C1, 0, TYP_NONE },
 	{ "inumber", FLDT_INO, OI(COFF(ino)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(COFF(uuid)), C1, 0, TYP_NONE },


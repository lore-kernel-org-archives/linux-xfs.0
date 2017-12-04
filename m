Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42580 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbdLDXyp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Dec 2017 18:54:45 -0500
Subject: [PATCH 2/5 V2] xfs_db: add missing padding fields
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
 <151094861330.27182.13544522894298156345.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5a7bec9c-999f-983e-2683-e7b55109f713@sandeen.net>
Date: Mon, 4 Dec 2017 17:54:44 -0600
MIME-Version: 1.0
In-Reply-To: <151094861330.27182.13544522894298156345.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Several data structures are missing padding fields from their field
definitions.  Add them so that they can be printed out if explicitly
requested.

Fix the AGI field order to be consistent with the structure
definition while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[sandeen: make them available but not printed by default]
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

v2: make available but not printed by default

diff --git a/db/agi.c b/db/agi.c
index fb69210..fab146e 100644
--- a/db/agi.c
+++ b/db/agi.c
@@ -55,8 +55,9 @@ const field_t	agi_flds[] = {
 	{ "unlinked", FLDT_AGINONN, OI(OFF(unlinked)),
 	  CI(XFS_AGI_UNLINKED_BUCKETS), FLD_ARRAY, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
-	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "pad32", FLDT_UINT32X, OI(OFF(pad32)), C1, FLD_SKIPALL, TYP_NONE },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "free_root", FLDT_AGBLOCK, OI(OFF(free_root)), C1, 0, TYP_FINOBT },
 	{ "free_level", FLDT_UINT32D, OI(OFF(free_level)), C1, 0, TYP_NONE },
 	{ NULL }
diff --git a/db/dir2.c b/db/dir2.c
index 7f7ea5a..0bd3437 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -940,6 +940,7 @@ const field_t	dir3_data_hdr_flds[] = {
 	{ "hdr", FLDT_DIR3_BLKHDR, OI(DH3OFF(hdr)), C1, 0, TYP_NONE },
 	{ "bestfree", FLDT_DIR2_DATA_FREE, OI(DH3OFF(best_free)),
 	  CI(XFS_DIR2_DATA_FD_COUNT), FLD_ARRAY, TYP_NONE },
+	{ "pad", FLDT_UINT32X, OI(DH3OFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
 	{ NULL }
 };
 
@@ -948,6 +949,7 @@ const field_t	dir3_leaf_hdr_flds[] = {
 	{ "info", FLDT_DA3_BLKINFO, OI(LH3OFF(info)), C1, 0, TYP_NONE },
 	{ "count", FLDT_UINT16D, OI(LH3OFF(count)), C1, 0, TYP_NONE },
 	{ "stale", FLDT_UINT16D, OI(LH3OFF(stale)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT32X, OI(LH3OFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
 	{ NULL }
 };
 
@@ -957,6 +959,7 @@ const field_t	dir3_free_hdr_flds[] = {
 	{ "firstdb", FLDT_INT32D, OI(FH3OFF(firstdb)), C1, 0, TYP_NONE },
 	{ "nvalid", FLDT_INT32D, OI(FH3OFF(nvalid)), C1, 0, TYP_NONE },
 	{ "nused", FLDT_INT32D, OI(FH3OFF(nused)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT32X, OI(FH3OFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/inode.c b/db/inode.c
index 6f971c6..b3f53d3 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -102,6 +102,7 @@ const field_t	inode_core_flds[] = {
 	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
 	{ "projid_hi", FLDT_UINT16D, OI(COFF(projid_hi)),
 	  inode_core_projid_count, FLD_COUNT, TYP_NONE },
+	{ "pad", FLDT_UINT8X, OI(OFF(pad)), CI(6), FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
 	{ "uid", FLDT_UINT32D, OI(COFF(uid)), C1, 0, TYP_NONE },
 	{ "gid", FLDT_UINT32D, OI(COFF(gid)), C1, 0, TYP_NONE },
 	{ "flushiter", FLDT_UINT16D, OI(COFF(flushiter)), C1, 0, TYP_NONE },
@@ -173,6 +174,7 @@ const field_t	inode_v3_flds[] = {
 	{ "lsn", FLDT_UINT64X, OI(COFF(lsn)), C1, 0, TYP_NONE },
 	{ "flags2", FLDT_UINT64X, OI(COFF(flags2)), C1, 0, TYP_NONE },
 	{ "cowextsize", FLDT_EXTLEN, OI(COFF(cowextsize)), C1, 0, TYP_NONE },
+	{ "pad2", FLDT_UINT8X, OI(OFF(pad2)), CI(12), FLD_ARRAY|FLD_SKIPALL, TYP_NONE },
 	{ "crtime", FLDT_TIMESTAMP, OI(COFF(crtime)), C1, 0, TYP_NONE },
 	{ "inumber", FLDT_INO, OI(COFF(ino)), C1, 0, TYP_NONE },
 	{ "uuid", FLDT_UUID, OI(COFF(uuid)), C1, 0, TYP_NONE },


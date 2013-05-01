Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C1B337F6D
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 01:30:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AC1A98F8037
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 23:30:35 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	G7mnYFyR8feemmml for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 23:30:33 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UXQYJ-0007uo-0J
	for xfs@oss.sgi.com; Wed, 01 May 2013 16:30:07 +1000
Date: Wed, 1 May 2013 16:30:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/8] xfsdb: re-instate DA btree node headers
Message-ID: <20130501063006.GK10481@dastard>
References: <20130430121300.GB10481@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130430121300.GB10481@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When removing the dirv1 code, it wasn't immediately obvious that the
dir v2 code used a small chunk of the dirv1 field definitions. i.e.
those for the DA btree node headers. Hence bits of xfs_db didn't
work as expected, and some tests failed in non-obvious ways. e.g
test 073 failed with this additional line of output:

Use of uninitialized value $logstart in numeric gt (>) at /home/dave/src/xfstests-dev/src/fill2fs line 84

which was the result of the command:

	xfs_db -r -c sb -c $TEST_DEV

giving an unexpectedly incorrect output.

Re-instate the needed field definitions and rename them from "DIR"
to "DA" so it is obvious they are for decoding DA Btree format
blocks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/dir2.c  |   30 +++++++++++++++++++++++++++---
 db/dir2.h  |    4 ++++
 db/field.c |    7 +++++++
 db/field.h |   15 +++------------
 4 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/db/dir2.c b/db/dir2.c
index a13fa25..a539f2d 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -84,9 +84,9 @@ const field_t	dir2_flds[] = {
 	  FLD_ARRAY|FLD_COUNT, TYP_NONE },
 	{ "ltail", FLDT_DIR2_LEAF_TAIL, dir2_leaf_tail_offset,
 	  dir2_leaf_tail_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
-	{ "nhdr", FLDT_DIR_NODE_HDR, OI(NOFF(hdr)), dir2_node_hdr_count,
+	{ "nhdr", FLDT_DA_NODE_HDR, OI(NOFF(hdr)), dir2_node_hdr_count,
 	  FLD_COUNT, TYP_NONE },
-	{ "nbtree", FLDT_DIR_NODE_ENTRY, OI(NOFF(btree)), dir2_node_btree_count,
+	{ "nbtree", FLDT_DA_NODE_ENTRY, OI(NOFF(btree)), dir2_node_btree_count,
 	  FLD_ARRAY|FLD_COUNT, TYP_NONE },
 	{ "fhdr", FLDT_DIR2_FREE_HDR, OI(FOFF(hdr)), dir2_free_hdr_count,
 	  FLD_COUNT, TYP_NONE },
@@ -144,7 +144,7 @@ const field_t	dir2_leaf_entry_flds[] = {
 
 #define	LHOFF(f)	bitize(offsetof(xfs_dir2_leaf_hdr_t, f))
 const field_t	dir2_leaf_hdr_flds[] = {
-	{ "info", FLDT_DIR_BLKINFO, OI(LHOFF(info)), C1, 0, TYP_NONE },
+	{ "info", FLDT_DA_BLKINFO, OI(LHOFF(info)), C1, 0, TYP_NONE },
 	{ "count", FLDT_UINT16D, OI(LHOFF(count)), C1, 0, TYP_NONE },
 	{ "stale", FLDT_UINT16D, OI(LHOFF(stale)), C1, 0, TYP_NONE },
 	{ NULL }
@@ -165,6 +165,30 @@ const field_t	dir2_free_hdr_flds[] = {
 	{ NULL }
 };
 
+#define	DBOFF(f)	bitize(offsetof(xfs_da_blkinfo_t, f))
+const field_t	da_blkinfo_flds[] = {
+	{ "forw", FLDT_DIRBLOCK, OI(DBOFF(forw)), C1, 0, TYP_INODATA },
+	{ "back", FLDT_DIRBLOCK, OI(DBOFF(back)), C1, 0, TYP_INODATA },
+	{ "magic", FLDT_UINT16X, OI(DBOFF(magic)), C1, 0, TYP_NONE },
+	{ "pad", FLDT_UINT16X, OI(DBOFF(pad)), C1, FLD_SKIPALL, TYP_NONE },
+	{ NULL }
+};
+
+#define	EOFF(f)	bitize(offsetof(xfs_da_node_entry_t, f))
+const field_t	da_node_entry_flds[] = {
+	{ "hashval", FLDT_UINT32X, OI(EOFF(hashval)), C1, 0, TYP_NONE },
+	{ "before", FLDT_DIRBLOCK, OI(EOFF(before)), C1, 0, TYP_INODATA },
+	{ NULL }
+};
+
+#define	HOFF(f)	bitize(offsetof(xfs_da_node_hdr_t, f))
+const field_t	da_node_hdr_flds[] = {
+	{ "info", FLDT_DA_BLKINFO, OI(HOFF(info)), C1, 0, TYP_NONE },
+	{ "count", FLDT_UINT16D, OI(HOFF(count)), C1, 0, TYP_NONE },
+	{ "level", FLDT_UINT16D, OI(HOFF(level)), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
 /*ARGSUSED*/
 static int
 dir2_block_hdr_count(
diff --git a/db/dir2.h b/db/dir2.h
index 5e117ac..a5f0bec 100644
--- a/db/dir2.h
+++ b/db/dir2.h
@@ -27,6 +27,10 @@ extern const field_t	dir2_leaf_entry_flds[];
 extern const field_t	dir2_leaf_hdr_flds[];
 extern const field_t	dir2_leaf_tail_flds[];
 
+extern const field_t	da_blkinfo_flds[];
+extern const field_t	da_node_entry_flds[];
+extern const field_t	da_node_hdr_flds[];
+
 /*
  * generic dir2 structures used by xfs_db
  */
diff --git a/db/field.c b/db/field.c
index 002c5ae..dc72563 100644
--- a/db/field.c
+++ b/db/field.c
@@ -195,6 +195,13 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(xfs_dir2_sf_off_t)), 0, NULL, NULL },
 	{ FLDT_DIR2SF, "dir2sf", NULL, (char *)dir2sf_flds, dir2sf_size,
 	  FTARG_SIZE, NULL, dir2sf_flds },
+	{ FLDT_DA_BLKINFO, "dir_blkinfo", NULL, (char *)da_blkinfo_flds,
+	  SI(bitsz(struct xfs_da_blkinfo)), 0, NULL, da_blkinfo_flds },
+	{ FLDT_DA_NODE_ENTRY, "dir_node_entry", fp_sarray,
+	  (char *)da_node_entry_flds, SI(bitsz(struct xfs_da_node_entry)), 0,
+	  NULL, da_node_entry_flds },
+	{ FLDT_DA_NODE_HDR, "dir_node_hdr", NULL, (char *)da_node_hdr_flds,
+	  SI(bitsz(struct xfs_da_node_hdr)), 0, NULL, da_node_hdr_flds },
 	{ FLDT_DIRBLOCK, "dirblock", fp_num, "%u", SI(bitsz(__uint32_t)), 0,
 	  fa_dirblock, NULL },
 	{ FLDT_DISK_DQUOT, "disk_dquot", NULL, (char *)disk_dquot_flds,
diff --git a/db/field.h b/db/field.h
index 6962d69..72c225b 100644
--- a/db/field.h
+++ b/db/field.h
@@ -75,7 +75,6 @@ typedef enum fldt	{
 	FLDT_DINODE_CORE,
 	FLDT_DINODE_FMT,
 	FLDT_DINODE_U,
-	FLDT_DIR,
 	FLDT_DIR2,
 	FLDT_DIR2_BLOCK_TAIL,
 	FLDT_DIR2_DATA_FREE,
@@ -94,18 +93,10 @@ typedef enum fldt	{
 	FLDT_DIR2_SF_HDR,
 	FLDT_DIR2_SF_OFF,
 	FLDT_DIR2SF,
-	FLDT_DIR_BLKINFO,
-	FLDT_DIR_INO,
-	FLDT_DIR_LEAF_ENTRY,
-	FLDT_DIR_LEAF_HDR,
-	FLDT_DIR_LEAF_MAP,
-	FLDT_DIR_LEAF_NAME,
-	FLDT_DIR_NODE_ENTRY,
-	FLDT_DIR_NODE_HDR,
-	FLDT_DIR_SF_ENTRY,
-	FLDT_DIR_SF_HDR,
+	FLDT_DA_BLKINFO,
+	FLDT_DA_NODE_ENTRY,
+	FLDT_DA_NODE_HDR,
 	FLDT_DIRBLOCK,
-	FLDT_DIRSHORT,
 	FLDT_DISK_DQUOT,
 	FLDT_DQBLK,
 	FLDT_DQID,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

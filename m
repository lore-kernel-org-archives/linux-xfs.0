Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0AF367CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 17:35:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8D87304051
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 15:35:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	epXIs3Hf1htx6m3V for <xfs@oss.sgi.com>;
	Thu, 12 May 2016 15:35:26 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1b0zCW-0006Db-5z
	for xfs@oss.sgi.com; Fri, 13 May 2016 08:35:24 +1000
Received: from dave by disappointment with local (Exim 4.87)
	(envelope-from <dave@disappointment.disaster>) id 1b0zCL-0001Qn-PH
	for xfs@oss.sgi.com; Fri, 13 May 2016 08:35:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_db: allow recalculating CRCs on invalid metadata
Date: Fri, 13 May 2016 08:35:13 +1000
Message-Id: <1463092513-5462-1-git-send-email-david@fromorbit.com>
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

Currently we can't write corrupt structures with valid CRCs on v5
filesystems via xfs_db. TO emulate certain types of corruption
result from software bugs in the kernel code, we need this
capability to set up the corrupted state. i.e. corrupt state with a
valid CRC needs to appear on disk.

This requires us to avoid running the verifier that would otherwise
prevent writing corrupt state to disk. To enable this, add the CRC
offset to the type table for different buffers and add a new flag to
the write command to trigger running a CRC calculation base don this
type table. We can then insert the calculated value into the correct
location in the buffer...

Because some objects are not directly buffer based, we can't easily
do this CRC trick. Those object types will be marked as
TYP_NO_CRC_OFF, and as a result will emit an error such as:

# xfs_db -x -c "inode 96" -c "write -d magic 0x4949" /dev/ram0
Cannot recalculate CRCs on this type of object
#

All v4 superblock types are configured this way, as are inode,
dquots and other v5 metadata types that either don't have CRCs or
don't have a fixed offset into a buffer to store their CRC.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/io.c    |   7 ++++
 db/io.h    |   1 +
 db/type.c  | 137 +++++++++++++++++++++++++++++++++----------------------------
 db/type.h  |   2 +
 db/write.c |  52 +++++++++++++++++------
 5 files changed, 124 insertions(+), 75 deletions(-)

diff --git a/db/io.c b/db/io.c
index 9452e07..91cab12 100644
--- a/db/io.c
+++ b/db/io.c
@@ -464,6 +464,13 @@ xfs_dummy_verify(
 }
 
 void
+xfs_verify_recalc_crc(
+	struct xfs_buf *bp)
+{
+	xfs_buf_update_cksum(bp, iocur_top->typ->crc_off);
+}
+
+void
 write_cur(void)
 {
 	if (iocur_sp < 0) {
diff --git a/db/io.h b/db/io.h
index 6201d7b..c69e9ce 100644
--- a/db/io.h
+++ b/db/io.h
@@ -64,6 +64,7 @@ extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
 extern void     ring_add(void);
 extern void	set_iocur_type(const struct typ *t);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
+extern void	xfs_verify_recalc_crc(struct xfs_buf *bp);
 
 /*
  * returns -1 for unchecked, 0 for bad and 1 for good
diff --git a/db/type.c b/db/type.c
index 1da7ee1..d061bc1 100644
--- a/db/type.c
+++ b/db/type.c
@@ -50,99 +50,110 @@ static const cmdinfo_t	type_cmd =
 	  N_("set/show current data type"), NULL };
 
 static const typ_t	__typtab[] = {
-	{ TYP_AGF, "agf", handle_struct, agf_hfld, NULL },
-	{ TYP_AGFL, "agfl", handle_struct, agfl_hfld, NULL },
-	{ TYP_AGI, "agi", handle_struct, agi_hfld, NULL },
-	{ TYP_ATTR, "attr", handle_struct, attr_hfld, NULL },
-	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_hfld, NULL },
-	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_hfld, NULL },
-	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_hfld, NULL },
-	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_hfld, NULL },
-	{ TYP_DATA, "data", handle_block, NULL, NULL },
-	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld, NULL },
-	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld, NULL },
-	{ TYP_INOBT, "inobt", handle_struct, inobt_hfld, NULL },
-	{ TYP_INODATA, "inodata", NULL, NULL, NULL },
-	{ TYP_INODE, "inode", handle_struct, inode_hfld, NULL },
-	{ TYP_LOG, "log", NULL, NULL, NULL },
-	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL },
-	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL },
-	{ TYP_SB, "sb", handle_struct, sb_hfld, NULL },
-	{ TYP_SYMLINK, "symlink", handle_string, NULL, NULL },
-	{ TYP_TEXT, "text", handle_text, NULL, NULL },
-	{ TYP_FINOBT, "finobt", handle_struct, inobt_hfld, NULL },
+	{ TYP_AGF, "agf", handle_struct, agf_hfld, NULL, TYP_NO_CRC_OFF },
+	{ TYP_AGFL, "agfl", handle_struct, agfl_hfld, NULL, TYP_NO_CRC_OFF },
+	{ TYP_AGI, "agi", handle_struct, agi_hfld, NULL, TYP_NO_CRC_OFF },
+	{ TYP_ATTR, "attr", handle_struct, attr_hfld, NULL, TYP_NO_CRC_OFF },
+	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_hfld, NULL,
+		TYP_NO_CRC_OFF },
+	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_hfld, NULL,
+		TYP_NO_CRC_OFF },
+	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_hfld, NULL, TYP_NO_CRC_OFF },
+	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_hfld, NULL, TYP_NO_CRC_OFF },
+	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_DIR2, "dir2", handle_struct, dir2_hfld, NULL, TYP_NO_CRC_OFF },
+	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld, NULL, TYP_NO_CRC_OFF },
+	{ TYP_INOBT, "inobt", handle_struct, inobt_hfld, NULL, TYP_NO_CRC_OFF },
+	{ TYP_INODATA, "inodata", NULL, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_INODE, "inode", handle_struct, inode_hfld, NULL, TYP_NO_CRC_OFF },
+	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_SB, "sb", handle_struct, sb_hfld, NULL, TYP_NO_CRC_OFF },
+	{ TYP_SYMLINK, "symlink", handle_string, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_FINOBT, "finobt", handle_struct, inobt_hfld, NULL,
+		TYP_NO_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
 static const typ_t	__typtab_crc[] = {
-	{ TYP_AGF, "agf", handle_struct, agf_hfld, &xfs_agf_buf_ops },
-	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld, &xfs_agfl_buf_ops },
-	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agi_buf_ops },
+	{ TYP_AGF, "agf", handle_struct, agf_hfld, &xfs_agf_buf_ops,
+		XFS_AGF_CRC_OFF },
+	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld, &xfs_agfl_buf_ops,
+		XFS_AGFL_CRC_OFF },
+	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agi_buf_ops,
+		XFS_AGI_CRC_OFF },
 	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld,
-		&xfs_attr3_db_buf_ops },
+		&xfs_attr3_db_buf_ops, TYP_NO_CRC_OFF },
 	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld,
-		&xfs_bmbt_buf_ops },
+		&xfs_bmbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_crc_hfld,
-		&xfs_bmbt_buf_ops },
+		&xfs_bmbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_crc_hfld,
-		&xfs_allocbt_buf_ops },
+		&xfs_allocbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_crc_hfld,
-		&xfs_allocbt_buf_ops },
-	{ TYP_DATA, "data", handle_block, NULL, NULL },
+		&xfs_allocbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_NO_CRC_OFF },
 	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
-		&xfs_dir3_db_buf_ops },
+		&xfs_dir3_db_buf_ops, TYP_NO_CRC_OFF },
 	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld,
-		&xfs_dquot_buf_ops },
+		&xfs_dquot_buf_ops, TYP_NO_CRC_OFF },
 	{ TYP_INOBT, "inobt", handle_struct, inobt_crc_hfld,
-		&xfs_inobt_buf_ops },
-	{ TYP_INODATA, "inodata", NULL, NULL, NULL },
+		&xfs_inobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_INODATA, "inodata", NULL, NULL, NULL, TYP_NO_CRC_OFF },
 	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
-		&xfs_inode_buf_ops },
-	{ TYP_LOG, "log", NULL, NULL, NULL },
-	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL },
-	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL },
-	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops },
+		&xfs_inode_buf_ops, TYP_NO_CRC_OFF },
+	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
+		XFS_SB_CRC_OFF },
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
-		&xfs_symlink_buf_ops },
-	{ TYP_TEXT, "text", handle_text, NULL, NULL },
+		&xfs_symlink_buf_ops, XFS_SYMLINK_CRC_OFF },
+	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_NO_CRC_OFF },
 	{ TYP_FINOBT, "finobt", handle_struct, inobt_crc_hfld,
-		&xfs_inobt_buf_ops },
+		&xfs_inobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
 static const typ_t	__typtab_spcrc[] = {
-	{ TYP_AGF, "agf", handle_struct, agf_hfld, &xfs_agf_buf_ops },
-	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld, &xfs_agfl_buf_ops },
-	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agi_buf_ops },
+	{ TYP_AGF, "agf", handle_struct, agf_hfld, &xfs_agf_buf_ops,
+		XFS_AGF_CRC_OFF },
+	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld, &xfs_agfl_buf_ops ,
+		XFS_AGFL_CRC_OFF },
+	{ TYP_AGI, "agi", handle_struct, agi_hfld, &xfs_agi_buf_ops ,
+		XFS_AGI_CRC_OFF },
 	{ TYP_ATTR, "attr3", handle_struct, attr3_hfld,
-		&xfs_attr3_db_buf_ops },
+		&xfs_attr3_db_buf_ops, TYP_NO_CRC_OFF },
 	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld,
-		&xfs_bmbt_buf_ops },
+		&xfs_bmbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_crc_hfld,
-		&xfs_bmbt_buf_ops },
+		&xfs_bmbt_buf_ops, XFS_BTREE_LBLOCK_CRC_OFF },
 	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_crc_hfld,
-		&xfs_allocbt_buf_ops },
+		&xfs_allocbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_crc_hfld,
-		&xfs_allocbt_buf_ops },
-	{ TYP_DATA, "data", handle_block, NULL, NULL },
+		&xfs_allocbt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_DATA, "data", handle_block, NULL, NULL, TYP_NO_CRC_OFF },
 	{ TYP_DIR2, "dir3", handle_struct, dir3_hfld,
-		&xfs_dir3_db_buf_ops },
+		&xfs_dir3_db_buf_ops, TYP_NO_CRC_OFF },
 	{ TYP_DQBLK, "dqblk", handle_struct, dqblk_hfld,
-		&xfs_dquot_buf_ops },
+		&xfs_dquot_buf_ops, TYP_NO_CRC_OFF },
 	{ TYP_INOBT, "inobt", handle_struct, inobt_spcrc_hfld,
-		&xfs_inobt_buf_ops },
-	{ TYP_INODATA, "inodata", NULL, NULL, NULL },
+		&xfs_inobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
+	{ TYP_INODATA, "inodata", NULL, NULL, NULL, TYP_NO_CRC_OFF },
 	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
-		&xfs_inode_buf_ops },
-	{ TYP_LOG, "log", NULL, NULL, NULL },
-	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL },
-	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL },
-	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops },
+		&xfs_inode_buf_ops, TYP_NO_CRC_OFF },
+	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_RTBITMAP, "rtbitmap", NULL, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_RTSUMMARY, "rtsummary", NULL, NULL, NULL, TYP_NO_CRC_OFF },
+	{ TYP_SB, "sb", handle_struct, sb_hfld, &xfs_sb_buf_ops,
+		XFS_SB_CRC_OFF },
 	{ TYP_SYMLINK, "symlink", handle_struct, symlink_crc_hfld,
-		&xfs_symlink_buf_ops },
-	{ TYP_TEXT, "text", handle_text, NULL, NULL },
+		&xfs_symlink_buf_ops, XFS_SYMLINK_CRC_OFF },
+	{ TYP_TEXT, "text", handle_text, NULL, NULL, TYP_NO_CRC_OFF },
 	{ TYP_FINOBT, "finobt", handle_struct, inobt_crc_hfld,
-		&xfs_inobt_buf_ops },
+		&xfs_inobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
diff --git a/db/type.h b/db/type.h
index d9583e5..e954a68 100644
--- a/db/type.h
+++ b/db/type.h
@@ -43,6 +43,8 @@ typedef struct typ
 	pfunc_t			pfunc;
 	const struct field	*fields;
 	const struct xfs_buf_ops *bops;
+	unsigned long		crc_off;
+#define TYP_NO_CRC_OFF	(-1UL)
 } typ_t;
 extern const typ_t	*typtab, *cur_typ;
 
diff --git a/db/write.c b/db/write.c
index 9f5b423..a922e16 100644
--- a/db/write.c
+++ b/db/write.c
@@ -79,7 +79,10 @@ write_help(void)
 "  String mode: 'write \"This_is_a_filename\" - write null terminated string.\n"
 "\n"
 " In data mode type 'write' by itself for a list of specific commands.\n\n"
-" Specifying the -c option will allow writes of invalid (corrupt) data.\n\n"
+" Specifying the -c option will allow writes of invalid (corrupt) data with\n"
+" an invalid CRC. Specifying the -d option will allow writes of invalid data,\n"
+" but still recalculate the CRC so we are forced to check and detect the\n"
+" invalid data appropriately.\n\n"
 ));
 
 }
@@ -92,7 +95,8 @@ write_f(
 	pfunc_t	pf;
 	extern char *progname;
 	int c;
-	int corrupt = 0;		/* Allow write of corrupt data; skip verification */
+	bool corrupt = false;	/* Allow write of bad data w/ invalid CRC */
+	bool invalid_data = false; /* Allow write of bad data w/ valid CRC */
 	struct xfs_buf_ops nowrite_ops;
 	const struct xfs_buf_ops *stashed_ops = NULL;
 
@@ -114,10 +118,13 @@ write_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "c")) != EOF) {
+	while ((c = getopt(argc, argv, "cd")) != EOF) {
 		switch (c) {
 		case 'c':
-			corrupt = 1;
+			corrupt = true;
+			break;
+		case 'd':
+			invalid_data = true;
 			break;
 		default:
 			dbprintf(_("bad option for write command\n"));
@@ -125,22 +132,43 @@ write_f(
 		}
 	}
 
+	if (corrupt && invalid_data) {
+		dbprintf(_("Cannot specify both -c and -d options\n"));
+		return 0;
+	}
+
+	if (invalid_data && iocur_top->typ->crc_off == TYP_NO_CRC_OFF) {
+		dbprintf(_("Cannot recalculate CRCs on this type of object\n"));
+		return 0;
+	}
+
 	argc -= optind;
 	argv += optind;
 
-	if (iocur_top->bp->b_ops && corrupt) {
-		/* Temporarily remove write verifier to write bad data */
-		stashed_ops = iocur_top->bp->b_ops;
-		nowrite_ops.verify_read = stashed_ops->verify_read;
+	/* If we don't have to juggle verifiers, then just issue the write */
+	if (!iocur_top->bp->b_ops ||
+	    !(corrupt || invalid_data)) {
+		(*pf)(DB_WRITE, cur_typ->fields, argc, argv);
+		return 0;
+	}
+
+
+	/* Temporarily remove write verifier to write bad data */
+	stashed_ops = iocur_top->bp->b_ops;
+	nowrite_ops.verify_read = stashed_ops->verify_read;
+	iocur_top->bp->b_ops = &nowrite_ops;
+
+	if (corrupt) {
 		nowrite_ops.verify_write = xfs_dummy_verify;
-		iocur_top->bp->b_ops = &nowrite_ops;
-		dbprintf(_("Allowing write of corrupted data\n"));
+		dbprintf(_("Allowing write of corrupted data and bad CRC\n"));
+	} else {
+		nowrite_ops.verify_write = xfs_verify_recalc_crc;
+		dbprintf(_("Allowing write of corrupted data with good CRC\n"));
 	}
 
 	(*pf)(DB_WRITE, cur_typ->fields, argc, argv);
 
-	if (stashed_ops)
-		iocur_top->bp->b_ops = stashed_ops;
+	iocur_top->bp->b_ops = stashed_ops;
 
 	return 0;
 }
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

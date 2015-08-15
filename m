Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E1A9A7F37
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:44:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C38AB304043
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:44:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id pX9uaqyNVxNDB4iK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:44:07 -0700 (PDT)
Subject: [PATCH 04/10] xfs_repair: fix broken EFSBADCRC/EFSCORRUPTED usage
	with buffer errors
From: "Darrick J. Wong" <djwong@alder.djwong.org>
Date: Fri, 14 Aug 2015 18:44:04 -0700
Message-ID: <20150815014404.1839.75324.stgit@birch.djwong.org>
In-Reply-To: <20150815014338.1839.37405.stgit@birch.djwong.org>
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

When we encounter CRC or verifier errors, bp->b_error is set to
-EFSBADCRC and -EFSCORRUPTED; note the negative sign.  For whatever
reason, repair and db use the positive versions, and therefore fail to
notice the error, so fix all the broken uses.

Note however that the db and repair turn the negative codes returned
by libxfs into positive codes that can be used with strerror.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attr.c     |    4 ++--
 db/dir2.c     |    4 ++--
 db/io.c       |    4 ++--
 db/io.h       |    2 +-
 repair/dir2.c |    2 +-
 repair/scan.c |   12 ++++++------
 6 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/db/attr.c b/db/attr.c
index 897834b..5e69100 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -554,7 +554,7 @@ xfs_attr3_db_read_verify(
 		break;
 	default:
 		dbprintf(_("Unknown attribute buffer type!\n"));
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 		return;
 	}
 verify:
@@ -566,7 +566,7 @@ xfs_attr3_db_write_verify(
 	struct xfs_buf		*bp)
 {
 	dbprintf(_("Writing unknown attribute buffer type!\n"));
-	xfs_buf_ioerror(bp, EFSCORRUPTED);
+	xfs_buf_ioerror(bp, -EFSCORRUPTED);
 }
 
 const struct xfs_buf_ops xfs_attr3_db_buf_ops = {
diff --git a/db/dir2.c b/db/dir2.c
index 7f69e6f..cc76662 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -1021,7 +1021,7 @@ xfs_dir3_db_read_verify(
 		break;
 	default:
 		dbprintf(_("Unknown directory buffer type!\n"));
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		xfs_buf_ioerror(bp, -EFSCORRUPTED);
 		return;
 	}
 verify:
@@ -1033,7 +1033,7 @@ xfs_dir3_db_write_verify(
 	struct xfs_buf		*bp)
 {
 	dbprintf(_("Writing unknown directory buffer type!\n"));
-	xfs_buf_ioerror(bp, EFSCORRUPTED);
+	xfs_buf_ioerror(bp, -EFSCORRUPTED);
 }
 
 const struct xfs_buf_ops xfs_dir3_db_buf_ops = {
diff --git a/db/io.c b/db/io.c
index 9fa52b8..9452e07 100644
--- a/db/io.c
+++ b/db/io.c
@@ -535,8 +535,8 @@ set_cur(
 	 * Keep the buffer even if the verifier says it is corrupted.
 	 * We're a diagnostic tool, after all.
 	 */
-	if (!bp || (bp->b_error && bp->b_error != EFSCORRUPTED &&
-				   bp->b_error != EFSBADCRC))
+	if (!bp || (bp->b_error && bp->b_error != -EFSCORRUPTED &&
+				   bp->b_error != -EFSBADCRC))
 		return;
 	iocur_top->buf = bp->b_addr;
 	iocur_top->bp = bp;
diff --git a/db/io.h b/db/io.h
index 31d96b4..6201d7b 100644
--- a/db/io.h
+++ b/db/io.h
@@ -75,6 +75,6 @@ iocur_crc_valid()
 		return -1;
 	if (iocur_top->bp->b_flags & LIBXFS_B_UNCHECKED)
 		return -1;
-	return (iocur_top->bp->b_error != EFSBADCRC &&
+	return (iocur_top->bp->b_error != -EFSBADCRC &&
 		(!iocur_top->ino_buf || iocur_top->ino_crc_ok));
 }
diff --git a/repair/dir2.c b/repair/dir2.c
index 187e069..a5646f8 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -199,7 +199,7 @@ _("bad dir magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
 			goto error_out;
 		}
 		/* corrupt node; rebuild the dir. */
-		if (bp->b_error == EFSBADCRC || bp->b_error == EFSCORRUPTED) {
+		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
 			do_warn(
 _("corrupt tree block %u for directory inode %" PRIu64 "\n"),
 				bno, da_cursor->ino);
diff --git a/repair/scan.c b/repair/scan.c
index 58f45eb..1e7a4da 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -82,7 +82,7 @@ scan_sbtree(
 		do_error(_("can't read btree block %d/%d\n"), agno, root);
 		return;
 	}
-	if (bp->b_error == EFSBADCRC || bp->b_error == EFSCORRUPTED) {
+	if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
 		do_warn(_("btree block %d/%d is suspect, error %d\n"),
 			agno, root, bp->b_error);
 		suspect = 1;
@@ -145,7 +145,7 @@ scan_lbtree(
 	 * is a corruption or not and whether it got corrected and so needs
 	 * writing back. CRC errors always imply we need to write the block.
 	 */
-	if (bp->b_error == EFSBADCRC) {
+	if (bp->b_error == -EFSBADCRC) {
 		do_warn(_("btree block %d/%d is suspect, error %d\n"),
 			XFS_FSB_TO_AGNO(mp, root),
 			XFS_FSB_TO_AGBNO(mp, root), bp->b_error);
@@ -1432,7 +1432,7 @@ scan_freelist(
 		do_abort(_("can't read agfl block for ag %d\n"), agno);
 		return;
 	}
-	if (agflbuf->b_error == EFSBADCRC)
+	if (agflbuf->b_error == -EFSBADCRC)
 		do_warn(_("agfl has bad CRC for ag %d\n"), agno);
 
 	freelist = XFS_BUF_TO_AGFL_BNO(mp, agflbuf);
@@ -1705,9 +1705,9 @@ scan_ag(
 	 * immediately, though.
 	 */
 	if (!no_modify) {
-		agi_dirty += (agibuf->b_error == EFSBADCRC);
-		agf_dirty += (agfbuf->b_error == EFSBADCRC);
-		sb_dirty += (sbbuf->b_error == EFSBADCRC);
+		agi_dirty += (agibuf->b_error == -EFSBADCRC);
+		agf_dirty += (agfbuf->b_error == -EFSBADCRC);
+		sb_dirty += (sbbuf->b_error == -EFSBADCRC);
 	}
 
 	if (agi_dirty && !no_modify)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

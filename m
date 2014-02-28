Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B84F87F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 20:51:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A723F304070
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 18:51:45 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nN50kLgUFM9sdpxQ for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 18:51:43 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WJDY2-0001wS-Vb
	for xfs@oss.sgi.com; Fri, 28 Feb 2014 13:51:39 +1100
Date: Fri, 28 Feb 2014 13:51:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH, V2] metadump: don't verify metadata being dumped
Message-ID: <20140228025138.GJ30131@dastard>
References: <1393548825-16499-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393548825-16499-1-git-send-email-david@fromorbit.com>
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

metadump: don't verify metadata being dumped

From: Dave Chinner <dchinner@redhat.com>

The discontiguous buffer support series added a verifier check on
the metadata buffers before they go written to the metadump image.
If this failed, it returned an error, and the restul woul dbe that
we stopped processing the metadata and exited, resulting in a
truncated dump.

xfs_metadump is supposed to dump the metadata in the filesystem for
forensic analysis purposes, which means we actually want it to
retain any corruptions it finds in the filesystem. Hence running the
verifier - even to recalculate CRCs - when the metadata is
unmodified is the wrong thing to be doing. And stopping the dump
when we come across an error is even worse.

We still need to do CRC recalculation when obfuscating names and
attributes. Hence we need to make running the verifier conditional
on the buffer or inode:
	a) being uncorrupted when read, and
	b) modified by the obfuscation code.

If either of these conditions is not true, then we don't run the
verifier or recalculate the CRCs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
V2: run verifiers on buffers and inodes modified by obfuscation, but
only if they are not corrupt before obfuscation. Thanks, Eric!

 db/io.h       |  1 +
 db/metadump.c | 57 ++++++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/db/io.h b/db/io.h
index 4f24c83..d8cf383 100644
--- a/db/io.h
+++ b/db/io.h
@@ -41,6 +41,7 @@ typedef struct iocur {
 	int			ino_crc_ok:1;
 	int			ino_buf:1;
 	int			dquot_buf:1;
+	int			need_crc:1;
 } iocur_t;
 
 #define DB_RING_ADD 1                   /* add to ring on set_cur */
diff --git a/db/metadump.c b/db/metadump.c
index 5baf83d..c829726 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -190,26 +190,36 @@ write_buf_segment(
 	return 0;
 }
 
+/*
+ * we want to preserve the state of the metadata in the dump - whether it is
+ * intact or corrupt, so even if the buffer has a verifier attached to it we
+ * don't want to run it prior to writing the buffer to the metadump image.
+ *
+ * The only reason for running the verifier is to recalculate the CRCs on a
+ * buffer that has been obfuscated. i.e. a buffer than metadump modified itself.
+ * In this case, we only run the verifier if the buffer was not corrupt to begin
+ * with so that we don't accidentally correct buffers with CRC or errors in them
+ * when we are obfuscating them.
+ */
 static int
 write_buf(
 	iocur_t		*buf)
 {
+	struct xfs_buf	*bp = buf->bp;
 	int		i;
 	int		ret;
 
 	/*
 	 * Run the write verifier to recalculate the buffer CRCs and check
-	 * we are writing something valid to disk
+	 * metadump didn't introduce a new corruption. Warn if the verifier
+	 * failed, but still continue to dump it into the output file.
 	 */
-	if (buf->bp && buf->bp->b_ops) {
-		buf->bp->b_error = 0;
-		buf->bp->b_ops->verify_write(buf->bp);
-		if (buf->bp->b_error) {
-			fprintf(stderr,
-	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
-				__func__, (long long)buf->bp->b_bn,
-				buf->bp->b_bcount);
-			return -buf->bp->b_error;
+	if (buf->need_crc && bp && bp->b_ops && !bp->b_error) {
+		bp->b_ops->verify_write(bp);
+		if (bp->b_error) {
+			print_warning(
+				"obfuscation corrupted block at bno 0x%llx/0x%x",
+				(long long)bp->b_bn, bp->b_bcount);
 		}
 	}
 
@@ -1374,6 +1384,7 @@ process_single_fsb_objects(
 		o++;
 		dp += mp->m_sb.sb_blocksize;
 	}
+	iocur_top->need_crc = 1;
 	ret = write_buf(iocur_top);
 
 out_pop:
@@ -1442,6 +1453,7 @@ process_multi_fsb_objects(
 
 			obfuscate_dir_data_block(iocur_top->data, o,
 						  last == mp->m_dirblkfsbs);
+			iocur_top->need_crc = 1;
 			ret = write_buf(iocur_top);
 out_pop:
 			pop_cur();
@@ -1722,6 +1734,13 @@ process_inode_data(
 	return 1;
 }
 
+/*
+ * when we process the inode, we may change the data in the data and/or
+ * attribute fork if they are in short form and we are obfuscating names.
+ * In this case we need to recalculate the CRC of the inode, but we should
+ * only do that if the CRC in the inode is good to begin with. If the crc
+ * is not ok, we just leave it alone.
+ */
 static int
 process_inode(
 	xfs_agnumber_t		agno,
@@ -1729,17 +1748,28 @@ process_inode(
 	xfs_dinode_t 		*dip)
 {
 	int			success;
+	bool			crc_ok = false; /* don't recalc by default */
+	bool			need_crc = false;
 
 	success = 1;
 	cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
 
+	/* we only care about crc recalculation if we are obfuscating names. */
+	if (!dont_obfuscate)
+		crc_ok = xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
+					  offsetof(struct xfs_dinode, di_crc));
+
 	/* copy appropriate data fork metadata */
 	switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
 		case S_IFDIR:
 			success = process_inode_data(dip, TYP_DIR2);
+			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
+				need_crc = 1;
 			break;
 		case S_IFLNK:
 			success = process_inode_data(dip, TYP_SYMLINK);
+			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
+				need_crc = 1;
 			break;
 		case S_IFREG:
 			success = process_inode_data(dip, TYP_DATA);
@@ -1754,6 +1784,7 @@ process_inode(
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
+				need_crc = 1;
 				if (!dont_obfuscate)
 					obfuscate_sf_attr(dip);
 				break;
@@ -1768,6 +1799,9 @@ process_inode(
 		}
 		nametable_clear();
 	}
+
+	if (crc_ok && need_crc)
+		xfs_dinode_calc_crc(mp, dip);
 	return success;
 }
 
@@ -1838,9 +1872,6 @@ copy_inode_chunk(
 
 		if (!process_inode(agno, agino + i, dip))
 			goto pop_out;
-
-		/* calculate the new CRC for the inode */
-		xfs_dinode_calc_crc(mp, dip);
 	}
 skip_processing:
 	if (write_buf(iocur_top))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 260F67F53
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 03:25:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B371304067
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 01:25:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jZcbSR2RhFYKgEDD for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 01:25:13 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WZyfv-0003WU-BG
	for xfs@oss.sgi.com; Tue, 15 Apr 2014 18:25:03 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WZyfv-0008QO-A9
	for xfs@oss.sgi.com; Tue, 15 Apr 2014 18:25:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 9/9] repair: detect and handle attribute tree CRC errors
Date: Tue, 15 Apr 2014 18:25:01 +1000
Message-Id: <1397550301-31883-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1397550301-31883-1-git-send-email-david@fromorbit.com>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
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

Currently the attribute code will not detect and correct errors in
the attribute tree. It also fails to validate the CRCs and headers
on remote attribute blocks. Ensure that all the attribute blocks are
CRC checked and that the processing functions understand the correct
block formats for decoding.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/attr_repair.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index ba85ac2..13ec90e 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -611,6 +611,8 @@ verify_da_path(xfs_mount_t	*mp,
 		ASSERT(cursor->level[this_level].dirty == 0 ||
 			(cursor->level[this_level].dirty && !no_modify));
 
+		if (bp->b_error == EFSBADCRC)
+			cursor->level[this_level].dirty++;
 		if (cursor->level[this_level].dirty && !no_modify)
 			libxfs_writebuf(cursor->level[this_level].bp, 0);
 		else
@@ -974,6 +976,10 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 	xfs_dfsbno_t	bno;
 	xfs_buf_t	*bp;
 	int		clearit = 0, i = 0, length = 0, amountdone = 0;
+	int		hdrsize = 0;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		hdrsize = sizeof(struct xfs_attr3_rmt_hdr);
 
 	/* ASSUMPTION: valuelen is a valid number, so use it for looping */
 	/* Note that valuelen is not a multiple of blocksize */
@@ -986,16 +992,26 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 			break;
 		}
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1), 0, NULL);
+				    XFS_FSB_TO_BB(mp, 1), 0,
+				    &xfs_attr3_rmt_buf_ops);
 		if (!bp) {
 			do_warn(
 	_("can't read remote block for attributes of inode %" PRIu64 "\n"), ino);
 			clearit = 1;
 			break;
 		}
+
+		if (bp->b_error == EFSBADCRC || bp->b_error == EFSCORRUPTED) {
+			do_warn(
+	_("Corrupt remote block for attributes of inode %" PRIu64 "\n"), ino);
+			clearit = 1;
+			break;
+		}
+
 		ASSERT(mp->m_sb.sb_blocksize == XFS_BUF_COUNT(bp));
-		length = MIN(XFS_BUF_COUNT(bp), valuelen - amountdone);
-		memmove(value, XFS_BUF_PTR(bp), length);
+
+		length = MIN(XFS_BUF_COUNT(bp) - hdrsize, valuelen - amountdone);
+		memmove(value, XFS_BUF_PTR(bp) + hdrsize, length);
 		amountdone += length;
 		value += length;
 		i++;
@@ -1320,13 +1336,16 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		}
 
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, dev_bno),
-					XFS_FSB_TO_BB(mp, 1), 0, NULL);
+				    XFS_FSB_TO_BB(mp, 1), 0,
+				    &xfs_attr3_leaf_buf_ops);
 		if (!bp) {
 			do_warn(
 	_("can't read file block %u (fsbno %" PRIu64 ") for attribute fork of inode %" PRIu64 "\n"),
 				da_bno, dev_bno, ino);
 			goto error_out;
 		}
+		if (bp->b_error == EFSBADCRC)
+			repair++;
 
 		leaf = bp->b_addr;
 		xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
@@ -1382,9 +1401,9 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 
 		current_hashval = greatest_hashval;
 
-		if (repair && !no_modify) 
+		if (repair && !no_modify)
 			libxfs_writebuf(bp, 0);
-		else 
+		else
 			libxfs_putbuf(bp);
 	} while (da_bno != 0);
 
@@ -1512,6 +1531,8 @@ process_longform_attr(
 			ino);
 		return(1);
 	}
+	if (bp->b_error == EFSBADCRC)
+		(*repair)++;
 
 	/* verify leaf block */
 	leaf = (xfs_attr_leafblock_t *)XFS_BUF_PTR(bp);
@@ -1555,7 +1576,7 @@ process_longform_attr(
 	case XFS_DA_NODE_MAGIC:		/* btree-form attribute */
 	case XFS_DA3_NODE_MAGIC:
 		/* must do this now, to release block 0 before the traversal */
-		if (repairlinks) {
+		if (*repair || repairlinks) {
 			*repair = 1;
 			libxfs_writebuf(bp, 0);
 		} else
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

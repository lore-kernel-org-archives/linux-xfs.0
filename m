Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E9DD7CBF
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 15:36:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C17F530404E
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 13:36:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ei5GOLdhOif4OL4J for <xfs@oss.sgi.com>;
	Tue, 28 May 2013 13:36:20 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: inode unlinked list needs to recalculate the inode
	CRC
Date: Wed, 29 May 2013 06:36:13 +1000
Message-Id: <1369773373-26697-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1369773373-26697-1-git-send-email-david@fromorbit.com>
References: <1369636707-15150-10-git-send-email-david@fromorbit.com>
	<1369773373-26697-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

From: Dave Chinner <dchinner@redhat.com>

The inode unlinked list manipulations operate directly on the inode
buffer, and so bypass the inode CRC calculation mechanisms. Hence an
inode on the unlinked list has an invalid CRC. Fix this by
recalculating the CRC whenever we modify an unlinked list pointer in
an inode, ncluding during log recovery. This is trivial to do and
results in  unlinked list operations always leaving a consistent
inode in the buffer.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c       |   42 ++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_log_recover.c |    9 +++++++++
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index efbe1ac..2d993e7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1579,6 +1579,23 @@ out_bmap_cancel:
 }
 
 /*
+ * Helper function to calculate range of the inode to log and recalculate the
+ * on-disk inode crc if necessary.
+ */
+static int
+xfs_iunlink_dinode_calc_crc(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip)
+{
+	if (dip->di_version < 3)
+		return sizeof(xfs_agino_t);
+
+	xfs_dinode_calc_crc(mp, dip);
+	return offsetof(struct xfs_dinode, di_changecount) -
+		offsetof(struct xfs_dinode, di_next_unlinked);
+}
+
+/*
  * This is called when the inode's link count goes to 0.
  * We place the on-disk inode on a list in the AGI.  It
  * will be pulled from this list when the inode is freed.
@@ -1638,10 +1655,15 @@ xfs_iunlink(
 		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
 		offset = ip->i_imap.im_boffset +
 			offsetof(xfs_dinode_t, di_next_unlinked);
+
+		/* need to recalc the inode CRC if appropriate */
+		xfs_iunlink_dinode_calc_crc(mp, dip);
+
 		xfs_trans_inode_buf(tp, ibp);
 		xfs_trans_log_buf(tp, ibp, offset,
-				  (offset + sizeof(xfs_agino_t) - 1));
+				  offset + sizeof(xfs_agino_t) - 1);
 		xfs_inobp_check(mp, ibp);
+
 	}
 
 	/*
@@ -1723,9 +1745,13 @@ xfs_iunlink_remove(
 			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			offset = ip->i_imap.im_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
+
+			/* need to recalc the inode CRC if appropriate */
+			xfs_iunlink_dinode_calc_crc(mp, dip);
+
 			xfs_trans_inode_buf(tp, ibp);
 			xfs_trans_log_buf(tp, ibp, offset,
-					  (offset + sizeof(xfs_agino_t) - 1));
+					  offset + sizeof(xfs_agino_t) - 1);
 			xfs_inobp_check(mp, ibp);
 		} else {
 			xfs_trans_brelse(tp, ibp);
@@ -1796,9 +1822,13 @@ xfs_iunlink_remove(
 			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			offset = ip->i_imap.im_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
+
+			/* need to recalc the inode CRC if appropriate */
+			xfs_iunlink_dinode_calc_crc(mp, dip);
+
 			xfs_trans_inode_buf(tp, ibp);
 			xfs_trans_log_buf(tp, ibp, offset,
-					  (offset + sizeof(xfs_agino_t) - 1));
+					  offset + sizeof(xfs_agino_t) - 1);
 			xfs_inobp_check(mp, ibp);
 		} else {
 			xfs_trans_brelse(tp, ibp);
@@ -1809,9 +1839,13 @@ xfs_iunlink_remove(
 		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
 		ASSERT(next_agino != 0);
 		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
+
+		/* need to recalc the inode CRC if appropriate */
+		xfs_iunlink_dinode_calc_crc(mp, dip);
+
 		xfs_trans_inode_buf(tp, last_ibp);
 		xfs_trans_log_buf(tp, last_ibp, offset,
-				  (offset + sizeof(xfs_agino_t) - 1));
+				  offset + sizeof(xfs_agino_t) - 1);
 		xfs_inobp_check(mp, last_ibp);
 	}
 	return 0;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 83088d9..45a85ff 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1912,6 +1912,15 @@ xlog_recover_do_inode_buffer(
 		buffer_nextp = (xfs_agino_t *)xfs_buf_offset(bp,
 					      next_unlinked_offset);
 		*buffer_nextp = *logged_nextp;
+
+		/*
+		 * If necessary, recalculate the CRC in the on-disk inode. We
+		 * have to leave the inode in a consistent state for whoever
+		 * reads it next....
+		 */
+		xfs_dinode_calc_crc(mp, (struct xfs_dinode *)
+				xfs_buf_offset(bp, i * mp->m_sb.sb_inodesize));
+
 	}
 
 	return 0;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

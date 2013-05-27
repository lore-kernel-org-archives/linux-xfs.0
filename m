Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D6F2529E13
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 01:38:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A7B3B8F8035
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 23:38:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ldqkWdFzL0YQopsk for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 23:38:54 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ugr50-0008G7-0C
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:50 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ugr4p-0003xi-Sq
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 9/9] xfs: inode unlinked list needs to recalculate the inode
	CRC
Date: Mon, 27 May 2013 16:38:27 +1000
Message-Id: <1369636707-15150-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1369636707-15150-1-git-send-email-david@fromorbit.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
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

The inode unlinked list manipulations operate directly on the inode
buffer, and so bypass the inode CRC calculation mechanisms. Hence an
inode on the unlinked list has an invalid CRC. Fix this by
recalculating the CRC whenever we modify an unlinked list pointer in
an inode. This is trivial to do, and the new CRC gets logged with
the inode core so on replay of the unlinked list operations this
will be updated as expected and remain consistent.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c       |   49 ++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_log_recover.c |   22 +++++++++++++++++++++
 2 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index efbe1ac..f4daadf 100644
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
@@ -1623,6 +1640,8 @@ xfs_iunlink(
 	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
 
 	if (agi->agi_unlinked[bucket_index] != cpu_to_be32(NULLAGINO)) {
+		int	size;
+
 		/*
 		 * There is already another inode in the bucket we need
 		 * to add ourselves to.  Add us at the front of the list.
@@ -1638,10 +1657,14 @@ xfs_iunlink(
 		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
 		offset = ip->i_imap.im_boffset +
 			offsetof(xfs_dinode_t, di_next_unlinked);
+
+		/* need to recalc and log the inode CRC if appropriate */
+		size = xfs_iunlink_dinode_calc_crc(mp, dip);
+
 		xfs_trans_inode_buf(tp, ibp);
-		xfs_trans_log_buf(tp, ibp, offset,
-				  (offset + sizeof(xfs_agino_t) - 1));
+		xfs_trans_log_buf(tp, ibp, offset, offset + size - 1);
 		xfs_inobp_check(mp, ibp);
+
 	}
 
 	/*
@@ -1678,6 +1701,7 @@ xfs_iunlink_remove(
 	short		bucket_index;
 	int		offset, last_offset = 0;
 	int		error;
+	int		size;
 
 	mp = tp->t_mountp;
 	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
@@ -1723,9 +1747,12 @@ xfs_iunlink_remove(
 			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			offset = ip->i_imap.im_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
+
+			/* need to recalc and log the inode CRC if appropriate */
+			size = xfs_iunlink_dinode_calc_crc(mp, dip);
+
 			xfs_trans_inode_buf(tp, ibp);
-			xfs_trans_log_buf(tp, ibp, offset,
-					  (offset + sizeof(xfs_agino_t) - 1));
+			xfs_trans_log_buf(tp, ibp, offset, offset + size - 1);
 			xfs_inobp_check(mp, ibp);
 		} else {
 			xfs_trans_brelse(tp, ibp);
@@ -1796,9 +1823,12 @@ xfs_iunlink_remove(
 			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			offset = ip->i_imap.im_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
+
+			/* need to recalc and log the inode CRC if appropriate */
+			size = xfs_iunlink_dinode_calc_crc(mp, dip);
+
 			xfs_trans_inode_buf(tp, ibp);
-			xfs_trans_log_buf(tp, ibp, offset,
-					  (offset + sizeof(xfs_agino_t) - 1));
+			xfs_trans_log_buf(tp, ibp, offset, offset + size - 1);
 			xfs_inobp_check(mp, ibp);
 		} else {
 			xfs_trans_brelse(tp, ibp);
@@ -1809,9 +1839,12 @@ xfs_iunlink_remove(
 		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
 		ASSERT(next_agino != 0);
 		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
+
+		/* need to recalc and log the inode CRC if appropriate */
+		size = xfs_iunlink_dinode_calc_crc(mp, dip);
+
 		xfs_trans_inode_buf(tp, last_ibp);
-		xfs_trans_log_buf(tp, last_ibp, offset,
-				  (offset + sizeof(xfs_agino_t) - 1));
+		xfs_trans_log_buf(tp, last_ibp, offset, offset + size - 1);
 		xfs_inobp_check(mp, last_ibp);
 	}
 	return 0;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d6204d1..285ad16 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1861,6 +1861,28 @@ xlog_recover_do_inode_buffer(
 		buffer_nextp = (xfs_agino_t *)xfs_buf_offset(bp,
 					      next_unlinked_offset);
 		*buffer_nextp = *logged_nextp;
+
+		/*
+		 * Check if we have to recover the CRC, too.i The CRC is
+		 * adjacent to the unlinked field, so should always be in the
+		 * same dirty region.
+		 */
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			int	crc_off;
+			__le32	*buffer_crcp;
+			__le32	*logged_crcp;
+
+			crc_off = next_unlinked_offset +
+				offsetof(struct xfs_dinode, di_crc) -
+				offsetof(struct xfs_dinode, di_next_unlinked);
+
+			buffer_crcp = (__le32 *)xfs_buf_offset(bp, crc_off);
+			logged_crcp = item->ri_buf[item_index].i_addr +
+					crc_off - reg_buf_offset;
+
+			*buffer_crcp = *logged_crcp;
+		}
+
 	}
 
 	return 0;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

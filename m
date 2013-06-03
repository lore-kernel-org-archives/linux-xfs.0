Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 17C8929E12
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 00:29:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A113304043
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 22:29:08 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XgzguTAe9TJ0BYKY for <xfs@oss.sgi.com>;
	Sun, 02 Jun 2013 22:29:02 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: inode unlinked list needs to recalculate the inode
	CRC
Date: Mon,  3 Jun 2013 15:28:48 +1000
Message-Id: <1370237332-24757-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1370237332-24757-1-git-send-email-david@fromorbit.com>
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_inode.c       |   16 ++++++++++++++++
 fs/xfs/xfs_log_recover.c |    9 +++++++++
 2 files changed, 25 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index efbe1ac..c50e785 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1638,6 +1638,10 @@ xfs_iunlink(
 		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
 		offset = ip->i_imap.im_boffset +
 			offsetof(xfs_dinode_t, di_next_unlinked);
+
+		/* need to recalc the inode CRC if appropriate */
+		xfs_dinode_calc_crc(mp, dip);
+
 		xfs_trans_inode_buf(tp, ibp);
 		xfs_trans_log_buf(tp, ibp, offset,
 				  (offset + sizeof(xfs_agino_t) - 1));
@@ -1723,6 +1727,10 @@ xfs_iunlink_remove(
 			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			offset = ip->i_imap.im_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
+
+			/* need to recalc the inode CRC if appropriate */
+			xfs_dinode_calc_crc(mp, dip);
+
 			xfs_trans_inode_buf(tp, ibp);
 			xfs_trans_log_buf(tp, ibp, offset,
 					  (offset + sizeof(xfs_agino_t) - 1));
@@ -1796,6 +1804,10 @@ xfs_iunlink_remove(
 			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			offset = ip->i_imap.im_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
+
+			/* need to recalc the inode CRC if appropriate */
+			xfs_dinode_calc_crc(mp, dip);
+
 			xfs_trans_inode_buf(tp, ibp);
 			xfs_trans_log_buf(tp, ibp, offset,
 					  (offset + sizeof(xfs_agino_t) - 1));
@@ -1809,6 +1821,10 @@ xfs_iunlink_remove(
 		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
 		ASSERT(next_agino != 0);
 		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
+
+		/* need to recalc the inode CRC if appropriate */
+		xfs_dinode_calc_crc(mp, dip);
+
 		xfs_trans_inode_buf(tp, last_ibp);
 		xfs_trans_log_buf(tp, last_ibp, offset,
 				  (offset + sizeof(xfs_agino_t) - 1));
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

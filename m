Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C714329E06
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 03:04:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B639530406A
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 01:04:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HPNBAkMGE0LXHw8A for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 01:04:53 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UZctH-0006Z8-GE
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UZctH-0007rE-5M
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7] xfs: don't do IO when creating an new inode
Date: Tue,  7 May 2013 18:04:30 +1000
Message-Id: <1367913876-30086-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1367913876-30086-1-git-send-email-david@fromorbit.com>
References: <1367913876-30086-1-git-send-email-david@fromorbit.com>
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

When we are allocating a new inode, we read the inode cluster off
disk to increment the generation number. We are already using a
random generation number for newly allocated inodes, so if we are not
using the ikeep mode, we can just generate a new generation number
when we initialise the newly allocated inode.

This avoids the need for reading the inode buffer during inode
creation. This will speed up allocation of inodes in cold, partially
allocated clusters as they will no longer need to be read from disk
during allocation. It will also reduce the CPU overhead of inode
allocation by not having the process the buffer read, even on cache
hits.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index efbe1ac..9a475d1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1028,6 +1028,11 @@ xfs_dinode_calc_crc(
 
 /*
  * Read the disk inode attributes into the in-core inode structure.
+ *
+ * If we are initialising a new inode and we are not utilising the
+ * XFS_MOUNT_IKEEP inode cluster mode, we can simple build the new inode core
+ * with a random generation number. If we are keeping inodes around, we need to
+ * read the inode cluster to get the existing generation number off disk.
  */
 int
 xfs_iread(
@@ -1047,6 +1052,22 @@ xfs_iread(
 	if (error)
 		return error;
 
+	/* shortcut IO on inode allocation if possible */
+	if ((iget_flags & XFS_IGET_CREATE) &&
+	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
+		/* initialise the on-disk inode core */
+		memset(&ip->i_d, 0, sizeof(ip->i_d));
+		ip->i_d.di_magic = XFS_DINODE_MAGIC;
+		ip->i_d.di_gen = prandom_u32();
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			ip->i_d.di_version = 3;
+			ip->i_d.di_ino = ip->i_ino;
+			uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+		} else
+			ip->i_d.di_version = 2;
+		return 0;
+	}
+
 	/*
 	 * Get pointers to the on-disk inode and the buffer containing it.
 	 */
@@ -1133,17 +1154,16 @@ xfs_iread(
 	xfs_buf_set_ref(bp, XFS_INO_REF);
 
 	/*
-	 * Use xfs_trans_brelse() to release the buffer containing the
-	 * on-disk inode, because it was acquired with xfs_trans_read_buf()
-	 * in xfs_imap_to_bp() above.  If tp is NULL, this is just a normal
+	 * Use xfs_trans_brelse() to release the buffer containing the on-disk
+	 * inode, because it was acquired with xfs_trans_read_buf() in
+	 * xfs_imap_to_bp() above.  If tp is NULL, this is just a normal
 	 * brelse().  If we're within a transaction, then xfs_trans_brelse()
 	 * will only release the buffer if it is not dirty within the
 	 * transaction.  It will be OK to release the buffer in this case,
-	 * because inodes on disk are never destroyed and we will be
-	 * locking the new in-core inode before putting it in the hash
-	 * table where other processes can find it.  Thus we don't have
-	 * to worry about the inode being changed just because we released
-	 * the buffer.
+	 * because inodes on disk are never destroyed and we will be locking the
+	 * new in-core inode before putting it in the cache where other
+	 * processes can find it.  Thus we don't have to worry about the inode
+	 * being changed just because we released the buffer.
 	 */
  out_brelse:
 	xfs_trans_brelse(tp, bp);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 384FB7F4E
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 17:27:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27D1A304032
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 15:27:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XLU3wp3MosQk7eLI for <xfs@oss.sgi.com>;
	Mon, 26 May 2014 15:27:15 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wp3MA-0001PT-Bq
	for xfs@oss.sgi.com; Tue, 27 May 2014 08:26:58 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wp3MA-0002VF-B7
	for xfs@oss.sgi.com; Tue, 27 May 2014 08:26:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: xfs_readsb needs to check for magic numbers
Date: Tue, 27 May 2014 08:26:54 +1000
Message-Id: <1401143214-9181-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1401143214-9181-1-git-send-email-david@fromorbit.com>
References: <1401143214-9181-1-git-send-email-david@fromorbit.com>
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

Commit daba542 ("xfs: skip verification on initial "guess"
superblock read") dropped the use of a verifier for the initial
superblock read so we can probe the sector size of the filesystem
stored in the superblock. It, however, now fails to validate that
what was read initially is actually an XFS superblock and hence will
fail the sector size check and return ENOSYS.

This causes probe-based mounts to fail because it expects XFS to
return EINVAL when it doesn't recognise the superblock format.

cc: <stable@vger.kernel.org>
Reported-by: Plamen Petrov <plamen.sisi@gmail.com>
Tested-by: Plamen Petrov <plamen.sisi@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3f09782..fa8a420 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -323,8 +323,19 @@ reread:
 	/*
 	 * Initialize the mount structure from the superblock.
 	 */
-	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
-	xfs_sb_quota_from_disk(&mp->m_sb);
+	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
+	xfs_sb_quota_from_disk(sbp);
+
+	/*
+	 * If we haven't validated the superblock, do so now before we try
+	 * to check the sector size and reread the superblock appropriately.
+	 */
+	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
+		if (loud)
+			xfs_warn(mp, "Invalid superblock magic number");
+		error = EINVAL;
+		goto release_buf;
+	}
 
 	/*
 	 * We must be able to do sector-sized and sector-aligned IO.
@@ -337,11 +348,11 @@ reread:
 		goto release_buf;
 	}
 
-	/*
-	 * Re-read the superblock so the buffer is correctly sized,
-	 * and properly verified.
-	 */
 	if (buf_ops == NULL) {
+		/*
+		 * Re-read the superblock so the buffer is correctly sized,
+		 * and properly verified.
+		 */
 		xfs_buf_relse(bp);
 		sector_size = sbp->sb_sectsize;
 		buf_ops = loud ? &xfs_sb_buf_ops : &xfs_sb_quiet_buf_ops;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

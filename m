Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0P5Vs9q033113 for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 23:31:54 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B081184F33
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 21:32:56 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	ZEOixBFpcRLzWJOH for <xfs@oss.sgi.com>;
	Sun, 24 Jan 2010 21:32:56 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11549003-1927428
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 16:02:55 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NZHZF-0002uf-IB
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 16:32:53 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NZHZE-0004lD-CH
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 16:32:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't hold onto reserved blocks on remount,ro
Date: Mon, 25 Jan 2010 16:32:52 +1100
Message-Id: <1264397572-18230-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

If we hold onto reserved blocks when doing a remount,ro we end
up writing the blocks used count to disk that includes the reserved
blocks. Reserved blocks are not actually used, so this results in
the values in the superblock being incorrect.

Hence if we run xfs_check or xfs_repair -n while the filesystem is
mounted remount,ro we end up with an inconsistent filesystem being
reported. Also, running xfs_copy on the remount,ro filesystem will
result in an inconsistent image being generated.

To fix this, unreserve the blocks when doing the remount,ro, and
reserved them again on remount,rw. This way a remount,ro filesystem
will appear consistent on disk to all utilities.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h           |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 9f2e398..67001ec 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1318,6 +1318,8 @@ xfs_fs_remount(
 
 	/* ro -> rw */
 	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
+		__uint64_t resblks;
+
 		mp->m_flags &= ~XFS_MOUNT_RDONLY;
 		if (mp->m_flags & XFS_MOUNT_BARRIER)
 			xfs_mountfs_check_barriers(mp);
@@ -1335,11 +1337,37 @@ xfs_fs_remount(
 			}
 			mp->m_update_flags = 0;
 		}
+
+		/*
+		 * Fill out the reserve pool if it is empty. Use the stashed
+		 * value if it is non-zero, otherwise go with the default.
+		 */
+		if (mp->m_resblks_ro) {
+			resblks = mp->m_resblks_ro;
+			mp->m_resblks_ro = 0;
+		} else {
+			resblks = mp->m_sb.sb_dblocks;
+			do_div(resblks, 20);
+			resblks = min_t(__uint64_t, resblks, 1024);
+		}
+		xfs_reserve_blocks(mp, &resblks, NULL);
 	}
 
 	/* rw -> ro */
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
+		/*
+		 * After we have synced the data but before we sync the
+		 * metadata, we need to free up the reserve block pool so that
+		 * the used block count in the superblock on disk is correct at
+		 * the end of the remount. Stash the current reserve pool size
+		 * so that if we get remounted rw, we can return it to the same
+		 * size.
+		 */
+		__uint64_t resblks = 0;
+
 		xfs_quiesce_data(mp);
+		mp->m_resblks_ro = mp->m_resblks;
+		xfs_reserve_blocks(mp, &resblks, NULL);
 		xfs_quiesce_attr(mp);
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f4d1441..a3de553 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -225,6 +225,7 @@ typedef struct xfs_mount {
 	__uint64_t		m_maxioffset;	/* maximum inode offset */
 	__uint64_t		m_resblks;	/* total reserved blocks */
 	__uint64_t		m_resblks_avail;/* available reserved blocks */
+	__uint64_t		m_resblks_ro;	/* reserved blks @ remount,ro */
 	int			m_dalign;	/* stripe unit */
 	int			m_swidth;	/* stripe width */
 	int			m_sinoalign;	/* stripe unit inode alignment */
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

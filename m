Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F2B6E7F92
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:20:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D29848F8037
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:20:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	AHQe1sm7qly439iA for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:20:39 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX82H-0006kr-9c
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:20:37 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX82H-0007Mc-8P
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:20:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: consider freeze levels in xfs_fs_writable()
Date: Thu, 25 Sep 2014 22:20:30 +1000
Message-Id: <1411647632-28240-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1411647632-28240-1-git-send-email-david@fromorbit.com>
References: <1411647632-28240-1-git-send-email-david@fromorbit.com>
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

The filesystem is still writable in certain circumstances while a
freeze is in progress but xfs_fs_writable() does not reflect that.
In some code we want to check whether the fs is writable, and the
context we can be called under varies because the code call be
called from under both unmount and freeze contexts. Hence allow
the caller to pass in the freeze level it is allowed to write at,
thereby ensuring that we can use the general writable function in
more places.

Note: Brian Foster also wrote an almost identical patch at the same
time, so some credit is due to him for the existence of this commit.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c   |  2 +-
 fs/xfs/xfs_mount.c | 21 +++++++++++++++------
 fs/xfs/xfs_mount.h |  2 +-
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ca4fd5b..7ada70c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1031,7 +1031,7 @@ xfs_log_need_covered(xfs_mount_t *mp)
 	struct xlog	*log = mp->m_log;
 	int		needed = 0;
 
-	if (!xfs_fs_writable(mp))
+	if (!xfs_fs_writable(mp, SB_UNFROZEN))
 		return 0;
 
 	if (!xlog_cil_empty(log))
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d36bdbc..9073895 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -607,7 +607,7 @@ xfs_mount_reset_sbqflags(
 	 * If the fs is readonly, let the incore superblock run
 	 * with quotas off but don't flush the update out to disk
 	 */
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (!xfs_fs_writable(mp, SB_UNFROZEN))
 		return 0;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
@@ -1077,11 +1077,16 @@ xfs_unmountfs(
 	xfs_sysfs_del(&mp->m_kobj);
 }
 
-int
-xfs_fs_writable(xfs_mount_t *mp)
+bool
+xfs_fs_writable(xfs_mount_t *mp, int frozen_state)
 {
-	return !(mp->m_super->s_writers.frozen || XFS_FORCED_SHUTDOWN(mp) ||
-		(mp->m_flags & XFS_MOUNT_RDONLY));
+	if (mp->m_super->s_writers.frozen > frozen_state)
+		return false;
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return false;
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return false;
+	return true;
 }
 
 /*
@@ -1099,7 +1104,11 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	xfs_trans_t	*tp;
 	int		error;
 
-	if (!xfs_fs_writable(mp))
+	/*
+	 * We can be called during the fs freeze process, and we need to be
+	 * able to write the superblock in that case.
+	 */
+	if (!xfs_fs_writable(mp, SB_FREEZE_FS))
 		return 0;
 
 	xfs_icsb_sync_counters(mp, 0);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b0447c8..30f85ca 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -384,7 +384,7 @@ extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
-extern int	xfs_fs_writable(xfs_mount_t *);
+extern bool	xfs_fs_writable(struct xfs_mount *, int);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
 extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

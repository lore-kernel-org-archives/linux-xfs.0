Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C2E867F47
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 12:00:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B09A38F8050
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 10:00:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hFGaX2rXWrCd9LrQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 10:00:25 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAEGH9Yl006340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 11:17:09 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sAEGH81i012331
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 11:17:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/3] xfs: allow lazy sb counter sync during filesystem freeze
	sequence
Date: Fri, 14 Nov 2014 11:17:07 -0500
Message-Id: <1415981827-52993-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1415981827-52993-1-git-send-email-bfoster@redhat.com>
References: <1415981827-52993-1-git-send-email-bfoster@redhat.com>
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

The expectation since the introduction the lazy superblock counters is
that the counters are synced and superblock logged appropriately as part
of the filesystem freeze sequence. This does not occur, however, due to
the logic in xfs_fs_writable() that prevents progress when the fs is in
any state other than SB_UNFROZEN.

While this is a bug, it has not been exposed to date because the last
thing XFS does during freeze is dirty the log. The log recovery process
recalculates the counters from AGI/AGF metadata to ensure everything is
correct. Therefore should a crash occur while an fs is frozen, the
subsequent log recovery puts everything back in order. See the following
commit for reference:

	92821e2b [XFS] Lazy Superblock Counters

We might not always want to rely on dirtying the log on a frozen fs.
Modify xfs_log_sbcount() to proceed when the filesystem is freezing but
not once the freeze process has completed. Modify xfs_fs_writable() to
accept the minimum freeze level for which modifications should be
blocked to support various codepaths.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c   |  2 +-
 fs/xfs/xfs_mount.c | 29 +++++++++++++++++++++--------
 fs/xfs/xfs_mount.h |  2 +-
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fe88ef6..e810e9d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1031,7 +1031,7 @@ xfs_log_need_covered(xfs_mount_t *mp)
 	struct xlog	*log = mp->m_log;
 	int		needed = 0;
 
-	if (!xfs_fs_writable(mp))
+	if (!xfs_fs_writable(mp, SB_FREEZE_WRITE))
 		return 0;
 
 	if (!xlog_cil_empty(log))
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 51435db..13d1170 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1074,11 +1074,23 @@ xfs_unmountfs(
 	xfs_sysfs_del(&mp->m_kobj);
 }
 
-int
-xfs_fs_writable(xfs_mount_t *mp)
+/*
+ * Determine whether modifications can proceed. The caller specifies the minimum
+ * freeze level for which modifications should not be allowed. This allows
+ * certain operations to proceed while the freeze sequence is in progress, if
+ * necessary.
+ */
+bool
+xfs_fs_writable(
+	struct xfs_mount	*mp,
+	int			level)
 {
-	return !(mp->m_super->s_writers.frozen || XFS_FORCED_SHUTDOWN(mp) ||
-		(mp->m_flags & XFS_MOUNT_RDONLY));
+	ASSERT(level > SB_UNFROZEN);
+	if ((mp->m_super->s_writers.frozen >= level) ||
+	    XFS_FORCED_SHUTDOWN(mp) || (mp->m_flags & XFS_MOUNT_RDONLY))
+		return false;
+
+	return true;
 }
 
 /*
@@ -1086,9 +1098,9 @@ xfs_fs_writable(xfs_mount_t *mp)
  *
  * Sync the superblock counters to disk.
  *
- * Note this code can be called during the process of freezing, so
- * we may need to use the transaction allocator which does not
- * block when the transaction subsystem is in its frozen state.
+ * Note this code can be called during the process of freezing, so we use the
+ * transaction allocator that does not block when the transaction subsystem is
+ * in its frozen state.
  */
 int
 xfs_log_sbcount(xfs_mount_t *mp)
@@ -1096,7 +1108,8 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	xfs_trans_t	*tp;
 	int		error;
 
-	if (!xfs_fs_writable(mp))
+	/* allow this to proceed during the freeze sequence... */
+	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
 		return 0;
 
 	xfs_icsb_sync_counters(mp, 0);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b0447c8..8852418 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -384,7 +384,7 @@ extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
-extern int	xfs_fs_writable(xfs_mount_t *);
+extern bool	xfs_fs_writable(struct xfs_mount *mp, int level);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
 extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B847A7FA6
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 08:54:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A6A148F804B
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 06:54:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D1FdIqOD1lJlHBhb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Aug 2014 06:54:30 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s76DsUhF032522
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 6 Aug 2014 09:54:30 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s76DsTFF005755
	for <xfs@oss.sgi.com>; Wed, 6 Aug 2014 09:54:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: allow lazy sb counter sync during filesystem freeze
	sequence
Date: Wed,  6 Aug 2014 09:54:28 -0400
Message-Id: <1407333268-38768-1-git-send-email-bfoster@redhat.com>
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
accept the maximum allowable freeze level as a parameter to support the
requirements of various codepaths.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

I also toyed with using a 'bypass_freezing' bool parameter and leaving
the freeze level bits isolated to xfs_fs_writable(), but this actually
looked a bit more clean. I'm fine with either way... thoughts?

Brian

 fs/xfs/xfs_log.c   |  2 +-
 fs/xfs/xfs_mount.c | 27 +++++++++++++++++++--------
 fs/xfs/xfs_mount.h |  2 +-
 3 files changed, 21 insertions(+), 10 deletions(-)

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
index fbf0384..177b6ea 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1080,11 +1080,21 @@ xfs_unmountfs(
 	xfs_sysfs_del(&mp->m_kobj);
 }
 
-int
-xfs_fs_writable(xfs_mount_t *mp)
+/*
+ * Determine whether modifications can proceed. The caller specifies the maximum
+ * freeze level that should be allowed to proceed. This allows certain required
+ * operations to proceed while the freeze sequence is in progress.
+ */
+bool
+xfs_fs_writable(
+	struct xfs_mount	*mp,
+	int			maxfreeze)
 {
-	return !(mp->m_super->s_writers.frozen || XFS_FORCED_SHUTDOWN(mp) ||
-		(mp->m_flags & XFS_MOUNT_RDONLY));
+	if ((mp->m_super->s_writers.frozen > maxfreeze) ||
+	    XFS_FORCED_SHUTDOWN(mp) || (mp->m_flags & XFS_MOUNT_RDONLY))
+		return false;
+
+	return true;
 }
 
 /*
@@ -1092,9 +1102,9 @@ xfs_fs_writable(xfs_mount_t *mp)
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
@@ -1102,7 +1112,8 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	xfs_trans_t	*tp;
 	int		error;
 
-	if (!xfs_fs_writable(mp))
+	/* allow this to proceed during the freeze sequence... */
+	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
 		return 0;
 
 	xfs_icsb_sync_counters(mp, 0);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b0447c8..fd15e5c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -384,7 +384,7 @@ extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
-extern int	xfs_fs_writable(xfs_mount_t *);
+extern bool	xfs_fs_writable(struct xfs_mount *mp, int maxfreeze);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
 extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

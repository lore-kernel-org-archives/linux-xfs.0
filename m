Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:42:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97Lg7gX000306
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:42:07 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AC0E129BBAC
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:43:46 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id mn7e98Eubwl16fgB for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:43:46 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKLE-0001jz-3i
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 08:43:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/10] XFS: use xfs_sync_inodes rather than xfs_syncsub
Date: Wed,  8 Oct 2008 08:43:32 +1100
Message-Id: <1223415819-6599-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1223415819-6599-1-git-send-email-david@fromorbit.com>
References: <1223415819-6599-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Kill the unused arg in xfs_syncsub() and xfs_sync_inodes().  For
callers of xfs_syncsub() that only want to flush inodes, replace
xfs_syncsub() with direct calls to xfs_sync_inodes() as that is all
that is being done with the specific flags being passed in.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c    |   21 +++++++--------------
 fs/xfs/linux-2.6/xfs_sync.h    |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    2 +-
 fs/xfs/xfs_mount.h             |    2 --
 fs/xfs/xfs_vfsops.c            |   14 +++++++-------
 5 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 461c1dc..7e9fb52 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -117,7 +117,7 @@ xfs_sync(
 	if (flags & SYNC_IOWAIT)
 		xfs_filestream_flush(mp);
 
-	return xfs_syncsub(mp, flags, NULL);
+	return xfs_syncsub(mp, flags);
 }
 
 /*
@@ -128,8 +128,7 @@ STATIC int
 xfs_sync_inodes_ag(
 	xfs_mount_t	*mp,
 	int		ag,
-	int		flags,
-	int		*bypassed)
+	int		flags)
 {
 	xfs_perag_t	*pag = &mp->m_perag[ag];
 	int		nr_found;
@@ -260,8 +259,6 @@ xfs_sync_inodes_ag(
 					error = xfs_iflush(ip, XFS_IFLUSH_DELWRI);
 				else
 					xfs_ifunlock(ip);
-			} else if (bypassed) {
-				(*bypassed)++;
 			}
 		}
 
@@ -288,15 +285,12 @@ xfs_sync_inodes_ag(
 int
 xfs_sync_inodes(
 	xfs_mount_t	*mp,
-	int		flags,
-	int             *bypassed)
+	int		flags)
 {
 	int		error;
 	int		last_error;
 	int		i;
 
-	if (bypassed)
-		*bypassed = 0;
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return 0;
 	error = 0;
@@ -305,7 +299,7 @@ xfs_sync_inodes(
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		if (!mp->m_perag[i].pag_ici_init)
 			continue;
-		error = xfs_sync_inodes_ag(mp, i, flags, bypassed);
+		error = xfs_sync_inodes_ag(mp, i, flags);
 		if (error)
 			last_error = error;
 		if (error == EFSCORRUPTED)
@@ -408,11 +402,10 @@ xfs_sync_fsdata(
  * interface as explained above under xfs_sync.
  *
  */
-int
+STATIC int
 xfs_syncsub(
 	xfs_mount_t	*mp,
-	int		flags,
-	int             *bypassed)
+	int		flags)
 {
 	int		error = 0;
 	int		last_error = 0;
@@ -431,7 +424,7 @@ xfs_syncsub(
 		if (flags & SYNC_BDFLUSH)
 			xfs_finish_reclaim_all(mp, 1, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 		else
-			error = xfs_sync_inodes(mp, flags, bypassed);
+			error = xfs_sync_inodes(mp, flags);
 	}
 
 	/*
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 3746d15..2954861 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -55,7 +55,7 @@ int xfs_syncd_init(struct xfs_mount *mp);
 void xfs_syncd_stop(struct xfs_mount *mp);
 
 int xfs_sync(struct xfs_mount *mp, int flags);
-int xfs_syncsub(struct xfs_mount *mp, int flags, int *bypassed);
+int xfs_sync_inodes(struct xfs_mount *mp, int flags);
 
 void xfs_flush_inode(struct xfs_inode *ip);
 void xfs_flush_device(struct xfs_inode *ip);
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 4254b07..9ff28e6 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -127,7 +127,7 @@ xfs_qm_quotactl(
 		break;
 
 	case Q_XQUOTASYNC:
-		return (xfs_sync_inodes(mp, SYNC_DELWRI, NULL));
+		return xfs_sync_inodes(mp, SYNC_DELWRI);
 
 	default:
 		break;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dfa307d..7e02a86 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -524,8 +524,6 @@ extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
 extern int	xfs_fs_writable(xfs_mount_t *);
-extern int	xfs_syncsub(xfs_mount_t *, int, int *);
-extern int	xfs_sync_inodes(xfs_mount_t *, int, int *);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
 extern int	xfs_dmops_get(struct xfs_mount *, struct xfs_mount_args *);
diff --git a/fs/xfs/xfs_vfsops.c b/fs/xfs/xfs_vfsops.c
index 0c5ee5e..d5396d6 100644
--- a/fs/xfs/xfs_vfsops.c
+++ b/fs/xfs/xfs_vfsops.c
@@ -68,15 +68,15 @@ xfs_quiesce_fs(
 	xfs_flush_buftarg(mp->m_ddev_targp, 0);
 	xfs_finish_reclaim_all(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 
-	/* This loop must run at least twice.
-	 * The first instance of the loop will flush
-	 * most meta data but that will generate more
-	 * meta data (typically directory updates).
-	 * Which then must be flushed and logged before
-	 * we can write the unmount record.
+	/*
+	 * This loop must run at least twice.  The first instance of the loop
+	 * will flush most meta data but that will generate more meta data
+	 * (typically directory updates).  Which then must be flushed and
+	 * logged before we can write the unmount record.
 	 */
 	do {
-		xfs_syncsub(mp, SYNC_INODE_QUIESCE, NULL);
+		xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
+		xfs_sync_inodes(mp, SYNC_INODE_QUIESCE);
 		pincount = xfs_flush_buftarg(mp->m_ddev_targp, 1);
 		if (!pincount) {
 			delay(50);
-- 
1.5.6.5

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:44875 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752533AbeBOVae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Feb 2018 16:30:34 -0500
Date: Fri, 16 Feb 2018 08:30:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_buf_lock vs aio
Message-ID: <20180215213030.GO7000@dastard>
References: <20180207233320.GB20367@dastard>
 <ed83833b-5024-40f2-b335-2dcab7fddf0e@scylladb.com>
 <20180208221153.GF20266@dastard>
 <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
 <20180209231015.GI20266@dastard>
 <697bf891-e7c4-4d60-e2ce-f1ba6935b38b@scylladb.com>
 <20180213051850.GE6778@dastard>
 <f8b3b7a4-eba4-d5ab-1748-a8382a2a8fd6@scylladb.com>
 <20180214235616.GM7000@dastard>
 <1f90f49b-e11d-3140-f73b-5834e52b5f8a@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f90f49b-e11d-3140-f73b-5834e52b5f8a@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 15, 2018 at 11:36:54AM +0200, Avi Kivity wrote:
> On 02/15/2018 01:56 AM, Dave Chinner wrote:
> A little bird whispered in my ear to try XFS_IOC_OPEN_BY_HANDLE to
> avoid the the time update lock, so we'll be trying that next, to
> emulate lazytime.

Biggest problem with that is it requires root permissions. It's not
a solution that can be deployed in practice, so I haven't bothered
suggesting it as something to try.

If you want to try lazytime, an easier test might be to rebuild the
kernel with this change below to support the lazytime mount option
and not log the timestamp updates. This is essentially the mechanism
that I'll use for this, but it will need to grow more stuff to have
the correct lazytime semantics...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


---
 fs/xfs/xfs_iops.c  | 27 +++++++++++++++++++++++----
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_super.c | 11 ++++++++++-
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 56475fcd76f2..29082707687b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1044,6 +1044,19 @@ xfs_vn_setattr(
 	return error;
 }
 
+/*
+ * When lazytime is enabled, we never do transactional timestamp updates.
+ * That means it will only get updated on disk when some other change unrelated
+ * to timestamps is made, and so pure timestamp changes can be lost.
+ *
+ * XXX: ideally we want to set an inode state bit here so that we can track
+ * inodes that are purely timestamp dirty. And inode radix tree bit would be
+ * ideal so we can do background sweeps to log the inodes and get them written
+ * to disk at some (long) interval.
+ *
+ * XXX: lazytime currently turns off iversion support, so is incompatible with
+ * applications that require it (such as the NFS server).
+ */
 STATIC int
 xfs_vn_update_time(
 	struct inode		*inode,
@@ -1053,15 +1066,18 @@ xfs_vn_update_time(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
+	bool			lazy = (mp->m_flags & XFS_MOUNT_LAZYTIME);
 	int			error;
 
 	trace_xfs_update_time(ip);
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
-	if (error)
-		return error;
+	if (!lazy) {
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
+		if (error)
+			return error;
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+	}
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (flags & S_CTIME)
 		inode->i_ctime = *now;
 	if (flags & S_MTIME)
@@ -1069,6 +1085,9 @@ xfs_vn_update_time(
 	if (flags & S_ATIME)
 		inode->i_atime = *now;
 
+	if (lazy)
+		return 0;
+
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
 	return xfs_trans_commit(tp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 75da058c9456..e085e1e92d18 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -217,6 +217,7 @@ typedef struct xfs_mount {
 						   must be synchronous except
 						   for space allocations */
 #define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
+#define XFS_MOUNT_LAZYTIME	(1ULL << 2)	/* lazily update [acm]times */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a248fd1a96b..ae76d558a934 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -83,7 +83,8 @@ enum {
 	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota,
 	Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
+	Opt_discard, Opt_nodiscard, Opt_dax,
+	Opt_err,
 };
 
 static const match_table_t tokens = {
@@ -216,6 +217,8 @@ xfs_parseargs(
 		mp->m_flags |= XFS_MOUNT_DIRSYNC;
 	if (sb->s_flags & SB_SYNCHRONOUS)
 		mp->m_flags |= XFS_MOUNT_WSYNC;
+	if (sb->s_flags & SB_LAZYTIME)
+		mp->m_flags |= XFS_MOUNT_LAZYTIME;
 
 	/*
 	 * Set some default flags that could be cleared by the mount option
@@ -492,6 +495,7 @@ xfs_showargs(
 		{ XFS_MOUNT_DISCARD,		",discard" },
 		{ XFS_MOUNT_SMALL_INUMS,	",inode32" },
 		{ XFS_MOUNT_DAX,		",dax" },
+		{ XFS_MOUNT_LAZYTIME,		",lazytime" },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
@@ -1319,6 +1323,11 @@ xfs_fs_remount(
 		}
 	}
 
+	if (*flags & SB_LAZYTIME)
+		mp->m_flags |= XFS_MOUNT_LAZYTIME;
+	else
+		mp->m_flags &= ~XFS_MOUNT_LAZYTIME;
+
 	/* ro -> rw */
 	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
 		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {

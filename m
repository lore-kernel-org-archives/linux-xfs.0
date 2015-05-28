Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE40C7F4E
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 18:46:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE8048F8066
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 16:46:12 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cIrYIXlDMOVqLJxl for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 16:46:11 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Yy7Uy-0006cv-DA
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Yy7Uy-00024p-Bb
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: add initial DAX support
Date: Fri, 29 May 2015 09:45:55 +1000
Message-Id: <1432856755-7859-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1432856755-7859-1-git-send-email-david@fromorbit.com>
References: <1432856755-7859-1-git-send-email-david@fromorbit.com>
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

Add initial DAX support to XFS. To do this we need a new mount
option to turn DAX on filesystem, and we need to propagate this into
the inode flags whenever an inode is instantiated so that the
per-inode checks throughout the code Do The Right Thing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_iops.c  | 24 ++++++++++++------------
 fs/xfs/xfs_mount.h |  2 ++
 fs/xfs/xfs_super.c | 25 +++++++++++++++++++++++--
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0994f95..3e8d32d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1195,22 +1195,22 @@ xfs_diflags_to_iflags(
 	struct inode		*inode,
 	struct xfs_inode	*ip)
 {
-	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
+	uint16_t		flags = ip->i_d.di_flags;
+
+	inode->i_flags &= ~(S_IMMUTABLE | S_APPEND | S_SYNC |
+			    S_NOATIME | S_DAX);
+
+	if (flags & XFS_DIFLAG_IMMUTABLE)
 		inode->i_flags |= S_IMMUTABLE;
-	else
-		inode->i_flags &= ~S_IMMUTABLE;
-	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
+	if (flags & XFS_DIFLAG_APPEND)
 		inode->i_flags |= S_APPEND;
-	else
-		inode->i_flags &= ~S_APPEND;
-	if (ip->i_d.di_flags & XFS_DIFLAG_SYNC)
+	if (flags & XFS_DIFLAG_SYNC)
 		inode->i_flags |= S_SYNC;
-	else
-		inode->i_flags &= ~S_SYNC;
-	if (ip->i_d.di_flags & XFS_DIFLAG_NOATIME)
+	if (flags & XFS_DIFLAG_NOATIME)
 		inode->i_flags |= S_NOATIME;
-	else
-		inode->i_flags &= ~S_NOATIME;
+	/* XXX: Also needs an on-disk per inode flag! */
+	if (ip->i_mount->m_flags & XFS_MOUNT_DAX)
+		inode->i_flags |= S_DAX;
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index df209c2..7999e91 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -181,6 +181,8 @@ typedef struct xfs_mount {
 						   allocator */
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
 
+#define XFS_MOUNT_DAX		(1ULL << 62)	/* TEST ONLY! */
+
 
 /*
  * Default minimum read and write sizes.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 858e1e6..1fb16562 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -112,6 +112,8 @@ static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 #define MNTOPT_DISCARD	   "discard"	/* Discard unused blocks */
 #define MNTOPT_NODISCARD   "nodiscard"	/* Do not discard unused blocks */
 
+#define MNTOPT_DAX	"dax"		/* Enable direct access to bdev pages */
+
 /*
  * Table driven mount option parser.
  *
@@ -363,6 +365,10 @@ xfs_parseargs(
 			mp->m_flags |= XFS_MOUNT_DISCARD;
 		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
 			mp->m_flags &= ~XFS_MOUNT_DISCARD;
+#ifdef CONFIG_FS_DAX
+		} else if (!strcmp(this_char, MNTOPT_DAX)) {
+			mp->m_flags |= XFS_MOUNT_DAX;
+#endif
 		} else {
 			xfs_warn(mp, "unknown mount option [%s].", this_char);
 			return -EINVAL;
@@ -452,8 +458,8 @@ done:
 }
 
 struct proc_xfs_info {
-	int	flag;
-	char	*str;
+	uint64_t	flag;
+	char		*str;
 };
 
 STATIC int
@@ -474,6 +480,7 @@ xfs_showargs(
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
 		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
 		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_32BITINODE },
+		{ XFS_MOUNT_DAX,		"," MNTOPT_DAX },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
@@ -1507,6 +1514,20 @@ xfs_fs_fill_super(
 	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
 		sb->s_flags |= MS_I_VERSION;
 
+	if (mp->m_flags & XFS_MOUNT_DAX) {
+		xfs_warn(mp,
+	"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
+		if (sb->s_blocksize != PAGE_SIZE) {
+			xfs_alert(mp,
+		"Filesystem block size invalid for DAX Turning DAX off.");
+			mp->m_flags &= ~XFS_MOUNT_DAX;
+		} else if (!sb->s_bdev->bd_disk->fops->direct_access) {
+			xfs_alert(mp,
+		"Block device does not support DAX Turning DAX off.");
+			mp->m_flags &= ~XFS_MOUNT_DAX;
+		}
+	}
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D076D7F63
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:51:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C389AC002
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 03:51:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jRJPXBSPKBN0ec41 for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 03:51:21 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: add initial DAX support
Date: Tue, 24 Mar 2015 21:51:06 +1100
Message-Id: <1427194266-2885-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194266-2885-1-git-send-email-david@fromorbit.com>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

Add initial DAX support to XFS. To do this we need a new mount
option to turn DAX on filesystem, and we need to propagate thi into
the inode flags whenever an inode is instantiated so that the
per-inode checks throughout the code Do The Right Thing.

There are still some things remaining to be done:

	- needs per-inode flags to mark inodes as DAX enabled, and
	  an inheritance flag to enable automatic filesystem
	  propagation of the property
	- fails occasionally with zero length writes instead of
	  ENOSPC errors, so error propagation inside/from the DAX
	  code need work
	- occasionally creates two extents rather than a single
	  larger extent like non-dax filesystems.
	- much more testing

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c  | 24 ++++++++++++------------
 fs/xfs/xfs_mount.h |  2 ++
 fs/xfs/xfs_super.c | 25 +++++++++++++++++++++++--
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 9ca5352..695d857 100644
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
index 8c995a2..cd44e88 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -179,6 +179,8 @@ typedef struct xfs_mount {
 						   allocator */
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
 
+#define XFS_MOUNT_DAX		(1ULL << 62)	/* TEST ONLY! */
+
 
 /*
  * Default minimum read and write sizes.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3ad0b17..0f26d7a 100644
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
@@ -1501,6 +1508,20 @@ xfs_fs_fill_super(
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

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8EGmmjI147415 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 11:48:48 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YmZ3popbi7zhC7NB for
	<xfs@oss.sgi.com>; Fri, 14 Sep 2012 09:49:54 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8EGnsUX027630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 12:49:54 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-109.phx2.redhat.com
	[10.3.113.109])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8EGnk0U019005
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 12:49:53 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/4] xfs: make inode64 as the default allocation mode
Date: Fri, 14 Sep 2012 13:49:38 -0300
Message-Id: <1347641381-30050-2-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1347641381-30050-1-git-send-email-cmaiolino@redhat.com>
References: <1347641381-30050-1-git-send-email-cmaiolino@redhat.com>
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

since 64-bit inodes can be accessed while using inode32, and these can also be
used on 32-bit kernels, there is no reason to still keep inode32 as the default
mount option.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_super.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f1f2968..967d024 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -88,6 +88,8 @@ mempool_t *xfs_ioend_pool;
 					 * unwritten extent conversion */
 #define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
 #define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
+#define MNTOPT_32BITINODE   "inode32"	/* inode allocation limited to
+					 * XFS_MAXINUMBER_32 */
 #define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
 #define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
 #define MNTOPT_LARGEIO	   "largeio"	/* report large I/O sizes in stat() */
@@ -198,7 +200,6 @@ xfs_parseargs(
 	 */
 	mp->m_flags |= XFS_MOUNT_BARRIER;
 	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
 
 	/*
 	 * These can be overridden by the mount option parsing.
@@ -295,6 +296,13 @@ xfs_parseargs(
 				return EINVAL;
 			}
 			dswidth = simple_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
+			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+#if !XFS_BIG_INUMS
+			xfs_warn(mp, "%s option not allowed on this system",
+				this_char);
+			return EINVAL;
+#endif
 		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
 			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
 #if !XFS_BIG_INUMS
@@ -493,13 +501,13 @@ xfs_showargs(
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
 		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
+		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_32BITINODE },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
 		/* the few simple ones we can get from the mount struct */
 		{ XFS_MOUNT_COMPAT_IOSIZE,	"," MNTOPT_LARGEIO },
 		{ XFS_MOUNT_BARRIER,		"," MNTOPT_NOBARRIER },
-		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_64BITINODE },
 		{ 0, NULL }
 	};
 	struct proc_xfs_info	*xfs_infop;
-- 
1.7.11.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8HGok48186634 for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 11:50:46 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dY4GyODIO6dCmKS1 for
	<xfs@oss.sgi.com>; Mon, 17 Sep 2012 09:51:56 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8HGpuGh009285
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 12:51:56 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-119.phx2.redhat.com
	[10.3.113.119])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q8HGpopH016371
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 12:51:55 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/4] xfs: make inode64 as the default allocation mode
Date: Mon, 17 Sep 2012 13:51:39 -0300
Message-Id: <1347900702-23421-2-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1347900702-23421-1-git-send-email-cmaiolino@redhat.com>
References: <1347900702-23421-1-git-send-email-cmaiolino@redhat.com>
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
 fs/xfs/xfs_super.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f1f2968..b1aa2db 100644
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
@@ -198,7 +200,9 @@ xfs_parseargs(
 	 */
 	mp->m_flags |= XFS_MOUNT_BARRIER;
 	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+#if !XFS_BIG_INUMS
 	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+#endif
 
 	/*
 	 * These can be overridden by the mount option parsing.
@@ -295,6 +299,8 @@ xfs_parseargs(
 				return EINVAL;
 			}
 			dswidth = simple_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
+			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
 		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
 			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
 #if !XFS_BIG_INUMS
@@ -493,13 +499,13 @@ xfs_showargs(
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

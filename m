Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KDWJQu088896 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 08:32:19 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PH1BtwtAgBLznFP9 for
	<xfs@oss.sgi.com>; Thu, 20 Sep 2012 06:33:32 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8KDXWEB016389
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 09:33:32 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-73.phx2.redhat.com
	[10.3.113.73])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8KDXRt4019074
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 09:33:31 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/6] xfs: make inode64 as the default allocation mode
Date: Thu, 20 Sep 2012 10:32:37 -0300
Message-Id: <1348147961-7520-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
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
If the filesystem cannot handle 64bit inode numbers (i.e CONFIG_LBDAF is not
enabled and BITS_PER_LONG == 32), XFS_MOUNT_SMALL_INUMS will still be set by
default, so inode64 is not an unconditional default value.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f1f2968..7686eee 100644
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
@@ -493,6 +499,7 @@ xfs_showargs(
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
 		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
+		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_32BITINODE },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
-- 
1.7.11.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1AJVR6h073204 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 13:31:27 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C887B1CBE071
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 11:32:39 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id pXynTW3AaF1xs8Zn for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2010 11:32:39 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 7C6BA8F4FF6
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 13:32:39 -0600 (CST)
Message-ID: <4B7309D7.5090800@sandeen.net>
Date: Wed, 10 Feb 2010 13:32:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] enable inode64 by default when possible
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Taking another swing at this.

As XFS continues to position itself as the choice for very
large Linux filesystems, we need to be mindful of the problems
that the 32-bit inode restriction can cause with allocations
and performance.

As such, this patch changes the default to inode64 whenever
XFS_BIG_INUMS is set, which in turn depends on either
CONFIG_LBDAF or 64-bit longs.

Going forward, we may wish to do this unconditionally for all
filesystems by choosing CONFIG_LBDAF by default when xfs is
chosen, but I'll leave that for later.

This patch adds a "noinode64" option for backwards compatibility.

(Minor update to documentation for "nobarrier" as well, which
had not been previously documented).

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 9878f50..05b845a 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -37,7 +37,10 @@ When mounting an XFS filesystem, the following options are accepted.
 	Enables the use of block layer write barriers for writes into
 	the journal and unwritten extent conversion.  This allows for
 	drive level write caching to be enabled, for devices that
-	support write barriers.
+	support write barriers.  This is the default.
+
+  nobarrier
+	Disables the use of block layer write barriers.
 
   dmapi
 	Enable the DMAPI (Data Management API) event callouts.
@@ -66,8 +69,16 @@ When mounting an XFS filesystem, the following options are accepted.
 	Indicates that XFS is allowed to create inodes at any location
 	in the filesystem, including those which will result in inode
 	numbers occupying more than 32 bits of significance.  This is
-	provided for backwards compatibility, but causes problems for
-	backup applications that cannot handle large inode numbers.
+	the default for 64-bit or CONFIG_LBDAF kernels as of 2.6.33.
+
+  noinode64
+	Indicates that XFS must create inodes in filesystem locations
+	which will not result in inode numbers occupying more than 32
+	bits of significance.  This is provided for backwards compatibility,
+	for 32-bit applications which may not use the 64-bit stat interface,
+	such as backup applications that cannot handle large inode numbers.
+	Note that this only affects new inode creation; existing 64-bit
+	inode locations are unaffected.
 
   largeio/nolargeio
 	If "nolargeio" is specified, the optimal I/O reported in
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 97c0f5a..7c74965 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -95,6 +95,7 @@ mempool_t *xfs_ioend_pool;
 #define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
 #define MNTOPT_OSYNCISOSYNC "osyncisosync" /* o_sync is REALLY o_sync */
 #define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
+#define MNTOPT_32BITINODE   "noinode64"	/* inodes allocated in 32-bit range */
 #define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
 #define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
 #define MNTOPT_LARGEIO	   "largeio"	/* report large I/O sizes in stat() */
@@ -196,7 +197,9 @@ xfs_parseargs(
 	 */
 	mp->m_flags |= XFS_MOUNT_BARRIER;
 	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+#ifndef XFS_BIG_INUMS
 	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+#endif
 
 	/*
 	 * These can be overridden by the mount option parsing.
@@ -317,6 +320,8 @@ xfs_parseargs(
 				this_char);
 			return EINVAL;
 #endif
+		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
+			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
 		} else if (!strcmp(this_char, MNTOPT_NOUUID)) {
 			mp->m_flags |= XFS_MOUNT_NOUUID;
 		} else if (!strcmp(this_char, MNTOPT_BARRIER)) {
@@ -534,6 +539,7 @@ xfs_showargs(
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
 		{ XFS_MOUNT_DMAPI,		"," MNTOPT_DMAPI },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
+		{ XFS_MOUNT_SMALL_INUMS,	"," MNTOPT_32BITINODE },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

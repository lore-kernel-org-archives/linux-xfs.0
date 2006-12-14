Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Dec 2006 10:05:17 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBEI59qw014981
	for <xfs@oss.sgi.com>; Thu, 14 Dec 2006 10:05:11 -0800
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kBEI4I9q010064
	for <xfs@oss.sgi.com>; Thu, 14 Dec 2006 13:04:18 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kBEI4Ipa025732
	for <xfs@oss.sgi.com>; Thu, 14 Dec 2006 13:04:18 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kBEI4HS1002807
	for <xfs@oss.sgi.com>; Thu, 14 Dec 2006 13:04:17 -0500
Message-ID: <45819221.70502@sandeen.net>
Date: Thu, 14 Dec 2006 12:04:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] use vfs-defined file attribute flags
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

the vfs finally has common flags defined for this stuff, rather than
forcing filesystems to re-define what ext2 has already done.  Seems
like XFS could use them instead of open-coding them.

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.19/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6.19.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux-2.6.19/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1095,11 +1095,11 @@ xfs_ioc_fsgeometry(
 /*
  * Linux extended inode flags interface.
  */
-#define LINUX_XFLAG_SYNC	0x00000008 /* Synchronous updates */
-#define LINUX_XFLAG_IMMUTABLE	0x00000010 /* Immutable file */
-#define LINUX_XFLAG_APPEND	0x00000020 /* writes to file may only append */
-#define LINUX_XFLAG_NODUMP	0x00000040 /* do not dump file */
-#define LINUX_XFLAG_NOATIME	0x00000080 /* do not update atime */
+#define LINUX_XFLAG_SYNC	FS_SYNC_FL	/* Synchronous updates */
+#define LINUX_XFLAG_IMMUTABLE	FS_IMMUTABLE_FL	/* Immutable file */
+#define LINUX_XFLAG_APPEND	FS_APPEND_FL	/* writes may only append */
+#define LINUX_XFLAG_NODUMP	FS_NODUMP_FL	/* do not dump file */
+#define LINUX_XFLAG_NOATIME	FS_NOATIME_FL	/* do not update atime */
 
 STATIC unsigned int
 xfs_merge_ioc_xflags(

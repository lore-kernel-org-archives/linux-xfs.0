Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:50389 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbfHNUn7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 16:43:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v5 01/18] xfs: compat_ioctl: use compat_ptr()
Date: Wed, 14 Aug 2019 22:42:28 +0200
Message-Id: <20190814204259.120942-2-arnd@arndb.de>
In-Reply-To: <20190814204259.120942-1-arnd@arndb.de>
References: <20190814204259.120942-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Brian Foster <bfoster@redhat.com>, Allison Collins <allison.henderson@oracle.com>, Nick Bowler <nbowler@draconx.ca>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <dchinner@redhat.com>

For 31-bit s390 user space, we have to pass pointer arguments through
compat_ptr() in the compat_ioctl handler.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/xfs_ioctl32.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 7fcf7569743f..ad91e81a2fcf 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -547,7 +547,7 @@ xfs_file_compat_ioctl(
 	struct inode		*inode = file_inode(filp);
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	void			__user *arg = (void __user *)p;
+	void			__user *arg = compat_ptr(p);
 	int			error;
 
 	trace_xfs_file_compat_ioctl(ip);
@@ -576,7 +576,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_SCRUB_METADATA:
 	case XFS_IOC_BULKSTAT:
 	case XFS_IOC_INUMBERS:
-		return xfs_file_ioctl(filp, cmd, p);
+		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);
 #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
 	/*
 	 * These are handled fine if no alignment issues.  To support x32
@@ -602,7 +602,7 @@ xfs_file_compat_ioctl(
 	 */
 	case XFS_IOC_SWAPEXT:
 #endif
-		return xfs_file_ioctl(filp, cmd, p);
+		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);
 #endif
 #if defined(BROKEN_X86_ALIGNMENT)
 	case XFS_IOC_ALLOCSP_32:
@@ -653,7 +653,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_SETXFLAGS_32:
 	case XFS_IOC_GETVERSION_32:
 		cmd = _NATIVE_IOC(cmd, long);
-		return xfs_file_ioctl(filp, cmd, p);
+		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);
 	case XFS_IOC_SWAPEXT_32: {
 		struct xfs_swapext	  sxp;
 		struct compat_xfs_swapext __user *sxu = arg;
-- 
2.20.0

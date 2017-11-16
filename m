Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47649 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932768AbdKPBPJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 20:15:09 -0500
Date: Wed, 15 Nov 2017 17:15:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH for 4.15] libxfs: fix dev_t handling in inode forks
Message-ID: <20171116011505.GH5119@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit 699f676961 ("xfs: remove if_rdev"), some ancient definitions
of MAJOR/MINOR/MKDEV were ported into libxfs.  However, platform_defs.h
already has IRIX_DEV_* macros which encode a (major, minor) tuple into a
(major:14, minor:18) u32 format.  libxfs writes these values to disk
without any further interpretation.

Existing libxfs clients pass these encoded device numbers into libxfs,
which means that we cannot suddenly start interpreting the bit fields
differently.  The ported MAJOR/MINOR does this (major:8, minor:8), with
the result that proto file specs for block/char devices write
bit-shifted garbage into i_rdev.

(Or at least it would write garbage if libxfs_ialloc hadn't also lost
the ability to set i_rdev in the same patch...)

Therefore, just keep using the "IRIX" device encoding macros in
platform_defs.h, and actually set i_rdev in libxfs_ialloc when someone
tries to create a device file.  This fixes a regression in xfs/019.

Cc: sandeen@sandeen.net
Fixes: 699f67696151d750a58c321b072360ccc694837b
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_priv.h |   18 ++++--------------
 libxfs/util.c        |    1 +
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 8c3f3b7..4c083b9 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -87,23 +87,13 @@ extern char    *progname;
 #undef ASSERT
 #define ASSERT(ex) assert(ex)
 
-#define MAJOR(dev)      ((dev)>>8)
-#define MINOR(dev)      ((dev) & 0xff)
-#define MKDEV(ma,mi) ((ma)<<8 | (mi))
-
-static inline unsigned sysv_major(uint32_t dev)
-{
-        return (dev >> 18) & 0x3fff;
-}
-
-static inline unsigned sysv_minor(uint32_t dev)
-{
-        return dev & 0x3ffff;
-}
+#define MKDEV(major, minor)	IRIX_MKDEV(major, minor)
+#define sysv_major(dev)		IRIX_DEV_MAJOR(dev)
+#define sysv_minor(dev)		IRIX_DEV_MINOR(dev)
 
 static inline uint32_t sysv_encode_dev(dev_t dev)
 {
-        return MINOR(dev) | (MAJOR(dev) << 18);
+        return IRIX_DEV_MINOR(dev) | (IRIX_DEV_MAJOR(dev) << 18);
 }
 
 #ifndef EWRONGFS
diff --git a/libxfs/util.c b/libxfs/util.c
index 90f96f8..792a17f 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -336,6 +336,7 @@ libxfs_ialloc(
 	case S_IFBLK:
 		ip->i_d.di_format = XFS_DINODE_FMT_DEV;
 		flags |= XFS_ILOG_DEV;
+		VFS_I(ip)->i_rdev = rdev;
 		break;
 	case S_IFREG:
 	case S_IFDIR:

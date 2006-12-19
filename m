Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Dec 2006 08:54:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBJGs0qw027217
	for <xfs@oss.sgi.com>; Tue, 19 Dec 2006 08:54:01 -0800
Message-ID: <458818ED.1040208@sandeen.net>
Date: Tue, 19 Dec 2006 10:53:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] use vfs-defined file attribute flags
References: <45819221.70502@sandeen.net> <20061214181500.GA13856@infradead.org> <45819630.3070701@sandeen.net>
In-Reply-To: <45819630.3070701@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

Eric Sandeen wrote:

> Christoph Hellwig wrote:
>   
>> Just kill the defines completly and use the FS_ flags
Ugh maybe I should test build when I change stuff eh.

This one builds, even :)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.19/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6.19.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux-2.6.19/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1095,11 +1095,6 @@ xfs_ioc_fsgeometry(
 /*
  * Linux extended inode flags interface.
  */
-#define LINUX_XFLAG_SYNC	0x00000008 /* Synchronous updates */
-#define LINUX_XFLAG_IMMUTABLE	0x00000010 /* Immutable file */
-#define LINUX_XFLAG_APPEND	0x00000020 /* writes to file may only append */
-#define LINUX_XFLAG_NODUMP	0x00000040 /* do not dump file */
-#define LINUX_XFLAG_NOATIME	0x00000080 /* do not update atime */
 
 STATIC unsigned int
 xfs_merge_ioc_xflags(
@@ -1108,23 +1103,23 @@ xfs_merge_ioc_xflags(
 {
 	unsigned int	xflags = start;
 
-	if (flags & LINUX_XFLAG_IMMUTABLE)
+	if (flags & FS_IMMUTABLE_FL)
 		xflags |= XFS_XFLAG_IMMUTABLE;
 	else
 		xflags &= ~XFS_XFLAG_IMMUTABLE;
-	if (flags & LINUX_XFLAG_APPEND)
+	if (flags & FS_APPEND_FL)
 		xflags |= XFS_XFLAG_APPEND;
 	else
 		xflags &= ~XFS_XFLAG_APPEND;
-	if (flags & LINUX_XFLAG_SYNC)
+	if (flags & FS_SYNC_FL)
 		xflags |= XFS_XFLAG_SYNC;
 	else
 		xflags &= ~XFS_XFLAG_SYNC;
-	if (flags & LINUX_XFLAG_NOATIME)
+	if (flags & FS_NOATIME_FL)
 		xflags |= XFS_XFLAG_NOATIME;
 	else
 		xflags &= ~XFS_XFLAG_NOATIME;
-	if (flags & LINUX_XFLAG_NODUMP)
+	if (flags & FS_NODUMP_FL)
 		xflags |= XFS_XFLAG_NODUMP;
 	else
 		xflags &= ~XFS_XFLAG_NODUMP;
@@ -1139,15 +1134,15 @@ xfs_di2lxflags(
 	unsigned int	flags = 0;
 
 	if (di_flags & XFS_DIFLAG_IMMUTABLE)
-		flags |= LINUX_XFLAG_IMMUTABLE;
+		flags |= FS_IMMUTABLE_FL;
 	if (di_flags & XFS_DIFLAG_APPEND)
-		flags |= LINUX_XFLAG_APPEND;
+		flags |= FS_APPEND_FL;
 	if (di_flags & XFS_DIFLAG_SYNC)
-		flags |= LINUX_XFLAG_SYNC;
+		flags |= FS_SYNC_FL;
 	if (di_flags & XFS_DIFLAG_NOATIME)
-		flags |= LINUX_XFLAG_NOATIME;
+		flags |= FS_NOATIME_FL;
 	if (di_flags & XFS_DIFLAG_NODUMP)
-		flags |= LINUX_XFLAG_NODUMP;
+		flags |= FS_NODUMP_FL;
 	return flags;
 }
 
@@ -1247,9 +1242,9 @@ xfs_ioc_xattr(
 			break;
 		}
 
-		if (flags & ~(LINUX_XFLAG_IMMUTABLE | LINUX_XFLAG_APPEND | \
-			      LINUX_XFLAG_NOATIME | LINUX_XFLAG_NODUMP | \
-			      LINUX_XFLAG_SYNC)) {
+		if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
+			      FS_NOATIME_FL | FS_NODUMP_FL | \
+			      FS_SYNC_FL)) {
 			error = -EOPNOTSUPP;
 			break;
 		}

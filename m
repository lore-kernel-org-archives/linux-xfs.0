Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46255 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754103AbcJYXEc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:04:32 -0400
Subject: [PATCH 08/39] xfs: create a separate cow extent size hint for the
 allocator
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:04:27 -0700
Message-ID: <147743666736.11035.6802622469574269372.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Create a per-inode extent size allocator hint for copy-on-write.  This
hint is separate from the existing extent size hint so that CoW can
take advantage of the fragmentation-reducing properties of extent size
hints without disabling delalloc for regular writes.

The extent size hint that's fed to the allocator during a copy on
write operation is the greater of the cowextsize and regular extsize
hint.

During reflink, if we're sharing the entire source file to the entire
destination file and the destination file doesn't already have a
cowextsize hint, propagate the source file's cowextsize hint to the
destination file.

[Plumb in the appropriate fsxattr flags and fields in the headers.]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/darwin.h  |    7 ++++++-
 include/freebsd.h |    6 +++++-
 include/irix.h    |    6 +++++-
 include/linux.h   |    7 ++++++-
 4 files changed, 22 insertions(+), 4 deletions(-)


diff --git a/include/darwin.h b/include/darwin.h
index 4132bfd..6c9f87a 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -292,7 +292,8 @@ struct fsxattr {
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/
 	__u32		fsx_nextents;	/* nextents field value (get)	*/
 	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
+	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
+	unsigned char	fsx_pad[8];
 };
 
 /*
@@ -320,4 +321,8 @@ struct fsxattr {
 
 #endif
 
+#ifndef FS_XFLAG_COWEXTSIZE
+#define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+#endif
+
 #endif	/* __XFS_DARWIN_H__ */
diff --git a/include/freebsd.h b/include/freebsd.h
index 32268ef..72935ec 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -181,7 +181,8 @@ struct fsxattr {
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/
 	__u32		fsx_nextents;	/* nextents field value (get)	*/
 	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
+	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
+	unsigned char	fsx_pad[8];
 };
 
 /*
@@ -209,5 +210,8 @@ struct fsxattr {
 
 #endif
 
+#ifndef FS_XFLAG_COWEXTSIZE
+#define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+#endif
 
 #endif	/* __XFS_FREEBSD_H__ */
diff --git a/include/irix.h b/include/irix.h
index 6094b8a..8bbcbd8 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -427,7 +427,8 @@ struct fsxattr {
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/
 	__u32		fsx_nextents;	/* nextents field value (get)	*/
 	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
+	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
+	unsigned char	fsx_pad[8];
 };
 
 /*
@@ -455,6 +456,9 @@ struct fsxattr {
 
 #endif
 
+#ifndef FS_XFLAG_COWEXTSIZE
+#define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+#endif
 
 /**
  * Abstraction of mountpoints.
diff --git a/include/linux.h b/include/linux.h
index 06f1af4..ddc053e 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -181,7 +181,8 @@ struct fsxattr {
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/
 	__u32		fsx_nextents;	/* nextents field value (get)	*/
 	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
+	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
+	unsigned char	fsx_pad[8];
 };
 
 /*
@@ -209,4 +210,8 @@ struct fsxattr {
 
 #endif
 
+#ifndef FS_XFLAG_COWEXTSIZE
+#define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+#endif
+
 #endif	/* __XFS_LINUX_H__ */


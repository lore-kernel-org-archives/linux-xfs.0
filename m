Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 30A7C832E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:41:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2FC7304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:41:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id GBPUS7JF3wCG4CBV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:41:19 -0700 (PDT)
Subject: [PATCH 099/145] xfs: support FS_XFLAG_REFLINK on reflink filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:41:12 -0700
Message-ID: <146612767278.16048.8454443224198853352.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Add support for reporting the "reflink" inode flag in the XFS-specific
getxflags ioctl, and allow the user to clear the flag if file size is
zero.

v2: Move the reflink flag out of the way of the DAX flag, and add the
new cowextsize flag.

v3: do not report (or allow changes to) FL_NOCOW_FL, since we don't
support a flag to prevent CoWing and the reflink flag is a poor
proxy.  We'll try to design away the need for the NOCOW flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/darwin.h  |    2 ++
 include/freebsd.h |    2 ++
 include/irix.h    |    2 ++
 include/linux.h   |    2 ++
 4 files changed, 8 insertions(+)


diff --git a/include/darwin.h b/include/darwin.h
index 2935b4c..abb2a22 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -314,6 +314,8 @@ struct fsxattr {
 #define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
+#define FS_XFLAG_REFLINK	0x00010000	/* file is reflinked */
+#define FS_XFLAG_COWEXTSIZE	0x00020000	/* CoW extent size allocator hint */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 #define FS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)
diff --git a/include/freebsd.h b/include/freebsd.h
index 3feca07..fc58a74 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -204,6 +204,8 @@ struct fsxattr {
 #define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
+#define FS_XFLAG_REFLINK	0x00010000	/* file is reflinked */
+#define FS_XFLAG_COWEXTSIZE	0x00020000	/* CoW extent size allocator hint */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 #define FS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)
diff --git a/include/irix.h b/include/irix.h
index 45c8594..c4d25b5 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -449,6 +449,8 @@ struct fsxattr {
 #define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
+#define FS_XFLAG_REFLINK	0x00010000	/* file is reflinked */
+#define FS_XFLAG_COWEXTSIZE	0x00020000	/* CoW extent size allocator hint */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 #define FS_IOC_FSGETXATTR		F_FSGETXATTR
diff --git a/include/linux.h b/include/linux.h
index cd4b3eb..d47a29c 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -207,6 +207,8 @@ struct fsxattr {
 #define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
+#define FS_XFLAG_REFLINK	0x00010000	/* file is reflinked */
+#define FS_XFLAG_COWEXTSIZE	0x00020000	/* CoW extent size allocator hint */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 #define FS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E9DC81A1
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:50:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 11250304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:50:13 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4XdIANjMATwyd3ST (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:50:11 -0700 (PDT)
Subject: [PATCH 33/71] xfs: support FS_XFLAG_REFLINK on reflink filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:50:05 -0700
Message-ID: <147216900528.4420.3049697376537013476.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

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
 include/darwin.h  |    8 ++++++++
 include/freebsd.h |    7 +++++++
 include/irix.h    |    7 +++++++
 include/linux.h   |    8 ++++++++
 4 files changed, 30 insertions(+)


diff --git a/include/darwin.h b/include/darwin.h
index 140386a..71a63a1 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -320,4 +320,12 @@ struct fsxattr {
 
 #endif
 
+#ifndef FS_XFLAG_REFLINK
+#define FS_XFLAG_REFLINK	0x00010000	/* file is reflinked */
+#endif
+
+#ifndef FS_XFLAG_COWEXTSIZE
+#define FS_XFLAG_COWEXTSIZE	0x00020000	/* CoW extent size allocator hint */
+#endif
+
 #endif	/* __XFS_DARWIN_H__ */
diff --git a/include/freebsd.h b/include/freebsd.h
index 668dcea..e8970a5 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -209,5 +209,12 @@ struct fsxattr {
 
 #endif
 
+#ifndef FS_XFLAG_REFLINK
+#define FS_XFLAG_REFLINK	0x00010000	/* file is reflinked */
+#endif
+
+#ifndef FS_XFLAG_COWEXTSIZE
+#define FS_XFLAG_COWEXTSIZE	0x00020000	/* CoW extent size allocator hint */
+#endif
 
 #endif	/* __XFS_FREEBSD_H__ */
diff --git a/include/irix.h b/include/irix.h
index 8b9d588..fea7c7c 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -454,6 +454,13 @@ struct fsxattr {
 
 #endif
 
+#ifndef FS_XFLAG_REFLINK
+#define FS_XFLAG_REFLINK	0x00010000	/* file is reflinked */
+#endif
+
+#ifndef FS_XFLAG_COWEXTSIZE
+#define FS_XFLAG_COWEXTSIZE	0x00020000	/* CoW extent size allocator hint */
+#endif
 
 /**
  * Abstraction of mountpoints.
diff --git a/include/linux.h b/include/linux.h
index 1663930..67337d6 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -209,4 +209,12 @@ struct fsxattr {
 
 #endif
 
+#ifndef FS_XFLAG_REFLINK
+#define FS_XFLAG_REFLINK	0x00010000	/* file is reflinked */
+#endif
+
+#ifndef FS_XFLAG_COWEXTSIZE
+#define FS_XFLAG_COWEXTSIZE	0x00020000	/* CoW extent size allocator hint */
+#endif
+
 #endif	/* __XFS_LINUX_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

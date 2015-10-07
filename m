Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3CE617F78
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 06:17:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABFE6AC006
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 04:17:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1DGFXuTzzCLyrsiE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 04:17:17 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 04/14 v2] xfsprogs: prefix XATTR_LIST_MAX with XFS_
Date: Wed,  7 Oct 2015 13:17:12 +0200
Message-Id: <1444216632-6520-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1442311164-12921-5-git-send-email-jtulak@redhat.com>
References: <1442311164-12921-5-git-send-email-jtulak@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Tulak <jtulak@redhat.com>

UPDATE:
- moved define from include/xfs.h to libxfs/xfs_fs.h

As we depends on XATTR_ value that is available only on some
platforms, prefix it with XFS_ and allow for an alternative value
in future.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 libhandle/handle.c | 4 ++--
 libhandle/jdm.c    | 4 ++--
 libxfs/xfs_fs.h    | 9 +++++++++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/libhandle/handle.c b/libhandle/handle.c
index b1c0c10..7207186 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -397,8 +397,8 @@ attr_list_by_handle(
 	alhreq.buffer = buf;
 	alhreq.buflen = bufsize;
 	/* prevent needless EINVAL from the kernel */
-	if (alhreq.buflen > XATTR_LIST_MAX)
-		alhreq.buflen = XATTR_LIST_MAX;
+	if (alhreq.buflen > XFS_XATTR_LIST_MAX)
+		alhreq.buflen = XFS_XATTR_LIST_MAX;
 
 	error = xfsctl(path, fd, XFS_IOC_ATTRLIST_BY_HANDLE, &alhreq);
 
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index d804423..e52f5d8 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -168,8 +168,8 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 	int rval;
 
 	/* prevent needless EINVAL from the kernel */
-	if (bufsz > XATTR_LIST_MAX)
-		bufsz = XATTR_LIST_MAX;
+	if (bufsz > XFS_XATTR_LIST_MAX)
+		bufsz = XFS_XATTR_LIST_MAX;
 
 	jdm_fill_filehandle( &filehandle, fshandlep, statp );
 	rval = attr_list_by_handle (( void * )&filehandle,
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 89689c6..3a86d7d 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -490,6 +490,15 @@ typedef struct xfs_swapext
 #define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
 
 /*
+ * ioctl limits
+ */
+#ifdef XATTR_LIST_MAX
+#  define XFS_XATTR_LIST_MAX XATTR_LIST_MAX
+#else
+#  define XFS_XATTR_LIST_MAX 65536
+#endif
+
+/*
  * ioctl commands that are used by Linux filesystems
  */
 #define XFS_IOC_GETXFLAGS	FS_IOC_GETFLAGS
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

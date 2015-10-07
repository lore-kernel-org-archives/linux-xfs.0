Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8F81B7F85
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 06:10:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6E1038F8033
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 04:10:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1YqxCyDDHSen5ERm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 04:10:49 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 3E622341AC4
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 11:10:49 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 1/2] xfs: prefix XATTR_LIST_MAX with XFS_
Date: Wed,  7 Oct 2015 13:10:36 +0200
Message-Id: <1444216236-6354-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1444216071-6281-1-git-send-email-jtulak@redhat.com>
References: <1444216071-6281-1-git-send-email-jtulak@redhat.com>
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

Remove a hard dependency of Linux XATTR_LIST_MAX value by using
a prefixed version. This patch reflects the same change in xfsprogs.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h | 10 ++++++++++
 fs/xfs/xfs_ioctl.c     |  2 +-
 fs/xfs/xfs_ioctl32.c   |  2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 89689c6..b2b73a9 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -490,6 +490,16 @@ typedef struct xfs_swapext
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
+
+/*
  * ioctl commands that are used by Linux filesystems
  */
 #define XFS_IOC_GETXFLAGS	FS_IOC_GETFLAGS
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ea7d85a..0e692a6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -411,7 +411,7 @@ xfs_attrlist_by_handle(
 	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
 		return -EFAULT;
 	if (al_hreq.buflen < sizeof(struct attrlist) ||
-	    al_hreq.buflen > XATTR_LIST_MAX)
+	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
 		return -EINVAL;
 
 	/*
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index b88bdc8..1a05d8a 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -356,7 +356,7 @@ xfs_compat_attrlist_by_handle(
 			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
 		return -EFAULT;
 	if (al_hreq.buflen < sizeof(struct attrlist) ||
-	    al_hreq.buflen > XATTR_LIST_MAX)
+	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
 		return -EINVAL;
 
 	/*
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

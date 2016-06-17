Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B71418053
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:31:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 873D6304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:40 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id wByeBAlxzmoRRiei (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:39 -0700 (PDT)
Subject: [PATCH 007/145] xfs: define XFS_IOC_FREEZE even if FIFREEZE is defined
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:31:29 -0700
Message-ID: <146612708926.16048.13122914973767530118.stgit@birch.djwong.org>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

From: Christoph Hellwig <hch@lst.de>

And the same for XFS_IOC_THAW.  Just because we now have a common
version of the ioctl we still need to provide the old name for it
for anyone using those.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_fs.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index b9622ba..1f17e1c 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -542,12 +542,8 @@ typedef struct xfs_swapext
 #define XFS_IOC_ERROR_CLEARALL	     _IOW ('X', 117, struct xfs_error_injection)
 /*	XFS_IOC_ATTRCTL_BY_HANDLE -- deprecated 118	 */
 
-/*	XFS_IOC_FREEZE		  -- FIFREEZE   119	 */
-/*	XFS_IOC_THAW		  -- FITHAW     120	 */
-#ifndef FIFREEZE
-#define XFS_IOC_FREEZE		     _IOWR('X', 119, int)
-#define XFS_IOC_THAW		     _IOWR('X', 120, int)
-#endif
+#define XFS_IOC_FREEZE		     _IOWR('X', 119, int)	/* aka FIFREEZE */
+#define XFS_IOC_THAW		     _IOWR('X', 120, int)	/* aka FITHAW */
 
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

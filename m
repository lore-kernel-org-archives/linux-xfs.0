Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A0ED87F83
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 13:03:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 71E0A8F804B
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 11:03:24 -0700 (PDT)
Date: Thu, 31 Oct 2013 21:00:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] xfs: underflow bug in xfs_attrlist_by_handle()
Message-ID: <20131031180010.GA24839@longonot.mountain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131025144452.GA28451@ngolde.de>
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
To: Ben Myers <bpm@sgi.com>
Cc: Fabian Yamaguchi <fabs@goesec.de>, security@kernel.org, Alex Elder <elder@kernel.org>, Nico Golde <nico@ngolde.de>, xfs@oss.sgi.com

If we allocate less than sizeof(struct attrlist) then we end up
corrupting memory or doing a ZERO_PTR_SIZE dereference.

This can only be triggered with CAP_SYS_ADMIN.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4d61340..33ad9a7 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -442,7 +442,8 @@ xfs_attrlist_by_handle(
 		return -XFS_ERROR(EPERM);
 	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
+	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	    al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
 	/*
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index e8fb123..a7992f8 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -356,7 +356,8 @@ xfs_compat_attrlist_by_handle(
 	if (copy_from_user(&al_hreq, arg,
 			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
+	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	    al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C8F977CD6
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 08:49:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8CB008F8037
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2016 06:49:01 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id JJ8kR9isO8UvGrFF (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2016 06:48:59 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aij9e-00013z-B6
	for xfs@oss.sgi.com; Wed, 23 Mar 2016 13:48:58 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] xfs: use ->readlink to implement the readlink_by_handle
	ioctl
Date: Wed, 23 Mar 2016 14:48:54 +0100
Message-Id: <1458740935-31260-4-git-send-email-hch@lst.de>
In-Reply-To: <1458740935-31260-1-git-send-email-hch@lst.de>
References: <1458740935-31260-1-git-send-email-hch@lst.de>
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

Also drop the now unused readlink_copy export.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/namei.c         |  1 -
 fs/xfs/xfs_ioctl.c | 18 ++----------------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f624d13..33b02dd 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4554,7 +4554,6 @@ int readlink_copy(char __user *buffer, int buflen, const char *link)
 out:
 	return len;
 }
-EXPORT_SYMBOL(readlink_copy);
 
 /*
  * A helper for ->readlink().  This should be used *ONLY* for symlinks that
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bcb6c19..68569b8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -277,7 +277,6 @@ xfs_readlink_by_handle(
 {
 	struct dentry		*dentry;
 	__u32			olen;
-	void			*link;
 	int			error;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -288,7 +287,7 @@ xfs_readlink_by_handle(
 		return PTR_ERR(dentry);
 
 	/* Restrict this handle operation to symlinks only. */
-	if (!d_is_symlink(dentry)) {
+	if (!dentry->d_inode->i_op->readlink) {
 		error = -EINVAL;
 		goto out_dput;
 	}
@@ -298,21 +297,8 @@ xfs_readlink_by_handle(
 		goto out_dput;
 	}
 
-	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
-	if (!link) {
-		error = -ENOMEM;
-		goto out_dput;
-	}
-
-	error = xfs_readlink(XFS_I(d_inode(dentry)), link);
-	if (error)
-		goto out_kfree;
-	error = readlink_copy(hreq->ohandle, olen, link);
-	if (error)
-		goto out_kfree;
+	error = dentry->d_inode->i_op->readlink(dentry, hreq->ohandle, olen);
 
- out_kfree:
-	kfree(link);
  out_dput:
 	dput(dentry);
 	return error;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

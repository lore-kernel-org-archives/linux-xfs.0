Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6D17A7F59
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 14:09:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06ED7AC001
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2015 12:08:56 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6SEZ38scXXUnrMrp (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2015 12:08:55 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] xfs: use ->readlink to implement the readlink_by_handle
	ioctl
Date: Thu, 23 Apr 2015 21:07:42 +0200
Message-Id: <1429816064-10033-5-git-send-email-hch@lst.de>
In-Reply-To: <1429816064-10033-1-git-send-email-hch@lst.de>
References: <1429816064-10033-1-git-send-email-hch@lst.de>
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
Cc: viro@zeniv.linux.org.uk

Also drop the now unused readlink_copy export.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/namei.c         |  1 -
 fs/xfs/xfs_ioctl.c | 19 ++-----------------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c83145a..482c6a9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4420,7 +4420,6 @@ int readlink_copy(char __user *buffer, int buflen, const char *link)
 out:
 	return len;
 }
-EXPORT_SYMBOL(readlink_copy);
 
 /*
  * A helper for ->readlink().  This should be used *ONLY* for symlinks that
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5f4a396..597609e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -276,7 +276,6 @@ xfs_readlink_by_handle(
 {
 	struct dentry		*dentry;
 	__u32			olen;
-	void			*link;
 	int			error;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -287,7 +286,7 @@ xfs_readlink_by_handle(
 		return PTR_ERR(dentry);
 
 	/* Restrict this handle operation to symlinks only. */
-	if (!d_is_symlink(dentry)) {
+	if (!dentry->d_inode->i_op->readlink) {
 		error = -EINVAL;
 		goto out_dput;
 	}
@@ -297,21 +296,7 @@ xfs_readlink_by_handle(
 		goto out_dput;
 	}
 
-	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
-	if (!link) {
-		error = -ENOMEM;
-		goto out_dput;
-	}
-
-	error = xfs_readlink(XFS_I(dentry->d_inode), link);
-	if (error)
-		goto out_kfree;
-	error = readlink_copy(hreq->ohandle, olen, link);
-	if (error)
-		goto out_kfree;
-
- out_kfree:
-	kfree(link);
+	error = dentry->d_inode->i_op->readlink(dentry, hreq->ohandle, olen);
  out_dput:
 	dput(dentry);
 	return error;
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

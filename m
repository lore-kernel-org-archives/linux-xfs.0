Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n38789wl072317 for <xfs@oss.sgi.com>; Wed, 8 Apr 2009 02:08:19 -0500
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F4B21F91F3
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2009 00:07:28 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id PO5FDKmsJRUf96te for
	<xfs@oss.sgi.com>; Wed, 08 Apr 2009 00:07:28 -0700 (PDT)
Message-ID: <49DC4D54.3020001@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 15:08:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH 4/6] xfs: use memdup_user()
References: <49DC4CC0.9050805@cn.fujitsu.com>
In-Reply-To: <49DC4CC0.9050805@cn.fujitsu.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: felixb@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Remove open-coded memdup_user()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c   |   23 +++++++----------------
 fs/xfs/linux-2.6/xfs_ioctl32.c |   12 ++++--------
 2 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index d0b4994..34eaab6 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -489,17 +489,12 @@ xfs_attrmulti_attr_set(
 	if (len > XATTR_SIZE_MAX)
 		return EINVAL;
 
-	kbuf = kmalloc(len, GFP_KERNEL);
-	if (!kbuf)
-		return ENOMEM;
-
-	if (copy_from_user(kbuf, ubuf, len))
-		goto out_kfree;
+	kbuf = memdup_user(ubuf, len);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
 
 	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
 
- out_kfree:
-	kfree(kbuf);
 	return error;
 }
 
@@ -540,20 +535,16 @@ xfs_attrmulti_by_handle(
 	if (!size || size > 16 * PAGE_SIZE)
 		goto out_dput;
 
-	error = ENOMEM;
-	ops = kmalloc(size, GFP_KERNEL);
-	if (!ops)
+	ops = memdup_user(am_hreq.ops, size);
+	if (IS_ERR(ops)) {
+		error = PTR_ERR(ops);
 		goto out_dput;
-
-	error = EFAULT;
-	if (copy_from_user(ops, am_hreq.ops, size))
-		goto out_kfree_ops;
+	}
 
 	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
 	if (!attr_name)
 		goto out_kfree_ops;
 
-
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
 		ops[i].am_error = strncpy_from_user(attr_name,
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
index c70c4e3..0882d16 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -427,20 +427,16 @@ xfs_compat_attrmulti_by_handle(
 	if (!size || size > 16 * PAGE_SIZE)
 		goto out_dput;
 
-	error = ENOMEM;
-	ops = kmalloc(size, GFP_KERNEL);
-	if (!ops)
+	ops = memdup_user(compat_ptr(am_hreq.ops), size);
+	if (IS_ERR(ops)) {
+		error = PTR_ERR(ops);
 		goto out_dput;
-
-	error = EFAULT;
-	if (copy_from_user(ops, compat_ptr(am_hreq.ops), size))
-		goto out_kfree_ops;
+	}
 
 	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
 	if (!attr_name)
 		goto out_kfree_ops;
 
-
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
 		ops[i].am_error = strncpy_from_user(attr_name,
-- 
1.5.4.rc3


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

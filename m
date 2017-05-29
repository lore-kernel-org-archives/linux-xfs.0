Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34780 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751170AbdE2J1F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 May 2017 05:27:05 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: request for inclusion of 2 xfs patches
Message-ID: <89781cfb-b826-8d01-d054-f70b0e2d8439@suse.com>
Date: Mon, 29 May 2017 12:27:02 +0300
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------A8EC53F4909C3BADEEEF929F"
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

This is a multi-part message in MIME format.
--------------A8EC53F4909C3BADEEEF929F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello, 

I'd like to request the following two patches to be 
included in 4.4 stable: 

0facef7fb053 ("xfs: in _attrlist_by_handle, copy the cursor back to userspace")

2a6fba6d2311 ("xfs: only return -errno or success from attr ->put_listent")

The fix a failure in xfstest/269 and also enable the xfs' XFS_IOC_ATTRLIST_BY_HANDLE
ioctl to function properly. The first commit applies cleanly, whereas the second has 
a minor conflict due t spacing. Backport is attached. 

--------------A8EC53F4909C3BADEEEF929F
Content-Type: text/x-patch;
 name="0002-xfs-only-return-errno-or-success-from-attr-put_liste.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-xfs-only-return-errno-or-success-from-attr-put_liste.pa";
 filename*1="tch"

>From 42432ed1a893868c62df93005afab8a92de95986 Mon Sep 17 00:00:00 2001
From: Eric Sandeen <sandeen@sandeen.net>
Date: Wed, 6 Apr 2016 07:57:18 +1000
Subject: [PATCH 2/2] xfs: only return -errno or success from attr
 ->put_listent

Today, the put_listent formatters return either 1 or 0; if
they return 1, some callers treat this as an error and return
it up the stack, despite "1" not being a valid (negative)
error code.

The intent seems to be that if the input buffer is full,
we set seen_enough or set count = -1, and return 1;
but some callers check the return before checking the
seen_enough or count fields of the context.

Fix this by only returning non-zero for actual errors
encountered, and rely on the caller to first check the
return value, then check the values in the context to
decide what to do.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Acked-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/xfs/xfs_attr.h      |  1 +
 fs/xfs/xfs_attr_list.c |  8 +++-----
 fs/xfs/xfs_xattr.c     | 15 ++++++++++-----
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index dd4824589470..234331227c0c 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -112,6 +112,7 @@ typedef struct attrlist_cursor_kern {
  *========================================================================*/
 
 
+/* Return 0 on success, or -errno; other state communicated via *context */
 typedef int (*put_listent_func_t)(struct xfs_attr_list_context *, int,
 			      unsigned char *, int, int, unsigned char *);
 
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 4fa14820e2e2..c8be331a3196 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -108,16 +108,14 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 					   (int)sfe->namelen,
 					   (int)sfe->valuelen,
 					   &sfe->nameval[sfe->namelen]);
-
+			if (error)
+				return error;
 			/*
 			 * Either search callback finished early or
 			 * didn't fit it all in the buffer after all.
 			 */
 			if (context->seen_enough)
 				break;
-
-			if (error)
-				return error;
 			sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
 		}
 		trace_xfs_attr_list_sf_all(context);
@@ -581,7 +579,7 @@ xfs_attr_put_listent(
 		trace_xfs_attr_list_full(context);
 		alist->al_more = 1;
 		context->seen_enough = 1;
-		return 1;
+		return 0;
 	}
 
 	aep = (attrlist_ent_t *)&context->alist[context->firstu];
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 839b35ca21c6..e6dae28dfa1a 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -180,7 +180,7 @@ xfs_xattr_put_listent(
 	arraytop = context->count + prefix_len + namelen + 1;
 	if (arraytop > context->firstu) {
 		context->count = -1;	/* insufficient space */
-		return 1;
+		return 0;
 	}
 	offset = (char *)context->alist + context->count;
 	strncpy(offset, xfs_xattr_prefix(flags), prefix_len);
@@ -222,12 +222,15 @@ list_one_attr(const char *name, const size_t len, void *data,
 }
 
 ssize_t
-xfs_vn_listxattr(struct dentry *dentry, char *data, size_t size)
+xfs_vn_listxattr(
+	struct dentry	*dentry,
+	char		*data,
+	size_t		size)
 {
 	struct xfs_attr_list_context context;
 	struct attrlist_cursor_kern cursor = { 0 };
-	struct inode		*inode = d_inode(dentry);
-	int			error;
+	struct inode	*inode = d_inode(dentry);
+	int		error;
 
 	/*
 	 * First read the regular on-disk attributes.
@@ -245,7 +248,9 @@ xfs_vn_listxattr(struct dentry *dentry, char *data, size_t size)
 	else
 		context.put_listent = xfs_xattr_put_listent_sizes;
 
-	xfs_attr_list_int(&context);
+	error = xfs_attr_list_int(&context);
+	if (error)
+		return error;
 	if (context.count < 0)
 		return -ERANGE;
 
-- 
2.7.4


--------------A8EC53F4909C3BADEEEF929F--

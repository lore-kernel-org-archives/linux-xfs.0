Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E1227F61
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 05:53:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FB388F8052
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 03:53:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vNC7ooPMZloe9p9K for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 03:53:06 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGRkk-0000sb-G4
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 20:53:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGRkk-0008Au-Ex
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 20:53:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: factor all the kmalloc-or-vmalloc fallback
	allocations
Date: Mon,  2 Sep 2013 20:53:00 +1000
Message-Id: <1378119180-31380-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1378119180-31380-1-git-send-email-david@fromorbit.com>
References: <1378119180-31380-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

We have quite a few places now where we do:

	x = kmem_zalloc(large size)
	if (!x)
		x = kmem_zalloc_large(large size)

and do a similar dance when freeing the memory. kmem_free() already
does the correct freeing dance, and kmem_zalloc_large() is only ever
called in these constructs, so just factor it all into
kmem_zalloc_large() and kmem_free().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/kmem.c          | 15 ++++++++++++---
 fs/xfs/kmem.h          |  9 +--------
 fs/xfs/xfs_acl.c       | 28 ++++++++--------------------
 fs/xfs/xfs_bmap_util.c | 15 ++++-----------
 fs/xfs/xfs_ioctl.c     | 34 +++++++++++-----------------------
 fs/xfs/xfs_ioctl32.c   | 18 ++++++------------
 fs/xfs/xfs_itable.c    |  2 +-
 7 files changed, 43 insertions(+), 78 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 4a7286c..a02cfb9 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -27,8 +27,6 @@
 
 /*
  * Greedy allocation.  May fail and may return vmalloced memory.
- *
- * Must be freed using kmem_free_large.
  */
 void *
 kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
@@ -36,7 +34,7 @@ kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
 	void		*ptr;
 	size_t		kmsize = maxsize;
 
-	while (!(ptr = kmem_zalloc_large(kmsize))) {
+	while (!(ptr = vzalloc(kmsize))) {
 		if ((kmsize >>= 1) <= minsize)
 			kmsize = minsize;
 	}
@@ -75,6 +73,17 @@ kmem_zalloc(size_t size, xfs_km_flags_t flags)
 	return ptr;
 }
 
+void *
+kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
+{
+	void	*ptr;
+
+	ptr = kmem_zalloc(size, flags | KM_MAYFAIL);
+	if (ptr)
+		return ptr;
+	return vzalloc(size);
+}
+
 void
 kmem_free(const void *ptr)
 {
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index b2f2620..3a7371c 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -57,17 +57,10 @@ kmem_flags_convert(xfs_km_flags_t flags)
 
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
 extern void *kmem_zalloc(size_t, xfs_km_flags_t);
+extern void *kmem_zalloc_large(size_t size, xfs_km_flags_t);
 extern void *kmem_realloc(const void *, size_t, size_t, xfs_km_flags_t);
 extern void  kmem_free(const void *);
 
-static inline void *kmem_zalloc_large(size_t size)
-{
-	return vzalloc(size);
-}
-static inline void kmem_free_large(void *ptr)
-{
-	vfree(ptr);
-}
 
 extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
 
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 4ea73cc..0e2f37e 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -152,12 +152,9 @@ xfs_get_acl(struct inode *inode, int type)
 	 * go out to the disk.
 	 */
 	len = XFS_ACL_MAX_SIZE(ip->i_mount);
-	xfs_acl = kmem_zalloc(len, KM_SLEEP | KM_MAYFAIL);
-	if (!xfs_acl) {
-		xfs_acl = kmem_zalloc_large(len);
-		if (!xfs_acl)
-			return ERR_PTR(-ENOMEM);
-	}
+	xfs_acl = kmem_zalloc_large(len, KM_SLEEP);
+	if (!xfs_acl)
+		return ERR_PTR(-ENOMEM);
 
 	error = -xfs_attr_get(ip, ea_name, (unsigned char *)xfs_acl,
 							&len, ATTR_ROOT);
@@ -181,10 +178,7 @@ xfs_get_acl(struct inode *inode, int type)
 out_update_cache:
 	set_cached_acl(inode, type, acl);
 out:
-	if (is_vmalloc_addr(xfs_acl))
-		kmem_free_large(xfs_acl);
-	else
-		kfree(xfs_acl);
+	kmem_free(xfs_acl);
 	return acl;
 }
 
@@ -215,12 +209,9 @@ xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 		struct xfs_acl *xfs_acl;
 		int len = XFS_ACL_MAX_SIZE(ip->i_mount);
 
-		xfs_acl = kmem_zalloc(len, KM_SLEEP | KM_MAYFAIL);
-		if (!xfs_acl) {
-			xfs_acl = kmem_zalloc_large(len);
-			if (!xfs_acl)
-				return -ENOMEM;
-		}
+		xfs_acl = kmem_zalloc_large(len, KM_SLEEP);
+		if (!xfs_acl)
+			return -ENOMEM;
 
 		xfs_acl_to_disk(xfs_acl, acl);
 
@@ -231,10 +222,7 @@ xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 		error = -xfs_attr_set(ip, ea_name, (unsigned char *)xfs_acl,
 				len, ATTR_ROOT);
 
-		if (is_vmalloc_addr(xfs_acl))
-			kmem_free_large(xfs_acl);
-		else
-			kfree(xfs_acl);
+		kmem_free(xfs_acl);
 	} else {
 		/*
 		 * A NULL ACL argument means we want to remove the ACL.
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c6dc551..97f952c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -612,13 +612,9 @@ xfs_getbmap(
 
 	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
 		return XFS_ERROR(ENOMEM);
-	out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx), KM_MAYFAIL);
-	if (!out) {
-		out = kmem_zalloc_large(bmv->bmv_count *
-					sizeof(struct getbmapx));
-		if (!out)
-			return XFS_ERROR(ENOMEM);
-	}
+	out = kmem_zalloc_large(bmv->bmv_count * sizeof(struct getbmapx), 0);
+	if (!out)
+		return XFS_ERROR(ENOMEM);
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
@@ -754,10 +750,7 @@ xfs_getbmap(
 			break;
 	}
 
-	if (is_vmalloc_addr(out))
-		kmem_free_large(out);
-	else
-		kmem_free(out);
+	kmem_free(out);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 21d9c9df..668e8f4 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -456,12 +456,9 @@ xfs_attrlist_by_handle(
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	kbuf = kmem_zalloc(al_hreq.buflen, KM_SLEEP | KM_MAYFAIL);
-	if (!kbuf) {
-		kbuf = kmem_zalloc_large(al_hreq.buflen);
-		if (!kbuf)
-			goto out_dput;
-	}
+	kbuf = kmem_zalloc_large(al_hreq.buflen, KM_SLEEP);
+	if (!kbuf)
+		goto out_dput;
 
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
 	error = -xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
@@ -472,12 +469,9 @@ xfs_attrlist_by_handle(
 	if (copy_to_user(al_hreq.buffer, kbuf, al_hreq.buflen))
 		error = -EFAULT;
 
- out_kfree:
-	if (is_vmalloc_addr(kbuf))
-		kmem_free_large(kbuf);
-	else
-		kmem_free(kbuf);
- out_dput:
+out_kfree:
+	kmem_free(kbuf);
+out_dput:
 	dput(dentry);
 	return error;
 }
@@ -495,12 +489,9 @@ xfs_attrmulti_attr_get(
 
 	if (*len > XATTR_SIZE_MAX)
 		return EINVAL;
-	kbuf = kmem_zalloc(*len, KM_SLEEP | KM_MAYFAIL);
-	if (!kbuf) {
-		kbuf = kmem_zalloc_large(*len);
-		if (!kbuf)
-			return ENOMEM;
-	}
+	kbuf = kmem_zalloc_large(*len, KM_SLEEP);
+	if (!kbuf)
+		return ENOMEM;
 
 	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
 	if (error)
@@ -509,11 +500,8 @@ xfs_attrmulti_attr_get(
 	if (copy_to_user(ubuf, kbuf, *len))
 		error = EFAULT;
 
- out_kfree:
-	if (is_vmalloc_addr(kbuf))
-		kmem_free_large(kbuf);
-	else
-		kmem_free(kbuf);
+out_kfree:
+	kmem_free(kbuf);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index d3ab953..f671f7e 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -371,12 +371,9 @@ xfs_compat_attrlist_by_handle(
 		return PTR_ERR(dentry);
 
 	error = -ENOMEM;
-	kbuf = kmem_zalloc(al_hreq.buflen, KM_SLEEP | KM_MAYFAIL);
-	if (!kbuf) {
-		kbuf = kmem_zalloc_large(al_hreq.buflen);
-		if (!kbuf)
-			goto out_dput;
-	}
+	kbuf = kmem_zalloc_large(al_hreq.buflen, KM_SLEEP);
+	if (!kbuf)
+		goto out_dput;
 
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
 	error = -xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
@@ -387,12 +384,9 @@ xfs_compat_attrlist_by_handle(
 	if (copy_to_user(compat_ptr(al_hreq.buffer), kbuf, al_hreq.buflen))
 		error = -EFAULT;
 
- out_kfree:
-	if (is_vmalloc_addr(kbuf))
-		kmem_free_large(kbuf);
-	else
-		kmem_free(kbuf);
- out_dput:
+out_kfree:
+	kmem_free(kbuf);
+out_dput:
 	dput(dentry);
 	return error;
 }
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 8a67d53..084b3e1 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -495,7 +495,7 @@ xfs_bulkstat(
 	/*
 	 * Done, we're either out of filesystem or space to put the data.
 	 */
-	kmem_free_large(irbuf);
+	kmem_free(irbuf);
 	*ubcountp = ubelem;
 	/*
 	 * Found some inodes, return them now and return the error next time.
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

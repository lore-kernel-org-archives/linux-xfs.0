Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57765 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753093AbdICPvq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 11:51:46 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1doXBZ-0004NA-Sl
        for linux-xfs@vger.kernel.org; Sun, 03 Sep 2017 15:51:46 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] xfs: simplify the xfs_getbmap interface
Date: Sun,  3 Sep 2017 17:51:40 +0200
Message-Id: <20170903155140.17256-2-hch@lst.de>
In-Reply-To: <20170903155140.17256-1-hch@lst.de>
References: <20170903155140.17256-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Instead of passing in a formatter callback allocate the bmap buffer
in the caller and process the entries there.  Additionally replace
the in-kernel buffer with a new much smaller structure, and unify
the implementation of the different ioctls in a single function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c |  38 ++++-----------
 fs/xfs/xfs_bmap_util.h |  10 ++--
 fs/xfs/xfs_ioctl.c     | 122 ++++++++++++++++++++++++-------------------------
 3 files changed, 75 insertions(+), 95 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a11f4c300643..43cd9a7be15e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -407,11 +407,11 @@ static int
 xfs_getbmap_report_one(
 	struct xfs_inode	*ip,
 	struct getbmapx		*bmv,
-	struct getbmapx		*out,
+	struct kgetbmap		*out,
 	int64_t			bmv_end,
 	struct xfs_bmbt_irec	*got)
 {
-	struct getbmapx		*p = out + bmv->bmv_entries;
+	struct kgetbmap		*p = out + bmv->bmv_entries;
 	bool			shared = false, trimmed = false;
 	int			error;
 
@@ -458,12 +458,12 @@ static void
 xfs_getbmap_report_hole(
 	struct xfs_inode	*ip,
 	struct getbmapx		*bmv,
-	struct getbmapx		*out,
+	struct kgetbmap		*out,
 	int64_t			bmv_end,
 	xfs_fileoff_t		bno,
 	xfs_fileoff_t		end)
 {
-	struct getbmapx		*p = out + bmv->bmv_entries;
+	struct kgetbmap		*p = out + bmv->bmv_entries;
 
 	if (bmv->bmv_iflags & BMV_IF_NO_HOLES)
 		return;
@@ -511,47 +511,36 @@ xfs_getbmap_next_rec(
  */
 int						/* error code */
 xfs_getbmap(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	struct getbmapx		*bmv,		/* user bmap structure */
-	xfs_bmap_format_t	formatter,	/* format to user */
-	void			*arg)		/* formatter arg */
+	struct kgetbmap		*out)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	int			iflags = bmv->bmv_iflags;
-	int			whichfork, lock, i, error = 0;
+	int			whichfork, lock, error = 0;
 	int64_t			bmv_end, max_len;
 	xfs_fileoff_t		bno, first_bno;
 	struct xfs_ifork	*ifp;
-	struct getbmapx		*out;
 	struct xfs_bmbt_irec	got, rec;
 	xfs_filblks_t		len;
 	xfs_extnum_t		idx;
 
+	if (bmv->bmv_iflags & ~BMV_IF_VALID)
+		return -EINVAL;
 #ifndef DEBUG
 	/* Only allow CoW fork queries if we're debugging. */
 	if (iflags & BMV_IF_COWFORK)
 		return -EINVAL;
 #endif
-
 	if ((iflags & BMV_IF_ATTRFORK) && (iflags & BMV_IF_COWFORK))
 		return -EINVAL;
 
-	if (bmv->bmv_count <= 1)
-		return -EINVAL;
-	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
-		return -ENOMEM;
-
 	if (bmv->bmv_length < -1)
 		return -EINVAL;
-
 	bmv->bmv_entries = 0;
 	if (bmv->bmv_length == 0)
 		return 0;
 
-	out = kmem_zalloc_large(bmv->bmv_count * sizeof(struct getbmapx), 0);
-	if (!out)
-		return -ENOMEM;
-
 	if (iflags & BMV_IF_ATTRFORK)
 		whichfork = XFS_ATTR_FORK;
 	else if (iflags & BMV_IF_COWFORK)
@@ -698,15 +687,6 @@ xfs_getbmap(
 	xfs_iunlock(ip, lock);
 out_unlock_iolock:
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
-	for (i = 0; i < bmv->bmv_entries; i++) {
-		/* format results & advance arg */
-		error = formatter(&arg, &out[i]);
-		if (error)
-			break;
-	}
-
-	kmem_free(out);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 0eaa81dc49be..6cfe747cb142 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -34,10 +34,14 @@ int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
 int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
 		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
 
-/* bmap to userspace formatter - copy to user & advance pointer */
-typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *);
+struct kgetbmap {
+	__s64		bmv_offset;	/* file offset of segment in blocks */
+	__s64		bmv_block;	/* starting block (64-bit daddr_t)  */
+	__s64		bmv_length;	/* length of segment, blocks	    */
+	__s32		bmv_oflags;	/* output flags */
+};
 int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
-		xfs_bmap_format_t formatter, void *arg);
+		struct kgetbmap *out);
 
 /* functions in xfs_bmap.c that are only needed by xfs_bmap_util.c */
 int	xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 82d14fe6ed95..ed35d322ed59 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1548,17 +1548,26 @@ xfs_ioc_setxflags(
 	return error;
 }
 
-STATIC int
-xfs_getbmap_format(void **ap, struct getbmapx *bmv)
+static bool
+xfs_getbmap_format(
+	struct kgetbmap		*p,
+	struct getbmapx __user	*u,
+	size_t			recsize)
 {
-	struct getbmap __user	*base = (struct getbmap __user *)*ap;
-
-	/* copy only getbmap portion (not getbmapx) */
-	if (copy_to_user(base, bmv, sizeof(struct getbmap)))
-		return -EFAULT;
-
-	*ap += sizeof(struct getbmap);
-	return 0;
+	if (put_user(p->bmv_offset, &u->bmv_offset) ||
+	    put_user(p->bmv_block, &u->bmv_block) ||
+	    put_user(p->bmv_length, &u->bmv_length) ||
+	    put_user(0, &u->bmv_count) ||
+	    put_user(0, &u->bmv_entries))
+		return false;
+	if (recsize < sizeof(struct getbmapx))
+		return true;
+	if (put_user(0, &u->bmv_iflags) ||
+	    put_user(p->bmv_oflags, &u->bmv_oflags) ||
+	    put_user(0, &u->bmv_unused1) ||
+	    put_user(0, &u->bmv_unused2))
+		return false;
+	return true;
 }
 
 STATIC int
@@ -1568,68 +1577,57 @@ xfs_ioc_getbmap(
 	void			__user *arg)
 {
 	struct getbmapx		bmx = { 0 };
-	int			error;
+	struct kgetbmap		*buf;
+	size_t			recsize;
+	int			error, i;
 
-	/* struct getbmap is a strict subset of struct getbmapx. */
-	if (copy_from_user(&bmx, arg, offsetof(struct getbmapx, bmv_iflags)))
-		return -EFAULT;
-
-	if (bmx.bmv_count < 2)
+	switch (cmd) {
+	case XFS_IOC_GETBMAPA:
+		bmx.bmv_iflags = BMV_IF_ATTRFORK;
+		/*FALLTHRU*/
+	case XFS_IOC_GETBMAP:
+		if (file->f_mode & FMODE_NOCMTIME)
+			bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
+		/* struct getbmap is a strict subset of struct getbmapx. */
+		recsize = sizeof(struct getbmap);
+		break;
+	case XFS_IOC_GETBMAPX:
+		recsize = sizeof(struct getbmapx);
+		break;
+	default:
 		return -EINVAL;
+	}
 
-	bmx.bmv_iflags = (cmd == XFS_IOC_GETBMAPA ? BMV_IF_ATTRFORK : 0);
-	if (file->f_mode & FMODE_NOCMTIME)
-		bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
-
-	error = xfs_getbmap(XFS_I(file_inode(file)), &bmx, xfs_getbmap_format,
-			    (__force struct getbmap *)arg+1);
-	if (error)
-		return error;
-
-	/* copy back header - only size of getbmap */
-	if (copy_to_user(arg, &bmx, sizeof(struct getbmap)))
-		return -EFAULT;
-	return 0;
-}
-
-STATIC int
-xfs_getbmapx_format(void **ap, struct getbmapx *bmv)
-{
-	struct getbmapx __user	*base = (struct getbmapx __user *)*ap;
-
-	if (copy_to_user(base, bmv, sizeof(struct getbmapx)))
-		return -EFAULT;
-
-	*ap += sizeof(struct getbmapx);
-	return 0;
-}
-
-STATIC int
-xfs_ioc_getbmapx(
-	struct xfs_inode	*ip,
-	void			__user *arg)
-{
-	struct getbmapx		bmx;
-	int			error;
-
-	if (copy_from_user(&bmx, arg, sizeof(bmx)))
+	if (copy_from_user(&bmx, arg, recsize))
 		return -EFAULT;
 
 	if (bmx.bmv_count < 2)
 		return -EINVAL;
+	if (bmx.bmv_count > ULONG_MAX / recsize)
+		return -ENOMEM;
 
-	if (bmx.bmv_iflags & (~BMV_IF_VALID))
-		return -EINVAL;
+	buf = kmem_zalloc_large(bmx.bmv_count * sizeof(*buf), 0);
+	if (!buf)
+		return -ENOMEM;
 
-	error = xfs_getbmap(ip, &bmx, xfs_getbmapx_format,
-			    (__force struct getbmapx *)arg+1);
+	error = xfs_getbmap(XFS_I(file_inode(file)), &bmx, buf);
 	if (error)
-		return error;
+		goto out_free_buf;
 
-	/* copy back header */
-	if (copy_to_user(arg, &bmx, sizeof(struct getbmapx)))
-		return -EFAULT;
+	error = -EFAULT;
+	if (copy_to_user(arg, &bmx, recsize))
+		goto out_free_buf;
+	arg += recsize;
+
+	for (i = 0; i < bmx.bmv_entries; i++) {
+		if (!xfs_getbmap_format(buf + i, arg, recsize))
+			goto out_free_buf;
+		arg += recsize;
+	}
 
+	error = 0;
+out_free_buf:
+	kmem_free(buf);
 	return 0;
 }
 
@@ -1886,10 +1884,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
-		return xfs_ioc_getbmap(filp, cmd, arg);
-
 	case XFS_IOC_GETBMAPX:
-		return xfs_ioc_getbmapx(ip, arg);
+		return xfs_ioc_getbmap(filp, cmd, arg);
 
 	case FS_IOC_GETFSMAP:
 		return xfs_ioc_getfsmap(ip, arg);
-- 
2.11.0


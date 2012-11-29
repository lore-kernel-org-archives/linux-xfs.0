Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAT4OIS5259854 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 22:24:19 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ax8jinIXXooCHUuX for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 20:26:35 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1Tdvhp-00073d-Vb
	for xfs@oss.sgi.com; Thu, 29 Nov 2012 15:26:34 +1100
Date: Thu, 29 Nov 2012 15:26:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4 V2] xfs: byte range granularity for XFS_IOC_ZERO_RANGE
Message-ID: <20121129042633.GA6434@dastard>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1354068063-1692-3-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

xfs: byte range granularity for XFS_IOC_ZERO_RANGE

From: Dave Chinner <dchinner@redhat.com>

XFS_IOC_ZERO_RANGE simply does not work properly for non page cache
aligned ranges. Neither test 242 or 290 exercise this correctly, so
the behaviour is completely busted even though the tests pass.

Fix it to support full byte range granularity as was originally
intended for this ioctl.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---

V2: remove bogus sub-granularity range assert.

 fs/xfs/xfs_file.c     |    2 +-
 fs/xfs/xfs_vnodeops.c |   96 ++++++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_vnodeops.h |    1 +
 3 files changed, 77 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 400b187..67284ed 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -86,7 +86,7 @@ xfs_rw_ilock_demote(
  *	valid before the operation, it will be read from disk before
  *	being partially zeroed.
  */
-STATIC int
+int
 xfs_iozero(
 	struct xfs_inode	*ip,	/* inode			*/
 	loff_t			pos,	/* offset in file		*/
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 2688079..d95f565 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2095,6 +2095,73 @@ xfs_free_file_space(
 	return error;
 }
 
+
+STATIC int
+xfs_zero_file_space(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len,
+	int			attr_flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	uint			granularity;
+	xfs_off_t		start_boundary;
+	xfs_off_t		end_boundary;
+	int			error;
+
+	granularity = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
+
+	/*
+	 * Round the range of extents we are going to convert inwards.  If the
+	 * offset is aligned, then it doesn't get changed so we zero from the
+	 * start of the block offset points to.
+	 */
+	start_boundary = round_up(offset, granularity);
+	end_boundary = round_down(offset + len, granularity);
+
+	ASSERT(start_boundary >= offset);
+	ASSERT(end_boundary <= offset + len);
+
+	if (!(attr_flags & XFS_ATTR_NOLOCK))
+		xfs_ilock(ip, XFS_IOLOCK_EXCL);
+
+	if (start_boundary < end_boundary - 1) {
+		/* punch out the page cache over the conversion range */
+		truncate_pagecache_range(VFS_I(ip), start_boundary,
+					 end_boundary - 1);
+		/* convert the blocks */
+		error = xfs_alloc_file_space(ip, start_boundary,
+					end_boundary - start_boundary - 1,
+					XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT,
+					attr_flags);
+		if (error)
+			goto out_unlock;
+
+		/* We've handled the interior of the range, now for the edges */
+		if (start_boundary != offset)
+			error = xfs_iozero(ip, offset, start_boundary - offset);
+		if (error)
+			goto out_unlock;
+
+		if (end_boundary != offset + len)
+			error = xfs_iozero(ip, end_boundary,
+					   offset + len - end_boundary);
+
+	} else {
+		/*
+		 * It's either a sub-granularity range or the range spanned lies
+		 * partially across two adjacent blocks.
+		 */
+		error = xfs_iozero(ip, offset, len);
+	}
+
+out_unlock:
+	if (!(attr_flags & XFS_ATTR_NOLOCK))
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return error;
+
+}
+
 /*
  * xfs_change_file_space()
  *      This routine allocates or frees disk space for the given file.
@@ -2120,10 +2187,8 @@ xfs_change_file_space(
 	xfs_fsize_t	fsize;
 	int		setprealloc;
 	xfs_off_t	startoffset;
-	xfs_off_t	end;
 	xfs_trans_t	*tp;
 	struct iattr	iattr;
-	int		prealloc_type;
 
 	if (!S_ISREG(ip->i_d.di_mode))
 		return XFS_ERROR(EINVAL);
@@ -2172,31 +2237,20 @@ xfs_change_file_space(
 	startoffset = bf->l_start;
 	fsize = XFS_ISIZE(ip);
 
-	/*
-	 * XFS_IOC_RESVSP and XFS_IOC_UNRESVSP will reserve or unreserve
-	 * file space.
-	 * These calls do NOT zero the data space allocated to the file,
-	 * nor do they change the file size.
-	 *
-	 * XFS_IOC_ALLOCSP and XFS_IOC_FREESP will allocate and free file
-	 * space.
-	 * These calls cause the new file data to be zeroed and the file
-	 * size to be changed.
-	 */
 	setprealloc = clrprealloc = 0;
-	prealloc_type = XFS_BMAPI_PREALLOC;
-
 	switch (cmd) {
 	case XFS_IOC_ZERO_RANGE:
-		prealloc_type |= XFS_BMAPI_CONVERT;
-		end = round_down(startoffset + bf->l_len, PAGE_SIZE) - 1;
-		if (startoffset <= end)
-			truncate_pagecache_range(VFS_I(ip), startoffset, end);
-		/* FALLTHRU */
+		error = xfs_zero_file_space(ip, startoffset, bf->l_len,
+						attr_flags);
+		if (error)
+			return error;
+		setprealloc = 1;
+		break;
+
 	case XFS_IOC_RESVSP:
 	case XFS_IOC_RESVSP64:
 		error = xfs_alloc_file_space(ip, startoffset, bf->l_len,
-						prealloc_type, attr_flags);
+						XFS_BMAPI_PREALLOC, attr_flags);
 		if (error)
 			return error;
 		setprealloc = 1;
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index 91a03fa..5163022 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -49,6 +49,7 @@ int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		int flags, struct attrlist_cursor_kern *cursor);
 
+int xfs_iozero(struct xfs_inode *, loff_t, size_t);
 int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
 int xfs_free_eofblocks(struct xfs_mount *, struct xfs_inode *, bool);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

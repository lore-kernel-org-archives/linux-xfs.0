Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN3MSFo018860 for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 21:22:28 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DyZQBLCFBzU0ebeA for <xfs@oss.sgi.com>;
	Thu, 22 Nov 2012 19:24:39 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Tbjsc-0000Ck-8G
	for xfs@oss.sgi.com; Fri, 23 Nov 2012 14:24:38 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TbjsS-0003ub-4q
	for xfs@oss.sgi.com; Fri, 23 Nov 2012 14:24:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: byte range granularity for XFS_IOC_ZERO_RANGE
Date: Fri, 23 Nov 2012 14:24:25 +1100
Message-Id: <1353641065-14983-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1353641065-14983-1-git-send-email-david@fromorbit.com>
References: <1353641065-14983-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

XFS_IOC_ZERO_RANGE simply does not work properly for non page cache
aligned ranges. Neither test 242 or 290 exercise this correctly, so
the behaviour is completely busted even though the tests pass.

Fix it to support full byte range granularity as was originally
intended for this ioctl.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_file.c     |    2 +-
 fs/xfs/xfs_vnodeops.c |   84 ++++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_vnodeops.h |    1 +
 3 files changed, 65 insertions(+), 22 deletions(-)

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
index 2688079..06ce0be 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2095,6 +2095,61 @@ xfs_free_file_space(
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
+	uint			rounding;
+	xfs_off_t		start;
+	xfs_off_t		end;
+	int			error;
+
+	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
+
+	/* round the range iof extents we are going to convert inwards */
+	start = round_up(offset, rounding);
+	end = round_down(offset + len, rounding);
+
+	ASSERT(start >= offset);
+	ASSERT(end <= offset + len);
+
+	if (!(attr_flags & XFS_ATTR_NOLOCK))
+		xfs_ilock(ip, XFS_IOLOCK_EXCL);
+
+	if (start < end - 1) {
+		/* punch out the page cache over the conversion range */
+		truncate_pagecache_range(VFS_I(ip), start, end - 1);
+		/* convert the blocks */
+		error = xfs_alloc_file_space(ip, start, end - start - 1,
+				    XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT,
+				    attr_flags);
+		if (error)
+			goto out_unlock;
+	} else {
+		/* it's a sub-rounding range */
+		ASSERT(offset + len <= start);
+		error = xfs_iozero(ip, offset, len);
+		goto out_unlock;
+	}
+
+	/* now we've handled the interior of the range, handle the edges */
+	if (start != offset)
+		error = xfs_iozero(ip, offset, start - offset);
+	if (!error && end != offset + len)
+		error = xfs_iozero(ip, end, offset + len - end);
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
@@ -2120,10 +2175,8 @@ xfs_change_file_space(
 	xfs_fsize_t	fsize;
 	int		setprealloc;
 	xfs_off_t	startoffset;
-	xfs_off_t	end;
 	xfs_trans_t	*tp;
 	struct iattr	iattr;
-	int		prealloc_type;
 
 	if (!S_ISREG(ip->i_d.di_mode))
 		return XFS_ERROR(EINVAL);
@@ -2172,31 +2225,20 @@ xfs_change_file_space(
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
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

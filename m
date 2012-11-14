Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAE6ems1032479 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 00:40:48 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1HXDaG4B35ZwnXdo for <xfs@oss.sgi.com>;
	Tue, 13 Nov 2012 22:42:50 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1TYWgS-0001mb-0e
	for xfs@oss.sgi.com; Wed, 14 Nov 2012 17:42:48 +1100
Date: Wed, 14 Nov 2012 17:42:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/32 V2] xfs: remove xfs_tosspages
Message-ID: <20121114064247.GC1710@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352721264-3700-3-git-send-email-david@fromorbit.com>
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

xfs: remove xfs_tosspages

From: Dave Chinner <dchinner@redhat.com>

It's a buggy, unnecessary wrapper that is duplicating
truncate_pagecache_range().

When replacing the call in xfs_change_file_space(), also ensure that
the length being allocated/freed is always positive before making
any changes. These checks are done in the lower extent manipulation
functions, too, but we need to do them before any page cache
operations.

Reported-by: Andrew Dahl <adahl@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
v2: fix rounding error in XFS_IOC_ZERO case.

 fs/xfs/xfs_dfrag.c    |    3 +--
 fs/xfs/xfs_fs_subr.c  |   12 ------------
 fs/xfs/xfs_vnodeops.c |   30 +++++++++++++++++++++++++-----
 fs/xfs/xfs_vnodeops.h |    2 --
 4 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index b9b8646..b2c63a2 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -315,8 +315,7 @@ xfs_swap_extents(
 	 * are safe.  We don't really care if non-io related
 	 * fields change.
 	 */
-
-	xfs_tosspages(ip, 0, -1, FI_REMAPF);
+	truncate_pagecache_range(VFS_I(ip), 0, -1);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SWAPEXT);
 	if ((error = xfs_trans_reserve(tp, 0,
diff --git a/fs/xfs/xfs_fs_subr.c b/fs/xfs/xfs_fs_subr.c
index 652b875..d49de3d 100644
--- a/fs/xfs/xfs_fs_subr.c
+++ b/fs/xfs/xfs_fs_subr.c
@@ -25,18 +25,6 @@
  * note: all filemap functions return negative error codes. These
  * need to be inverted before returning to the xfs core functions.
  */
-void
-xfs_tosspages(
-	xfs_inode_t	*ip,
-	xfs_off_t	first,
-	xfs_off_t	last,
-	int		fiopt)
-{
-	/* can't toss partial tail pages, so mask them out */
-	last &= ~(PAGE_SIZE - 1);
-	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last - 1);
-}
-
 int
 xfs_flushinval_pages(
 	xfs_inode_t	*ip,
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index c2ddd7a..de3702a 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2118,7 +2118,7 @@ xfs_change_file_space(
 	xfs_fsize_t	fsize;
 	int		setprealloc;
 	xfs_off_t	startoffset;
-	xfs_off_t	llen;
+	xfs_off_t	end;
 	xfs_trans_t	*tp;
 	struct iattr	iattr;
 	int		prealloc_type;
@@ -2139,12 +2139,30 @@ xfs_change_file_space(
 		return XFS_ERROR(EINVAL);
 	}
 
-	llen = bf->l_len > 0 ? bf->l_len - 1 : bf->l_len;
+	/*
+	 * length of <= 0 for resv/unresv/zero is invalid.  length for
+	 * alloc/free is ignored completely and we have no idea what userspace
+	 * might have set it to, so set it to zero to allow range
+	 * checks to pass.
+	 */
+	switch (cmd) {
+	case XFS_IOC_ZERO_RANGE:
+	case XFS_IOC_RESVSP:
+	case XFS_IOC_RESVSP64:
+	case XFS_IOC_UNRESVSP:
+	case XFS_IOC_UNRESVSP64:
+		if (bf->l_len <= 0)
+			return XFS_ERROR(EINVAL);
+		break;
+	default:
+		bf->l_len = 0;
+		break;
+	}
 
 	if (bf->l_start < 0 ||
 	    bf->l_start > mp->m_super->s_maxbytes ||
-	    bf->l_start + llen < 0 ||
-	    bf->l_start + llen > mp->m_super->s_maxbytes)
+	    bf->l_start + bf->l_len < 0 ||
+	    bf->l_start + bf->l_len >= mp->m_super->s_maxbytes)
 		return XFS_ERROR(EINVAL);
 
 	bf->l_whence = 0;
@@ -2169,7 +2187,9 @@ xfs_change_file_space(
 	switch (cmd) {
 	case XFS_IOC_ZERO_RANGE:
 		prealloc_type |= XFS_BMAPI_CONVERT;
-		xfs_tosspages(ip, startoffset, startoffset + bf->l_len, 0);
+		end = round_down(startoffset + bf->l_len, PAGE_SIZE) - 1;
+		if (startoffset > end)
+			truncate_pagecache_range(VFS_I(ip), startoffset, end);
 		/* FALLTHRU */
 	case XFS_IOC_RESVSP:
 	case XFS_IOC_RESVSP64:
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index 52fafc4..d48141d 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -48,8 +48,6 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		int flags, struct attrlist_cursor_kern *cursor);
-void xfs_tosspages(struct xfs_inode *inode, xfs_off_t first,
-		xfs_off_t last, int fiopt);
 int xfs_flushinval_pages(struct xfs_inode *ip, xfs_off_t first,
 		xfs_off_t last, int fiopt);
 int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

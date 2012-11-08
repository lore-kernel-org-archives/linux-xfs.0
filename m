Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8MN4R3027489 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 16:23:04 -0600
Received: from cxfsxe19.americas.sgi.com (cxfsxe19.americas.sgi.com
	[128.162.240.35])
	by estes.americas.sgi.com (Postfix) with ESMTP id AF4A9700263D;
	Thu,  8 Nov 2012 16:25:03 -0600 (CST)
Received: by cxfsxe19.americas.sgi.com (Postfix, from userid 0)
	id 9AEC6BA0C2; Thu,  8 Nov 2012 16:25:03 -0600 (CST)
Message-Id: <20121108222315.626928496@sgi.com>
Date: Thu, 08 Nov 2012 16:23:16 -0600
From: Andrew Dahl <adahl@sgi.com>
Subject: [patch 1/2] xfs: xfs_tosspages() bug
References: <20121108222315.505370321@sgi.com>
Content-Disposition: inline; filename=xfs_fix_tosspages_tossing_all_pages
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
Cc: Andrew Dahl <adahl@sgi.com>

xfs_tosspages() takes a closed interval as an argument, take 
this into account when rounding down to the last byte of the
last complete page. If the request consists of a single 
partial page, there will be nothing to toss. 

Signed-off-by: Andrew Dahl <adahl@sgi.com>

---

Index: xfs/fs/xfs/xfs_fs_subr.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fs_subr.c
+++ xfs/fs/xfs/xfs_fs_subr.c
@@ -32,9 +32,17 @@ xfs_tosspages(
 	xfs_off_t	last,
 	int		fiopt)
 {
-	/* can't toss partial tail pages, so mask them out */
-	last &= ~(PAGE_SIZE - 1);
-	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last - 1);
+	/*
+	 * Can't toss partial tail pages, so mask them out.  If the only
+	 * page to toss was a partial tail, there will be nothing left
+	 * to do.
+	 */
+	if (last != -1) {
+	        last = ((last + 1) & PAGE_MASK) - 1;
+	        if (last < first)
+	                return;
+	}
+	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last);
 }
 
 int
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c
+++ xfs/fs/xfs/xfs_vnodeops.c
@@ -2172,7 +2172,7 @@ xfs_change_file_space(
 	switch (cmd) {
 	case XFS_IOC_ZERO_RANGE:
 		prealloc_type |= XFS_BMAPI_CONVERT;
-		xfs_tosspages(ip, startoffset, startoffset + bf->l_len, 0);
+		xfs_tosspages(ip, startoffset, bf->l_len ? startoffset + llen : -1, 0);
 		/* FALLTHRU */
 	case XFS_IOC_RESVSP:
 	case XFS_IOC_RESVSP64:



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

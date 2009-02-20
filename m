Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1K8rX5e164873 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 02:53:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 653DA1975A88
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:53:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZeUQKLHGGgkPalB1 for
	<xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:53:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LaR7V-00041x-SP
	for xfs@oss.sgi.com; Fri, 20 Feb 2009 08:52:29 +0000
Message-Id: <20090220085229.787651000@bombadil.infradead.org>
Date: Fri, 20 Feb 2009 03:52:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/7] xfs: kill vn_atime_* helpers.
References: <20090220085207.663702000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-vn_atime_
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

Two out of three are unused already, and the third is better done open-coded
with a comment describing what's going on here.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2009-02-03 17:38:26.016436576 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_vnode.h	2009-02-03 17:40:13.809477409 +0100
@@ -58,25 +58,6 @@ static inline int VN_BAD(struct inode *v
 }
 
 /*
- * Extracting atime values in various formats
- */
-static inline void vn_atime_to_bstime(struct inode *vp, xfs_bstime_t *bs_atime)
-{
-	bs_atime->tv_sec = vp->i_atime.tv_sec;
-	bs_atime->tv_nsec = vp->i_atime.tv_nsec;
-}
-
-static inline void vn_atime_to_timespec(struct inode *vp, struct timespec *ts)
-{
-	*ts = vp->i_atime;
-}
-
-static inline void vn_atime_to_time_t(struct inode *vp, time_t *tt)
-{
-	*tt = vp->i_atime.tv_sec;
-}
-
-/*
  * Some useful predicates.
  */
 #define VN_MAPPED(vp)	mapping_mapped(vp->i_mapping)
Index: xfs/fs/xfs/xfs_itable.c
===================================================================
--- xfs.orig/fs/xfs/xfs_itable.c	2009-02-03 17:38:26.035436548 +0100
+++ xfs/fs/xfs/xfs_itable.c	2009-02-03 17:39:41.954562280 +0100
@@ -83,7 +83,12 @@ xfs_bulkstat_one_iget(
 	buf->bs_uid = dic->di_uid;
 	buf->bs_gid = dic->di_gid;
 	buf->bs_size = dic->di_size;
-	vn_atime_to_bstime(VFS_I(ip), &buf->bs_atime);
+	/*
+	 * We are reading the atime from the Linux inode because the
+	 * dinode might not be uptodate.
+	 */
+	buf->bs_atime.tv_sec = VFS_I(ip)->i_atime.tv_sec;
+	buf->bs_atime.tv_nsec = VFS_I(ip)->i_atime.tv_nsec;
 	buf->bs_mtime.tv_sec = dic->di_mtime.t_sec;
 	buf->bs_mtime.tv_nsec = dic->di_mtime.t_nsec;
 	buf->bs_ctime.tv_sec = dic->di_ctime.t_sec;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

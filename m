Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7WhLV203672 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:32:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28F9D185E8E3
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XU3wzvDFFOedkrxZ for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLwu-0002zc-At
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:00 +0000
Message-Id: <20090126073200.151836000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/17] xfs: make sure to free the real-time inodes in the
	mount error path
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-free-rtinodes
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

When mount failes after allocating the real-time inodes we currently leak
them.  Add a new helper to free the real-time inodes which can be used by
both the mount and unmount path.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rtalloc.c	2009-01-24 18:02:17.458778944 +0100
+++ xfs/fs/xfs/xfs_rtalloc.c	2009-01-24 18:04:16.922779103 +0100
@@ -2288,6 +2288,16 @@ xfs_rtmount_inodes(
 	return 0;
 }
 
+void
+xfs_rtunmount_inodes(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_rbmip)
+		IRELE(mp->m_rbmip);
+	if (mp->m_rsumip)
+		IRELE(mp->m_rsumip);
+}
+
 /*
  * Pick an extent for allocation at the start of a new realtime file.
  * Use the sequence number stored in the atime field of the bitmap inode.
Index: xfs/fs/xfs/xfs_rtalloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_rtalloc.h	2009-01-24 18:02:17.462779035 +0100
+++ xfs/fs/xfs/xfs_rtalloc.h	2009-01-24 18:04:16.929904172 +0100
@@ -108,6 +108,9 @@ xfs_rtfree_extent(
 int					/* error */
 xfs_rtmount_init(
 	struct xfs_mount	*mp);	/* file system mount structure */
+void
+xfs_rtunmount_inodes(
+	struct xfs_mount	*mp);
 
 /*
  * Get the bitmap and summary inodes into the mount structure
@@ -146,6 +149,7 @@ xfs_growfs_rt(
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
 # define xfs_rtmount_init(m)    (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
 # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
+# define xfs_rtunmount_inodes(m)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __KERNEL__ */
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-01-24 18:02:20.240779188 +0100
+++ xfs/fs/xfs/xfs_mount.c	2009-01-24 18:04:16.931903659 +0100
@@ -1138,7 +1138,7 @@ xfs_mountfs(
 		error = xfs_mount_log_sb(mp, mp->m_update_flags);
 		if (error) {
 			cmn_err(CE_WARN, "XFS: failed to write sb changes");
-			goto out_rele_rip;
+			goto out_rtunmount;
 		}
 	}
 
@@ -1147,7 +1147,7 @@ xfs_mountfs(
 	 */
 	error = XFS_QM_INIT(mp, &quotamount, &quotaflags);
 	if (error)
-		goto out_rele_rip;
+		goto out_rtunmount;
 
 	/*
 	 * Finish recovering the file system.  This part needed to be
@@ -1157,7 +1157,7 @@ xfs_mountfs(
 	error = xfs_log_mount_finish(mp);
 	if (error) {
 		cmn_err(CE_WARN, "XFS: log mount finish failed");
-		goto out_rele_rip;
+		goto out_rtunmount;
 	}
 
 	/*
@@ -1165,7 +1165,7 @@ xfs_mountfs(
 	 */
 	error = XFS_QM_MOUNT(mp, quotamount, quotaflags);
 	if (error)
-		goto out_rele_rip;
+		goto out_rtunmount;
 
 	/*
 	 * Now we are mounted, reserve a small amount of unused space for
@@ -1189,6 +1189,8 @@ xfs_mountfs(
 
 	return 0;
 
+ out_rtunmount:
+	xfs_rtunmount_inodes(mp);
  out_rele_rip:
 	IRELE(rip);
  out_log_dealloc:
@@ -1219,10 +1221,7 @@ xfs_unmountfs(
 	 */
 	XFS_QM_UNMOUNT(mp);
 
-	if (mp->m_rbmip)
-		IRELE(mp->m_rbmip);
-	if (mp->m_rsumip)
-		IRELE(mp->m_rsumip);
+	xfs_rtunmount_inodes(mp);
 	IRELE(mp->m_rootip);
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8HIwdTb233085 for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 13:58:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 228F11688BA0
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 11:59:54 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MSgEFBeWzimq4Po0 for
	<xfs@oss.sgi.com>; Thu, 17 Sep 2009 11:59:54 -0700 (PDT)
Date: Thu, 17 Sep 2009 14:59:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20090917185953.GA24590@infradead.org>
References: <89c4f90c0909160327l1a1fdaa2g131cd7fa249ad529@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <89c4f90c0909160327l1a1fdaa2g131cd7fa249ad529@mail.gmail.com>
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
To: Tommy van Leeuwen <tommy@news-service.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 16, 2009 at 12:27:21PM +0200, Tommy van Leeuwen wrote:
> Hello All,
> 
> We had this error reported on the list about 1 or 2 months ago. During
> that time a lot of fixes were applied. However, we still experience
> this problem with the recent 2.6.31 tree. We've also applied an extra
> log entry to aid in debugging.
> 
> printk("XFS: inode_init_always failed to re-initialize inode\n");
> 
> However, we didn't see this logging!

Can you try the patch below, its does two things

 - remove all that reclaimable flagging if we reclaim the inode
   directly.  This removes any possibility of racing with the reclaiming
   thread.
 - adds asserts if one of the reclaim-related flags is already set.


Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2009-09-17 14:39:37.799003843 -0300
+++ xfs/fs/xfs/xfs_vnodeops.c	2009-09-17 14:50:14.987005862 -0300
@@ -2460,39 +2460,35 @@ int
 xfs_reclaim(
 	xfs_inode_t	*ip)
 {
-
 	xfs_itrace_entry(ip);
 
 	ASSERT(!VN_MAPPED(VFS_I(ip)));
 
 	/* bad inode, get out here ASAP */
-	if (is_bad_inode(VFS_I(ip))) {
-		xfs_ireclaim(ip);
-		return 0;
-	}
+	if (is_bad_inode(VFS_I(ip)))
+		goto out_reclaim;
 
 	xfs_ioend_wait(ip);
 
 	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
 
 	/*
+	 * We should never get here with one of the reclaim flags already set.
+	 */
+	BUG_ON(xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	BUG_ON(xfs_iflags_test(ip, XFS_IRECLAIM));
+
+	/*
 	 * If we have nothing to flush with this inode then complete the
-	 * teardown now, otherwise break the link between the xfs inode and the
-	 * linux inode and clean up the xfs inode later. This avoids flushing
-	 * the inode to disk during the delete operation itself.
-	 *
-	 * When breaking the link, we need to set the XFS_IRECLAIMABLE flag
-	 * first to ensure that xfs_iunpin() will never see an xfs inode
-	 * that has a linux inode being reclaimed. Synchronisation is provided
-	 * by the i_flags_lock.
+	 * teardown now, otherwise delay the flush operation.
 	 */
-	if (!ip->i_update_core && (ip->i_itemp == NULL)) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_iflock(ip);
-		xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-		return xfs_reclaim_inode(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC);
+	if (ip->i_update_core || ip->i_itemp) {
+		xfs_inode_set_reclaim_tag(ip);
+		return 0;
 	}
-	xfs_inode_set_reclaim_tag(ip);
+
+out_reclaim:
+	xfs_ireclaim(ip);
 	return 0;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

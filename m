Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7R5vjF8179126 for <xfs@oss.sgi.com>; Sat, 27 Aug 2011 00:57:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBD2311E25C
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 22:57:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	O62bu5ebIpDuxpd6 for <xfs@oss.sgi.com>;
	Fri, 26 Aug 2011 22:57:44 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QxBto-0007NT-5r
	for xfs@oss.sgi.com; Sat, 27 Aug 2011 05:57:44 +0000
Date: Sat, 27 Aug 2011 01:57:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/2] xfs: fix xfs_mark_inode_dirty during umount
Message-ID: <20110827055744.GA28351@infradead.org>
References: <20110827055731.GA24159@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110827055731.GA24159@infradead.org>
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

During umount we do not add a dirty inode to the lru and wait for it to
become clean first, but force writeback of data and metadata with
I_WILL_FREE set.  Currently there is no way for XFS to detect that the
inode has been redirtied for metadata operations, as we skip the
mark_inode_dirty call during teardown.  Fix this by setting i_update_core
nanually in that case, so that the inode gets flushed during inode reclaim.

Alternatively we could enable calling mark_inode_dirty for inodes in
I_WILL_FREE state, and let the VFS dirty tracking handle this.  I decided
against this as we will get better I/O patterns from reclaim compared to
the synchronous writeout in write_inode_now, and always marking the inode
dirty in some way from xfs_mark_inode_dirty is a better safetly net in
either case.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iops.c	2011-08-26 12:31:19.090631739 +0200
+++ linux-2.6/fs/xfs/xfs_iops.c	2011-08-26 12:35:43.692531800 +0200
@@ -70,9 +70,8 @@ xfs_synchronize_times(
 }
 
 /*
- * If the linux inode is valid, mark it dirty.
- * Used when committing a dirty inode into a transaction so that
- * the inode will get written back by the linux code
+ * If the linux inode is valid, mark it dirty, else mark the dirty state
+ * in the XFS inode to make sure we pick it up when reclaiming the inode.
  */
 void
 xfs_mark_inode_dirty_sync(
@@ -82,6 +81,10 @@ xfs_mark_inode_dirty_sync(
 
 	if (!(inode->i_state & (I_WILL_FREE|I_FREEING)))
 		mark_inode_dirty_sync(inode);
+	else {
+		barrier();
+		ip->i_update_core = 1;
+	}
 }
 
 void
@@ -92,6 +95,11 @@ xfs_mark_inode_dirty(
 
 	if (!(inode->i_state & (I_WILL_FREE|I_FREEING)))
 		mark_inode_dirty(inode);
+	else {
+		barrier();
+		ip->i_update_core = 1;
+	}
+
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

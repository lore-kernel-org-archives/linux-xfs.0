Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA6BfhLG255307 for <xfs@oss.sgi.com>; Sat, 6 Nov 2010 06:41:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D4921C1F457
	for <xfs@oss.sgi.com>; Sat,  6 Nov 2010 04:43:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Apv5i31WwK2JMRjF for
	<xfs@oss.sgi.com>; Sat, 06 Nov 2010 04:43:09 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PEhAq-0006i2-P6
	for xfs@oss.sgi.com; Sat, 06 Nov 2010 11:43:08 +0000
Date: Sat, 6 Nov 2010 07:43:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: use hlist_add_fake
Message-ID: <20101106114308.GD25395@infradead.org>
References: <20101106114226.GA25395@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101106114226.GA25395@infradead.org>
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

XFS does not need it's inodes to actuall be hashed in the VFS inode cache, but
we require the inode to be marked hashed for the writeback code to work.

Insted of using insert_inode_hash, which requires a second inode_lock roundtrip
after the partial merge of the inode scalability patches in 2.6.37-rc simply
use the new hlist_add_fake helper to mark it hashed without requiring a lock
or touching a global cache line.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-11-05 19:17:18.511013308 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_iops.c	2010-11-05 19:23:31.772029658 +0100
@@ -762,7 +762,8 @@ xfs_setup_inode(
 	inode->i_state = I_NEW;
 
 	inode_sb_list_add(inode);
-	insert_inode_hash(inode);
+	/* make the inode look hashed for the writeback code */
+	hlist_add_fake(&inode->i_hash);
 
 	inode->i_mode	= ip->i_d.di_mode;
 	inode->i_nlink	= ip->i_d.di_nlink;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

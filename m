Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2G7pWF031831 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:07:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 535D5164F1EF
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:07:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1k8dUtqvCRiEd8VI for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:07:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xlz-0007W8-Ua
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:51 +0000
Message-Id: <20081202160651.861936000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 16/22] use xfs_trans_ijoin in xfs_trans_iget
Content-Disposition: inline; filename=xfs-cleanup-xfs_trans_iget
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Use xfs_trans_ijoin in xfs_trans_iget in case we need to join an inode into
a transaction instead of opencoding it.  Based on a discussion with and an
incomplete patch from Niv Sardi.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_trans_inode.c	2008-11-19 19:43:42.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_trans_inode.c	2008-11-19 19:55:45.000000000 +0100
@@ -85,7 +85,6 @@ xfs_trans_iget(
 {
 	int			error;
 	xfs_inode_t		*ip;
-	xfs_inode_log_item_t	*iip;
 
 	/*
 	 * If the transaction pointer is NULL, just call the normal
@@ -138,34 +137,7 @@ xfs_trans_iget(
 	}
 	ASSERT(ip != NULL);
 
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	if (ip->i_itemp == NULL)
-		xfs_inode_item_init(ip, mp);
-	iip = ip->i_itemp;
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
-
-	xfs_trans_inode_broot_debug(ip);
-
-	/*
-	 * If the IO lock has been acquired, mark that in
-	 * the inode log item so we'll know to unlock it
-	 * when the transaction commits.
-	 */
-	ASSERT(iip->ili_flags == 0);
-	if (lock_flags & XFS_IOLOCK_EXCL) {
-		iip->ili_flags |= XFS_ILI_IOLOCKED_EXCL;
-	} else if (lock_flags & XFS_IOLOCK_SHARED) {
-		iip->ili_flags |= XFS_ILI_IOLOCKED_SHARED;
-	}
-
-	/*
-	 * Initialize i_transp so we can find it with xfs_inode_incore()
-	 * above.
-	 */
-	ip->i_transp = tp;
-
+	xfs_trans_ijoin(tp, ip, lock_flags);
 	*ipp = ip;
 	return 0;
 }

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

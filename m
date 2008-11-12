Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 03:44:30 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mACBiMxN006941
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 03:44:22 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82C7A154B41C
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 03:44:22 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id VVrvjs8E6FiyVJIn for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 03:44:22 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1L0E8V-00051z-PF
	for xfs@oss.sgi.com; Wed, 12 Nov 2008 11:43:51 +0000
Date: Wed, 12 Nov 2008 06:43:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: fix error handling in xlog_recover_process_one_iunlink
Message-ID: <20081112114351.GA15216@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

If we fail after xfs_iget we have to drop the reference count, spotted
by Dave Chinner.  Also remove some useless asserts and stop trying to
deal with di_mode == 0 inodes because never gets those without passing
the IGET_CREATE flag to xfs_iget.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-11-12 11:05:22.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-11-12 11:05:54.000000000 +0100
@@ -3147,13 +3147,12 @@ xlog_recover_process_one_iunlink(
 	/*
 	 * Get the on disk inode to find the next inode in the bucket.
 	 */
-	ASSERT(ip != NULL);
 	error = xfs_itobp(mp, NULL, ip, &dip, &ibp, XFS_BUF_LOCK);
 	if (error)
-		goto fail;
+		goto fail_iput;
 
-	ASSERT(dip != NULL);
 	ASSERT(ip->i_d.di_nlink == 0);
+	ASSERT(ip->i_d.di_mode != 0);
 
 	/* setup for the next pass */
 	agino = be32_to_cpu(dip->di_next_unlinked);
@@ -3165,18 +3164,11 @@ xlog_recover_process_one_iunlink(
 	 */
 	ip->i_d.di_dmevmask = 0;
 
-	/*
-	 * If this is a new inode, handle it specially.  Otherwise, just
-	 * drop our reference to the inode.  If there are no other
-	 * references, this will send the inode to xfs_inactive() which
-	 * will truncate the file and free the inode.
-	 */
-	if (ip->i_d.di_mode == 0)
-		xfs_iput_new(ip, 0);
-	else
-		IRELE(ip);
+	IRELE(ip);
 	return agino;
 
+ fail_iput:
+	IRELE(ip);
  fail:
 	/*
 	 * We can't read in the inode this bucket points to, or this inode

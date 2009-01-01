Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01HbvxJ009025 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 11:37:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B47201BF7CEC
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 09:37:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vwkoX3dO19H3RclK for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 09:37:56 -0800 (PST)
Date: Thu, 1 Jan 2009 12:37:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS internal error when NFS client accesses nonexistent inode
Message-ID: <20090101173756.GA31126@infradead.org>
References: <87zlicfncr.fsf@server.ak.quickcircuit.co.nz>
	<20090101171409.GA18020@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090101171409.GA18020@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mario Becroft <mb@gem.win.co.nz>
Cc: xfs@oss.sgi.com

This should cure your shutdowns on a 2.6.27-ish codebase:



Index: btrfs-unstable/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- btrfs-unstable.orig/fs/xfs/linux-2.6/xfs_export.c	2009-01-01 18:34:39.868671500 +0100
+++ btrfs-unstable/fs/xfs/linux-2.6/xfs_export.c	2009-01-01 18:35:37.224782654 +0100
@@ -127,8 +127,8 @@ xfs_nfs_get_inode(
 	if (ino == 0)
 		return ERR_PTR(-ESTALE);
 
-	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, 0);
+	error = xfs_iget(mp, NULL, ino, XFS_IGET_BULKSTAT, XFS_ILOCK_SHARED, &ip, 0);
 		return ERR_PTR(-error);
 	if (!ip)
 		return ERR_PTR(-EIO);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

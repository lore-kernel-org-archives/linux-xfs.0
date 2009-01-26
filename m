Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7WiVj203695 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:32:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29F97B7525
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id trxkAgxpx4sNuwQm for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLwv-00031K-9B
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:01 +0000
Message-Id: <20090126073201.084826000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/17] xfs: remove unused XFS_MOUNT_ILOCK/XFS_MOUNT_IUNLOCK
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_MOUNT_ILOCK
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

These aren't only unused but also reference a lock that doesn't exist anymore.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2009-01-21 21:03:27.866294994 +0100
+++ xfs/fs/xfs/xfs_mount.h	2009-01-24 18:13:41.777903750 +0100
@@ -500,9 +500,6 @@ typedef struct xfs_mod_sb {
 	int64_t		msb_delta;	/* Change to make to specified field */
 } xfs_mod_sb_t;
 
-#define	XFS_MOUNT_ILOCK(mp)	mutex_lock(&((mp)->m_ilock))
-#define	XFS_MOUNT_IUNLOCK(mp)	mutex_unlock(&((mp)->m_ilock))
-
 extern int	xfs_log_sbcount(xfs_mount_t *, uint);
 extern int	xfs_mountfs(xfs_mount_t *mp);
 extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAJDbFII117992 for <xfs@oss.sgi.com>; Fri, 19 Nov 2010 07:37:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15D7913D8D64
	for <xfs@oss.sgi.com>; Fri, 19 Nov 2010 05:38:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LVvY2c52MyOm143y for
	<xfs@oss.sgi.com>; Fri, 19 Nov 2010 05:38:50 -0800 (PST)
Date: Fri, 19 Nov 2010 08:38:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix exporting with left over 64-bit inodes
Message-ID: <20101119133848.GA5471@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Cc: Samuel Kvasnica <samuel.kvasnica@ims.co.at>

From: Samuel Kvasnica <samuel.kvasnica@ims.co.at>

We now support mounting and using filesystems with 64-bit inodes even
when not mounted with the inode64 option (which now only controls if
we allocate new inodes in that space or not).  Make sure we always
use large NFS file handles when exporting a filesystem that may contain
64-bit inodes.  Note that this only affects newly generated file handles,
any outstanding 32-bit file handle is still accepted.

[hch: the comment and commit log are mine, the rest is from a patch
 snipplet from Samuel]

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2010-11-10 17:08:27.341529680 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_export.c	2010-11-10 17:10:10.321529680 +0100
@@ -70,8 +70,16 @@ xfs_fs_encode_fh(
 	else
 		fileid_type = FILEID_INO32_GEN_PARENT;
 
-	/* filesystem may contain 64bit inode numbers */
-	if (!(XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_SMALL_INUMS))
+	/*
+	 * If the the filesystem may contain 64bit inode numbers, we need
+	 * to use larger file handles that can represent them.
+	 *
+	 * While we only allocate inodes that do not fit into 32 bits any
+	 * large enough filesystem may contain them, thus the slightly
+	 * confusing looking conditional below.
+	 */
+	if (!(XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_SMALL_INUMS) ||
+	    (XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_32BITINODES))
 		fileid_type |= XFS_FILEID_TYPE_64FLAG;
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

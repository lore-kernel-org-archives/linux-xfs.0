Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96IUMc2109572 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:30:27 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2B1E18C8736
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:31:25 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id oz3Who0Mt3ifuUoU for
	<xfs@oss.sgi.com>; Wed, 06 Oct 2010 11:31:25 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P3Ylv-0000Z0-Oi
	for xfs@oss.sgi.com; Wed, 06 Oct 2010 18:31:23 +0000
Date: Wed, 6 Oct 2010 14:31:23 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: fix bogus m_maxagi check in xfs_iget
Message-ID: <20101006183123.GA2166@lst.de>
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

These days inode64 should only control which AGs we allocate new inodes
from, while we still try to support reading all existing inodes.  To make
this actually work the check ontop of xfs_iget needs to be relaxed to allow
inodes in all allocation groups instead of just those that we allow
allocating inodes from.  Note that we can't simply remove the check - it
prevents us from accessing invalid data when fed invalid inode numbers
from NFS or bulkstat.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-10-05 10:56:05.749253507 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-10-06 20:22:36.189003262 +0200
@@ -365,8 +365,8 @@ xfs_iget(
 	xfs_perag_t	*pag;
 	xfs_agino_t	agino;
 
-	/* the radix tree exists only in inode capable AGs */
-	if (XFS_INO_TO_AGNO(mp, ino) >= mp->m_maxagi)
+	/* reject inode numbers outside existing AGs */
+	if (XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
 		return EINVAL;
 
 	/* get the perag structure and ensure that it's inode capable */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

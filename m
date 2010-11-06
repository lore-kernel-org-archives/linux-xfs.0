Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA6BfI9g255271 for <xfs@oss.sgi.com>; Sat, 6 Nov 2010 06:41:19 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6BC9139596E
	for <xfs@oss.sgi.com>; Sat,  6 Nov 2010 04:42:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ePIKTXWnGt9JBkvP for
	<xfs@oss.sgi.com>; Sat, 06 Nov 2010 04:42:44 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PEhAS-0006cF-1k
	for xfs@oss.sgi.com; Sat, 06 Nov 2010 11:42:44 +0000
Date: Sat, 6 Nov 2010 07:42:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: tell lockdep about parent iolock usage in filestreams
Message-ID: <20101106114243.GB25395@infradead.org>
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

The filestreams code may take the iolock on the parent inode while holding it
on a child.  This is the only place in XFS where we take both the child and
parent iolock, so just telling lockdep about it is enough.  The lock flag
required for that was already added as part of the ilock lockdep annotations
and unused so far.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_filestream.c
===================================================================
--- xfs.orig/fs/xfs/xfs_filestream.c	2010-11-02 14:28:57.888491016 -0400
+++ xfs/fs/xfs/xfs_filestream.c	2010-11-02 14:30:42.591824351 -0400
@@ -744,9 +744,15 @@ xfs_filestream_new_ag(
 	 * If the file's parent directory is known, take its iolock in exclusive
 	 * mode to prevent two sibling files from racing each other to migrate
 	 * themselves and their parent to different AGs.
+	 *
+	 * Note that we lock the parent directory iolock inside the child
+	 * iolock here.  That's fine as we never hold both parent and child
+	 * iolock in any other place.  This is different from the ilock,
+	 * which requires locking of the child after the parent for namespace
+	 * operations.
 	 */
 	if (pip)
-		xfs_ilock(pip, XFS_IOLOCK_EXCL);
+		xfs_ilock(pip, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
 
 	/*
 	 * A new AG needs to be found for the file.  If the file's parent

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

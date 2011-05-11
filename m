Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4BF7DM8128054 for <xfs@oss.sgi.com>; Wed, 11 May 2011 10:07:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C6FD445774
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fZZaLGWhDOUo6IR3 for
	<xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QKB0K-0005h3-SC
	for xfs@oss.sgi.com; Wed, 11 May 2011 15:07:12 +0000
Message-Id: <20110511150712.830693893@bombadil.infradead.org>
Date: Wed, 11 May 2011 11:04:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 8/9] xfs: fix up asserts in xfs_iflush_fork
References: <20110511150402.258164661@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-ep-access-5
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

Remove asserts in xfs_iflush_fork that would call xfs_iext_get_ext with
a potentially invalid extent buffer index.

Based on an earlier patch from Lachlan McIlroy.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-05-11 10:18:39.555233397 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-05-11 12:04:24.099733330 +0200
@@ -2557,12 +2557,9 @@ xfs_iflush_fork(
 	case XFS_DINODE_FMT_EXTENTS:
 		ASSERT((ifp->if_flags & XFS_IFEXTENTS) ||
 		       !(iip->ili_format.ilf_fields & extflag[whichfork]));
-		ASSERT((xfs_iext_get_ext(ifp, 0) != NULL) ||
-			(ifp->if_bytes == 0));
-		ASSERT((xfs_iext_get_ext(ifp, 0) == NULL) ||
-			(ifp->if_bytes > 0));
 		if ((iip->ili_format.ilf_fields & extflag[whichfork]) &&
 		    (ifp->if_bytes > 0)) {
+			ASSERT(xfs_iext_get_ext(ifp, 0));
 			ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) > 0);
 			(void)xfs_iextents_copy(ip, (xfs_bmbt_rec_t *)cp,
 				whichfork);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

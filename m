Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8Q9EaNM140323 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 04:14:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3399018ED8D
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 02:14:35 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	i8lIImC5RB48Jn5f for <xfs@oss.sgi.com>;
	Mon, 26 Sep 2011 02:14:35 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R87Gl-0001iG-0P
	for xfs@oss.sgi.com; Mon, 26 Sep 2011 09:14:35 +0000
Date: Mon, 26 Sep 2011 05:14:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: XFS_TRANS_SWAPEXT is not a valid flag for
	xfs_trans_commit
Message-ID: <20110926091434.GA6575@infradead.org>
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

XFS_TRANS_SWAPEXT is a transaction type, not a flag for xfs_trans_commit, so
don't pass it in xfs_swap_extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dfrag.c	2011-07-26 17:53:45.336403605 +0200
+++ xfs/fs/xfs/xfs_dfrag.c	2011-07-27 18:48:03.390684228 +0200
@@ -438,7 +438,7 @@ xfs_swap_extents(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(tp);
 
-	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
+	error = xfs_trans_commit(tp, 0);
 
 	trace_xfs_swap_extent_after(ip, 0);
 	trace_xfs_swap_extent_after(tip, 1);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

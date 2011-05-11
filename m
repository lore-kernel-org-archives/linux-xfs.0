Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4BF7Ch9128043 for <xfs@oss.sgi.com>; Wed, 11 May 2011 10:07:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69116445772
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ibAON6r7xsxSx60z for
	<xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QKB0J-0005eP-R3
	for xfs@oss.sgi.com; Wed, 11 May 2011 15:07:11 +0000
Message-Id: <20110511150711.786279651@bombadil.infradead.org>
Date: Wed, 11 May 2011 11:04:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/9] xfs: correctly decrement the extent buffer index in
	xfs_bmap_del_extent
References: <20110511150402.258164661@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-ep-access
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

The code in xfs_bmap_del_extent does not correctly decrement the extent buffer
index when deleting a whole extent.  Most of the time this gets caught by
checks in xfs_bmapi that work around it and decrement it manually and thus
wasn't noticed so far.

Based on an earlier patch from Lachlan McIlroy.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-05-10 17:11:21.212901236 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-05-10 17:13:36.177399627 +0200
@@ -2916,8 +2916,10 @@ xfs_bmap_del_extent(
 		 */
 		xfs_iext_remove(ip, *idx, 1,
 				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
+		--*idx;
 		if (delay)
 			break;
+
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		flags |= XFS_ILOG_CORE;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

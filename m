Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66kA2014524 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56CDD1051A8
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:06:46 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	mrCn1xocPayR20xp for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:06:46 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6bt-0005JU-P9
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 06:06:45 +0000
Message-Id: <20110824060645.722947164@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 24/25] xfs: dont ignore error code from xfs_bmbt_update
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-xfs_bmap_add_extent_unwritten_real-fix-error-handling
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

Fix a case in xfs_bmap_add_extent_unwritten_real where we aren't passing
the returned error on.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:14:48.488677858 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:14:50.002002992 +0200
@@ -1217,10 +1217,11 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
-			if (xfs_bmbt_update(cur, LEFT.br_startoff,
+			error = xfs_bmbt_update(cur, LEFT.br_startoff,
 				LEFT.br_startblock,
 				LEFT.br_blockcount + new->br_blockcount,
-				LEFT.br_state))
+				LEFT.br_state);
+			if (error)
 				goto done;
 		}
 		break;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

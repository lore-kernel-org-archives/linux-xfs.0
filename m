Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82HwIEw034420 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:58:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B950A41E03E
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2DwF15ZUUZofuQ8P for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:42 -0700 (PDT)
Message-Id: <20090902175842.262611292@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 14/14] repair: add missing locking in scanfunc_bmap
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-scanfunc_bmap-locking
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
Cc: Barry Naujok <bnaujok@sgi.com>

Make sure to protect access to the block usage tracking btree with
the ag_lock.


Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2009-08-20 03:16:13.000000000 +0000
+++ xfsprogs-dev/repair/scan.c	2009-08-20 03:18:17.000000000 +0000
@@ -235,6 +235,7 @@
 		agno = XFS_FSB_TO_AGNO(mp, bno);
 		agbno = XFS_FSB_TO_AGBNO(mp, bno);
 
+		pthread_mutex_lock(&ag_locks[agno]);
 		state = get_bmap(agno, agbno);
 		switch (state) {
 		case XR_E_UNKNOWN:
@@ -280,6 +281,7 @@
 				state, ino, (__uint64_t) bno);
 			break;
 		}
+		pthread_mutex_unlock(&ag_locks[agno]);
 	} else  {
 		/*
 		 * attribute fork for realtime files is in the regular

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9E3rx8K170338 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 22:53:59 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD22B255F
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 20:55:29 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id K6LrBxg8kEDNDhk6 for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 20:55:29 -0700 (PDT)
Message-ID: <4AD54BAF.2050206@sandeen.net>
Date: Tue, 13 Oct 2009 22:55:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] free temporary cursor in xfs_dialloc
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>

Commit bd169565993b39b9b4b102cdac8b13e0a259ce2f seems
to have a slight regression where this code path:

	if (!--searchdistance) {
		/*
		 * Not in range - save last search
		 * location and allocate a new inode
		 */
		...
		goto newino;
	}

doesn't free the temporary cursor (tcur) that got dup'd in
this function.

This leaks an item in the xfs_btree_cur zone, and it's caught
on module unload:

===========================================================
BUG xfs_btree_cur: Objects remaining on kmem_cache_close()
-----------------------------------------------------------

It seems like maybe a single free at the end of the function might
be cleaner, but for now put a del_cursor right in this code block
similar to the handling in the rest of the function.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index ab64f3e..0785797 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -880,6 +880,7 @@ nextag:
 				 * Not in range - save last search
 				 * location and allocate a new inode
 				 */
+				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
 				pag->pagl_leftrec = trec.ir_startino;
 				pag->pagl_rightrec = rec.ir_startino;
 				pag->pagl_pagino = pagino;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

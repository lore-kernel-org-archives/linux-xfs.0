Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9E3w5Dw170500 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 22:58:05 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C47BE17827F3
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 20:59:33 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id WrUoqH8lKJJzOvNK for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 20:59:33 -0700 (PDT)
Message-ID: <4AD54CA4.6000301@sandeen.net>
Date: Tue, 13 Oct 2009 22:59:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] free temporary cursor in xfs_dialloc
References: <4AD54BAF.2050206@sandeen.net>
In-Reply-To: <4AD54BAF.2050206@sandeen.net>
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

(V2 w/o whitespace mangling, ugh)

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

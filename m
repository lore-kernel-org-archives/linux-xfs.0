Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1742A7F4E
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 15:00:55 -0600 (CST)
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D97188F8040
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 13:00:54 -0800 (PST)
Date: Tue, 3 Dec 2013 15:00:54 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [RFC PATCH] xfs: fix calculation of freed inode cluster blocks
Message-ID: <20131203210054.GN1935@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

rec.ir_startino is an agino rather than an ino.  Use the correct macro
when dealing with it in xfs_difree.

---

This is very lightly tested so it's RFC.  Looks like using "ino to
agbno" is actually harmless when you pass in an agino, so there
shouldn't have been any trouble caused by this one.

-Ben

 fs/xfs/xfs_ialloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/xfs/xfs_ialloc.c
===================================================================
--- a/fs/xfs/xfs_ialloc.c	2013-12-03 12:07:24.485185962 -0600
+++ b/fs/xfs/xfs_ialloc.c	2013-12-03 12:07:40.994563706 -0600
@@ -1229,7 +1229,7 @@ xfs_difree(
 		}
 
 		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp,
-				agno, XFS_INO_TO_AGBNO(mp,rec.ir_startino)),
+				agno, XFS_AGINO_TO_AGBNO(mp, rec.ir_startino)),
 				XFS_IALLOC_BLOCKS(mp), flist, mp);
 	} else {
 		*delete = 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

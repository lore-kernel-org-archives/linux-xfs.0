Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5AD5B7F72
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 14:34:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D98BAAC004
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 12:34:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BLU3bAEXifQSnZPn for <xfs@oss.sgi.com>;
	Wed, 09 Sep 2015 12:34:14 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 03/13] xfs_repair: make CRC checking consistent in path
	verification
Date: Wed,  9 Sep 2015 14:34:01 -0500
Message-Id: <1441827251-13128-4-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

verify_da_path and verify_dir2_path both take steps to
re-compute the CRC of the block if it otherwise looks
ok and no other changes are needed.  They do this inside
a loop, but the approach differs; verify_da_path expects
its caller to check the first buffer prior to the loop,
and verify_dir2_path expects its caller to check the last
buffer after the loop.

Make this consistent by semi-arbitrarily choosing to make
verify_da_path (and its caller) match the method used by
verify_dir2_path, and check the last buffer after the
loop is done.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/attr_repair.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index f29a5bd..aba0782 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -606,6 +606,14 @@ verify_da_path(xfs_mount_t	*mp,
 		ASSERT(cursor->level[this_level].dirty == 0 ||
 			(cursor->level[this_level].dirty && !no_modify));
 
+		/*
+		 * If block looks ok but CRC didn't match, make sure to
+		 * recompute it.
+		 */
+		if (!no_modify &&
+		    cursor->level[this_level].bp->b_error == -EFSBADCRC)
+			cursor->level[this_level].dirty = 1;
+
 		if (cursor->level[this_level].dirty && !no_modify)
 			libxfs_writebuf(cursor->level[this_level].bp, 0);
 		else
@@ -618,14 +626,6 @@ verify_da_path(xfs_mount_t	*mp,
 		cursor->level[this_level].hashval =
 					be32_to_cpu(btree[0].hashval);
 		entry = cursor->level[this_level].index = 0;
-
-		/*
-		 * We want to rewrite the buffer on a CRC error seeing as it
-		 * contains what appears to be a valid node block, but only if
-		 * we are fixing errors.
-		 */
-		if (bp->b_error == -EFSBADCRC && !no_modify)
-			cursor->level[this_level].dirty++;
 	}
 	/*
 	 * ditto for block numbers
@@ -1363,8 +1363,6 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 				da_bno, dev_bno, ino);
 			goto error_out;
 		}
-		if (bp->b_error == -EFSBADCRC)
-			repair++;
 
 		leaf = bp->b_addr;
 		xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
@@ -1419,6 +1417,12 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		}
 
 		current_hashval = greatest_hashval;
+                /*
+		 * If block looks ok but CRC didn't match, make sure to
+		 * recompute it.
+		 */
+		if (!no_modify && bp->b_error == -EFSBADCRC)
+			repair++;
 
 		if (repair && !no_modify)
 			libxfs_writebuf(bp, 0);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

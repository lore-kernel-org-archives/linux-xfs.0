Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD0BE7F51
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 14:34:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BA1E28F8054
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 12:34:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id icX4VzWMFN8GzFoZ for <xfs@oss.sgi.com>;
	Wed, 09 Sep 2015 12:34:16 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 10/13] xfs_repair: Remove more differences between attr & dir2
Date: Wed,  9 Sep 2015 14:34:08 -0500
Message-Id: <1441827251-13128-11-git-send-email-sandeen@sandeen.net>
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

This is a hodgepodge of unrelated but not-completely-trivial
chagnes to both the dir2 and attr code to make their common
code more similar.

* It removes the whichfork checking in attr_repair, because we
  only get there with XFS_ATTR_FORK.
* It changes the magic-checking logic slightly to match.
* It swaps some (bp == NULL) tests for (!bp)

These should be purely cosmetic changes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/attr_repair.c |   20 +++++---------------
 repair/dir2.c        |   14 ++++++++------
 2 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index c8ba484..26a0e71 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -177,19 +177,13 @@ traverse_int_dablock(xfs_mount_t	*mp,
 			free(bmp);
 
 		if (!bp) {
-			if (whichfork == XFS_DATA_FORK)
-				do_warn(
-	_("can't read block %u (fsbno %" PRIu64 ") for directory inode %" PRIu64 "\n"),
-					bno, fsbno, da_cursor->ino);
-			else
-				do_warn(
+			do_warn(
 	_("can't read block %u (fsbno %" PRIu64 ") for attrbute fork of inode %" PRIu64 "\n"),
 					bno, fsbno, da_cursor->ino);
 			goto error_out;
 		}
 
 		node = bp->b_addr;
-		btree = M_DIROPS(mp)->node_tree_p(node);
 		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
 
 		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
@@ -210,6 +204,7 @@ _("corrupt tree block %u for directory inode %" PRIu64 "\n"),
 			goto error_out;
 		}
 
+		btree = M_DIROPS(mp)->node_tree_p(node);
 		if (nodehdr.count > geo->node_ents)  {
 			do_warn(_("bad record count in inode %" PRIu64 ", "
 				  "count = %d, max = %d\n"),
@@ -235,14 +230,9 @@ _("bad header depth for directory inode %" PRIu64 "\n"),
 			if (nodehdr.level == i - 1)  {
 				i--;
 			} else  {
-				if (whichfork == XFS_DATA_FORK)
-					do_warn(_("bad directory btree for "
-						  "directory inode %" PRIu64 "\n"),
-						da_cursor->ino);
-				else
-					do_warn(_("bad attribute fork btree "
-						  "for inode %" PRIu64 "\n"),
-						da_cursor->ino);
+				do_warn(_("bad attribute fork btree "
+					  "for inode %" PRIu64 "\n"),
+					da_cursor->ino);
 				libxfs_putbuf(bp);
 				goto error_out;
 			}
diff --git a/repair/dir2.c b/repair/dir2.c
index 9398df5..8cf981f 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -172,7 +172,7 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 		bp = da_read_buf(mp, nex, bmp, &xfs_da3_node_buf_ops);
 		if (bmp != &lbmp)
 			free(bmp);
-		if (bp == NULL) {
+		if (!bp) {
 			do_warn(
 _("can't read block %u for directory inode %" PRIu64 "\n"),
 				bno, da_cursor->ino);
@@ -192,8 +192,10 @@ _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
 			*rbno = 0;
 			libxfs_putbuf(bp);
 			return(1);
-		} else if (!(nodehdr.magic == XFS_DA_NODE_MAGIC ||
-			     nodehdr.magic == XFS_DA3_NODE_MAGIC))  {
+		}
+
+		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
+		    nodehdr.magic != XFS_DA3_NODE_MAGIC)  {
 			libxfs_putbuf(bp);
 			do_warn(
 _("bad dir magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
@@ -574,7 +576,7 @@ _("can't get map info for block %u of directory inode %" PRIu64 "\n"),
 		if (bmp != &lbmp)
 			free(bmp);
 
-		if (bp == NULL) {
+		if (!bp) {
 			do_warn(
 _("can't read block %u for directory inode %" PRIu64 "\n"),
 				dabno, cursor->ino);
@@ -589,8 +591,8 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
 		 * entry count, verify level
 		 */
 		bad = 0;
-		if (!(nodehdr.magic == XFS_DA_NODE_MAGIC ||
-		      nodehdr.magic == XFS_DA3_NODE_MAGIC)) {
+		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
+		    nodehdr.magic != XFS_DA3_NODE_MAGIC) {
 			do_warn(
 _("bad magic number %x in block %u for directory inode %" PRIu64 "\n"),
 				nodehdr.magic,
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

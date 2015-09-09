Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 144B27F5F
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 14:34:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F30C5304062
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 12:34:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ZEo9a6DJEroDL6VS for <xfs@oss.sgi.com>;
	Wed, 09 Sep 2015 12:34:16 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 11/13] xfs_repair: whitespace & comments
Date: Wed,  9 Sep 2015 14:34:09 -0500
Message-Id: <1441827251-13128-12-git-send-email-sandeen@sandeen.net>
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

This patch does nothing but fix up whitespace and comments
to match across dir2.c and attr_repair.c

At this point, a diff of repair/dir2.c and attr_repair.c
show them to be identical in function.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/attr_repair.c |   36 ++++++++++++++++++------------------
 repair/dir2.c        |   46 ++++++++++++++++++++++++----------------------
 2 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 26a0e71..0804a22 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -187,7 +187,7 @@ traverse_int_dablock(xfs_mount_t	*mp,
 		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
 
 		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
-		    nodehdr.magic != XFS_DA3_NODE_MAGIC)  {
+		    nodehdr.magic != XFS_DA3_NODE_MAGIC) {
 			do_warn(_("bad dir/attr magic number in inode %" PRIu64 ", "
 				  "file bno = %u, fsbno = %" PRIu64 "\n"),
 				da_cursor->ino, bno, fsbno);
@@ -205,7 +205,7 @@ _("corrupt tree block %u for directory inode %" PRIu64 "\n"),
 		}
 
 		btree = M_DIROPS(mp)->node_tree_p(node);
-		if (nodehdr.count > geo->node_ents)  {
+		if (nodehdr.count > geo->node_ents) {
 			do_warn(_("bad record count in inode %" PRIu64 ", "
 				  "count = %d, max = %d\n"),
 				da_cursor->ino, nodehdr.count, geo->node_ents);
@@ -226,10 +226,10 @@ _("bad header depth for directory inode %" PRIu64 "\n"),
 				i = -1;
 				goto error_out;
 			}
-		} else  {
-			if (nodehdr.level == i - 1)  {
+		} else {
+			if (nodehdr.level == i - 1) {
 				i--;
-			} else  {
+			} else {
 				do_warn(_("bad attribute fork btree "
 					  "for inode %" PRIu64 "\n"),
 					da_cursor->ino);
@@ -256,7 +256,7 @@ _("bad header depth for directory inode %" PRIu64 "\n"),
 	return(1);
 
 error_out:
-	while (i > 1 && i <= da_cursor->active)  {
+	while (i > 1 && i <= da_cursor->active) {
 		libxfs_putbuf(da_cursor->level[i].bp);
 		i++;
 	}
@@ -351,7 +351,7 @@ verify_final_da_path(xfs_mount_t	*mp,
 	 * that all entries are used, encountered and expected hashvals
 	 * match, etc.
 	 */
-	if (entry != nodehdr.count - 1)  {
+	if (entry != nodehdr.count - 1) {
 		do_warn(_("directory/attribute block used/count "
 			  "inconsistency - %d/%hu\n"),
 			entry, nodehdr.count);
@@ -368,7 +368,7 @@ verify_final_da_path(xfs_mount_t	*mp,
 			be32_to_cpu(btree[entry].hashval));
 		bad++;
 	}
-	if (nodehdr.forw != 0)  {
+	if (nodehdr.forw != 0) {
 		do_warn(_("bad directory/attribute forward block pointer, "
 			  "expected 0, saw %u\n"),
 			nodehdr.forw);
@@ -402,7 +402,7 @@ verify_final_da_path(xfs_mount_t	*mp,
 	}
 
 	if (cursor->level[p_level].hashval != be32_to_cpu(btree[entry].hashval)) {
-		if (!no_modify)  {
+		if (!no_modify) {
 			do_warn(_("correcting bad hashval in non-leaf "
 				  "dir/attr block\n\tin (level %d) in "
 				  "inode %" PRIu64 ".\n"),
@@ -410,7 +410,7 @@ verify_final_da_path(xfs_mount_t	*mp,
 			btree[entry].hashval = cpu_to_be32(
 						cursor->level[p_level].hashval);
 			cursor->level[this_level].dirty++;
-		} else  {
+		} else {
 			do_warn(_("would correct bad hashval in non-leaf "
 				  "dir/attr block\n\tin (level %d) in "
 				  "inode %" PRIu64 ".\n"),
@@ -440,7 +440,7 @@ verify_final_da_path(xfs_mount_t	*mp,
 	/*
 	 * bail out if this is the root block (top of tree)
 	 */
-	if (this_level >= cursor->active)  {
+	if (this_level >= cursor->active) {
 #ifdef XR_DIR_TRACE
 		fprintf(stderr, "verify_final_da_path returns 0 (ok)\n");
 #endif
@@ -529,7 +529,7 @@ verify_da_path(xfs_mount_t	*mp,
 	 * block and move on to the next block.
 	 * and update cursor value for said level
 	 */
-	if (entry >= nodehdr.count)  {
+	if (entry >= nodehdr.count) {
 		/*
 		 * update the hash value for this level before
 		 * validating it.  bno value should be ok since
@@ -588,7 +588,7 @@ _("can't get map info for block %u of directory inode %" PRIu64 "\n"),
 		 */
 		bad = 0;
 		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
-		    nodehdr.magic != XFS_DA3_NODE_MAGIC)  {
+		    nodehdr.magic != XFS_DA3_NODE_MAGIC) {
 			do_warn(
 	_("bad magic number %x in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
 				nodehdr.magic,
@@ -615,7 +615,7 @@ _("can't get map info for block %u of directory inode %" PRIu64 "\n"),
 				dabno, fsbno, cursor->ino);
 			bad++;
 		}
-		if (bad)  {
+		if (bad) {
 #ifdef XR_DIR_TRACE
 			fprintf(stderr, "verify_da_path returns 1 (bad) #4\n");
 #endif
@@ -654,7 +654,7 @@ _("can't get map info for block %u of directory inode %" PRIu64 "\n"),
 	/*
 	 * ditto for block numbers
 	 */
-	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before))  {
+	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
 #ifdef XR_DIR_TRACE
 		fprintf(stderr, "bad directory btree pointer, child bno "
 			"should be %d, block bno is %d, hashval is %u\n",
@@ -670,8 +670,8 @@ _("can't get map info for block %u of directory inode %" PRIu64 "\n"),
 	 * block against the hashval in the current entry
 	 */
 	if (cursor->level[p_level].hashval !=
-				be32_to_cpu(btree[entry].hashval))  {
-		if (!no_modify)  {
+				be32_to_cpu(btree[entry].hashval)) {
+		if (!no_modify) {
 			do_warn(_("correcting bad hashval in interior "
 				  "dir/attr block\n\tin (level %d) in "
 				  "inode %" PRIu64 ".\n"),
@@ -679,7 +679,7 @@ _("can't get map info for block %u of directory inode %" PRIu64 "\n"),
 			btree[entry].hashval = cpu_to_be32(
 						cursor->level[p_level].hashval);
 			cursor->level[this_level].dirty++;
-		} else  {
+		} else {
 			do_warn(_("would correct bad hashval in interior "
 				  "dir/attr block\n\tin (level %d) in "
 				  "inode %" PRIu64 ".\n"),
diff --git a/repair/dir2.c b/repair/dir2.c
index 8cf981f..7b47a9e 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -183,7 +183,7 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
 		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
 
 		if (nodehdr.magic == XFS_DIR2_LEAFN_MAGIC ||
-		    nodehdr.magic == XFS_DIR3_LEAFN_MAGIC)  {
+		    nodehdr.magic == XFS_DIR3_LEAFN_MAGIC) {
 			if ( i != -1 ) {
 				do_warn(
 _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
@@ -195,7 +195,7 @@ _("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
 		}
 
 		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
-		    nodehdr.magic != XFS_DA3_NODE_MAGIC)  {
+		    nodehdr.magic != XFS_DA3_NODE_MAGIC) {
 			libxfs_putbuf(bp);
 			do_warn(
 _("bad dir magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
@@ -212,7 +212,7 @@ _("corrupt tree block %u for directory inode %" PRIu64 "\n"),
 			goto error_out;
 		}
 		btree = M_DIROPS(mp)->node_tree_p(node);
-		if (nodehdr.count > geo->node_ents)  {
+		if (nodehdr.count > geo->node_ents) {
 			do_warn(
 _("bad record count in inode %" PRIu64 ", count = %d, max = %d\n"),
 				da_cursor->ino, nodehdr.count, geo->node_ents);
@@ -233,9 +233,9 @@ _("bad header depth for directory inode %" PRIu64 "\n"),
 				goto error_out;
 			}
 		} else {
-			if (nodehdr.level == i - 1)  {
+			if (nodehdr.level == i - 1) {
 				i--;
-			} else  {
+			} else {
 				do_warn(
 _("bad directory btree for directory inode %" PRIu64 "\n"),
 					da_cursor->ino);
@@ -262,7 +262,7 @@ _("bad directory btree for directory inode %" PRIu64 "\n"),
 	return(1);
 
 error_out:
-	while (i > 1 && i <= da_cursor->active)  {
+	while (i > 1 && i <= da_cursor->active) {
 		libxfs_putbuf(da_cursor->level[i].bp);
 		i++;
 	}
@@ -358,7 +358,7 @@ verify_final_dir2_path(xfs_mount_t	*mp,
 	 * that all entries are used, encountered and expected hashvals
 	 * match, etc.
 	 */
-	if (entry != nodehdr.count - 1)  {
+	if (entry != nodehdr.count - 1) {
 		do_warn(
 		_("directory block used/count inconsistency - %d / %hu\n"),
 			entry, nodehdr.count);
@@ -368,20 +368,20 @@ verify_final_dir2_path(xfs_mount_t	*mp,
 	 * hash values monotonically increasing ???
 	 */
 	if (cursor->level[this_level].hashval >=
-				be32_to_cpu(btree[entry].hashval))  {
+				be32_to_cpu(btree[entry].hashval)) {
 		do_warn(_("directory/attribute block hashvalue inconsistency, "
 			  "expected > %u / saw %u\n"),
 			cursor->level[this_level].hashval,
 			be32_to_cpu(btree[entry].hashval));
 		bad++;
 	}
-	if (nodehdr.forw != 0)  {
+	if (nodehdr.forw != 0) {
 		do_warn(_("bad directory/attribute forward block pointer, "
 			  "expected 0, saw %u\n"),
 			nodehdr.forw);
 		bad++;
 	}
-	if (bad)  {
+	if (bad) {
 		do_warn(_("bad directory block in inode %" PRIu64 "\n"), cursor->ino);
 		return(1);
 	}
@@ -408,8 +408,8 @@ verify_final_dir2_path(xfs_mount_t	*mp,
 	}
 
 	if (cursor->level[p_level].hashval !=
-				be32_to_cpu(btree[entry].hashval))  {
-		if (!no_modify)  {
+				be32_to_cpu(btree[entry].hashval)) {
+		if (!no_modify) {
 			do_warn(
 _("correcting bad hashval in non-leaf dir block\n"
   "\tin (level %d) in inode %" PRIu64 ".\n"),
@@ -417,7 +417,7 @@ _("correcting bad hashval in non-leaf dir block\n"
 			btree[entry].hashval = cpu_to_be32(
 						cursor->level[p_level].hashval);
 			cursor->level[this_level].dirty++;
-		} else  {
+		} else {
 			do_warn(
 _("would correct bad hashval in non-leaf dir block\n"
   "\tin (level %d) in inode %" PRIu64 ".\n"),
@@ -454,7 +454,7 @@ _("would correct bad hashval in non-leaf dir block\n"
 		return(0);
 	}
 	/*
-	 * set hashvalue to correctl reflect the now-validated
+	 * set hashvalue to correctly reflect the now-validated
 	 * last entry in this block and continue upwards validation
 	 */
 	cursor->level[this_level].hashval = hashval;
@@ -536,7 +536,7 @@ verify_dir2_path(xfs_mount_t	*mp,
 	 * block and move on to the next block.
 	 * and update cursor value for said level
 	 */
-	if (entry >= nodehdr.count)  {
+	if (entry >= nodehdr.count) {
 		/*
 		 * update the hash value for this level before
 		 * validating it.  bno value should be ok since
@@ -599,27 +599,27 @@ _("bad magic number %x in block %u for directory inode %" PRIu64 "\n"),
 				dabno, cursor->ino);
 			bad++;
 		}
-		if (nodehdr.back != cursor->level[this_level].bno)  {
+		if (nodehdr.back != cursor->level[this_level].bno) {
 			do_warn(
 _("bad back pointer in block %u for directory inode %" PRIu64 "\n"),
 				dabno, cursor->ino);
 			bad++;
 		}
-		if (nodehdr.count > geo->node_ents)  {
+		if (nodehdr.count > geo->node_ents) {
 			do_warn(
 _("entry count %d too large in block %u for directory inode %" PRIu64 "\n"),
 				nodehdr.count,
 				dabno, cursor->ino);
 			bad++;
 		}
-		if (nodehdr.level != this_level)  {
+		if (nodehdr.level != this_level) {
 			do_warn(
 _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
 				nodehdr.level,
 				dabno, cursor->ino);
 			bad++;
 		}
-		if (bad)  {
+		if (bad) {
 #ifdef XR_DIR_TRACE
 			fprintf(stderr, "verify_dir2_path returns 1 (bad) #4\n");
 #endif
@@ -643,6 +643,8 @@ _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
 			libxfs_writebuf(cursor->level[this_level].bp, 0);
 		else
 			libxfs_putbuf(cursor->level[this_level].bp);
+
+		/* switch cursor to point at the new buffer we just read */
 		cursor->level[this_level].bp = bp;
 		cursor->level[this_level].dirty = 0;
 		cursor->level[this_level].bno = dabno;
@@ -670,8 +672,8 @@ _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
 	 * block against the hashval in the current entry
 	 */
 	if (cursor->level[p_level].hashval !=
-				be32_to_cpu(btree[entry].hashval))  {
-		if (!no_modify)  {
+				be32_to_cpu(btree[entry].hashval)) {
+		if (!no_modify) {
 			do_warn(
 _("correcting bad hashval in interior dir block\n"
   "\tin (level %d) in inode %" PRIu64 ".\n"),
@@ -679,7 +681,7 @@ _("correcting bad hashval in interior dir block\n"
 			btree[entry].hashval = cpu_to_be32(
 					cursor->level[p_level].hashval);
 			cursor->level[this_level].dirty++;
-		} else  {
+		} else {
 			do_warn(
 _("would correct bad hashval in interior dir block\n"
   "\tin (level %d) in inode %" PRIu64 ".\n"),
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B0367F5D
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 04:24:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8514AC005
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 02:24:11 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VyKSYuPHtE1F7C6O for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 02:24:09 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W6HS4-0004fF-Aa
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W6HS4-0004Va-9f
	for xfs@oss.sgi.com; Thu, 23 Jan 2014 21:24:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] metadump: walk single fsb objects a block at a time
Date: Thu, 23 Jan 2014 21:23:54 +1100
Message-Id: <1390472635-17225-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1390472635-17225-1-git-send-email-david@fromorbit.com>
References: <1390472635-17225-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

To be able to support arbitrary discontiguous extents in multi-block
objects, we need to be able to process a single object at a time
presented as a single flat buffer. Right now we pass an arbitrary
extent and have the individal object processing functions break it
up and keep track of inter-call state.

This greatly complicates the processing of directory objects, such
that certain formats are simply not handled at all. Instead, for
single block objects loop over the extent a block at a time, feeding
a whole object to the processing function and hence making the
extent walking generic instead of per object.

At thsi point multi-block directory objects still need to use the
existing code, so duplicate the old single block object code into it
so we can fix it up properly. This means directory block processing
can't be fully cleaned up yet.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c | 180 ++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 107 insertions(+), 73 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 9fc08ed..e973c5e 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1257,12 +1257,11 @@ obfuscate_dir_data_blocks(
 }
 
 static void
-obfuscate_symlink_blocks(
-	char			*block,
-	xfs_dfilblks_t		count)
+obfuscate_symlink_block(
+	char			*block)
 {
-	count <<= mp->m_sb.sb_blocklog;
-	obfuscate_path_components(block, count);
+	/* XXX: need to handle CRC headers */
+	obfuscate_path_components(block, mp->m_sb.sb_blocksize);
 }
 
 #define MAX_REMOTE_VALS		4095
@@ -1283,80 +1282,79 @@ add_remote_vals(
 		blockidx++;
 		length -= XFS_LBSIZE(mp);
 	}
+
+	if (attr_data.remote_val_count >= MAX_REMOTE_VALS) {
+		print_warning(
+"Overflowed attr obfuscation array. No longer obfuscating remote attrs.");
+	}
 }
 
 static void
-obfuscate_attr_blocks(
+obfuscate_attr_block(
 	char			*block,
-	xfs_dfiloff_t		offset,
-	xfs_dfilblks_t		count)
+	xfs_dfiloff_t		offset)
 {
 	xfs_attr_leafblock_t	*leaf;
-	int			c;
 	int			i;
 	int			nentries;
 	xfs_attr_leaf_entry_t 	*entry;
 	xfs_attr_leaf_name_local_t *local;
 	xfs_attr_leaf_name_remote_t *remote;
 
-	for (c = 0; c < count; c++, offset++, block += XFS_LBSIZE(mp)) {
+	leaf = (xfs_attr_leafblock_t *)block;
 
-		leaf = (xfs_attr_leafblock_t *)block;
-
-		if (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC) {
-			for (i = 0; i < attr_data.remote_val_count; i++) {
-				if (attr_data.remote_vals[i] == offset)
-					memset(block, 0, XFS_LBSIZE(mp));
-			}
-			continue;
+	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC) {
+		for (i = 0; i < attr_data.remote_val_count; i++) {
+			/* XXX: need to handle CRC headers */
+			if (attr_data.remote_vals[i] == offset)
+				memset(block, 0, XFS_LBSIZE(mp));
 		}
+		return;
+	}
+
+	nentries = be16_to_cpu(leaf->hdr.count);
+	if (nentries * sizeof(xfs_attr_leaf_entry_t) +
+			sizeof(xfs_attr_leaf_hdr_t) > XFS_LBSIZE(mp)) {
+		if (show_warnings)
+			print_warning("invalid attr count in inode %llu",
+					(long long)cur_ino);
+		return;
+	}
 
-		nentries = be16_to_cpu(leaf->hdr.count);
-		if (nentries * sizeof(xfs_attr_leaf_entry_t) +
-				sizeof(xfs_attr_leaf_hdr_t) > XFS_LBSIZE(mp)) {
+	for (i = 0, entry = &leaf->entries[0]; i < nentries; i++, entry++) {
+		if (be16_to_cpu(entry->nameidx) > XFS_LBSIZE(mp)) {
 			if (show_warnings)
-				print_warning("invalid attr count in inode %llu",
+				print_warning(
+				"invalid attr nameidx in inode %llu",
 						(long long)cur_ino);
-			continue;
+			break;
 		}
-
-		for (i = 0, entry = &leaf->entries[0]; i < nentries;
-				i++, entry++) {
-			if (be16_to_cpu(entry->nameidx) > XFS_LBSIZE(mp)) {
+		if (entry->flags & XFS_ATTR_LOCAL) {
+			local = xfs_attr3_leaf_name_local(leaf, i);
+			if (local->namelen == 0) {
 				if (show_warnings)
-					print_warning("invalid attr nameidx "
-							"in inode %llu",
-							(long long)cur_ino);
+					print_warning(
+				"zero length for attr name in inode %llu",
+						(long long)cur_ino);
 				break;
 			}
-			if (entry->flags & XFS_ATTR_LOCAL) {
-				local = xfs_attr3_leaf_name_local(leaf, i);
-				if (local->namelen == 0) {
-					if (show_warnings)
-						print_warning("zero length for "
-							"attr name in inode %llu",
-							(long long)cur_ino);
-					break;
-				}
-				generate_obfuscated_name(0, local->namelen,
-					&local->nameval[0]);
-				memset(&local->nameval[local->namelen], 0,
-					be16_to_cpu(local->valuelen));
-			} else {
-				remote = xfs_attr3_leaf_name_remote(leaf, i);
-				if (remote->namelen == 0 ||
-						remote->valueblk == 0) {
-					if (show_warnings)
-						print_warning("invalid attr "
-							"entry in inode %llu",
-							(long long)cur_ino);
-					break;
-				}
-				generate_obfuscated_name(0, remote->namelen,
-					&remote->name[0]);
-				add_remote_vals(be32_to_cpu(remote->valueblk),
-					be32_to_cpu(remote->valuelen));
+			generate_obfuscated_name(0, local->namelen,
+				&local->nameval[0]);
+			memset(&local->nameval[local->namelen], 0,
+				be16_to_cpu(local->valuelen));
+		} else {
+			remote = xfs_attr3_leaf_name_remote(leaf, i);
+			if (remote->namelen == 0 || remote->valueblk == 0) {
+				if (show_warnings)
+					print_warning(
+				"invalid attr entry in inode %llu",
+						(long long)cur_ino);
+				break;
 			}
+			generate_obfuscated_name(0, remote->namelen,
+						 &remote->name[0]);
+			add_remote_vals(be32_to_cpu(remote->valueblk),
+					be32_to_cpu(remote->valuelen));
 		}
 	}
 }
@@ -1369,7 +1367,9 @@ process_single_fsb_objects(
 	typnm_t		btype,
 	xfs_dfiloff_t	last)
 {
+	char		*dp;
 	int		ret = 0;
+	int		i;
 
 	push_cur();
 	set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s), c * blkbb,
@@ -1392,22 +1392,27 @@ process_single_fsb_objects(
 		goto out_pop;
 	}
 
-	switch (btype) {
-	case TYP_DIR2:
-		if (o >= mp->m_dirleafblk)
-			break;
+	dp = iocur_top->data;
+	for (i = 0; i < c; i++) {
+		switch (btype) {
+		case TYP_DIR2:
+			if (o >= mp->m_dirleafblk)
+				break;
 
-		obfuscate_dir_data_blocks(iocur_top->data, o, c,
-					 last == mp->m_dirblkfsbs);
-		break;
-	case TYP_SYMLINK:
-		obfuscate_symlink_blocks(iocur_top->data, c);
-		break;
-	case TYP_ATTR:
-		obfuscate_attr_blocks(iocur_top->data, o, c);
-		break;
-	default:
-		break;
+			obfuscate_dir_data_blocks(dp, o, 1,
+						  last == mp->m_dirblkfsbs);
+			break;
+		case TYP_SYMLINK:
+			obfuscate_symlink_block(dp);
+			break;
+		case TYP_ATTR:
+			obfuscate_attr_block(dp, o);
+			break;
+		default:
+			break;
+		}
+		o++;
+		dp += mp->m_sb.sb_blocksize;
 	}
 	ret = write_buf(iocur_top);
 
@@ -1424,12 +1429,41 @@ process_multi_fsb_objects(
 	typnm_t		btype,
 	xfs_dfiloff_t	last)
 {
+	int		ret = 0;
+
 	if (btype != TYP_DIR2) {
 		print_warning("bad type for multi-fsb object %d", btype);
 		return -EINVAL;
 	}
 
-	return process_single_fsb_objects(o, s, c, btype, last);
+	push_cur();
+	set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s), c * blkbb,
+			DB_RING_IGN, NULL);
+
+	if (!iocur_top->data) {
+		xfs_agnumber_t	agno = XFS_FSB_TO_AGNO(mp, s);
+		xfs_agblock_t	agbno = XFS_FSB_TO_AGBNO(mp, s);
+
+		print_warning("cannot read %s block %u/%u (%llu)",
+				typtab[btype].name, agno, agbno, s);
+		if (stop_on_read_error)
+			ret = -EIO;
+		goto out_pop;
+
+	}
+
+	if (dont_obfuscate || o >= mp->m_dirleafblk) {
+		ret = write_buf(iocur_top);
+		goto out_pop;
+	}
+
+	obfuscate_dir_data_blocks(iocur_top->data, o, c,
+				 last == mp->m_dirblkfsbs);
+	ret = write_buf(iocur_top);
+
+out_pop:
+	pop_cur();
+	return ret;
 }
 
 /* inode copy routines */
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

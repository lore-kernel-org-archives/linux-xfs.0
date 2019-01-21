Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbfAUMEO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jan 2019 07:04:14 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5CDAC83F46
        for <linux-xfs@vger.kernel.org>; Mon, 21 Jan 2019 12:04:13 +0000 (UTC)
Received: from hades.usersys.redhat.com (unknown [10.40.205.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B072C68384
        for <linux-xfs@vger.kernel.org>; Mon, 21 Jan 2019 12:04:12 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Fix metadump CRC miscalculation of symlink blocks
Date: Mon, 21 Jan 2019 13:04:07 +0100
Message-Id: <20190121120407.25413-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

When recalculating the CRC of symlink blocks (due obfuscation and/or
zero_stale_data), xfs_metadump uses wrong offsets for its calculation.

symlink blocks have a single header for each extent in the inode, so,
the CRC calculation is done based on the whole extent.
xfs_metadump assumes a single FSB to calculate CRCs, doesn't matter the
type of metadata.

To fix this, xfs_metadump should process symlink blocks using whole
extents instead of a block-by-block granularity.

This patch refactors process_single_fsb_objects(), moving all the code
used to process each object (now either a single block or the whole
extent) to a new function called process_object(), and use
process_single_fsb_objects() to either loop across each block on a
single extent, or, to read the whole extent in a single buffer and set
the cursor appropriately.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Comments are much appreciated :)

 db/metadump.c | 158 +++++++++++++++++++++++++++-----------------------
 1 file changed, 87 insertions(+), 71 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 8b8e4725..c84f0a32 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1752,98 +1752,114 @@ process_attr_block(
 	}
 }
 
-/* Processes symlinks, attrs, directories ... */
 static int
-process_single_fsb_objects(
+process_object(
 	xfs_fileoff_t	o,
 	xfs_fsblock_t	s,
 	xfs_filblks_t	c,
 	typnm_t		btype,
 	xfs_fileoff_t	last)
 {
-	char		*dp;
-	int		ret = 0;
-	int		i;
+	char *dp;
 
-	for (i = 0; i < c; i++) {
-		push_cur();
-		set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s), blkbb,
-				DB_RING_IGN, NULL);
-
-		if (!iocur_top->data) {
-			xfs_agnumber_t	agno = XFS_FSB_TO_AGNO(mp, s);
-			xfs_agblock_t	agbno = XFS_FSB_TO_AGBNO(mp, s);
-
-			print_warning("cannot read %s block %u/%u (%llu)",
-					typtab[btype].name, agno, agbno, s);
-			if (stop_on_read_error)
-				ret = -EIO;
-			goto out_pop;
+	if (!iocur_top->data) {
+		xfs_agnumber_t	agno = XFS_FSB_TO_AGNO(mp, s);
+		xfs_agblock_t	agbno = XFS_FSB_TO_AGBNO(mp, s);
 
-		}
+		print_warning("canot read %s block %u/%u (%llu)",
+				typtab[btype].name, agno, agbno, s);
+		if (stop_on_read_error)
+			return -EIO;
+	}
 
-		if (!obfuscate && !zero_stale_data)
-			goto write;
+	if (!obfuscate && !zero_stale_data)
+		return write_buf(iocur_top);
 
-		/* Zero unused part of interior nodes */
-		if (zero_stale_data) {
-			xfs_da_intnode_t *node = iocur_top->data;
-			int magic = be16_to_cpu(node->hdr.info.magic);
+	if (zero_stale_data) {
+		xfs_da_intnode_t *node = iocur_top->data;
+		int magic = be16_to_cpu(node->hdr.info.magic);
 
-			if (magic == XFS_DA_NODE_MAGIC ||
-			    magic == XFS_DA3_NODE_MAGIC) {
-				struct xfs_da3_icnode_hdr hdr;
-				int used;
+		if (magic == XFS_DA_NODE_MAGIC ||
+		    magic == XFS_DA3_NODE_MAGIC) {
+			struct xfs_da3_icnode_hdr hdr;
+			int used;
 
-				M_DIROPS(mp)->node_hdr_from_disk(&hdr, node);
-				used = M_DIROPS(mp)->node_hdr_size;
+			M_DIROPS(mp)->node_hdr_from_disk(&hdr, node);
+			used = M_DIROPS(mp)->node_hdr_size;
 
-				used += hdr.count
-					* sizeof(struct xfs_da_node_entry);
+			used += hdr.count
+				* sizeof(struct xfs_da_node_entry);
 
-				if (used < mp->m_sb.sb_blocksize) {
-					memset((char *)node + used, 0,
-						mp->m_sb.sb_blocksize - used);
-					iocur_top->need_crc = 1;
-				}
+			if (used < mp->m_sb.sb_blocksize) {
+				memset((char *)node + used, 0,
+					mp->m_sb.sb_blocksize - used);
+				iocur_top->need_crc = 1;
 			}
 		}
+	}
 
-		/* Handle leaf nodes */
-		dp = iocur_top->data;
-		switch (btype) {
-		case TYP_DIR2:
-			if (o >= mp->m_dir_geo->freeblk) {
-				/* TODO, zap any stale data */
-				break;
-			} else if (o >= mp->m_dir_geo->leafblk) {
-				process_dir_leaf_block(dp);
-			} else {
-				process_dir_data_block(dp, o,
-					 last == mp->m_dir_geo->fsbcount);
-			}
-			iocur_top->need_crc = 1;
-			break;
-		case TYP_SYMLINK:
-			process_symlink_block(dp);
-			iocur_top->need_crc = 1;
-			break;
-		case TYP_ATTR:
-			process_attr_block(dp, o);
-			iocur_top->need_crc = 1;
-			break;
-		default:
+	dp = iocur_top->data;
+	switch (btype) {
+	case TYP_DIR2:
+		if (o >= mp->m_dir_geo->freeblk)
 			break;
-		}
+		else if (o >= mp->m_dir_geo->leafblk)
+			process_dir_leaf_block(dp);
+		else
+			process_dir_data_block(dp, o,
+					last == mp->m_dir_geo->fsbcount);
+		break;
+	case TYP_SYMLINK:
+		process_symlink_block(dp);
+		break;
+	case TYP_ATTR:
+		process_attr_block(dp, o);
+		break;
+	default:
+		return write_buf(iocur_top);
+	}
 
-write:
-		ret = write_buf(iocur_top);
-out_pop:
+
+	iocur_top->need_crc = 1;
+	return write_buf(iocur_top);
+
+}
+/* Processes symlinks, attrs, directories ... */
+static int
+process_single_fsb_objects(
+	xfs_fileoff_t	o,
+	xfs_fsblock_t	s,
+	xfs_filblks_t	c,
+	typnm_t		btype,
+	xfs_fileoff_t	last)
+{
+	int		ret = 0;
+	int		i;
+
+	/*
+	 * Symlink inodes have one header per extent. Process the whole extent
+	 * if this is the case so CRCs are properly calculated.
+	 */
+	if (btype == TYP_SYMLINK) {
+		push_cur();
+		set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s),
+				(blkbb * c), DB_RING_IGN, NULL);
+		ret = process_object(o, s, c, btype, last);
 		pop_cur();
-		if (ret)
-			break;
-		o++;
-		s++;
+	} else {
+		for (i = 0; i < c; i++) {
+			push_cur();
+			set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s),
+					blkbb, DB_RING_IGN, NULL);
+			ret = process_object(o, s, c, btype, last);
+
+			pop_cur();
+			if (ret)
+				return ret;
+			o++;
+			s++;
+
+		}
 	}
 
 	return ret;
-- 
2.17.2

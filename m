Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF9597F5E
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 04:33:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D3A1304059
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 02:33:40 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id hqORsd4xDcPR55l0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 02:33:38 -0700 (PDT)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 83AAAABEF
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 09:33:37 +0000 (UTC)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] repair: Repair directory block CRC mismatches
Date: Tue, 24 Jun 2014 11:33:35 +0200
Message-Id: <1403602415-28767-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

It can happen that just CRC doesn't match for directory blocks. In that
case xfs_repair will just report the error but won't fix anything (as
further checking of the block doesn't reveal any problems). Make sure we
recompute and write out new CRC when we failed verification during
reading.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 repair/dir2.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index 14c1435f5077..a189c161e569 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -596,7 +596,13 @@ _("bad level %d in block %u for directory inode %" PRIu64 "\n"),
 		 */
 		ASSERT(cursor->level[this_level].dirty == 0 ||
 			(cursor->level[this_level].dirty && !no_modify));
-
+		/*
+		 * If block looks ok but CRC didn't match, make sure to
+		 * recompute it.
+		 */
+		if (!no_modify &&
+		    cursor->level[this_level].bp->b_error == EFSBADCRC)
+			cursor->level[this_level].dirty = 1;
 		if (cursor->level[this_level].dirty && !no_modify)
 			libxfs_writebuf(cursor->level[this_level].bp, 0);
 		else
@@ -1621,6 +1627,9 @@ _("bad directory block magic # %#x in block %u for directory inode %" PRIu64 "\n
 		blp = (xfs_dir2_leaf_entry_t *)btp;
 	rval = process_dir2_data(mp, ino, dip, ino_discovery, dirname, parent,
 		bp, dot, dotdot, mp->m_dirdatablk, (char *)blp, &dirty);
+	/* If block looks ok but CRC didn't match, make sure to recompute it. */
+	if (!rval && bp->b_error == EFSBADCRC)
+		dirty = 1;
 	if (dirty && !no_modify) {
 		*repair = 1;
 		libxfs_writebuf(bp, 0);
@@ -1784,6 +1793,12 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 			}
 		}
 		current_hashval = greatest_hashval;
+		/*
+		 * If block looks ok but CRC didn't match, make sure to
+		 * recompute it.
+		 */
+		if (!no_modify && bp->b_error == EFSBADCRC)
+			buf_dirty = 1;
 		ASSERT(buf_dirty == 0 || (buf_dirty && !no_modify));
 		if (buf_dirty && !no_modify) {
 			*repair = 1;
@@ -1927,8 +1942,12 @@ _("bad directory block magic # %#x in block %" PRIu64 " for directory inode %" P
 		i = process_dir2_data(mp, ino, dip, ino_discovery, dirname,
 			parent, bp, dot, dotdot, (xfs_dablk_t)dbno,
 			(char *)data + mp->m_dirblksize, &dirty);
-		if (i == 0)
+		if (i == 0) {
 			good++;
+			/* Maybe just CRC is wrong. Make sure we correct it. */
+			if (bp->b_error == EFSBADCRC)
+				dirty = 1;
+		}
 		if (dirty && !no_modify) {
 			*repair = 1;
 			libxfs_writebuf(bp, 0);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

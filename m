Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45519 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755110AbcJGXHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 19:07:46 -0400
Subject: [PATCH 3/7] xfs: reduce stack usage of _reflink_clear_inode_flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Oct 2016 16:07:38 -0700
Message-ID: <147588165809.12127.6624984020251009472.stgit@birch.djwong.org>
In-Reply-To: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

The loop in _reflink_clear_inode_flag isn't necessary since we
jump out if any part of any extent is shared.  Remove the loop
and we no longer need two maps, so we can save some stack use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_reflink.c |   40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 9c58b4a..c4e35dc 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1507,7 +1507,7 @@ xfs_reflink_clear_inode_flag(
 	xfs_extlen_t		aglen;
 	xfs_agblock_t		rbno;
 	xfs_extlen_t		rlen;
-	struct xfs_bmbt_irec	map[2];
+	struct xfs_bmbt_irec	map;
 	int			nmaps;
 	int			error = 0;
 
@@ -1521,37 +1521,29 @@ xfs_reflink_clear_inode_flag(
 		 * Look for extents in the file.  Skip holes, delalloc, or
 		 * unwritten extents; they can't be reflinked.
 		 */
-		error = xfs_bmapi_read(ip, fbno, end - fbno, map, &nmaps, 0);
+		error = xfs_bmapi_read(ip, fbno, end - fbno, &map, &nmaps, 0);
 		if (error)
 			return error;
 		if (nmaps == 0)
 			break;
-		if (map[0].br_startblock == HOLESTARTBLOCK ||
-		    map[0].br_startblock == DELAYSTARTBLOCK ||
-		    ISUNWRITTEN(&map[0]))
+		if (map.br_startblock == HOLESTARTBLOCK ||
+		    map.br_startblock == DELAYSTARTBLOCK ||
+		    ISUNWRITTEN(&map))
 			goto next;
 
-		map[1] = map[0];
-		while (map[1].br_blockcount) {
-			agno = XFS_FSB_TO_AGNO(mp, map[1].br_startblock);
-			agbno = XFS_FSB_TO_AGBNO(mp, map[1].br_startblock);
-			aglen = map[1].br_blockcount;
-
-			error = xfs_reflink_find_shared(mp, agno, agbno, aglen,
-					&rbno, &rlen, false);
-			if (error)
-				return error;
-			/* Is there still a shared block here? */
-			if (rbno != NULLAGBLOCK)
-				return 0;
-
-			map[1].br_blockcount -= aglen;
-			map[1].br_startoff += aglen;
-			map[1].br_startblock += aglen;
-		}
+		agno = XFS_FSB_TO_AGNO(mp, map.br_startblock);
+		agbno = XFS_FSB_TO_AGBNO(mp, map.br_startblock);
+		aglen = map.br_blockcount;
 
+		error = xfs_reflink_find_shared(mp, agno, agbno, aglen,
+				&rbno, &rlen, false);
+		if (error)
+			return error;
+		/* Is there still a shared block here? */
+		if (rbno != NULLAGBLOCK)
+			return 0;
 next:
-		fbno = map[0].br_startoff + map[0].br_blockcount;
+		fbno = map.br_startoff + map.br_blockcount;
 	}
 
 	/*


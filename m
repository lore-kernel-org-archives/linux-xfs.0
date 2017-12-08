Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49218 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752428AbdLHDjv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 22:39:51 -0500
Subject: [PATCH 5/5] xfs: only skip rmap owner checks for unknown-owner rmap
 removal
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 07 Dec 2017 19:39:39 -0800
Message-ID: <151270437900.12194.1274499001703749199.stgit@magnolia>
In-Reply-To: <151270433736.12194.14709247629624139846.stgit@magnolia>
References: <151270433736.12194.14709247629624139846.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, libor.klepac@bcom.cz, bfoster@redhat.com, alex@zadarastorage.com, david@fromorbit.com

From: Darrick J. Wong <darrick.wong@oracle.com>

For rmap removal, refactor the rmap owner checks into a separate
function, then skip the checks if we are performing an unknown-owner
removal.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   76 +++++++++++++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 7465cfb..50db920 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -368,6 +368,51 @@ xfs_rmap_lookup_le_range(
 }
 
 /*
+ * Perform all the relevant owner checks for a removal op.  If we're doing an
+ * unknown-owner removal then we have no owner information to check.
+ */
+static int
+xfs_rmap_free_check_owner(
+	struct xfs_mount	*mp,
+	uint64_t		ltoff,
+	struct xfs_rmap_irec	*rec,
+	xfs_fsblock_t		bno,
+	xfs_filblks_t		len,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags)
+{
+	int			error = 0;
+
+	if (owner == XFS_RMAP_OWN_UNKNOWN)
+		return 0;
+
+	/* Make sure the unwritten flag matches. */
+	XFS_WANT_CORRUPTED_GOTO(mp, (flags & XFS_RMAP_UNWRITTEN) ==
+			(rec->rm_flags & XFS_RMAP_UNWRITTEN), out);
+
+	/* Make sure the owner matches what we expect to find in the tree. */
+	XFS_WANT_CORRUPTED_GOTO(mp, owner == rec->rm_owner, out);
+
+	/* Check the offset, if necessary. */
+	if (XFS_RMAP_NON_INODE_OWNER(owner))
+		goto out;
+
+	if (flags & XFS_RMAP_BMBT_BLOCK) {
+		XFS_WANT_CORRUPTED_GOTO(mp, rec->rm_flags & XFS_RMAP_BMBT_BLOCK,
+				out);
+	} else {
+		XFS_WANT_CORRUPTED_GOTO(mp, rec->rm_offset <= offset, out);
+		XFS_WANT_CORRUPTED_GOTO(mp,
+				ltoff + rec->rm_blockcount >= offset + len,
+				out);
+	}
+
+out:
+	return error;
+}
+
+/*
  * Find the extent in the rmap btree and remove it.
  *
  * The record we find should always be an exact match for the extent that we're
@@ -468,33 +513,16 @@ xfs_rmap_unmap(
 			goto out_done;
 	}
 
-	/* Make sure the unwritten flag matches. */
-	XFS_WANT_CORRUPTED_GOTO(mp, (flags & XFS_RMAP_UNWRITTEN) ==
-			(ltrec.rm_flags & XFS_RMAP_UNWRITTEN), out_error);
-
 	/* Make sure the extent we found covers the entire freeing range. */
 	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno &&
-		ltrec.rm_startblock + ltrec.rm_blockcount >=
-		bno + len, out_error);
-
-	/* Make sure the owner matches what we expect to find in the tree. */
-	XFS_WANT_CORRUPTED_GOTO(mp, owner == ltrec.rm_owner ||
-				    XFS_RMAP_NON_INODE_OWNER(owner), out_error);
+			ltrec.rm_startblock + ltrec.rm_blockcount >=
+			bno + len, out_error);
 
-	/* Check the offset, if necessary. */
-	if (!XFS_RMAP_NON_INODE_OWNER(owner)) {
-		if (flags & XFS_RMAP_BMBT_BLOCK) {
-			XFS_WANT_CORRUPTED_GOTO(mp,
-					ltrec.rm_flags & XFS_RMAP_BMBT_BLOCK,
-					out_error);
-		} else {
-			XFS_WANT_CORRUPTED_GOTO(mp,
-					ltrec.rm_offset <= offset, out_error);
-			XFS_WANT_CORRUPTED_GOTO(mp,
-					ltoff + ltrec.rm_blockcount >= offset + len,
-					out_error);
-		}
-	}
+	/* Check owner information. */
+	error = xfs_rmap_free_check_owner(mp, ltoff, &ltrec, bno, len, owner,
+			offset, flags);
+	if (error)
+		goto out_error;
 
 	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
 		/* exact match, simply remove the record from rmap tree */


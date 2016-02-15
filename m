Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 193557CAC
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:19:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A435BAC005
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:18:57 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	W5EzOey1YcEWNS8a for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:18:55 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000MB-Gw
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005GJ-GE
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/14] xfs: log local to remote symlink conversions correctly
	on v5 supers
Date: Mon, 15 Feb 2016 17:18:14 +1100
Message-Id: <1455517105-20033-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

From: Brian Foster <bfoster@redhat.com>

Source kernel commit b7cdc66be54b64daef593894d12ecc405f117829

A local format symlink inode is converted to extent format when an
extended attribute is set on an inode as part of the attribute fork
creation. This means a block is allocated, the local symlink target name
is copied to the block and the block is logged. Currently,
xfs_bmap_local_to_extents() handles logging the remote block data based
on the size of the data fork prior to the conversion. This is not
correct on v5 superblock filesystems, which add an additional header to
remote symlink blocks that is nonexistent in local format inodes.

As a result, the full length of the remote symlink block content is not
logged. This can lead to corruption should a crash occur and log
recovery replay this transaction.

Since a callout is already used to initialize the new remote symlink
block, update the local-to-extents conversion mechanism to make the
callout also responsible for logging the block. It is already required
to set the log buffer type and format the block appropriately based on
the superblock version. This ensures the remote symlink is always logged
correctly. Note that xfs_bmap_local_to_extents() is only called for
symlinks so there are no other callouts that require modification.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_bmap.c           | 10 ++++++----
 libxfs/xfs_symlink_remote.c |  3 +++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index b9e58e2..8464810 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -940,14 +940,16 @@ xfs_bmap_local_to_extents(
 	bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
 
 	/*
-	 * Initialise the block and copy the data
+	 * Initialize the block, copy the data and log the remote buffer.
 	 *
-	 * Note: init_fn must set the buffer log item type correctly!
+	 * The callout is responsible for logging because the remote format
+	 * might differ from the local format and thus we don't know how much to
+	 * log here. Note that init_fn must also set the buffer log item type
+	 * correctly.
 	 */
 	init_fn(tp, bp, ip, ifp);
 
-	/* account for the change in fork size and log everything */
-	xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
+	/* account for the change in fork size */
 	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
 	xfs_bmap_local_to_extents_empty(ip, whichfork);
 	flags |= XFS_ILOG_CORE;
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index fb9ece8..04c7446 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -184,6 +184,7 @@ xfs_symlink_local_to_remote(
 	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
 		bp->b_ops = NULL;
 		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
+		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
 		return;
 	}
 
@@ -199,4 +200,6 @@ xfs_symlink_local_to_remote(
 	buf = bp->b_addr;
 	buf += xfs_symlink_hdr_set(mp, ip->i_ino, 0, ifp->if_bytes, bp);
 	memcpy(buf, ifp->if_u1.if_data, ifp->if_bytes);
+	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
+					ifp->if_bytes - 1);
 }
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

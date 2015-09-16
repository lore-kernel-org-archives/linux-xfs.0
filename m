Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E0A5C7F47
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 11:31:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C55EB304051
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 09:31:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mvBWDbUGVelXjQyL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2015 09:31:36 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 06E16461E7
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 16:31:36 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-92.bos.redhat.com [10.18.41.92])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8GGVZZb006580
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 12:31:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: log local to remote symlink conversions correctly on v5
	supers
Date: Wed, 16 Sep 2015 12:31:34 -0400
Message-Id: <1442421094-15791-1-git-send-email-bfoster@redhat.com>
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
---
 fs/xfs/libxfs/xfs_bmap.c           | 10 ++++++----
 fs/xfs/libxfs/xfs_symlink_remote.c |  3 +++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8e2010d..b5cb61e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -948,14 +948,16 @@ xfs_bmap_local_to_extents(
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
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 8f8af05..b9884aa 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -183,6 +183,7 @@ xfs_symlink_local_to_remote(
 	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
 		bp->b_ops = NULL;
 		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
+		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
 		return;
 	}
 
@@ -198,4 +199,6 @@ xfs_symlink_local_to_remote(
 	buf = bp->b_addr;
 	buf += xfs_symlink_hdr_set(mp, ip->i_ino, 0, ifp->if_bytes, bp);
 	memcpy(buf, ifp->if_u1.if_data, ifp->if_bytes);
+	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
+					ifp->if_bytes - 1);
 }
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfCHQNX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Mar 2019 11:13:23 -0500
Date: Fri, 8 Mar 2019 08:13:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: clean up xfs_dir2_leafn_add
Message-ID: <20190308161308.GC4676@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Nathan Chancellor <natechancellor@gmail.com>, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove typedefs and consolidate local variable initialization.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index de46f26c5292..16731d2d684b 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -426,26 +426,22 @@ xfs_dir2_leaf_to_node(
 static int					/* error */
 xfs_dir2_leafn_add(
 	struct xfs_buf		*bp,		/* leaf buffer */
-	xfs_da_args_t		*args,		/* operation arguments */
+	struct xfs_da_args	*args,		/* operation arguments */
 	int			index)		/* insertion pt for new entry */
 {
+	struct xfs_dir3_icleaf_hdr leafhdr;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_dir2_leaf	*leaf = bp->b_addr;
+	struct xfs_dir2_leaf_entry *lep;
+	struct xfs_dir2_leaf_entry *ents;
 	int			compact;	/* compacting stale leaves */
-	xfs_inode_t		*dp;		/* incore directory inode */
-	int			highstale;	/* next stale entry */
-	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
-	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
+	int			highstale = 0;	/* next stale entry */
 	int			lfloghigh;	/* high leaf entry logging */
 	int			lfloglow;	/* low leaf entry logging */
-	int			lowstale;	/* previous stale entry */
-	struct xfs_dir3_icleaf_hdr leafhdr;
-	struct xfs_dir2_leaf_entry *ents;
+	int			lowstale = 0;	/* previous stale entry */
 
 	trace_xfs_dir2_leafn_add(args, index);
 
-	dp = args->dp;
-	leaf = bp->b_addr;
-	highstale = 0;
-	lowstale = 0;
 	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 

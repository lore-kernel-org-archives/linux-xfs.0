Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 793C07F85
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 17:00:08 -0500 (CDT)
Date: Thu, 8 Aug 2013 17:00:07 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 9] xfsprogs: issues with a24374f41c9
Message-ID: <20130808220007.GW3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130808210600.GN3111@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

This patch corresponds with kernel commit 517c22207b04.  There were a couple
bits that didn't match when it was copied to libxfs.

---
 libxfs/xfs_attr.c      |    2 +-
 libxfs/xfs_attr_leaf.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

Index: b/libxfs/xfs_attr.c
===================================================================
--- a/libxfs/xfs_attr.c	2013-08-06 13:38:35.480817970 -0500
+++ b/libxfs/xfs_attr.c	2013-08-06 13:38:56.660877582 -0500
@@ -861,7 +861,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *
 	error = xfs_attr3_leaf_lookup_int(bp, args);
 	if (error == ENOATTR) {
 		xfs_trans_brelse(args->trans, bp);
-		return(error);
+		return error;
 	}
 
 	xfs_attr3_leaf_remove(bp, args);
Index: b/libxfs/xfs_attr_leaf.c
===================================================================
--- a/libxfs/xfs_attr_leaf.c	2013-08-06 13:39:07.140818083 -0500
+++ b/libxfs/xfs_attr_leaf.c	2013-08-06 13:39:29.450857207 -0500
@@ -1111,7 +1111,6 @@ xfs_attr3_leaf_add_work(
 	struct xfs_attr_leaf_entry *entry;
 	struct xfs_attr_leaf_name_local *name_loc;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	struct xfs_attr_leaf_map *map;
 	struct xfs_mount	*mp;
 	int			tmp;
 	int			i;
@@ -1210,7 +1209,7 @@ xfs_attr3_leaf_add_work(
 	tmp = (ichdr->count - 1) * sizeof(xfs_attr_leaf_entry_t)
 					+ xfs_attr3_leaf_hdr_size(leaf);
 
-	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; map++, i++) {
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
 		if (ichdr->freemap[i].base == tmp) {
 			ichdr->freemap[i].base += sizeof(xfs_attr_leaf_entry_t);
 			ichdr->freemap[i].size -= sizeof(xfs_attr_leaf_entry_t);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

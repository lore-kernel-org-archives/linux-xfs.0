Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935605AbeF1Qgj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 93173818F6F8
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DEA6111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 16/24] xfs: remove struct xfs_bmalloca dfops field
Date: Thu, 28 Jun 2018 12:36:28 -0400
Message-Id: <20180628163636.52564-17-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that bma.dfops is only assigned from ->t_dfops, replace all
accesses to the former with the latter and remove the unnecessary
field. This patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 30 +++++++++++++++---------------
 fs/xfs/libxfs/xfs_bmap.h |  1 -
 fs/xfs/xfs_filestream.c  |  3 ++-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2bbeccad1e90..17b0b22a1edf 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1806,7 +1806,7 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-					bma->firstblock, bma->dfops,
+					bma->firstblock, bma->tp->t_dfops,
 					&bma->cur, 1, &tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
@@ -1884,7 +1884,7 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-				bma->firstblock, bma->dfops, &bma->cur, 1,
+				bma->firstblock, bma->tp->t_dfops, &bma->cur, 1,
 				&tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
@@ -1965,8 +1965,8 @@ xfs_bmap_add_extent_delay_real(
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-					bma->firstblock, bma->dfops, &bma->cur,
-					1, &tmp_rval, whichfork);
+					bma->firstblock, bma->tp->t_dfops,
+					&bma->cur, 1, &tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
@@ -1991,7 +1991,7 @@ xfs_bmap_add_extent_delay_real(
 
 	/* add reverse mapping unless caller opted out */
 	if (!(bma->flags & XFS_BMAPI_NORMAP)) {
-		error = xfs_rmap_map_extent(mp, bma->dfops, bma->ip,
+		error = xfs_rmap_map_extent(mp, bma->tp->t_dfops, bma->ip,
 				whichfork, new);
 		if (error)
 			goto done;
@@ -2003,7 +2003,7 @@ xfs_bmap_add_extent_delay_real(
 
 		ASSERT(bma->cur == NULL);
 		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
-				bma->firstblock, bma->dfops, &bma->cur,
+				bma->firstblock, bma->tp->t_dfops, &bma->cur,
 				da_old > 0, &tmp_logflags, whichfork);
 		bma->logflags |= tmp_logflags;
 		if (error)
@@ -3480,7 +3480,7 @@ xfs_bmap_btalloc(
 			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
 		if (error)
 			return error;
-	} else if (ap->dfops->dop_low) {
+	} else if (ap->tp->t_dfops->dop_low) {
 		if (xfs_inode_is_filestream(ap->ip))
 			args.type = XFS_ALLOCTYPE_FIRST_AG;
 		else
@@ -3515,7 +3515,7 @@ xfs_bmap_btalloc(
 	 * is >= the stripe unit and the allocation offset is
 	 * at the end of file.
 	 */
-	if (!ap->dfops->dop_low && ap->aeof) {
+	if (!ap->tp->t_dfops->dop_low && ap->aeof) {
 		if (!ap->offset) {
 			args.alignment = stripe_align;
 			atype = args.type;
@@ -3607,7 +3607,7 @@ xfs_bmap_btalloc(
 		args.total = ap->minlen;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
-		ap->dfops->dop_low = true;
+		ap->tp->t_dfops->dop_low = true;
 	}
 	if (args.fsbno != NULLFSBLOCK) {
 		/*
@@ -4083,7 +4083,7 @@ xfs_bmapi_allocate(
 	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
 		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
 		bma->cur->bc_private.b.firstblock = *bma->firstblock;
-		bma->cur->bc_private.b.dfops = bma->dfops;
+		bma->cur->bc_private.b.dfops = bma->tp->t_dfops;
 	}
 	/*
 	 * Bump the number of extents we've allocated
@@ -4119,8 +4119,8 @@ xfs_bmapi_allocate(
 	else
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
 				whichfork, &bma->icur, &bma->cur, &bma->got,
-				bma->firstblock, bma->dfops, &bma->logflags,
-				bma->flags);
+				bma->firstblock, bma->tp->t_dfops,
+				&bma->logflags, bma->flags);
 
 	bma->logflags |= tmp_logflags;
 	if (error)
@@ -4172,7 +4172,7 @@ xfs_bmapi_convert_unwritten(
 		bma->cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
 					bma->ip, whichfork);
 		bma->cur->bc_private.b.firstblock = *bma->firstblock;
-		bma->cur->bc_private.b.dfops = bma->dfops;
+		bma->cur->bc_private.b.dfops = bma->tp->t_dfops;
 	}
 	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
@@ -4190,7 +4190,7 @@ xfs_bmapi_convert_unwritten(
 
 	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, whichfork,
 			&bma->icur, &bma->cur, mval, bma->firstblock,
-			bma->dfops, &tmp_logflags);
+			bma->tp->t_dfops, &tmp_logflags);
 	/*
 	 * Log the inode core unconditionally in the unwritten extent conversion
 	 * path because the conversion might not have done so (e.g., if the
@@ -4338,8 +4338,8 @@ xfs_bmapi_write(
 	bma.ip = ip;
 	bma.total = total;
 	bma.datatype = 0;
-	bma.dfops = tp ? tp->t_dfops : NULL;
 	bma.firstblock = firstblock;
+	ASSERT(!tp || tp->t_dfops);
 
 	while (bno < end && n < *nmap) {
 		bool			need_alloc = false, wasdelay = false;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 1e2694adb9c7..02811cd31153 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -20,7 +20,6 @@ extern kmem_zone_t	*xfs_bmap_free_item_zone;
  */
 struct xfs_bmalloca {
 	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
-	struct xfs_defer_ops	*dfops;	/* bmap freelist */
 	struct xfs_trans	*tp;	/* transaction pointer */
 	struct xfs_inode	*ip;	/* incore inode pointer */
 	struct xfs_bmbt_irec	prev;	/* extent before the new one */
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 2d2c5ab9143c..56a3999cefae 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -19,6 +19,7 @@
 #include "xfs_filestream.h"
 #include "xfs_trace.h"
 #include "xfs_ag_resv.h"
+#include "xfs_trans.h"
 
 struct xfs_fstrm_item {
 	struct xfs_mru_cache_elem	mru;
@@ -377,7 +378,7 @@ xfs_filestream_new_ag(
 
 	if (xfs_alloc_is_userdata(ap->datatype))
 		flags |= XFS_PICK_USERDATA;
-	if (ap->dfops->dop_low)
+	if (ap->tp->t_dfops->dop_low)
 		flags |= XFS_PICK_LOWSPACE;
 
 	err = xfs_filestream_pick_ag(pip, startag, agp, flags, minlen);
-- 
2.17.1


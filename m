Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934258AbeGCRXV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:21 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 49B3244D0E
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34A081117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 16/25] xfs: remove bmap extent add helper firstblock params
Date: Tue,  3 Jul 2018 13:23:10 -0400
Message-Id: <20180703172319.24509-17-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The add extent helpers all receive firstblock via ->t_firstblock.
Drop the parameter and access it directly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bd1273546b54..adc45a0941ff 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2031,7 +2031,6 @@ xfs_bmap_add_extent_unwritten_real(
 	struct xfs_iext_cursor	*icur,
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	int			*logflagsp) /* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
@@ -2473,8 +2472,8 @@ xfs_bmap_add_extent_unwritten_real(
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, first, &cur, 0,
-				&tmp_logflags, whichfork);
+		error = xfs_bmap_extents_to_btree(tp, ip, &tp->t_firstblock,
+				&cur, 0, &tmp_logflags, whichfork);
 		*logflagsp |= tmp_logflags;
 		if (error)
 			goto done;
@@ -2645,7 +2644,6 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_iext_cursor	*icur,
 	struct xfs_btree_cur	**curp,
 	struct xfs_bmbt_irec	*new,
-	xfs_fsblock_t		*first,
 	int			*logflagsp,
 	int			flags)
 {
@@ -2837,8 +2835,8 @@ xfs_bmap_add_extent_hole_real(
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, first, curp, 0,
-				&tmp_logflags, whichfork);
+		error = xfs_bmap_extents_to_btree(tp, ip, &tp->t_firstblock,
+				curp, 0, &tmp_logflags, whichfork);
 		*logflagsp |= tmp_logflags;
 		cur = *curp;
 		if (error)
@@ -4108,8 +4106,7 @@ xfs_bmapi_allocate(
 	else
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
 				whichfork, &bma->icur, &bma->cur, &bma->got,
-				&bma->tp->t_firstblock, &bma->logflags,
-				bma->flags);
+				&bma->logflags, bma->flags);
 
 	bma->logflags |= tmp_logflags;
 	if (error)
@@ -4177,8 +4174,7 @@ xfs_bmapi_convert_unwritten(
 	}
 
 	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, whichfork,
-			&bma->icur, &bma->cur, mval, &bma->tp->t_firstblock,
-			&tmp_logflags);
+			&bma->icur, &bma->cur, mval, &tmp_logflags);
 	/*
 	 * Log the inode core unconditionally in the unwritten extent conversion
 	 * path because the conversion might not have done so (e.g., if the
@@ -4552,7 +4548,7 @@ xfs_bmapi_remap(
 		got.br_state = XFS_EXT_NORM;
 
 	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
-			&cur, &got, &tp->t_firstblock, &logflags, flags);
+			&cur, &got, &logflags, flags);
 	if (error)
 		goto error0;
 
@@ -5316,7 +5312,7 @@ __xfs_bunmapi(
 			del.br_state = XFS_EXT_UNWRITTEN;
 			error = xfs_bmap_add_extent_unwritten_real(tp, ip,
 					whichfork, &icur, &cur, &del,
-					&tp->t_firstblock, &logflags);
+					&logflags);
 			if (error)
 				goto error0;
 			goto nodelete;
@@ -5373,8 +5369,7 @@ __xfs_bunmapi(
 				prev.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
 						ip, whichfork, &icur, &cur,
-						&prev, &tp->t_firstblock,
-						&logflags);
+						&prev, &logflags);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5383,8 +5378,7 @@ __xfs_bunmapi(
 				del.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
 						ip, whichfork, &icur, &cur,
-						&del, &tp->t_firstblock,
-						&logflags);
+						&del, &logflags);
 				if (error)
 					goto error0;
 				goto nodelete;
-- 
2.17.1


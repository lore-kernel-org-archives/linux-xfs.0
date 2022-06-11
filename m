Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38042CCA47C
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343696AbiFKB1i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349011AbiFKB1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:21 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9ED983A4817
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3B3C310E7211
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005APz-8x
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELNm-7r
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 40/50] xfs: move xfs_bmap_btalloc_filestreams() to xfs_filestreams.c
Date:   Sat, 11 Jun 2022 11:26:49 +1000
Message-Id: <20220611012659.3418072-41-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=Eojz1_NsGFHgA-TchCsA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_bmap_btalloc_filestreams() calls two filestreams functions to
select the AG to allocate from. Both those functions end up in
the same selection function that iterates all AGs multiple times.
Worst case, xfs_bmap_btalloc_filestreams() can iterate all AGs 4
times just to select the initial AG to allocate in.

Move xfs_bmap_btalloc_filestreams() to fs/xfs/xfs_filestreams.c so
that the inefficient abstraction can be greatly simplified and
the implementation made more efficient.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 78 ++--------------------------------------
 fs/xfs/xfs_filestream.c  | 67 ++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_filestream.h  |  5 +--
 3 files changed, 71 insertions(+), 79 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 65f407ace78f..6a87897ac644 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3215,68 +3215,6 @@ xfs_bmap_select_minlen(
 	return args->maxlen;
 }
 
-STATIC int
-xfs_bmap_btalloc_filestreams(
-	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args,
-	xfs_extlen_t		*blen)
-{
-	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		start_agno;
-	int			error;
-
-	args->total = ap->total;
-
-	start_agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-	if (start_agno == NULLAGNUMBER)
-		start_agno = 0;
-
-	pag = xfs_perag_grab(mp, start_agno);
-	if (pag) {
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-		xfs_perag_rele(pag);
-		if (error) {
-			if (error != -EAGAIN)
-				return error;
-			*blen = 0;
-		}
-	}
-
-	if (*blen < args->maxlen) {
-		xfs_agnumber_t	agno = start_agno;
-
-		error = xfs_filestream_new_ag(ap, &agno);
-		if (error)
-			return error;
-		if (agno == NULLAGNUMBER)
-			goto out_select;
-
-		pag = xfs_perag_grab(mp, agno);
-		if (!pag)
-			goto out_select;
-
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-		xfs_perag_rele(pag);
-		if (error) {
-			if (error != -EAGAIN)
-				return error;
-			*blen = 0;
-		}
-		start_agno = agno;
-	}
-
-out_select:
-	args->minlen = xfs_bmap_select_minlen(ap, args, *blen);
-
-	/*
-	 * Set the failure fallback case to look in the selected AG as stream
-	 * may have moved.
-	 */
-	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, start_agno, 0);
-	return 0;
-}
-
 /* Update all inode and quota accounting for the allocation we just did. */
 static void
 xfs_bmap_btalloc_accounting(
@@ -3615,25 +3553,15 @@ xfs_btalloc_filestreams(
 	struct xfs_alloc_arg	*args,
 	int			stripe_align)
 {
-	xfs_agnumber_t		agno = xfs_filestream_lookup_ag(ap->ip);
 	xfs_extlen_t		blen = 0;
 	int			error;
 
-	/* Determine the initial block number we will target for allocation. */
-	if (agno == NULLAGNUMBER)
-		agno = 0;
-	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
-	xfs_bmap_adjacent(ap);
-
-	/*
-	 * Search for an allocation group with a single extent large enough for
-	 * the request.  If one isn't found, then adjust the minimum allocation
-	 * size to the largest space found.
-	 */
-	error = xfs_bmap_btalloc_filestreams(ap, args, &blen);
+	error = xfs_filestream_select_ag(ap, args, &blen);
 	if (error)
 		return error;
 
+	args->minlen = xfs_bmap_select_minlen(ap, args, blen);
+
 	if (ap->aeof) {
 		error = xfs_btalloc_at_eof(ap, args, blen, stripe_align, true);
 		if (error || args->fsbno != NULLFSBLOCK)
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 2eb702034d05..458df92fd9a6 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -12,6 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_alloc.h"
 #include "xfs_mru_cache.h"
 #include "xfs_trace.h"
@@ -263,7 +264,7 @@ xfs_filestream_get_parent(
  *
  * Returns NULLAGNUMBER in case of an error.
  */
-xfs_agnumber_t
+static xfs_agnumber_t
 xfs_filestream_lookup_ag(
 	struct xfs_inode	*ip)
 {
@@ -312,7 +313,7 @@ xfs_filestream_lookup_ag(
  * This is called when the allocator can't find a suitable extent in the
  * current AG, and we have to move the stream into a new AG with more space.
  */
-int
+static int
 xfs_filestream_new_ag(
 	struct xfs_bmalloca	*ap,
 	xfs_agnumber_t		*agp)
@@ -358,6 +359,68 @@ xfs_filestream_new_ag(
 	return err;
 }
 
+/*
+ * Search for an allocation group with a single extent large enough for
+ * the request.  If one isn't found, then adjust the minimum allocation
+ * size to the largest space found.
+ */
+int
+xfs_filestream_select_ag(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		*blen)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		start_agno = xfs_filestream_lookup_ag(ap->ip);
+	int			error;
+
+	/* Determine the initial block number we will target for allocation. */
+	if (start_agno == NULLAGNUMBER)
+		start_agno = 0;
+	ap->blkno = XFS_AGB_TO_FSB(args->mp, start_agno, 0);
+	xfs_bmap_adjacent(ap);
+	args->total = ap->total;
+
+	pag = xfs_perag_grab(mp, start_agno);
+	if (pag) {
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+		xfs_perag_rele(pag);
+		if (error) {
+			if (error != -EAGAIN)
+				return error;
+			*blen = 0;
+		}
+	}
+
+	if (*blen < args->maxlen) {
+		xfs_agnumber_t	agno = start_agno;
+
+		error = xfs_filestream_new_ag(ap, &agno);
+		if (error)
+			return error;
+		if (agno == NULLAGNUMBER)
+			goto out_select;
+
+		pag = xfs_perag_grab(mp, agno);
+		if (!pag)
+			goto out_select;
+
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+		xfs_perag_rele(pag);
+		if (error) {
+			if (error != -EAGAIN)
+				return error;
+			*blen = 0;
+		}
+		start_agno = agno;
+	}
+
+out_select:
+	ap->blkno = XFS_AGB_TO_FSB(mp, start_agno, 0);
+	return 0;
+}
+
 void
 xfs_filestream_deassociate(
 	struct xfs_inode	*ip)
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 403226ebb80b..df9f7553e106 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -9,13 +9,14 @@
 struct xfs_mount;
 struct xfs_inode;
 struct xfs_bmalloca;
+struct xfs_alloc_arg;
 
 int xfs_filestream_mount(struct xfs_mount *mp);
 void xfs_filestream_unmount(struct xfs_mount *mp);
 void xfs_filestream_deassociate(struct xfs_inode *ip);
-xfs_agnumber_t xfs_filestream_lookup_ag(struct xfs_inode *ip);
-int xfs_filestream_new_ag(struct xfs_bmalloca *ap, xfs_agnumber_t *agp);
 int xfs_filestream_peek_ag(struct xfs_mount *mp, xfs_agnumber_t agno);
+int xfs_filestream_select_ag(struct xfs_bmalloca *ap,
+		struct xfs_alloc_arg *args, xfs_extlen_t *blen);
 
 static inline int
 xfs_inode_is_filestream(
-- 
2.35.1


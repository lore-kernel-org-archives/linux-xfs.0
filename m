Return-Path: <SRS0=2CQE=7X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C41C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 03:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C5392076A
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 03:59:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z8WwzTWw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgFJD7b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 23:59:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40629 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725927AbgFJD7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 23:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591761568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=M0t9Fwj3Gla8Q66HipRgfZnG6sLR4txLg7UuLyUmKVY=;
        b=Z8WwzTWwTBw/HErMDJwVE2ELu21WbXProvZmLWuQ0PBs0Gmez8WayI0vGLfMziTpeQfclG
        IBFJMpf8Tp2lrfyFL6rMrhaSEMik3jroUVpT8CTOpjV2UV8kSPRBi/e1F/cRwagwTO25Hr
        M45f8+XfsjHcaSYRTa3TFXtt0q8xNpE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434--I2P-UytOsqu_tQ5PbqKbw-1; Tue, 09 Jun 2020 23:59:26 -0400
X-MC-Unique: -I2P-UytOsqu_tQ5PbqKbw-1
Received: by mail-pl1-f197.google.com with SMTP id w8so594728plq.10
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2020 20:59:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=M0t9Fwj3Gla8Q66HipRgfZnG6sLR4txLg7UuLyUmKVY=;
        b=IHau/+vXbnp0bQSNyuZhhcUhFyETads6l05zA+Q1dO/X+3dYzfKTp4uUK+F8bTc0kt
         qJPCnt2XM5XRLCq8PMWxydiyiSQ7MQtJCUbHrWrTFY31i5gWL2BwTMTsNHiIfGEisPMk
         8oFe2AT7Saj1L+Vj1JD3xWb4M4LKNThsVtoHARUQWgEeTmgtGiWckbRCfKMxBobIFRs7
         1su8NLL78b4oKn1PqmbMG1PcjRrokfNAI92HFdqTYlWx2hWOi9ReHQC5ODB+6jOR4kK7
         mkA88UNAo3h3fudlL9SNrW3t9sCgTl4i/h4WZjXSHefTHWvpyRXq4oGaGVJy5wVZZuy5
         6L0g==
X-Gm-Message-State: AOAM530vAmG5/tk6bfsCVfll2zlMw5Yu7luQW6gLL0wqL1nV0wFsFClw
        FOOAUaMXWe5fGxM2vtxCBghG+nXB7N8mLDHPuCdMVz34O2Zs5N4kNCxvoPEiASvJY8JyOrjQJCr
        GPTDSQgkx21V29n+Dj1rm
X-Received: by 2002:a62:2545:: with SMTP id l66mr949094pfl.12.1591761565423;
        Tue, 09 Jun 2020 20:59:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4hbTB/RgQZzILS0wU2uvCbaDxY8r45Upg+yuBop0tD4M30f0PszGSqd+fj5oMMx9qk1Asaw==
X-Received: by 2002:a62:2545:: with SMTP id l66mr949075pfl.12.1591761564997;
        Tue, 09 Jun 2020 20:59:24 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f29sm9838994pgf.63.2020.06.09.20.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 20:59:24 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: [RFC PATCH v2] xfs_repair: fix rebuilding btree block less than minrecs
Date:   Wed, 10 Jun 2020 11:58:42 +0800
Message-Id: <20200610035842.22785-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200609114053.31924-1-hsiangkao@redhat.com>
References: <20200609114053.31924-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In production, we found that sometimes xfs_repair phase 5
rebuilds freespace node block with pointers less than minrecs
and if we trigger xfs_repair again it would report such
the following message:

bad btree nrecs (39, min=40, max=80) in btbno block 0/7882

The background is that xfs_repair starts to rebuild AGFL
after the freespace btree is settled in phase 5 so we may
need to leave necessary room in advance for each btree
leaves in order to avoid freespace btree split and then
result in AGFL rebuild fails. The old mathematics uses
ceil(num_extents / maxrecs) to decide the number of node
blocks. That would be fine without leaving extra space
since minrecs = maxrecs / 2 but if some slack was decreased
from maxrecs, the result would be larger than what is
expected and cause num_recs_pb less than minrecs, i.e:

num_extents = 79, adj_maxrecs = 80 - 2 (slack) = 78

so we'd get

num_blocks = ceil(79 / 78) = 2,
num_recs_pb = 79 / 2 = 39, which is less than
minrecs = 80 / 2 = 40

OTOH, btree bulk loading code behaves in a different way.
As in xfs_btree_bload_level_geometry it wrote

num_blocks = floor(num_extents / maxrecs)

which will never go below minrecs. And when it goes above
maxrecs, just increment num_blocks and recalculate so we
can get the reasonable results.

Later, btree bulk loader will replace the current repair
code. But we may still want to look for a backportable
solution for stable versions. Hense, keep the same logic
to avoid the freespace as well as rmap btree minrecs
underflow for now.

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>
Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
changes since v1:
 - fix indentation, typedefs, etc code styling problem
   pointed out by Darrick;

 - adapt init_rmapbt_cursor to the new algorithm since
   it's similar pointed out by Darrick; thus the function
   name remains the origin compute_level_geometry...
   and hence, adjust the subject a bit as well.

 repair/phase5.c | 151 ++++++++++++++++++++----------------------------
 1 file changed, 63 insertions(+), 88 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index abae8a08..278de7a4 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -348,11 +348,32 @@ finish_cursor(bt_status_t *curs)
  * failure at runtime. Hence leave a couple of records slack space in
  * each block to allow immediate modification of the tree without
  * requiring splits to be done.
- *
- * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
  */
-#define XR_ALLOC_BLOCK_MAXRECS(mp, level) \
-	(libxfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
+static void
+compute_level_geometry(
+	struct xfs_mount *	mp,
+	struct bt_stat_level *	lptr,
+	uint64_t		nr_this_level,
+	int			slack,
+	bool			leaf)
+{
+	unsigned int		maxrecs = mp->m_alloc_mxr[!leaf];
+	unsigned int		desired_npb;
+
+	desired_npb = max(mp->m_alloc_mnr[!leaf], maxrecs - slack);
+	lptr->num_recs_tot = nr_this_level;
+	lptr->num_blocks = max(1ULL, nr_this_level / desired_npb);
+
+	lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
+	lptr->modulo = nr_this_level % lptr->num_blocks;
+	if (lptr->num_recs_pb > maxrecs ||
+	    (lptr->num_recs_pb == maxrecs && lptr->modulo)) {
+		lptr->num_blocks++;
+
+		lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
+		lptr->modulo = nr_this_level % lptr->num_blocks;
+	}
+}
 
 /*
  * this calculates a freespace cursor for an ag.
@@ -370,6 +391,7 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	int			i;
 	int			extents_used;
 	int			extra_blocks;
+	uint64_t		old_blocks;
 	bt_stat_level_t		*lptr;
 	bt_stat_level_t		*p_lptr;
 	extent_tree_node_t	*ext_ptr;
@@ -388,10 +410,7 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	 * of the tree and set up the cursor for the leaf level
 	 * (note that the same code is duplicated further down)
 	 */
-	lptr->num_blocks = howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0));
-	lptr->num_recs_pb = num_extents / lptr->num_blocks;
-	lptr->modulo = num_extents % lptr->num_blocks;
-	lptr->num_recs_tot = num_extents;
+	compute_level_geometry(mp, lptr, num_extents, 2, true);
 	level = 1;
 
 #ifdef XR_BLD_FREE_TRACE
@@ -405,29 +424,23 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	 * if we need more levels, set them up.  # of records
 	 * per level is the # of blocks in the level below it
 	 */
-	if (lptr->num_blocks > 1)  {
-		for (; btree_curs->level[level - 1].num_blocks > 1
-				&& level < XFS_BTREE_MAXLEVELS;
-				level++)  {
-			lptr = &btree_curs->level[level];
-			p_lptr = &btree_curs->level[level - 1];
-			lptr->num_blocks = howmany(p_lptr->num_blocks,
-					XR_ALLOC_BLOCK_MAXRECS(mp, level));
-			lptr->modulo = p_lptr->num_blocks
-					% lptr->num_blocks;
-			lptr->num_recs_pb = p_lptr->num_blocks
-					/ lptr->num_blocks;
-			lptr->num_recs_tot = p_lptr->num_blocks;
+	while (lptr->num_blocks > 1) {
+		p_lptr = lptr;
+		lptr = &btree_curs->level[level];
+
+		compute_level_geometry(mp, lptr,
+				p_lptr->num_blocks, 0, false);
 #ifdef XR_BLD_FREE_TRACE
-			fprintf(stderr, "%s %d %d %d %d %d\n", __func__,
-					level,
-					lptr->num_blocks,
-					lptr->num_recs_pb,
-					lptr->modulo,
-					lptr->num_recs_tot);
+		fprintf(stderr, "%s %d %d %d %d %d\n", __func__,
+				level,
+				lptr->num_blocks,
+				lptr->num_recs_pb,
+				lptr->modulo,
+				lptr->num_recs_tot);
 #endif
-		}
+		level++;
 	}
+	ASSERT (level < XFS_BTREE_MAXLEVELS);
 
 	ASSERT(lptr->num_blocks == 1);
 	btree_curs->num_levels = level;
@@ -496,8 +509,11 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	 * see if the number of leaf blocks will change as a result
 	 * of the number of extents changing
 	 */
-	if (howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0))
-			!= btree_curs->level[0].num_blocks)  {
+	old_blocks = btree_curs->level[0].num_blocks;
+	compute_level_geometry(mp, &btree_curs->level[0], num_extents, 2, true);
+	extra_blocks = 0;
+
+	if (old_blocks != btree_curs->level[0].num_blocks)  {
 		/*
 		 * yes -- recalculate the cursor.  If the number of
 		 * excess (overallocated) blocks is < xfs_agfl_size/2, we're ok.
@@ -553,31 +569,19 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		}
 
 		lptr = &btree_curs->level[0];
-		lptr->num_blocks = howmany(num_extents,
-					XR_ALLOC_BLOCK_MAXRECS(mp, 0));
-		lptr->num_recs_pb = num_extents / lptr->num_blocks;
-		lptr->modulo = num_extents % lptr->num_blocks;
-		lptr->num_recs_tot = num_extents;
 		level = 1;
 
 		/*
 		 * if we need more levels, set them up
 		 */
-		if (lptr->num_blocks > 1)  {
-			for (level = 1; btree_curs->level[level-1].num_blocks
-					> 1 && level < XFS_BTREE_MAXLEVELS;
-					level++)  {
-				lptr = &btree_curs->level[level];
-				p_lptr = &btree_curs->level[level-1];
-				lptr->num_blocks = howmany(p_lptr->num_blocks,
-					XR_ALLOC_BLOCK_MAXRECS(mp, level));
-				lptr->modulo = p_lptr->num_blocks
-						% lptr->num_blocks;
-				lptr->num_recs_pb = p_lptr->num_blocks
-						/ lptr->num_blocks;
-				lptr->num_recs_tot = p_lptr->num_blocks;
-			}
+		while (lptr->num_blocks > 1) {
+			p_lptr = lptr;
+			lptr = &btree_curs->level[level++];
+
+			compute_level_geometry(mp, lptr,
+					p_lptr->num_blocks, 0, false);
 		}
+		ASSERT (level < XFS_BTREE_MAXLEVELS);
 		ASSERT(lptr->num_blocks == 1);
 		btree_curs->num_levels = level;
 
@@ -591,22 +595,6 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 
 		ASSERT(blocks_allocated_total >= blocks_needed);
 		extra_blocks = blocks_allocated_total - blocks_needed;
-	} else  {
-		if (extents_used > 0) {
-			/*
-			 * reset the leaf level geometry to account
-			 * for consumed extents.  we can leave the
-			 * rest of the cursor alone since the number
-			 * of leaf blocks hasn't changed.
-			 */
-			lptr = &btree_curs->level[0];
-
-			lptr->num_recs_pb = num_extents / lptr->num_blocks;
-			lptr->modulo = num_extents % lptr->num_blocks;
-			lptr->num_recs_tot = num_extents;
-		}
-
-		extra_blocks = 0;
 	}
 
 	btree_curs->num_tot_blocks = blocks_allocated_pt;
@@ -1376,7 +1364,6 @@ init_rmapbt_cursor(
 	struct bt_stat_level	*lptr;
 	struct bt_stat_level	*p_lptr;
 	xfs_extlen_t		blocks_allocated;
-	int			maxrecs;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
 		memset(btree_curs, 0, sizeof(struct bt_status));
@@ -1412,32 +1399,20 @@ init_rmapbt_cursor(
 	 * Leave enough slack in the rmapbt that we can insert the
 	 * metadata AG entries without too many splits.
 	 */
-	maxrecs = mp->m_rmap_mxr[0];
-	if (num_recs > maxrecs)
-		maxrecs -= 10;
-	blocks_allocated = lptr->num_blocks = howmany(num_recs, maxrecs);
-
-	lptr->modulo = num_recs % lptr->num_blocks;
-	lptr->num_recs_pb = num_recs / lptr->num_blocks;
-	lptr->num_recs_tot = num_recs;
+	compute_level_geometry(mp, lptr, num_recs,
+			num_recs > mp->m_rmap_mxr[0] ? 10 : 0, true);
+	blocks_allocated = lptr->num_blocks;
 	level = 1;
 
-	if (lptr->num_blocks > 1)  {
-		for (; btree_curs->level[level-1].num_blocks > 1
-				&& level < XFS_BTREE_MAXLEVELS;
-				level++)  {
-			lptr = &btree_curs->level[level];
-			p_lptr = &btree_curs->level[level - 1];
-			lptr->num_blocks = howmany(p_lptr->num_blocks,
-				mp->m_rmap_mxr[1]);
-			lptr->modulo = p_lptr->num_blocks % lptr->num_blocks;
-			lptr->num_recs_pb = p_lptr->num_blocks
-					/ lptr->num_blocks;
-			lptr->num_recs_tot = p_lptr->num_blocks;
+	while (lptr->num_blocks > 1) {
+		p_lptr = lptr;
+		lptr = &btree_curs->level[level++];
 
-			blocks_allocated += lptr->num_blocks;
-		}
+		compute_level_geometry(mp, lptr,
+				p_lptr->num_blocks, 0, false);
+		blocks_allocated += lptr->num_blocks;
 	}
+	ASSERT(level < XFS_BTREE_MAXLEVELS);
 	ASSERT(lptr->num_blocks == 1);
 	btree_curs->num_levels = level;
 
-- 
2.18.1


Return-Path: <SRS0=2CQE=7X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0C2C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 05:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8091B20734
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Jun 2020 05:27:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XrDJOwdZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgFJF1O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 01:27:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26187 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725270AbgFJF1N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jun 2020 01:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591766830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=aQroRHMO5GdqwQY2hY0uf2gqUNgsoYQ6M0foeHO+HfQ=;
        b=XrDJOwdZjKHTfMv2XugbLocgU5V0s/erwiwL+oOiyGt6p06pzT7C0/jsI4QdR8FOuy//Ho
        qD8JmPIe7Pb/o0fHJ/Q4qd0J9zDA2Px6bcO+58essyJdtPecXiHt+nX9kH6qjfhph9E2l1
        YolPoayD8g6Jid3TGsY4neGzsjxSg1I=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-sA2Pa15jM1WdKmkziuZebA-1; Wed, 10 Jun 2020 01:27:09 -0400
X-MC-Unique: sA2Pa15jM1WdKmkziuZebA-1
Received: by mail-pf1-f200.google.com with SMTP id c9so956193pfn.23
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2020 22:27:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aQroRHMO5GdqwQY2hY0uf2gqUNgsoYQ6M0foeHO+HfQ=;
        b=RKFCjLpWHiTe/6bDMFS8x9jOpayF6iuCEue8EV2JTIQWeUqyUh24/mVQpJwhO4BZyk
         aGidc4T1/Qiq3a+snjr+t1GZwebArHtLq7e/eslgaveE/1H0YyZMuDhuP5o6C5DsOyuX
         5bC/eJq3ZAx9gRQFSC1/u47yhYzCqBuYS3FjBD17G1V51lr81Z/8FOQX8WjPK1ODx0Ig
         2TNm/M7uJ14e2EeDO7PJSaVnmuR/rV+JZZWW1lmopnoCkKy+vifJ1l6NQsd0cZ4L8OuX
         5ndyj7mqDW2DXl3+Bb4O7al7Cqn++cH2x9IPBzdwAWLNPvAxgflbHD1m7tK0pyhA8ZJi
         jblg==
X-Gm-Message-State: AOAM5309f0X5nDD6rHN7Oz+pfGrc5S3B+vHAyX/oOhP/R5LLS5b/nh+b
        QI2yJlHxHY3Qi5HzvUgTlo5QEsEG8U4l1z7QoT0QsiHB57pyFq2idGEnzafkGVjm2413GHkbxBh
        ierk8ejNkSfe7iI7pHFLT
X-Received: by 2002:a65:6550:: with SMTP id a16mr1237400pgw.183.1591766827480;
        Tue, 09 Jun 2020 22:27:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKd+AFtqzBxyEEUb1x3QUOgXGCGI2U2ZS2gw6gUlZ1qhIO/oU4bn5tGmPXVn8Ayr4c+Vf8OQ==
X-Received: by 2002:a65:6550:: with SMTP id a16mr1237380pgw.183.1591766827081;
        Tue, 09 Jun 2020 22:27:07 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 63sm11455156pfd.65.2020.06.09.22.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 22:27:06 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: [RFC PATCH v3] xfs_repair: fix rebuilding btree block less than minrecs
Date:   Wed, 10 Jun 2020 13:26:24 +0800
Message-Id: <20200610052624.7425-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200610035842.22785-1-hsiangkao@redhat.com>
References: <20200610035842.22785-1-hsiangkao@redhat.com>
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

Later, btree bulk loader will replace the current repair code.
But we may still want to look for a backportable solution
for stable versions. Hence, keep the same logic to avoid
the freespace as well as rmap btree minrecs underflow for now.

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>
Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
changes since v2:
 still some minor styling fix (ASSERT, args)..

changes since v1:
 - fix indentation, typedefs, etc code styling problem
   pointed out by Darrick;

 - adapt init_rmapbt_cursor to the new algorithm since
   it's similar pointed out by Darrick; thus the function
   name remains the origin compute_level_geometry...
   and hence, adjust the subject a bit as well.

 repair/phase5.c | 152 ++++++++++++++++++++----------------------------
 1 file changed, 63 insertions(+), 89 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index abae8a08..d30d32b2 100644
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
+	struct xfs_mount	*mp,
+	struct bt_stat_level	*lptr,
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
@@ -405,30 +424,23 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
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
-
+	ASSERT(level < XFS_BTREE_MAXLEVELS);
 	ASSERT(lptr->num_blocks == 1);
 	btree_curs->num_levels = level;
 
@@ -496,8 +508,11 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
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
@@ -553,31 +568,19 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
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
+		ASSERT(level < XFS_BTREE_MAXLEVELS);
 		ASSERT(lptr->num_blocks == 1);
 		btree_curs->num_levels = level;
 
@@ -591,22 +594,6 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 
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
@@ -1376,7 +1363,6 @@ init_rmapbt_cursor(
 	struct bt_stat_level	*lptr;
 	struct bt_stat_level	*p_lptr;
 	xfs_extlen_t		blocks_allocated;
-	int			maxrecs;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
 		memset(btree_curs, 0, sizeof(struct bt_status));
@@ -1412,32 +1398,20 @@ init_rmapbt_cursor(
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


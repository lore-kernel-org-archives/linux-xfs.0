Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DF8C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 11:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C13CA2068D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 11:41:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g1gGVh4W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgFILlv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 07:41:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41291 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726116AbgFILlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 07:41:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591702907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=PyJWsFpyd87Rk3FvIQm1A9u1OwV7g4iVUg3Hzfm1A6c=;
        b=g1gGVh4WiiigBLG4lsOvI5YUwadmN4tNAsPlBmhfBYRMZzPtxjFzCE1KaVjS3dX5VpMxv8
        JRV+CQMqa2qRx7DU49tRMgtWG01ja2axB6bW17tTpfTEK0IYXE0pgyGOKNitZwwqOyNruO
        ac7PT85gt0B0QQxZx/OnLvDERr6YSlw=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-h2miEwEWMc6_hsX13cfdUA-1; Tue, 09 Jun 2020 07:41:40 -0400
X-MC-Unique: h2miEwEWMc6_hsX13cfdUA-1
Received: by mail-pf1-f198.google.com with SMTP id f14so5111797pfd.2
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2020 04:41:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PyJWsFpyd87Rk3FvIQm1A9u1OwV7g4iVUg3Hzfm1A6c=;
        b=RBJYECYMsU6dNO5sydc1T4QeckIr/kv7dwzla73navGFSoSOBjkVay8vBq9SaVFq9e
         p2oR8y2Enpxc2lqMWH8QbO8fytR/P+pZK8TWhPLEwI05pmIUm610NMmEDy519+Wr5w3O
         9+Q7gvI4OBvYtrl8uSmeYaXOTObBedeuW5StfbcTmdn9BsOQ9RU69fhxekyQ00D/uTUV
         2Xe7izTzMtdfxGfUTLeB/dUqvZDYpcj2rKzDVvAi/JD4JYnvl2+XUG/zBbNh+UqR8Dkk
         Qr9g7GwhBru0Z55OCUmiVdSnOtIvliZXvfAKzNNj4i/LZ48vnxVFCQ+uV1OK/dyuix2s
         SGyQ==
X-Gm-Message-State: AOAM531u/Hv0VTU3+vtxZRoJwqw+ZFAn0zs4dHLG7jpmeJOjvS1UFwye
        XHiKH1QxHNwwH6Y4mYLnoxLfo3NI292Q5tBt9uHjBEKNfJmPOwt35nAo0zMCmcGGVg70scBc0j0
        Y1BAyRlzzCedBap0/ulln
X-Received: by 2002:a63:1114:: with SMTP id g20mr23952212pgl.3.1591702898426;
        Tue, 09 Jun 2020 04:41:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJeMz5E6aglG9dWKEsWNzCSg3DNg8jwYih1mgEOzi3yK/4oyDDJNMGLB0wLJesTUaELbz8xQ==
X-Received: by 2002:a63:1114:: with SMTP id g20mr23952198pgl.3.1591702898056;
        Tue, 09 Jun 2020 04:41:38 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x25sm8346666pge.23.2020.06.09.04.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 04:41:36 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: [RFC PATCH] xfs_repair: fix rebuilding btree node block less than minrecs
Date:   Tue,  9 Jun 2020 19:40:53 +0800
Message-Id: <20200609114053.31924-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
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

which will never go below minrecs. And when it goes
above maxrecs, just increment num_blocks and recalculate
so we can get the reasonable results.

In the long term, btree bulk loader will replace the current
repair code as well as to resolve AGFL dependency issue.
But we may still want to look for a backportable solution
for stable versions. Hence, use the same logic to avoid the
freespace btree minrecs underflow for now.

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>
Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
not heavy tested yet..

 repair/phase5.c | 101 +++++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 56 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index abae8a08..997804a5 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -348,11 +348,29 @@ finish_cursor(bt_status_t *curs)
  * failure at runtime. Hence leave a couple of records slack space in
  * each block to allow immediate modification of the tree without
  * requiring splits to be done.
- *
- * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
  */
-#define XR_ALLOC_BLOCK_MAXRECS(mp, level) \
-	(libxfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
+static void
+compute_level_geometry(xfs_mount_t *mp, bt_stat_level_t *lptr,
+		       uint64_t nr_this_level, bool leaf)
+{
+	unsigned int		maxrecs = mp->m_alloc_mxr[!leaf];
+	int			slack = leaf ? 2 : 0;
+	unsigned int		desired_npb;
+
+	desired_npb = max(mp->m_alloc_mnr[!leaf], maxrecs - slack);
+	lptr->num_recs_tot = nr_this_level;
+	lptr->num_blocks = max(1ULL, nr_this_level / desired_npb);
+
+	lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
+	lptr->modulo = nr_this_level % lptr->num_blocks;
+	if (lptr->num_recs_pb > maxrecs || (lptr->num_recs_pb == maxrecs &&
+			lptr->modulo)) {
+		lptr->num_blocks++;
+
+		lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
+		lptr->modulo = nr_this_level % lptr->num_blocks;
+	}
+}
 
 /*
  * this calculates a freespace cursor for an ag.
@@ -370,6 +388,7 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	int			i;
 	int			extents_used;
 	int			extra_blocks;
+	uint64_t		old_blocks;
 	bt_stat_level_t		*lptr;
 	bt_stat_level_t		*p_lptr;
 	extent_tree_node_t	*ext_ptr;
@@ -388,10 +407,7 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	 * of the tree and set up the cursor for the leaf level
 	 * (note that the same code is duplicated further down)
 	 */
-	lptr->num_blocks = howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0));
-	lptr->num_recs_pb = num_extents / lptr->num_blocks;
-	lptr->modulo = num_extents % lptr->num_blocks;
-	lptr->num_recs_tot = num_extents;
+	compute_level_geometry(mp, lptr, num_extents, true);
 	level = 1;
 
 #ifdef XR_BLD_FREE_TRACE
@@ -406,18 +422,12 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	 * per level is the # of blocks in the level below it
 	 */
 	if (lptr->num_blocks > 1)  {
-		for (; btree_curs->level[level - 1].num_blocks > 1
-				&& level < XFS_BTREE_MAXLEVELS;
-				level++)  {
+		do {
+			p_lptr = lptr;
 			lptr = &btree_curs->level[level];
-			p_lptr = &btree_curs->level[level - 1];
-			lptr->num_blocks = howmany(p_lptr->num_blocks,
-					XR_ALLOC_BLOCK_MAXRECS(mp, level));
-			lptr->modulo = p_lptr->num_blocks
-					% lptr->num_blocks;
-			lptr->num_recs_pb = p_lptr->num_blocks
-					/ lptr->num_blocks;
-			lptr->num_recs_tot = p_lptr->num_blocks;
+
+			compute_level_geometry(mp, lptr,
+					p_lptr->num_blocks, false);
 #ifdef XR_BLD_FREE_TRACE
 			fprintf(stderr, "%s %d %d %d %d %d\n", __func__,
 					level,
@@ -426,7 +436,9 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 					lptr->modulo,
 					lptr->num_recs_tot);
 #endif
-		}
+			level++;
+		} while (lptr->num_blocks > 1);
+		ASSERT (level < XFS_BTREE_MAXLEVELS);
 	}
 
 	ASSERT(lptr->num_blocks == 1);
@@ -496,8 +508,11 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 	 * see if the number of leaf blocks will change as a result
 	 * of the number of extents changing
 	 */
-	if (howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0))
-			!= btree_curs->level[0].num_blocks)  {
+	old_blocks = btree_curs->level[0].num_blocks;
+	compute_level_geometry(mp, &btree_curs->level[0], num_extents, true);
+	extra_blocks = 0;
+
+	if (old_blocks != btree_curs->level[0].num_blocks)  {
 		/*
 		 * yes -- recalculate the cursor.  If the number of
 		 * excess (overallocated) blocks is < xfs_agfl_size/2, we're ok.
@@ -553,30 +568,20 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
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
 		if (lptr->num_blocks > 1)  {
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
+			do {
+				p_lptr = lptr;
+				lptr = &btree_curs->level[level++];
+
+				compute_level_geometry(mp, lptr,
+						p_lptr->num_blocks, false);
+			} while (lptr->num_blocks > 1);
+			ASSERT (level < XFS_BTREE_MAXLEVELS);
 		}
 		ASSERT(lptr->num_blocks == 1);
 		btree_curs->num_levels = level;
@@ -591,22 +596,6 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 
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
-- 
2.18.1


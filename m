Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977CAC3F2D8
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 710F720848
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgCEBpm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 20:45:42 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48467 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbgCEBpl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 20:45:41 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5DF1D7E9F5C
        for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2020 12:45:38 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9fZx-0005xU-L2
        for linux-xfs@vger.kernel.org; Thu, 05 Mar 2020 12:45:37 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9fZx-0002wH-JB
        for linux-xfs@vger.kernel.org; Thu, 05 Mar 2020 12:45:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: make the btree ag cursor private union anonymous
Date:   Thu,  5 Mar 2020 12:45:37 +1100
Message-Id: <20200305014537.11236-8-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200305014537.11236-1-david@fromorbit.com>
References: <20200305014537.11236-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=W38UdHNrk_fkfbhuzRoA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is much less widely used than the bc_private union was, so this
is done as a single patch. The named union xfs_btree_cur_private
goes away and is embedded into the struct xfs_btree_cur_ag as an
anonymous union, and the code is modified via this script:

$ sed -i 's/priv\.\([abt|refc]\)/\1/g' fs/xfs/*[ch] fs/xfs/*/*[ch]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          | 14 +++++++-------
 fs/xfs/libxfs/xfs_alloc_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_btree.h          | 25 +++++++++++--------------
 fs/xfs/libxfs/xfs_refcount.c       | 24 ++++++++++++------------
 fs/xfs/libxfs/xfs_refcount_btree.c |  4 ++--
 5 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0e9dea73980a..037b033d3e9d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -151,7 +151,7 @@ xfs_alloc_lookup_eq(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
-	cur->bc_ag.priv.abt.active = (*stat == 1);
+	cur->bc_ag.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -171,7 +171,7 @@ xfs_alloc_lookup_ge(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
-	cur->bc_ag.priv.abt.active = (*stat == 1);
+	cur->bc_ag.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -190,7 +190,7 @@ xfs_alloc_lookup_le(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
-	cur->bc_ag.priv.abt.active = (*stat == 1);
+	cur->bc_ag.abt.active = (*stat == 1);
 	return error;
 }
 
@@ -198,7 +198,7 @@ static inline bool
 xfs_alloc_cur_active(
 	struct xfs_btree_cur	*cur)
 {
-	return cur && cur->bc_ag.priv.abt.active;
+	return cur && cur->bc_ag.abt.active;
 }
 
 /*
@@ -907,7 +907,7 @@ xfs_alloc_cur_check(
 		deactivate = true;
 out:
 	if (deactivate)
-		cur->bc_ag.priv.abt.active = false;
+		cur->bc_ag.abt.active = false;
 	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
 				  *new);
 	return 0;
@@ -1353,7 +1353,7 @@ xfs_alloc_walk_iter(
 		if (error)
 			return error;
 		if (i == 0)
-			cur->bc_ag.priv.abt.active = false;
+			cur->bc_ag.abt.active = false;
 
 		if (count > 0)
 			count--;
@@ -1468,7 +1468,7 @@ xfs_alloc_ag_vextent_locality(
 		if (error)
 			return error;
 		if (i) {
-			acur->cnt->bc_ag.priv.abt.active = true;
+			acur->cnt->bc_ag.abt.active = true;
 			fbcur = acur->cnt;
 			fbinc = false;
 		}
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 3bcfda4ca8e2..a88dee44baf6 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -507,7 +507,7 @@ xfs_allocbt_init_cursor(
 
 	cur->bc_ag.agbp = agbp;
 	cur->bc_ag.agno = agno;
-	cur->bc_ag.priv.abt.active = false;
+	cur->bc_ag.abt.active = false;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 22aa26463ac3..d2a2c76cb87c 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -177,22 +177,19 @@ union xfs_btree_irec {
 	struct xfs_refcount_irec	rc;
 };
 
-/* Per-AG btree private information. */
-union xfs_btree_cur_private {
-	struct {
-		unsigned long	nr_ops;		/* # record updates */
-		int		shape_changes;	/* # of extent splits */
-	} refc;
-	struct {
-		bool		active;		/* allocation cursor state */
-	} abt;
-};
-
 /* Per-AG btree information. */
 struct xfs_btree_cur_ag {
-	struct xfs_buf			*agbp;
-	xfs_agnumber_t			agno;
-	union xfs_btree_cur_private	priv;
+	struct xfs_buf		*agbp;
+	xfs_agnumber_t		agno;
+	union {
+		struct {
+			unsigned long nr_ops;	/* # record updates */
+			int	shape_changes;	/* # of extent splits */
+		} refc;
+		struct {
+			bool	active;		/* allocation cursor state */
+		} abt;
+	};
 };
 
 /* Btree-in-inode cursor information */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index ef3e706f1d94..2076627243b0 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -883,7 +883,7 @@ xfs_refcount_still_have_space(
 {
 	unsigned long			overhead;
 
-	overhead = cur->bc_ag.priv.refc.shape_changes *
+	overhead = cur->bc_ag.refc.shape_changes *
 			xfs_allocfree_log_count(cur->bc_mp, 1);
 	overhead *= cur->bc_mp->m_sb.sb_blocksize;
 
@@ -891,17 +891,17 @@ xfs_refcount_still_have_space(
 	 * Only allow 2 refcount extent updates per transaction if the
 	 * refcount continue update "error" has been injected.
 	 */
-	if (cur->bc_ag.priv.refc.nr_ops > 2 &&
+	if (cur->bc_ag.refc.nr_ops > 2 &&
 	    XFS_TEST_ERROR(false, cur->bc_mp,
 			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
 		return false;
 
-	if (cur->bc_ag.priv.refc.nr_ops == 0)
+	if (cur->bc_ag.refc.nr_ops == 0)
 		return true;
 	else if (overhead > cur->bc_tp->t_log_res)
 		return false;
 	return  cur->bc_tp->t_log_res - overhead >
-		cur->bc_ag.priv.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
+		cur->bc_ag.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
 /*
@@ -968,7 +968,7 @@ xfs_refcount_adjust_extents(
 					error = -EFSCORRUPTED;
 					goto out_error;
 				}
-				cur->bc_ag.priv.refc.nr_ops++;
+				cur->bc_ag.refc.nr_ops++;
 			} else {
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 						cur->bc_ag.agno,
@@ -1003,7 +1003,7 @@ xfs_refcount_adjust_extents(
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
 				goto out_error;
-			cur->bc_ag.priv.refc.nr_ops++;
+			cur->bc_ag.refc.nr_ops++;
 		} else if (ext.rc_refcount == 1) {
 			error = xfs_refcount_delete(cur, &found_rec);
 			if (error)
@@ -1012,7 +1012,7 @@ xfs_refcount_adjust_extents(
 				error = -EFSCORRUPTED;
 				goto out_error;
 			}
-			cur->bc_ag.priv.refc.nr_ops++;
+			cur->bc_ag.refc.nr_ops++;
 			goto advloop;
 		} else {
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
@@ -1088,7 +1088,7 @@ xfs_refcount_adjust(
 	if (shape_changed)
 		shape_changes++;
 	if (shape_changes)
-		cur->bc_ag.priv.refc.shape_changes++;
+		cur->bc_ag.refc.shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
 	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen,
@@ -1166,8 +1166,8 @@ xfs_refcount_finish_one(
 	 */
 	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.agno != agno) {
-		nr_ops = rcur->bc_ag.priv.refc.nr_ops;
-		shape_changes = rcur->bc_ag.priv.refc.shape_changes;
+		nr_ops = rcur->bc_ag.refc.nr_ops;
+		shape_changes = rcur->bc_ag.refc.shape_changes;
 		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
@@ -1183,8 +1183,8 @@ xfs_refcount_finish_one(
 			error = -ENOMEM;
 			goto out_cur;
 		}
-		rcur->bc_ag.priv.refc.nr_ops = nr_ops;
-		rcur->bc_ag.priv.refc.shape_changes = shape_changes;
+		rcur->bc_ag.refc.nr_ops = nr_ops;
+		rcur->bc_ag.refc.shape_changes = shape_changes;
 	}
 	*pcur = rcur;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index f66cd6dfbe6c..476c3a9df9a1 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -340,8 +340,8 @@ xfs_refcountbt_init_cursor(
 	cur->bc_ag.agno = agno;
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_ag.priv.refc.nr_ops = 0;
-	cur->bc_ag.priv.refc.shape_changes = 0;
+	cur->bc_ag.refc.nr_ops = 0;
+	cur->bc_ag.refc.shape_changes = 0;
 
 	return cur;
 }
-- 
2.24.0.rc0


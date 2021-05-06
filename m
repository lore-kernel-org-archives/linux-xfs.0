Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B5BC43619
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D065C613B4
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbhEFHWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 03:22:01 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:60014 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233406AbhEFHV7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 03:21:59 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 28E7A67C88
        for <linux-xfs@vger.kernel.org>; Thu,  6 May 2021 17:20:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leYJb-005lni-W8
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1leYJb-001973-OP
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/22] xfs: prepare for moving perag definitions and support to libxfs
Date:   Thu,  6 May 2021 17:20:34 +1000
Message-Id: <20210506072054.271157-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210506072054.271157-1-david@fromorbit.com>
References: <20210506072054.271157-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=58VazpsMrXCI6D3nIUUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The perag structures really need to be defined with the rest of the
AG support infrastructure. The struct xfs_perag and init/teardown
has been placed in xfs_mount.[ch] because there are differences in
the structure between kernel and userspace. Mainly that userspace
doesn't have a lot of the internal stuff that the kernel has for
caches and discard and other such structures.

However, it makes more sense to move this to libxfs than to keep
this separation because we are now moving to use struct perags
everywhere in the code instead of passing raw agnumber_t values
about. Hence we shoudl really move the support infrastructure to
libxfs/xfs_ag.[ch].

To do this without breaking userspace, first we need to rearrange
the structures and code so that all the kernel specific code is
located together. This makes it simple for userspace to ifdef out
the all the parts it does not need, minimising the code differences
between kernel and userspace. The next commit will do the move...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c | 50 ++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_mount.h | 19 +++++++++---------
 2 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 21c630dde476..2e6d42014346 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -148,9 +148,11 @@ xfs_free_perag(
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
+
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
+
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
 	}
 }
@@ -175,14 +177,14 @@ xfs_sb_validate_fsb_count(
 
 int
 xfs_initialize_perag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agcount,
-	xfs_agnumber_t	*maxagi)
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agcount,
+	xfs_agnumber_t		*maxagi)
 {
-	xfs_agnumber_t	index;
-	xfs_agnumber_t	first_initialised = NULLAGNUMBER;
-	xfs_perag_t	*pag;
-	int		error = -ENOMEM;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		index;
+	xfs_agnumber_t		first_initialised = NULLAGNUMBER;
+	int			error;
 
 	/*
 	 * Walk the current per-ag tree so we don't try to initialise AGs
@@ -203,17 +205,6 @@ xfs_initialize_perag(
 		}
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
-		spin_lock_init(&pag->pag_ici_lock);
-		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
-		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-
-		error = xfs_buf_hash_init(pag);
-		if (error)
-			goto out_free_pag;
-		init_waitqueue_head(&pag->pagb_wait);
-		spin_lock_init(&pag->pagb_lock);
-		pag->pagb_count = 0;
-		pag->pagb_tree = RB_ROOT;
 
 		error = radix_tree_preload(GFP_NOFS);
 		if (error)
@@ -229,13 +220,27 @@ xfs_initialize_perag(
 		}
 		spin_unlock(&mp->m_perag_lock);
 		radix_tree_preload_end();
-		/* first new pag is fully initialized */
-		if (first_initialised == NULLAGNUMBER)
-			first_initialised = index;
+
+		spin_lock_init(&pag->pag_ici_lock);
+		spin_lock_init(&pag->pagb_lock);
+		spin_lock_init(&pag->pag_state_lock);
+		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
+		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
+		init_waitqueue_head(&pag->pagb_wait);
+		pag->pagb_count = 0;
+		pag->pagb_tree = RB_ROOT;
+
+		error = xfs_buf_hash_init(pag);
+		if (error)
+			goto out_free_pag;
+
 		error = xfs_iunlink_init(pag);
 		if (error)
 			goto out_hash_destroy;
-		spin_lock_init(&pag->pag_state_lock);
+
+		/* first new pag is fully initialized */
+		if (first_initialised == NULLAGNUMBER)
+			first_initialised = index;
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
@@ -249,6 +254,7 @@ xfs_initialize_perag(
 out_hash_destroy:
 	xfs_buf_hash_destroy(pag);
 out_free_pag:
+	pag = radix_tree_delete(&mp->m_perag_tree, index);
 	kmem_free(pag);
 out_unwind_new_pags:
 	/* unwind any prior newly initialized pags */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bb67274ee23f..6e534be5eea8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -338,6 +338,16 @@ typedef struct xfs_perag {
 	xfs_agino_t	pagl_leftrec;
 	xfs_agino_t	pagl_rightrec;
 
+	int		pagb_count;	/* pagb slots in use */
+	uint8_t		pagf_refcount_level; /* recount btree height */
+
+	/* Blocks reserved for all kinds of metadata. */
+	struct xfs_ag_resv	pag_meta_resv;
+	/* Blocks reserved for the reverse mapping btree. */
+	struct xfs_ag_resv	pag_rmapbt_resv;
+
+	/* -- kernel only structures below this line -- */
+
 	/*
 	 * Bitsets of per-ag metadata that have been checked and/or are sick.
 	 * Callers should hold pag_state_lock before accessing this field.
@@ -364,19 +374,10 @@ typedef struct xfs_perag {
 
 	/* for rcu-safe freeing */
 	struct rcu_head	rcu_head;
-	int		pagb_count;	/* pagb slots in use */
-
-	/* Blocks reserved for all kinds of metadata. */
-	struct xfs_ag_resv	pag_meta_resv;
-	/* Blocks reserved for the reverse mapping btree. */
-	struct xfs_ag_resv	pag_rmapbt_resv;
 
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 
-	/* reference count */
-	uint8_t			pagf_refcount_level;
-
 	/*
 	 * Unlinked inode information.  This incore information reflects
 	 * data stored in the AGI, so callers must hold the AGI buffer lock
-- 
2.31.1


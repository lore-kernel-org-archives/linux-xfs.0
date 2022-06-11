Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CC8C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346465AbiFKB1K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346654AbiFKB1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:09 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 130023A4813
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 44D6F5EC7E4
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:03 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005AOn-EY
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELLl-DP
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/50] xfs: active perag reference counting
Date:   Sat, 11 Jun 2022 11:26:24 +1000
Message-Id: <20220611012659.3418072-16-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef68
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=PRkkLlb27XPojcOo628A:9
        a=nzbRRBgF3B2C-GGZ:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We need to be able to dynamically remove instantiated AGs from
memory safely, either for shrinking the filesystem or paging AG
state in and out of memory (e.g. supporting millions of AGs). This
means we need to be able to safely exclude operations from accessing
perags while dynamic removal is in progress.

To do this, introduce the concept of active and passive references.
Active references are required for high level operations that make
use of an AG for a given operation (e.g. allocation) and pin the
perag in memory for the duration of the operation that is operating
on the perag (e.g. transaction scope). This means we can fail to get
an active reference to an AG, hence callers of the new active
reference API must be able to handle lookup failure gracefully.

Passive references are used in low level code, where we might need
to access the perag structure for the purposes of completing high
level operations. For example, buffers need to use passive
references because:
- we need to be able to do metadata IO during operations like grow
  and shrink transactions where high level active references to the
  AG have already been blocked
- buffers need to pin the perag until they are reclaimed from
  memory, something that high level code has no direct control over.
- unused cached buffers should not prevent a shrink from being
  started.

Hence we have active references that will form exclusion barriers
for operations to be performed on an AG, and passive references that
will prevent reclaim of the perag until all objects with passive
references have been reclaimed themselves.

This patch introduce xfs_perag_grab()/xfs_perag_rele() as the API
for active AG reference functionality. We also need to convert the
for_each_perag*() iterators to use active references, which will
start the process of converting high level code over to using active
references. Conversion of non-iterator based code to active
references will be done in followup patches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c    | 74 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_ag.h    | 31 +++++++++++-----
 fs/xfs/scrub/bmap.c       |  2 +-
 fs/xfs/scrub/fscounters.c |  4 +--
 fs/xfs/xfs_fsmap.c        |  4 +--
 fs/xfs/xfs_icache.c       |  2 +-
 fs/xfs/xfs_iwalk.c        |  6 ++--
 fs/xfs/xfs_reflink.c      |  2 +-
 fs/xfs/xfs_trace.h        |  3 ++
 9 files changed, 107 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 49e1ef2f0b9a..ae5b91d7fa5f 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -94,6 +94,68 @@ xfs_perag_put(
 	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
 }
 
+/*
+ * Active references for perag structures. This is for short term access to the
+ * per ag structures for walking trees or accessing state. If an AG is being
+ * shrunk or is offline, then this will fail to find that AG and return NULL
+ * instead.
+ */
+struct xfs_perag *
+xfs_perag_grab(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_perag	*pag;
+
+	rcu_read_lock();
+	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
+	if (pag) {
+		trace_xfs_perag_grab(mp, pag->pag_agno,
+				atomic_read(&pag->pag_active_ref), _RET_IP_);
+		if (!atomic_inc_not_zero(&pag->pag_active_ref))
+			pag = NULL;
+	}
+	rcu_read_unlock();
+	return pag;
+}
+
+/*
+ * search from @first to find the next perag with the given tag set.
+ */
+struct xfs_perag *
+xfs_perag_grab_tag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		first,
+	int			tag)
+{
+	struct xfs_perag	*pag;
+	int			found;
+
+	rcu_read_lock();
+	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
+					(void **)&pag, first, 1, tag);
+	if (found <= 0) {
+		rcu_read_unlock();
+		return NULL;
+	}
+	trace_xfs_perag_grab_tag(mp, pag->pag_agno,
+			atomic_read(&pag->pag_active_ref), _RET_IP_);
+	if (!atomic_inc_not_zero(&pag->pag_active_ref))
+		pag = NULL;
+	rcu_read_unlock();
+	return pag;
+}
+
+void
+xfs_perag_rele(
+	struct xfs_perag	*pag)
+{
+	trace_xfs_perag_rele(pag->pag_mount, pag->pag_agno,
+			atomic_read(&pag->pag_active_ref), _RET_IP_);
+	if (atomic_dec_and_test(&pag->pag_active_ref))
+		wake_up(&pag->pag_active_wq);
+}
+
 /*
  * xfs_initialize_perag_data
  *
@@ -191,12 +253,15 @@ xfs_free_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
-		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
+		XFS_IS_CORRUPT(mp, atomic_read(&pag->pag_ref) != 0);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 
+		/* drop the mount's active reference */
+		xfs_perag_rele(pag);
+		XFS_IS_CORRUPT(mp, atomic_read(&pag->pag_active_ref) != 0);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
 	}
 }
@@ -315,6 +380,7 @@ xfs_initialize_perag(
 		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		init_waitqueue_head(&pag->pagb_wait);
+		init_waitqueue_head(&pag->pag_active_wq);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 #endif /* __KERNEL__ */
@@ -327,6 +393,9 @@ xfs_initialize_perag(
 		if (error)
 			goto out_hash_destroy;
 
+		/* Active ref owned by mount indicates AG is online. */
+		atomic_set(&pag->pag_active_ref, 1);
+
 		/* first new pag is fully initialized */
 		if (first_initialised == NULLAGNUMBER)
 			first_initialised = index;
@@ -363,7 +432,8 @@ xfs_initialize_perag(
 			break;
 		xfs_buf_hash_destroy(pag);
 		xfs_iunlink_destroy(pag);
-		kmem_free(pag);
+		xfs_perag_rele(pag);
+		__xfs_free_perag(&pag->rcu_head);
 	}
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 75f7c10c110a..b36d5725c91c 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -32,7 +32,9 @@ struct xfs_ag_resv {
 struct xfs_perag {
 	struct xfs_mount *pag_mount;	/* owner filesystem */
 	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
-	atomic_t	pag_ref;	/* perag reference count */
+	atomic_t	pag_ref;	/* passive reference count */
+	atomic_t	pag_active_ref;	/* active reference count */
+	wait_queue_head_t pag_active_wq;/* woken active_ref falls to zero */
 	char		pagf_init;	/* this agf's entry is initialized */
 	char		pagi_init;	/* this agi's entry is initialized */
 	char		pagf_metadata;	/* the agf is preferred to be metadata */
@@ -117,11 +119,18 @@ int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_free_perag(struct xfs_mount *mp);
 
+/* Passive AG references */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
 struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int tag);
 void xfs_perag_put(struct xfs_perag *pag);
 
+/* Active AG references */
+struct xfs_perag *xfs_perag_grab(struct xfs_mount *, xfs_agnumber_t);
+struct xfs_perag *xfs_perag_grab_tag(struct xfs_mount *, xfs_agnumber_t,
+				   int tag);
+void xfs_perag_rele(struct xfs_perag *pag);
+
 /*
  * Per-ag geometry infomation and validation
  */
@@ -184,14 +193,18 @@ xfs_perag_next(
 	struct xfs_mount	*mp = pag->pag_mount;
 
 	*agno = pag->pag_agno + 1;
-	xfs_perag_put(pag);
-	if (*agno > end_agno)
-		return NULL;
-	return xfs_perag_get(mp, *agno);
+	xfs_perag_rele(pag);
+	while (*agno <= end_agno) {
+		pag = xfs_perag_grab(mp, *agno);
+		if (pag)
+			return pag;
+		(*agno)++;
+	}
+	return NULL;
 }
 
 #define for_each_perag_range(mp, agno, end_agno, pag) \
-	for ((pag) = xfs_perag_get((mp), (agno)); \
+	for ((pag) = xfs_perag_grab((mp), (agno)); \
 		(pag) != NULL; \
 		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
 
@@ -204,11 +217,11 @@ xfs_perag_next(
 	for_each_perag_from((mp), (agno), (pag))
 
 #define for_each_perag_tag(mp, agno, pag, tag) \
-	for ((agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
+	for ((agno) = 0, (pag) = xfs_perag_grab_tag((mp), 0, (tag)); \
 		(pag) != NULL; \
 		(agno) = (pag)->pag_agno + 1, \
-		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get_tag((mp), (agno), (tag)))
+		xfs_perag_rele(pag), \
+		(pag) = xfs_perag_grab_tag((mp), (agno), (tag)))
 
 struct aghdr_init_data {
 	/* per ag data */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 9353fd060525..81245c66590f 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -605,7 +605,7 @@ xchk_bmap_check_rmaps(
 			break;
 	}
 	if (pag)
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 6a6f8fe7f87c..3706296c61b6 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -105,7 +105,7 @@ xchk_fscount_warmup(
 	if (agi_bp)
 		xfs_buf_relse(agi_bp);
 	if (pag)
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	return error;
 }
 
@@ -224,7 +224,7 @@ xchk_fscount_aggregate_agcounts(
 
 	}
 	if (pag)
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index d8337274c74d..ca80ad703e06 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -688,11 +688,11 @@ __xfs_getfsmap_datadev(
 		info->agf_bp = NULL;
 	}
 	if (info->pag) {
-		xfs_perag_put(info->pag);
+		xfs_perag_rele(info->pag);
 		info->pag = NULL;
 	} else if (pag) {
 		/* loop termination case */
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5269354b1b69..f2b0ca0453d6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1759,7 +1759,7 @@ xfs_icwalk(
 		if (error) {
 			last_error = error;
 			if (error == -EFSCORRUPTED) {
-				xfs_perag_put(pag);
+				xfs_perag_rele(pag);
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 7558486f4937..c31857d903a4 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -591,7 +591,7 @@ xfs_iwalk(
 	}
 
 	if (iwag.pag)
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	xfs_iwalk_free(&iwag);
 	return error;
 }
@@ -683,7 +683,7 @@ xfs_iwalk_threaded(
 			break;
 	}
 	if (pag)
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	if (polled)
 		xfs_pwork_poll(&pctl);
 	return xfs_pwork_destroy(&pctl);
@@ -776,7 +776,7 @@ xfs_inobt_walk(
 	}
 
 	if (iwag.pag)
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	xfs_iwalk_free(&iwag);
 	return error;
 }
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d2328cc26ddf..1243f0ea8dd8 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -799,7 +799,7 @@ xfs_reflink_recover_cow(
 	for_each_perag(mp, agno, pag) {
 		error = xfs_refcount_recover_cow_leftovers(mp, pag);
 		if (error) {
-			xfs_perag_put(pag);
+			xfs_perag_rele(pag);
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d32026585c1b..32efed970b73 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -189,6 +189,9 @@ DEFINE_EVENT(xfs_perag_class, name,	\
 DEFINE_PERAG_REF_EVENT(xfs_perag_get);
 DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
+DEFINE_PERAG_REF_EVENT(xfs_perag_grab);
+DEFINE_PERAG_REF_EVENT(xfs_perag_grab_tag);
+DEFINE_PERAG_REF_EVENT(xfs_perag_rele);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 
-- 
2.35.1


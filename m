Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236A6C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349321AbiFKB1W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348166AbiFKB1O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:14 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 906AC3A4CC5
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7C09D10E7205
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005AOp-Fc
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELLr-EU
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/50] xfs: rework the perag trace points to be perag centric
Date:   Sat, 11 Jun 2022 11:26:25 +1000
Message-Id: <20220611012659.3418072-17-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a3ef68
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=y0MLRB0vTC7IaxJqomAA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So that they all output the same information in the traces to make
debugging refcount issues easier.

This means that all the lookup/drop functions no longer need to use
the full memory barrier atomic operations (atomic*_return()) so
will have less overhead when tracing is off. The set/clear tag
tracepoints no longer abuse the reference count to pass the tag -
the tag being cleared is obvious from the _RET_IP_ that is recorded
in the trace point.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c | 25 +++++++++----------------
 fs/xfs/xfs_icache.c    |  4 ++--
 fs/xfs/xfs_trace.h     | 21 +++++++++++----------
 3 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index ae5b91d7fa5f..1fc73ac55250 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -44,16 +44,15 @@ xfs_perag_get(
 	xfs_agnumber_t		agno)
 {
 	struct xfs_perag	*pag;
-	int			ref = 0;
 
 	rcu_read_lock();
 	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
 	if (pag) {
+		trace_xfs_perag_get(pag, _RET_IP_);
 		ASSERT(atomic_read(&pag->pag_ref) >= 0);
-		ref = atomic_inc_return(&pag->pag_ref);
+		atomic_inc(&pag->pag_ref);
 	}
 	rcu_read_unlock();
-	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
 	return pag;
 }
 
@@ -68,7 +67,6 @@ xfs_perag_get_tag(
 {
 	struct xfs_perag	*pag;
 	int			found;
-	int			ref;
 
 	rcu_read_lock();
 	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
@@ -77,9 +75,9 @@ xfs_perag_get_tag(
 		rcu_read_unlock();
 		return NULL;
 	}
-	ref = atomic_inc_return(&pag->pag_ref);
+	trace_xfs_perag_get_tag(pag, _RET_IP_);
+	atomic_inc(&pag->pag_ref);
 	rcu_read_unlock();
-	trace_xfs_perag_get_tag(mp, pag->pag_agno, ref, _RET_IP_);
 	return pag;
 }
 
@@ -87,11 +85,9 @@ void
 xfs_perag_put(
 	struct xfs_perag	*pag)
 {
-	int	ref;
-
+	trace_xfs_perag_put(pag, _RET_IP_);
 	ASSERT(atomic_read(&pag->pag_ref) > 0);
-	ref = atomic_dec_return(&pag->pag_ref);
-	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
+	atomic_dec(&pag->pag_ref);
 }
 
 /*
@@ -110,8 +106,7 @@ xfs_perag_grab(
 	rcu_read_lock();
 	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
 	if (pag) {
-		trace_xfs_perag_grab(mp, pag->pag_agno,
-				atomic_read(&pag->pag_active_ref), _RET_IP_);
+		trace_xfs_perag_grab(pag, _RET_IP_);
 		if (!atomic_inc_not_zero(&pag->pag_active_ref))
 			pag = NULL;
 	}
@@ -138,8 +133,7 @@ xfs_perag_grab_tag(
 		rcu_read_unlock();
 		return NULL;
 	}
-	trace_xfs_perag_grab_tag(mp, pag->pag_agno,
-			atomic_read(&pag->pag_active_ref), _RET_IP_);
+	trace_xfs_perag_grab_tag(pag, _RET_IP_);
 	if (!atomic_inc_not_zero(&pag->pag_active_ref))
 		pag = NULL;
 	rcu_read_unlock();
@@ -150,8 +144,7 @@ void
 xfs_perag_rele(
 	struct xfs_perag	*pag)
 {
-	trace_xfs_perag_rele(pag->pag_mount, pag->pag_agno,
-			atomic_read(&pag->pag_active_ref), _RET_IP_);
+	trace_xfs_perag_rele(pag, _RET_IP_);
 	if (atomic_dec_and_test(&pag->pag_active_ref))
 		wake_up(&pag->pag_active_wq);
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f2b0ca0453d6..1ca6cfeccbb8 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -254,7 +254,7 @@ xfs_perag_set_inode_tag(
 		break;
 	}
 
-	trace_xfs_perag_set_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
+	trace_xfs_perag_set_inode_tag(pag, _RET_IP_);
 }
 
 /* Clear a tag on both the AG incore inode tree and the AG radix tree. */
@@ -288,7 +288,7 @@ xfs_perag_clear_inode_tag(
 	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno, tag);
 	spin_unlock(&mp->m_perag_lock);
 
-	trace_xfs_perag_clear_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
+	trace_xfs_perag_clear_inode_tag(pag, _RET_IP_);
 }
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 32efed970b73..cacef4eecac0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -159,33 +159,34 @@ TRACE_EVENT(xlog_intent_recovery_failed,
 );
 
 DECLARE_EVENT_CLASS(xfs_perag_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,
-		 unsigned long caller_ip),
-	TP_ARGS(mp, agno, refcount, caller_ip),
+	TP_PROTO(struct xfs_perag *pag, unsigned long caller_ip),
+	TP_ARGS(pag, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(int, refcount)
+		__field(int, active_refcount)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->refcount = refcount;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->refcount = atomic_read(&pag->pag_ref);
+		__entry->active_refcount = atomic_read(&pag->pag_active_ref);
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno 0x%x refcount %d caller %pS",
+	TP_printk("dev %d:%d agno 0x%x passive refs %d active refs %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->refcount,
+		  __entry->active_refcount,
 		  (char *)__entry->caller_ip)
 );
 
 #define DEFINE_PERAG_REF_EVENT(name)	\
 DEFINE_EVENT(xfs_perag_class, name,	\
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount,	\
-		 unsigned long caller_ip),					\
-	TP_ARGS(mp, agno, refcount, caller_ip))
+	TP_PROTO(struct xfs_perag *pag, unsigned long caller_ip), \
+	TP_ARGS(pag, caller_ip))
 DEFINE_PERAG_REF_EVENT(xfs_perag_get);
 DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
-- 
2.35.1


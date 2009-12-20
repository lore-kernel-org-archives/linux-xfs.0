Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBK4RZQs149081 for <xfs@oss.sgi.com>; Sat, 19 Dec 2009 22:27:36 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 01AA019C24E4
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2009 20:28:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	yWH5iMTZdhDAZeBX for <xfs@oss.sgi.com>;
	Sat, 19 Dec 2009 20:28:15 -0800 (PST)
Received: from discord (unverified [121.44.162.26])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10517811-1927428
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2009 14:58:14 +1030 (CDT)
Received: from dave by discord with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>) id 1NMDOv-0000Iw-Fa
	for xfs@oss.sgi.com; Sun, 20 Dec 2009 15:28:13 +1100
Date: Sun, 20 Dec 2009 15:28:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/6] XFS: Add trace points for per-ag refcount debugging.
Message-ID: <20091220042813.GJ4850@discord.disaster>
References: <1260857477-2368-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1260857477-2368-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Uninline xfs_perag_{get,put} so that tracepoints can be inserted
into them to speed debugging of reference count problems.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |   27 +++++++++++++++++++++++++++
 fs/xfs/xfs_ag.h              |    2 ++
 fs/xfs/xfs_mount.c           |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h           |   25 ++-----------------------
 4 files changed, 65 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index d4ded59..5ec1475 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -33,6 +33,33 @@ struct xfs_dquot;
 struct xlog_ticket;
 struct log;
 
+#define DEFINE_PERAG_REF_EVENT(name) \
+TRACE_EVENT(name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int refcount, \
+		 unsigned long caller_ip), \
+	TP_ARGS(mp, agno, refcount, caller_ip), \
+	TP_STRUCT__entry( \
+		__field(dev_t, dev) \
+		__field(xfs_agnumber_t, agno) \
+		__field(int, refcount) \
+		__field(unsigned long, caller_ip) \
+	), \
+	TP_fast_assign( \
+		__entry->dev = mp->m_super->s_dev; \
+		__entry->agno = agno; \
+		__entry->refcount = refcount; \
+		__entry->caller_ip = caller_ip; \
+	), \
+	TP_printk("dev %d:%d agno %u refcount %d caller %pf", \
+		  MAJOR(__entry->dev), MINOR(__entry->dev), \
+		  __entry->agno, \
+		  __entry->refcount, \
+		  (char *)__entry->caller_ip) \
+);
+
+DEFINE_PERAG_REF_EVENT(xfs_perag_get)
+DEFINE_PERAG_REF_EVENT(xfs_perag_put)
+
 #define DEFINE_ATTR_LIST_EVENT(name) \
 TRACE_EVENT(name, \
 	TP_PROTO(struct xfs_attr_list_context *ctx), \
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 18ae43f..963bc27 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -197,6 +197,8 @@ typedef struct xfs_perag_busy {
 #endif
 
 typedef struct xfs_perag {
+	struct xfs_mount *pag_mount;	/* owner filesystem */
+	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
 	atomic_t	pag_ref;	/* perag reference count */
 	char		pagf_init;	/* this agf's entry is initialized */
 	char		pagi_init;	/* this agi's entry is initialized */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1d00f7f..223d9c3 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -201,6 +201,38 @@ xfs_uuid_unmount(
 
 
 /*
+ * Reference counting access wrappers to the perag structures.
+ */
+struct xfs_perag *
+xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
+{
+	struct xfs_perag	*pag;
+	int			ref = 0;
+
+	spin_lock(&mp->m_perag_lock);
+	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
+	if (pag) {
+		ASSERT(atomic_read(&pag->pag_ref) >= 0);
+		/* catch leaks in the positive direction during testing */
+		ASSERT(atomic_read(&pag->pag_ref) < 1000);
+		ref = atomic_inc_return(&pag->pag_ref);
+	}
+	spin_unlock(&mp->m_perag_lock);
+	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
+	return pag;
+}
+
+void
+xfs_perag_put(struct xfs_perag *pag)
+{
+	int	ref;
+
+	ASSERT(atomic_read(&pag->pag_ref) > 0);
+	ref = atomic_dec_return(&pag->pag_ref);
+	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
+}
+
+/*
  * Free up the resources associated with a mount structure.  Assume that
  * the structure was initially zeroed, so we can tell which fields got
  * initialized.
@@ -433,6 +465,8 @@ xfs_initialize_perag(
 			kmem_free(pag);
 			return -EEXIST;
 		}
+		pag->pag_agno = index;
+		pag->pag_mount = mp;
 		spin_unlock(&mp->m_perag_lock);
 		radix_tree_preload_end();
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 16b2212..e62fd1c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -386,29 +386,8 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 /*
  * perag get/put wrappers for ref counting
  */
-static inline struct xfs_perag *
-xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
-{
-	struct xfs_perag	*pag;
-
-	spin_lock(&mp->m_perag_lock);
-	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
-	if (pag) {
-		ASSERT(atomic_read(&pag->pag_ref) >= 0);
-		/* catch leaks in the positive direction during testing */
-		ASSERT(atomic_read(&pag->pag_ref) < 1000);
-		atomic_inc(&pag->pag_ref);
-	}
-	spin_unlock(&mp->m_perag_lock);
-	return pag;
-}
-
-static inline void
-xfs_perag_put(struct xfs_perag *pag)
-{
-	ASSERT(atomic_read(&pag->pag_ref) > 0);
-	atomic_dec(&pag->pag_ref);
-}
+struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
+void	xfs_perag_put(struct xfs_perag *pag);
 
 /*
  * Per-cpu superblock locking functions

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

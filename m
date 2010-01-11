Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BBpMJp137858 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 05:51:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B72B7158862
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 03:52:16 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	mmL4XdDn2IPVfVnY for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 03:52:16 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11367104-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:22:14 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUIof-0003fJ-4d
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:52:13 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUIkS-0006GB-Ul
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:47:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/10] XFS: Add trace points for per-ag refcount debugging.
Date: Mon, 11 Jan 2010 22:47:46 +1100
Message-Id: <1263210469-22171-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1263210469-22171-1-git-send-email-david@fromorbit.com>
References: <1263210469-22171-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
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
index c22a608..058fff1 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -78,6 +78,33 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	)
 )
 
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
 DEFINE_EVENT(xfs_attr_list_class, name, \
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
index f241fec..049dbc7 100644
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
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

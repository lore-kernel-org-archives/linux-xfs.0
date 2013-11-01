Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A62937F53
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 23:27:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 64754304059
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 21:27:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	v0BxsEu0PVUteXPO for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 21:27:28 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vc6KR-0008Gs-4q
	for xfs@oss.sgi.com; Fri, 01 Nov 2013 15:27:23 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vc6KR-0005le-3q
	for xfs@oss.sgi.com; Fri, 01 Nov 2013 15:27:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] xfs: add tracepoints to AGF/AGI read operations
Date: Fri,  1 Nov 2013 15:27:19 +1100
Message-Id: <1383280040-21979-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1383280040-21979-1-git-send-email-david@fromorbit.com>
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

To help track down AGI/AGF lock ordering issues, I added these
tracepoints to tell us when an AGI or AGF is read and locked.  With
these we can now determine if the lock ordering goes wrong from
tracing captures.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c  |  5 ++++-
 fs/xfs/xfs_ialloc.c |  6 +++++-
 fs/xfs/xfs_trace.h  | 25 +++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index bcf1652..9eab2df 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2294,6 +2294,8 @@ xfs_read_agf(
 {
 	int		error;
 
+	trace_xfs_read_agf(mp, agno);
+
 	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_trans_read_buf(
 			mp, tp, mp->m_ddev_targp,
@@ -2324,8 +2326,9 @@ xfs_alloc_read_agf(
 	struct xfs_perag	*pag;		/* per allocation group data */
 	int			error;
 
-	ASSERT(agno != NULLAGNUMBER);
+	trace_xfs_alloc_read_agf(mp, agno);
 
+	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_read_agf(mp, tp, agno,
 			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
 			bpp);
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 14d732f..e87719c 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -40,6 +40,7 @@
 #include "xfs_icreate_item.h"
 #include "xfs_icache.h"
 #include "xfs_dinode.h"
+#include "xfs_trace.h"
 
 
 /*
@@ -1627,8 +1628,9 @@ xfs_read_agi(
 {
 	int			error;
 
-	ASSERT(agno != NULLAGNUMBER);
+	trace_xfs_read_agi(mp, agno);
 
+	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
@@ -1651,6 +1653,8 @@ xfs_ialloc_read_agi(
 	struct xfs_perag	*pag;	/* per allocation group data */
 	int			error;
 
+	trace_xfs_ialloc_read_agi(mp, agno);
+
 	error = xfs_read_agi(mp, tp, agno, bpp);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f195476..425dfa4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -135,6 +135,31 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_eofblocks);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_eofblocks);
 
+DECLARE_EVENT_CLASS(xfs_ag_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
+	TP_ARGS(mp, agno),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+	),
+	TP_printk("dev %d:%d agno %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno)
+);
+#define DEFINE_AG_EVENT(name)	\
+DEFINE_EVENT(xfs_ag_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),	\
+	TP_ARGS(mp, agno))
+
+DEFINE_AG_EVENT(xfs_read_agf);
+DEFINE_AG_EVENT(xfs_alloc_read_agf);
+DEFINE_AG_EVENT(xfs_read_agi);
+DEFINE_AG_EVENT(xfs_ialloc_read_agi);
+
 TRACE_EVENT(xfs_attr_list_node_descend,
 	TP_PROTO(struct xfs_attr_list_context *ctx,
 		 struct xfs_da_node_entry *btree),
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

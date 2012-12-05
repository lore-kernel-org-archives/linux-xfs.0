Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB5GhQP8030138 for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 10:43:27 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id O8BzCPs45nV2ifSW for
	<xfs@oss.sgi.com>; Wed, 05 Dec 2012 08:45:50 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qB5GjmeQ004097
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 11:45:48 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qB5GjlLa032572
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2012 11:45:47 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/4] xfs: preallocation throttling tracepoints
Date: Wed,  5 Dec 2012 11:47:58 -0500
Message-Id: <1354726078-31793-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1354726078-31793-1-git-send-email-bfoster@redhat.com>
References: <1354726078-31793-1-git-send-email-bfoster@redhat.com>
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

Define tracepoints for preallocation throttling. The
xfs_prealloc_dquot_max_pct() tracepoint provides data on the max
allowable prealloc for each quota. The xfs_iomap_prealloc_size()
tracepoint provides data on the overall prealloc.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c |    6 ++++-
 fs/xfs/xfs_trace.h |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index bbeec02..0d64055 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -369,6 +369,7 @@ xfs_prealloc_dquot_max(
 
 	do_div(free, 100);
 	free *= pct;
+	trace_xfs_prealloc_dquot_max_pct(dq, free, pct);
 
 	return free;
 }
@@ -426,7 +427,7 @@ xfs_iomap_prealloc_size(
 	xfs_fsblock_t		alloc_blocks = 0;
 	int			shift = 0;
 	int64_t			freesp;
-	int64_t                 max_quota_prealloc;
+	int64_t                 max_quota_prealloc = -1;
 
 	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
 		goto check_writeio;
@@ -469,6 +470,9 @@ check_writeio:
 	if (alloc_blocks < mp->m_writeio_blocks)
 		alloc_blocks = mp->m_writeio_blocks;
 
+	trace_xfs_iomap_prealloc_size(ip, alloc_blocks, shift, max_quota_prealloc,
+				      mp->m_writeio_blocks);
+
 	return alloc_blocks;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2e137d4..2b28626 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -618,6 +618,33 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 		  (char *)__entry->caller_ip)
 )
 
+TRACE_EVENT(xfs_iomap_prealloc_size,
+	TP_PROTO(struct xfs_inode *ip, xfs_fsblock_t blocks, int shift,
+		 int64_t qfreesp, unsigned int writeio_blocks),
+	TP_ARGS(ip, blocks, shift, qfreesp, writeio_blocks),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsblock_t, blocks)
+		__field(int, shift)
+		__field(int64_t, qfreesp)
+		__field(unsigned int, writeio_blocks)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->blocks = blocks;
+		__entry->shift = shift;
+		__entry->qfreesp = qfreesp;
+		__entry->writeio_blocks = writeio_blocks;
+	),
+	TP_printk("dev %d:%d ino 0x%llx prealloc blocks %llu shift %d "
+		"quota max %lld, m_writeio_blocks %u",
+		MAJOR(__entry->dev), MINOR(__entry->dev), __entry->ino,
+		__entry->blocks, __entry->shift, __entry->qfreesp,
+		__entry->writeio_blocks)
+)
+
 #define DEFINE_IREF_EVENT(name) \
 DEFINE_EVENT(xfs_iref_class, name, \
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip), \
@@ -770,6 +797,41 @@ DEFINE_DQUOT_EVENT(xfs_dqflush);
 DEFINE_DQUOT_EVENT(xfs_dqflush_force);
 DEFINE_DQUOT_EVENT(xfs_dqflush_done);
 
+TRACE_EVENT(xfs_prealloc_dquot_max_pct,
+	TP_PROTO(struct xfs_dquot *dqp, int64_t free, int pct),
+	TP_ARGS(dqp, free, pct),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u32, id)
+		__field(unsigned long long, res_bcount)
+		__field(unsigned long long, blk_hardlimit)
+		__field(unsigned long long, blk_softlimit)
+		__field(unsigned long long, free)
+		__field(int, pct)
+	),
+	TP_fast_assign(
+		__entry->dev = dqp->q_mount->m_super->s_dev;
+		__entry->id = be32_to_cpu(dqp->q_core.d_id);
+		__entry->res_bcount = dqp->q_res_bcount;
+		__entry->blk_hardlimit =
+			be64_to_cpu(dqp->q_core.d_blk_hardlimit);
+		__entry->blk_softlimit =
+			be64_to_cpu(dqp->q_core.d_blk_softlimit);
+		__entry->free = free;
+		__entry->pct = pct;
+	),
+	TP_printk("dev %d:%d id 0x%x res_bc 0x%llx "
+		  "bhardlimit 0x%llx bsoftlimit 0x%llx "
+		  "free 0x%llx (%d%%)",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->id,
+		  __entry->res_bcount,
+		  __entry->blk_hardlimit,
+		  __entry->blk_softlimit,
+		  __entry->free,
+		  __entry->pct)
+)
+
 DECLARE_EVENT_CLASS(xfs_loggrant_class,
 	TP_PROTO(struct xlog *log, struct xlog_ticket *tic),
 	TP_ARGS(log, tic),
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N55CLf136106 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:12 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZkYW8fKWHHRwG7xL for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:57 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pbz-0003K3-8g
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:43 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pbp-0003it-5d
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 090/102] xfs: add trace points for log forces
Date: Thu, 23 Aug 2012 15:02:48 +1000
Message-Id: <1345698180-13612-91-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: 14c26c6a05de138a4fd9a0c05ff8e7435a618324

To enable easy tracing of the location of log forces and the
frequency of them via perf, add a pair of trace points to the log
force functions.  This will help debug where excessive log forces
are being issued from by simple perf commands like:

# ~/perf/perf top -e xfs:xfs_log_force -G -U

Which gives this sort of output:

Events: 141  xfs:xfs_log_force
-  100.00%  [kernel]  [k] xfs_log_force
   - xfs_log_force
        87.04% xfsaild
           kthread
           kernel_thread_helper
      - 12.87% xfs_buf_lock
           _xfs_buf_find
           xfs_buf_get
           xfs_trans_get_buf
           xfs_da_do_buf
           xfs_da_get_buf
           xfs_dir2_data_init
           xfs_dir2_leaf_addname
           xfs_dir_createname
           xfs_create
           xfs_vn_mknod
           xfs_vn_create
           vfs_create
           do_last.isra.41
           path_openat
           do_filp_open
           do_sys_open
           sys_open
           system_call_fastpath

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sig.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |   16 ++++++++++++++++
 fs/xfs/xfs_log.c             |    2 ++
 2 files changed, 18 insertions(+)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 1315931..a163ae3 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -880,6 +880,22 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
 		  __print_flags(__entry->flags, "|", XFS_LI_FLAGS))
 )
 
+TRACE_EVENT(xfs_log_force,
+	TP_PROTO(struct xfs_mount *mp, xfs_lsn_t lsn),
+	TP_ARGS(mp, lsn),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_lsn_t, lsn)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->lsn = lsn;
+	),
+	TP_printk("dev %d:%d lsn 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->lsn)
+)
+
 #define DEFINE_LOG_ITEM_EVENT(name) \
 DEFINE_EVENT(xfs_log_item_class, name, \
 	TP_PROTO(struct xfs_log_item *lip), \
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 653cba8..9f80aa8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2981,6 +2981,7 @@ xfs_log_force(
 {
 	int	error;
 
+	trace_xfs_log_force(mp, 0);
 	error = _xfs_log_force(mp, flags, NULL);
 	if (error)
 		xfs_warn(mp, "%s: error %d returned.", __func__, error);
@@ -3131,6 +3132,7 @@ xfs_log_force_lsn(
 {
 	int	error;
 
+	trace_xfs_log_force(mp, lsn);
 	error = _xfs_log_force_lsn(mp, lsn, flags, NULL);
 	if (error)
 		xfs_warn(mp, "%s: error %d returned.", __func__, error);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

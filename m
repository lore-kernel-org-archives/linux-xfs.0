Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3O6Xvch031579 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 01:33:57 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VN2wf4DT4oSQYxXJ for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 23:33:55 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMZJx-0004NL-Vs
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:54 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMZJn-0005t5-TH
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/10] xfs: add trace points for log forces
Date: Tue, 24 Apr 2012 16:33:31 +1000
Message-Id: <1335249220-22274-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1335249220-22274-1-git-send-email-david@fromorbit.com>
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_log.c   |    2 ++
 fs/xfs/xfs_trace.h |   16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9b10a15..6b965bf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2941,6 +2941,7 @@ xfs_log_force(
 {
 	int	error;
 
+	trace_xfs_log_force(mp, 0);
 	error = _xfs_log_force(mp, flags, NULL);
 	if (error)
 		xfs_warn(mp, "%s: error %d returned.", __func__, error);
@@ -3089,6 +3090,7 @@ xfs_log_force_lsn(
 {
 	int	error;
 
+	trace_xfs_log_force(mp, lsn);
 	error = _xfs_log_force_lsn(mp, lsn, flags, NULL);
 	if (error)
 		xfs_warn(mp, "%s: error %d returned.", __func__, error);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index febff43..7cf9d35 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -874,6 +874,22 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
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
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 314827CCA
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 03:53:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA35D304043
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 01:53:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9hhIbLayqaFC9iyC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 01:53:51 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 617F0C00DE14
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 08:53:51 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u2F8roMV025309
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 04:53:50 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Add caller function output to xfs_log_force tracepoint
Date: Tue, 15 Mar 2016 09:53:39 +0100
Message-Id: <1458032019-31953-1-git-send-email-cmaiolino@redhat.com>
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

I had sent this patch yesterday, but for some reason it didn't reach xfs list,
sending again.


Output the caller of xfs_log_force might be useful when tracing log checkpoint
problems without the need to build kernel with DEBUG.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_log.c   |  4 ++--
 fs/xfs/xfs_trace.h | 10 ++++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b49ccf5..8c08015b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3378,7 +3378,7 @@ xfs_log_force(
 {
 	int	error;
 
-	trace_xfs_log_force(mp, 0);
+	trace_xfs_log_force(mp, 0, _RET_IP_);
 	error = _xfs_log_force(mp, flags, NULL);
 	if (error)
 		xfs_warn(mp, "%s: error %d returned.", __func__, error);
@@ -3527,7 +3527,7 @@ xfs_log_force_lsn(
 {
 	int	error;
 
-	trace_xfs_log_force(mp, lsn);
+	trace_xfs_log_force(mp, lsn, _RET_IP_);
 	error = _xfs_log_force_lsn(mp, lsn, flags, NULL);
 	if (error)
 		xfs_warn(mp, "%s: error %d returned.", __func__, error);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c8d5842..384bb17 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1053,19 +1053,21 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
 )
 
 TRACE_EVENT(xfs_log_force,
-	TP_PROTO(struct xfs_mount *mp, xfs_lsn_t lsn),
-	TP_ARGS(mp, lsn),
+	TP_PROTO(struct xfs_mount *mp, xfs_lsn_t lsn, unsigned long caller_ip),
+	TP_ARGS(mp, lsn, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_lsn_t, lsn)
+		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->lsn = lsn;
+		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d lsn 0x%llx",
+	TP_printk("dev %d:%d lsn 0x%llx caller %ps",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->lsn)
+		  __entry->lsn, (void *)__entry->caller_ip)
 )
 
 #define DEFINE_LOG_ITEM_EVENT(name) \
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

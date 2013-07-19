Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8487D7F81
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00DA4AC010
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gibpsffAnGfxrcAb for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:36 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048G-En
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-0001zw-Bb
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 40/49] xfs: Refactor xfs_ticket_alloc() to extract a new helper
Date: Fri, 19 Jul 2013 16:25:11 +1000
Message-Id: <1374215120-7271-41-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

From: Jie Liu <jeff.liu@oracle.com>

Refactor xlog_ticket_alloc() to extract a new helper, i.e.
xfs_log_calc_unit_res().

This helper would be used to calculate the total log reservation
size by adding extra log operation/transation headers for a new
log ticket.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c        | 60 +++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_log_format.h |  4 ++++
 2 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d852a2b..b02415b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3391,24 +3391,17 @@ xfs_log_ticket_get(
 }
 
 /*
- * Allocate and initialise a new log ticket.
+ * Figure out the total log space unit (in bytes) that would be
+ * required for a log ticket.
  */
-struct xlog_ticket *
-xlog_ticket_alloc(
-	struct xlog	*log,
-	int		unit_bytes,
-	int		cnt,
-	char		client,
-	bool		permanent,
-	xfs_km_flags_t	alloc_flags)
+int
+xfs_log_calc_unit_res(
+	struct xfs_mount	*mp,
+	int			unit_bytes)
 {
-	struct xlog_ticket *tic;
-	uint		num_headers;
-	int		iclog_space;
-
-	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
-	if (!tic)
-		return NULL;
+	struct xlog		*log = mp->m_log;
+	int			iclog_space;
+	uint			num_headers;
 
 	/*
 	 * Permanent reservations have up to 'cnt'-1 active log operations
@@ -3483,20 +3476,43 @@ xlog_ticket_alloc(
 	unit_bytes += log->l_iclog_hsize;
 
 	/* for roundoff padding for transaction data and one for commit record */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
-	    log->l_mp->m_sb.sb_logsunit > 1) {
+	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1) {
 		/* log su roundoff */
-		unit_bytes += 2*log->l_mp->m_sb.sb_logsunit;
+		unit_bytes += 2 * mp->m_sb.sb_logsunit;
 	} else {
 		/* BB roundoff */
-		unit_bytes += 2*BBSIZE;
+		unit_bytes += 2 * BBSIZE;
         }
 
+	return unit_bytes;
+}
+
+/*
+ * Allocate and initialise a new log ticket.
+ */
+struct xlog_ticket *
+xlog_ticket_alloc(
+	struct xlog		*log,
+	int			unit_bytes,
+	int			cnt,
+	char			client,
+	bool			permanent,
+	xfs_km_flags_t		alloc_flags)
+{
+	struct xlog_ticket	*tic;
+	int			unit_res;
+
+	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
+	if (!tic)
+		return NULL;
+
+	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
+
 	atomic_set(&tic->t_ref, 1);
 	tic->t_task		= current;
 	INIT_LIST_HEAD(&tic->t_queue);
-	tic->t_unit_res		= unit_bytes;
-	tic->t_curr_res		= unit_bytes;
+	tic->t_unit_res		= unit_res;
+	tic->t_curr_res		= unit_res;
 	tic->t_cnt		= cnt;
 	tic->t_ocnt		= cnt;
 	tic->t_tid		= prandom_u32();
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index 198381e..cc08f59 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -18,6 +18,8 @@
 #ifndef	__XFS_LOG_FORMAT_H__
 #define __XFS_LOG_FORMAT_H__
 
+struct xfs_mount;
+
 /*
  * On-disk Log Format definitions.
  *
@@ -834,4 +836,6 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
+
 #endif /* __XFS_LOG_FORMAT_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4103329E24
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:51:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2EEAC304039
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:51:00 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DsjT8EqZzsnDRzsr for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:58 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004YW-Si
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:16 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00063f-Ey
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 40/50] xfs: Refactor
	xfs_ticket_alloc() to extract a new helper
Date: Mon, 12 Aug 2013 20:50:01 +1000
Message-Id: <1376304611-22994-41-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log.c        | 60 +++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_log_format.h |  4 ++++
 2 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bf89eb9..704f095 100644
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

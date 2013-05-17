Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C5047F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 00:38:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D1BB88F8040
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 22:38:45 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pd2l0kubzk8nDKqQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 22:38:44 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r4H5cfTW031511
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:42 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5cgZj014305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:43 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5cfMl029761 for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:42 GMT
Message-ID: <5195C25F.3000709@oracle.com>
Date: Fri, 17 May 2013 13:38:39 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 6/8] xfs: Refactor xfs_ticket_alloc() to extract a new
	helper
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Refactor xfs_ticket_alloc() to extract a new helper, i.e.
xfs_log_calc_unit_res().

This helper would be used to calcaulation the total log reservation
size by adding extra log operation/transation headers for a new
log ticket.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_log.c |   53 +++++++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_log.h |    1 +
 2 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b345a7c..304b3d0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3377,24 +3377,17 @@ xfs_log_ticket_get(
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
@@ -3478,11 +3471,35 @@ xlog_ticket_alloc(
 		unit_bytes += 2*BBSIZE;
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
+	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
+
+	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
+	if (!tic)
+		return NULL;
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
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 5caee96..8424291 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -184,6 +184,7 @@ bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 void	xfs_log_work_queue(struct xfs_mount *mp);
 void	xfs_log_worker(struct work_struct *work);
 void	xfs_log_quiesce(struct xfs_mount *mp);
+int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
 
 #endif
 #endif	/* __XFS_LOG_H__ */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

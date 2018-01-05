Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41638 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbeAEDjl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 22:39:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w053bp3e151455
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 03:39:41 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fa08w04s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 05 Jan 2018 03:39:41 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w053de8S004349
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 03:39:40 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w053ddCd016797
        for <linux-xfs@vger.kernel.org>; Fri, 5 Jan 2018 03:39:40 GMT
Subject: [PATCH 1/3] xfs: trace log reservations at mount time
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Jan 2018 19:39:27 -0800
Message-ID: <151512356737.14363.9190260401902946215.stgit@magnolia>
In-Reply-To: <151512356118.14363.7797314285394643799.stgit@magnolia>
References: <151512356118.14363.7797314285394643799.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

At each mount, emit the transaction reservation type information via
tracepoints.  This makes it easier to compare the log reservation info
calculated by the kernel and xfsprogs so that we can more easily diagnose
minimum log size failures on freshly formatted filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |    2 +-
 fs/xfs/libxfs/xfs_shared.h     |    3 +++
 fs/xfs/xfs_trace.h             |   26 ++++++++++++++++++++++++++
 fs/xfs/xfs_trans.c             |   22 ++++++++++++++++++++++
 4 files changed, 52 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index c105979..cc4cbe2 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -55,7 +55,7 @@ xfs_log_calc_max_attrsetm_res(
  * the maximum one in terms of the pre-calculated values which were done
  * at mount time.
  */
-STATIC void
+void
 xfs_log_get_max_trans_res(
 	struct xfs_mount	*mp,
 	struct xfs_trans_res	*max_resp)
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 67ccb1a..d0b84da 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -76,6 +76,9 @@ struct xfs_log_item_desc {
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
 int	xfs_log_calc_minimum_size(struct xfs_mount *);
 
+struct xfs_trans_res;
+void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
+				  struct xfs_trans_res *max_resp);
 
 /*
  * Values for t_flags.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9235b2c..b6251f8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3313,6 +3313,32 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 
+TRACE_EVENT(xfs_trans_resv_calc,
+	TP_PROTO(struct xfs_mount *mp, unsigned int type,
+		 struct xfs_trans_res *res),
+	TP_ARGS(mp, type, res),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, type)
+		__field(uint, logres)
+		__field(int, logcount)
+		__field(int, logflags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->type = type;
+		__entry->logres = res->tr_logres;
+		__entry->logcount = res->tr_logcount;
+		__entry->logflags = res->tr_logflags;
+	),
+	TP_printk("dev %d:%d type %d logres %u logcount %d flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->logres,
+		  __entry->logcount,
+		  __entry->logflags)
+);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index a87f657..86f92df 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -35,6 +35,27 @@
 kmem_zone_t	*xfs_trans_zone;
 kmem_zone_t	*xfs_log_item_desc_zone;
 
+#if defined(CONFIG_TRACEPOINTS)
+static void
+xfs_trans_trace_reservations(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans_res	resv;
+	struct xfs_trans_res	*res;
+	struct xfs_trans_res	*end_res;
+	int			i;
+
+	res = (struct xfs_trans_res *)M_RES(mp);
+	end_res = (struct xfs_trans_res *)(M_RES(mp) + 1);
+	for (i = 0; res < end_res; i++, res++)
+		trace_xfs_trans_resv_calc(mp, i, res);
+	xfs_log_get_max_trans_res(mp, &resv);
+	trace_xfs_trans_resv_calc(mp, -1, &resv);
+}
+#else
+# define xfs_trans_trace_reservations(mp)
+#endif
+
 /*
  * Initialize the precomputed transaction reservation values
  * in the mount structure.
@@ -44,6 +65,7 @@ xfs_trans_init(
 	struct xfs_mount	*mp)
 {
 	xfs_trans_resv_calc(mp, M_RES(mp));
+	xfs_trans_trace_reservations(mp);
 }
 
 /*


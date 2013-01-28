Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A534F7F4C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:25:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26CFBAC001
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 05:25:44 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id pXgWoXtO8Diik6UV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 05:25:42 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r0SDPeMY005184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:25:41 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r0SDPdr3022207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:25:40 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r0SDPdVk019299 for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:25:39 -0600
Message-ID: <51067C4F.8050701@oracle.com>
Date: Mon, 28 Jan 2013 21:25:35 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v4 01/13] xfs: add a helper to figure out the space log
	reservation per item
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
To: xfs@oss.sgi.com

Add a new helper xfs_calc_buf_res() to calcuate out the transaction space
reservations per item.  xfs_buf_log_overhead() is used to figure out the
extra space for struct xfs_buf_log_format that gets written into the log
for every buffer as well as a log opheader, i.e. struct xlog_op_header.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_trans.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 06ed520..6c601ea 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -37,14 +37,45 @@
 #include "xfs_extent_busy.h"
 #include "xfs_bmap.h"
 #include "xfs_quota.h"
+#include "xfs_qm.h"
 #include "xfs_trans_priv.h"
 #include "xfs_trans_space.h"
 #include "xfs_inode_item.h"
+#include "xfs_log_priv.h"
+#include "xfs_buf_item.h"
 #include "xfs_trace.h"
 
 kmem_zone_t	*xfs_trans_zone;
 kmem_zone_t	*xfs_log_item_desc_zone;
 
+/*
+ * A buffer has a format structure overhead in the log in addition
+ * to the data, so we need to take this into account when reserving
+ * space in a transaction for a buffer.  Round the space required up
+ * to a multiple of 128 bytes so that we don't change the historical
+ * reservation that has been used for this overhead.
+ */
+STATIC uint
+xfs_buf_log_overhead(void)
+{
+	return round_up(sizeof(struct xlog_op_header) +
+			sizeof(struct xfs_buf_log_format), 128);
+}
+
+/*
+ * Calculate out transaction log reservation per item in bytes.
+ *
+ * The nbufs argument is used to indicate the number of items that
+ * will be changed in a transaction.  size is used to tell how many
+ * bytes should be reserved per item.
+ */
+STATIC uint
+xfs_calc_buf_res(
+	uint		nbufs,
+	uint		size)
+{
+	return nbufs * (size + xfs_buf_log_overhead());
+}
 
 /*
  * Various log reservation values.
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

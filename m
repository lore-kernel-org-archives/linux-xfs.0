Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0F60D7F4C
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 23:31:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D77808F8035
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 21:31:30 -0800 (PST)
Message-ID: <51230E28.2020000@oracle.com>
Date: Tue, 19 Feb 2013 13:31:20 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3 1/3] xfsprogs: sync xfs_calc_buf_res() to user space
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
Cc: Mark Tinguely <tinguely@sgi.com>

Sync the new helper xfs_calc_buf_res() to user space.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 libxfs/xfs_trans.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/libxfs/xfs_trans.c b/libxfs/xfs_trans.c
index 635de8f..d7ff1a9 100644
--- a/libxfs/xfs_trans.c
+++ b/libxfs/xfs_trans.c
@@ -23,6 +23,35 @@ kmem_zone_t	*xfs_trans_zone;
 kmem_zone_t	*xfs_log_item_desc_zone;
 
 /*
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
+
+/*
  * Various log reservation values.
  *
  * These are based on the size of the file system block because that is what
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

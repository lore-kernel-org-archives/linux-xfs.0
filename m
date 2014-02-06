Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5686F7F54
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 00:17:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 068B2AC004
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 22:17:27 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6hYyQTpZpOHz0Zo1 for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 22:17:26 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WBIH4-0007IB-Ok
	for xfs@oss.sgi.com; Thu, 06 Feb 2014 17:17:22 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WBIH4-00081j-Nb
	for xfs@oss.sgi.com; Thu, 06 Feb 2014 17:17:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: ensure correct log item buffer alignment
Date: Thu,  6 Feb 2014 17:17:22 +1100
Message-Id: <1391667442-30822-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

On 32 bit platforms, the log item vector headers are not 64 bit
aligned or sized. hence if we don't take care to align them
correctly or pad the buffer appropriately for 8 byte alignment, we
can end up with alignment issues when accessing the user buffer
directly as a structure.

To solve this, simply pad the buffer headers to 64 bit offset so
that the data section is always 8 byte aligned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index cdebd83..4ef6fdb 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -205,16 +205,25 @@ xlog_cil_insert_format_items(
 		/*
 		 * We 64-bit align the length of each iovec so that the start
 		 * of the next one is naturally aligned.  We'll need to
-		 * account for that slack space here.
+		 * account for that slack space here. Then round nbytes up
+		 * to 64-bit alignment so that the initial buffer alignment is
+		 * easy to calculate and verify.
 		 */
 		nbytes += niovecs * sizeof(uint64_t);
+		nbytes = round_up(nbytes, sizeof(uint64_t));
 
 		/* grab the old item if it exists for reservation accounting */
 		old_lv = lip->li_lv;
 
-		/* calc buffer size */
-		buf_size = sizeof(struct xfs_log_vec) + nbytes +
-				niovecs * sizeof(struct xfs_log_iovec);
+		/*
+		 * The data buffer needs to start 64-bit aligned, so round up
+		 * that space to ensure we can align it appropriately and not
+		 * overrun the buffer.
+		 */
+		buf_size = nbytes +
+			   round_up((sizeof(struct xfs_log_vec) +
+				     niovecs * sizeof(struct xfs_log_iovec)),
+				    sizeof(uint64_t));
 
 		/* compare to existing item size */
 		if (lip->li_lv && buf_size <= lip->li_lv->lv_size) {
@@ -251,6 +260,8 @@ xlog_cil_insert_format_items(
 		/* The allocated data region lies beyond the iovec region */
 		lv->lv_buf_len = 0;
 		lv->lv_buf = (char *)lv + buf_size - nbytes;
+		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
+
 		lip->li_ops->iop_format(lip, lv);
 insert:
 		ASSERT(lv->lv_buf_len <= nbytes);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7N0FVtd102033 for <xfs@oss.sgi.com>; Sun, 22 Aug 2010 19:15:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3DF915225
	for <xfs@oss.sgi.com>; Sun, 22 Aug 2010 17:16:02 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	VX90npTFwt5E6NOP for <xfs@oss.sgi.com>;
	Sun, 22 Aug 2010 17:16:02 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	36068808-1927428
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 09:46:00 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OnKhj-0003Uv-0G
	for xfs@oss.sgi.com; Mon, 23 Aug 2010 10:15:59 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OnKha-00023z-Qv
	for xfs@oss.sgi.com; Mon, 23 Aug 2010 10:15:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: don't do memory allocation under the CIL context lock
Date: Mon, 23 Aug 2010 10:15:45 +1000
Message-Id: <1282522546-7892-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1282522546-7892-1-git-send-email-david@fromorbit.com>
References: <1282522546-7892-1-git-send-email-david@fromorbit.com>
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

Formatting items requires memory allocation when using delayed
logging. Currently that memory allocation is done while holding the
CIL context lock in read mode. This means that if memory allocation
takes some time (e.g. enters reclaim), we cannot push on the CIL
until the allocation(s) required by formatting complete. This can
stall CIL pushes for some time, and once a push is stalled so are
all new transaction commits.

Fix this splitting the item formatting into two steps. The first
step which does the allocation and memcpy() into the allocated
buffer is now done outside the CIL context lock, and only the CIL
insert is done inside the CIL context lock. This avoids the stall
issue.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 9768f24..ed575fb 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -270,15 +270,10 @@ xlog_cil_insert(
 static void
 xlog_cil_format_items(
 	struct log		*log,
-	struct xfs_log_vec	*log_vector,
-	struct xlog_ticket	*ticket,
-	xfs_lsn_t		*start_lsn)
+	struct xfs_log_vec	*log_vector)
 {
 	struct xfs_log_vec *lv;
 
-	if (start_lsn)
-		*start_lsn = log->l_cilp->xc_ctx->sequence;
-
 	ASSERT(log_vector);
 	for (lv = log_vector; lv; lv = lv->lv_next) {
 		void	*ptr;
@@ -302,9 +297,24 @@ xlog_cil_format_items(
 			ptr += vec->i_len;
 		}
 		ASSERT(ptr == lv->lv_buf + lv->lv_buf_len);
+	}
+}
 
+static void
+xlog_cil_insert_items(
+	struct log		*log,
+	struct xfs_log_vec	*log_vector,
+	struct xlog_ticket	*ticket,
+	xfs_lsn_t		*start_lsn)
+{
+	struct xfs_log_vec *lv;
+
+	if (start_lsn)
+		*start_lsn = log->l_cilp->xc_ctx->sequence;
+
+	ASSERT(log_vector);
+	for (lv = log_vector; lv; lv = lv->lv_next)
 		xlog_cil_insert(log, ticket, lv->lv_item, lv);
-	}
 }
 
 static void
@@ -612,9 +622,17 @@ xfs_log_commit_cil(
 		return XFS_ERROR(EIO);
 	}
 
+	/*
+	 * do all the hard work of formatting items (including memory
+	 * allocation) outside the CIL context lock. This prevents stalling CIL
+	 * pushes when we are low on memory and a transaction commit spends a
+	 * lot of time in memory reclaim.
+	 */
+	xlog_cil_format_items(log, log_vector);
+
 	/* lock out background commit */
 	down_read(&log->l_cilp->xc_ctx_lock);
-	xlog_cil_format_items(log, log_vector, tp->t_ticket, commit_lsn);
+	xlog_cil_insert_items(log, log_vector, tp->t_ticket, commit_lsn);
 
 	/* check we didn't blow the reservation */
 	if (tp->t_ticket->t_curr_res < 0)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

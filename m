Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9AEED7CAE
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 06:40:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 65D9A8F8040
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 04:40:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kjKQJbbB8BTXh08v (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2016 04:40:00 -0800 (PST)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/4] xfs: refactor in-core log state update to helper
Date: Thu,  3 Mar 2016 07:39:57 -0500
Message-Id: <1457008798-58734-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1457008798-58734-1-git-send-email-bfoster@redhat.com>
References: <1457008798-58734-1-git-send-email-bfoster@redhat.com>
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
Cc: Jan Beulich <JBeulich@suse.com>

Once the record at the head of the log is identified and verified, the
in-core log state is updated based on the record. This includes
information such as the current head block and cycle, the start block of
the last record written to the log, the tail lsn, etc.

Once torn write detection is conditional, this logic will need to be
reused. Factor the code to update the in-core log data structures into a
new helper function. This patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 52 ++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8a240d1..0ebc2b2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1275,6 +1275,37 @@ xlog_check_unmount_rec(
 	return 0;
 }
 
+static void
+xlog_set_state(
+	struct xlog		*log,
+	xfs_daddr_t		head_blk,
+	struct xlog_rec_header	*rhead,
+	xfs_daddr_t		rhead_blk,
+	bool			bump_cycle)
+{
+	/*
+	 * Reset log values according to the state of the log when we
+	 * crashed.  In the case where head_blk == 0, we bump curr_cycle
+	 * one because the next write starts a new cycle rather than
+	 * continuing the cycle of the last good log record.  At this
+	 * point we have guaranteed that all partial log records have been
+	 * accounted for.  Therefore, we know that the last good log record
+	 * written was complete and ended exactly on the end boundary
+	 * of the physical log.
+	 */
+	log->l_prev_block = rhead_blk;
+	log->l_curr_block = (int)head_blk;
+	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
+	if (bump_cycle)
+		log->l_curr_cycle++;
+	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
+	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
+	xlog_assign_grant_head(&log->l_reserve_head.grant, log->l_curr_cycle,
+					BBTOB(log->l_curr_block));
+	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
+					BBTOB(log->l_curr_block));
+}
+
 /*
  * Find the sync block number or the tail of the log.
  *
@@ -1355,26 +1386,9 @@ xlog_find_tail(
 		goto done;
 
 	/*
-	 * Reset log values according to the state of the log when we
-	 * crashed.  In the case where head_blk == 0, we bump curr_cycle
-	 * one because the next write starts a new cycle rather than
-	 * continuing the cycle of the last good log record.  At this
-	 * point we have guaranteed that all partial log records have been
-	 * accounted for.  Therefore, we know that the last good log record
-	 * written was complete and ended exactly on the end boundary
-	 * of the physical log.
+	 * Set the log state based on the current head record.
 	 */
-	log->l_prev_block = rhead_blk;
-	log->l_curr_block = (int)*head_blk;
-	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
-	if (wrapped)
-		log->l_curr_cycle++;
-	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
-	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
-	xlog_assign_grant_head(&log->l_reserve_head.grant, log->l_curr_cycle,
-					BBTOB(log->l_curr_block));
-	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
-					BBTOB(log->l_curr_block));
+	xlog_set_state(log, *head_blk, rhead, rhead_blk, wrapped);
 	tail_lsn = atomic64_read(&log->l_tail_lsn);
 
 	/*
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

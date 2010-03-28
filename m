Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2S9XwcD194558 for <xfs@oss.sgi.com>; Sun, 28 Mar 2010 04:34:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C7D428057B
	for <xfs@oss.sgi.com>; Sun, 28 Mar 2010 02:35:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AIK0T0QxLFkTW8Hz for
	<xfs@oss.sgi.com>; Sun, 28 Mar 2010 02:35:43 -0700 (PDT)
Date: Sun, 28 Mar 2010 05:35:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Always update the log tail on disk in sync
Message-ID: <20100328093541.GA11654@infradead.org>
References: <1269493671-11034-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
In-Reply-To: <1269493671-11034-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2300815951108516690=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2300815951108516690==
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Looks good.

 
Reviewed-by: Christoph Hellwig <hch@lst.de>

> +	switch (log->l_covered_state) {
> +	case XLOG_STATE_COVER_NEED:
> +	case XLOG_STATE_COVER_NEED2:
> +		if (!xfs_trans_ail_tail(log->l_ailp) &&
> +		    xlog_iclogs_empty(log)) {
> +			if (log->l_covered_state == XLOG_STATE_COVER_NEED)
> +				log->l_covered_state = XLOG_STATE_COVER_DONE;
> +			else {
> +				ASSERT(log->l_covered_state == XLOG_STATE_COVER_NEED2);

Moving this assert into the switch introduces an overly long line.
But it's rather pintless anyway, so we can just drop it.

Together with reordering the switch statement for slightly better
readability we might get something like the version below:


---

From: Dave Chinner <dchinner@redhat.com>

Updates to the VFS layer removed an extra ->sync_fs call into the
filesystem during the sync process (from the quota code).
Unfortunately the sync code was unknowingly relying on this call to
make sure metadata buffers were flushed via a xfs_buftarg_flush()
call to move the tail of the log forward in memory before the final
transactions of the sync process were issued.

As a result, the old code would write a very recent log tail value
to the log by the end of the sync process, and so a subsequent crash
would leave nothing for log recovery to do. Hence in qa test 182,
log recovery only replayed a small handle for inode fsync
transactions in this case.

However, with the removal of the extra ->sync_fs call, the log tail
was now not moved forward with the inode fsync transactions near the
end of the sync procese the first (and only) buftarg flush occurred
after these transactions went to disk. The result is that log
recovery now sees a large number of transactions for metadata that
is already on disk.

This usually isn't a problem, but when the transactions include
inode chunk allocation, the inode create transactions and all
subsequent changes are replayed as we cannt rely on what is on disk
is valid. As a result, if the inode was written and contains
unlogged changes, the unlogged changes are lost, thereby violating
sync semantics.

The fix is to always issue a transaction after the buftarg flush
occurs is the log iѕ not idle or covered. This results in a dummy
transaction being written that contains the up-to-date log tail
value, which will be very recent. Indeed, it will be at least as
recent as the old code would have left on disk, so log recovery
will behave exactly as it used to in this situation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c |   41 +++++++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 12 deletions(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-03-22 16:38:58.391255744 +0100
+++ xfs/fs/xfs/xfs_log.c	2010-03-28 11:30:16.381032270 +0200
@@ -745,9 +745,16 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 
 /*
  * Determine if we have a transaction that has gone to disk
- * that needs to be covered. Log activity needs to be idle (no AIL and
- * nothing in the iclogs). And, we need to be in the right state indicating
- * something has gone out.
+ * that needs to be covered. To begin the transition to the idle state
+ * firstly the log needs to be idle (no AIL and nothing in the iclogs).
+ * If we are then in a state where covering is needed, the caller is informed
+ * that dummy transactions are required to move the log into the idle state.
+ *
+ * Because this is called as part of the sync process, we should also indicate
+ * that dummy transactions should be issued in anything but the covered or
+ * idle states. This ensures that the log tail is accurately reflected in
+ * the log at the end of the sync, hence if a crash occurrs avoids replay
+ * of transactions where the metadata is already on disk.
  */
 int
 xfs_log_need_covered(xfs_mount_t *mp)
@@ -759,17 +766,24 @@ xfs_log_need_covered(xfs_mount_t *mp)
 		return 0;
 
 	spin_lock(&log->l_icloglock);
-	if (((log->l_covered_state == XLOG_STATE_COVER_NEED) ||
-		(log->l_covered_state == XLOG_STATE_COVER_NEED2))
-			&& !xfs_trans_ail_tail(log->l_ailp)
-			&& xlog_iclogs_empty(log)) {
-		if (log->l_covered_state == XLOG_STATE_COVER_NEED)
-			log->l_covered_state = XLOG_STATE_COVER_DONE;
-		else {
-			ASSERT(log->l_covered_state == XLOG_STATE_COVER_NEED2);
-			log->l_covered_state = XLOG_STATE_COVER_DONE2;
+	switch (log->l_covered_state) {
+	case XLOG_STATE_COVER_DONE:
+	case XLOG_STATE_COVER_DONE2:
+	case XLOG_STATE_COVER_IDLE:
+		break;
+	case XLOG_STATE_COVER_NEED:
+	case XLOG_STATE_COVER_NEED2:
+		if (!xfs_trans_ail_tail(log->l_ailp) &&
+		    xlog_iclogs_empty(log)) {
+			if (log->l_covered_state == XLOG_STATE_COVER_NEED)
+				log->l_covered_state = XLOG_STATE_COVER_DONE;
+			else
+				log->l_covered_state = XLOG_STATE_COVER_DONE2;
 		}
+		/*FALLTHRU*/
+	default:
 		needed = 1;
+		break;
 	}
 	spin_unlock(&log->l_icloglock);
 	return needed;


--===============2300815951108516690==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2300815951108516690==--

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D0D87CB7
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 12:11:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E31A8AC003
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9u2TsQTKX1wq5l0f (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:11:10 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id B2568821C7
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 17:11:09 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-69.bos.redhat.com [10.18.41.69])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7BHB9Qr008727
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 13:11:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/5] xfs: rework log recovery to submit buffers on LSN
	boundaries
Date: Thu, 11 Aug 2016 13:11:03 -0400
Message-Id: <1470935467-52772-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
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

The fix to log recovery to update the metadata LSN in recovered buffers
introduces the requirement that a buffer is submitted only once per
current LSN. Log recovery currently submits buffers on transaction
boundaries. This is not sufficient as the abstraction between log
records and transactions allows for various scenarios where multiple
transactions can share the same current LSN. If independent transactions
share an LSN and both modify the same buffer, log recovery can
incorrectly skip updates and leave the filesystem in an inconsisent
state.

In preparation for proper metadata LSN updates during log recovery,
update log recovery to submit buffers for write on LSN change boundaries
rather than transaction boundaries. Explicitly track the current LSN in
a new struct xlog field to handle the various corner cases of when the
current LSN may or may not change.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_priv.h    |  3 +-
 fs/xfs/xfs_log_recover.c | 82 +++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 66 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 765f084..2b6eec5 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -413,7 +413,8 @@ struct xlog {
 	/* log record crc error injection factor */
 	uint32_t		l_badcrc_factor;
 #endif
-
+	/* log recovery lsn tracking (for buffer submission */
+	xfs_lsn_t		l_recovery_lsn;
 };
 
 #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e8638fd..97a0af9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3846,14 +3846,13 @@ STATIC int
 xlog_recover_commit_trans(
 	struct xlog		*log,
 	struct xlog_recover	*trans,
-	int			pass)
+	int			pass,
+	struct list_head	*buffer_list)
 {
 	int				error = 0;
-	int				error2;
 	int				items_queued = 0;
 	struct xlog_recover_item	*item;
 	struct xlog_recover_item	*next;
-	LIST_HEAD			(buffer_list);
 	LIST_HEAD			(ra_list);
 	LIST_HEAD			(done_list);
 
@@ -3876,7 +3875,7 @@ xlog_recover_commit_trans(
 			items_queued++;
 			if (items_queued >= XLOG_RECOVER_COMMIT_QUEUE_MAX) {
 				error = xlog_recover_items_pass2(log, trans,
-						&buffer_list, &ra_list);
+						buffer_list, &ra_list);
 				list_splice_tail_init(&ra_list, &done_list);
 				items_queued = 0;
 			}
@@ -3894,15 +3893,14 @@ out:
 	if (!list_empty(&ra_list)) {
 		if (!error)
 			error = xlog_recover_items_pass2(log, trans,
-					&buffer_list, &ra_list);
+					buffer_list, &ra_list);
 		list_splice_tail_init(&ra_list, &done_list);
 	}
 
 	if (!list_empty(&done_list))
 		list_splice_init(&done_list, &trans->r_itemq);
 
-	error2 = xfs_buf_delwri_submit(&buffer_list);
-	return error ? error : error2;
+	return error;
 }
 
 STATIC void
@@ -4085,7 +4083,8 @@ xlog_recovery_process_trans(
 	char			*dp,
 	unsigned int		len,
 	unsigned int		flags,
-	int			pass)
+	int			pass,
+	struct list_head	*buffer_list)
 {
 	int			error = 0;
 	bool			freeit = false;
@@ -4109,7 +4108,8 @@ xlog_recovery_process_trans(
 		error = xlog_recover_add_to_cont_trans(log, trans, dp, len);
 		break;
 	case XLOG_COMMIT_TRANS:
-		error = xlog_recover_commit_trans(log, trans, pass);
+		error = xlog_recover_commit_trans(log, trans, pass,
+						  buffer_list);
 		/* success or fail, we are now done with this transaction. */
 		freeit = true;
 		break;
@@ -4191,10 +4191,12 @@ xlog_recover_process_ophdr(
 	struct xlog_op_header	*ohead,
 	char			*dp,
 	char			*end,
-	int			pass)
+	int			pass,
+	struct list_head	*buffer_list)
 {
 	struct xlog_recover	*trans;
 	unsigned int		len;
+	int			error;
 
 	/* Do we understand who wrote this op? */
 	if (ohead->oh_clientid != XFS_TRANSACTION &&
@@ -4221,8 +4223,39 @@ xlog_recover_process_ophdr(
 		return 0;
 	}
 
+	/*
+	 * Recovered buffers are submitted for I/O on current LSN change
+	 * boundaries. This is necessary to accommodate metadata LSN ordering
+	 * rules of v5 superblock filesystems.
+	 *
+	 * Store the new current LSN in l_recovery_lsn as we cannot rely on
+	 * either record boundaries or transaction boundaries alone to track LSN
+	 * changes. This has several contributing factors:
+	 *
+	 * - Metadata LSNs are updated at buffer submission time. Thus, buffers
+	 *   can only be submitted safely once per current LSN value.
+	 * - The current LSN is defined as the start cycle/block of the first
+	 *   record in which a transaction appears.
+	 * - A record can hold multiple transactions. Thus, a transaction change
+	 *   does not guarantee a change in current LSN.
+	 * - A transaction can span multiple records. Thus, a record change does
+	 *   not guarantee a change in current LSN. Consider the case where a
+	 *   record holds one small transaction and a subsequent that carries
+	 *   over to the next record. Both transactions share the same LSN as
+	 *   per the definition of the current LSN.
+	 *
+	 * In summary, this means we must track the current LSN independently
+	 * and submit buffers for the previous LSN only when it has changed.
+	 */
+	if (log->l_recovery_lsn != trans->r_lsn) {
+		error = xfs_buf_delwri_submit(buffer_list);
+		if (error)
+			return error;
+		log->l_recovery_lsn = trans->r_lsn;
+	}
+
 	return xlog_recovery_process_trans(log, trans, dp, len,
-					   ohead->oh_flags, pass);
+					   ohead->oh_flags, pass, buffer_list);
 }
 
 /*
@@ -4240,7 +4273,8 @@ xlog_recover_process_data(
 	struct hlist_head	rhash[],
 	struct xlog_rec_header	*rhead,
 	char			*dp,
-	int			pass)
+	int			pass,
+	struct list_head	*buffer_list)
 {
 	struct xlog_op_header	*ohead;
 	char			*end;
@@ -4262,7 +4296,7 @@ xlog_recover_process_data(
 
 		/* errors will abort recovery */
 		error = xlog_recover_process_ophdr(log, rhash, rhead, ohead,
-						    dp, end, pass);
+						   dp, end, pass, buffer_list);
 		if (error)
 			return error;
 
@@ -4685,7 +4719,8 @@ xlog_recover_process(
 	struct hlist_head	rhash[],
 	struct xlog_rec_header	*rhead,
 	char			*dp,
-	int			pass)
+	int			pass,
+	struct list_head	*buffer_list)
 {
 	int			error;
 	__le32			crc;
@@ -4732,7 +4767,8 @@ xlog_recover_process(
 	if (error)
 		return error;
 
-	return xlog_recover_process_data(log, rhash, rhead, dp, pass);
+	return xlog_recover_process_data(log, rhash, rhead, dp, pass,
+					 buffer_list);
 }
 
 STATIC int
@@ -4793,9 +4829,11 @@ xlog_do_recovery_pass(
 	char			*offset;
 	xfs_buf_t		*hbp, *dbp;
 	int			error = 0, h_size, h_len;
+	int			error2 = 0;
 	int			bblks, split_bblks;
 	int			hblks, split_hblks, wrapped_hblks;
 	struct hlist_head	rhash[XLOG_RHASH_SIZE];
+	LIST_HEAD		(buffer_list);
 
 	ASSERT(head_blk != tail_blk);
 	rhead_blk = 0;
@@ -4981,7 +5019,7 @@ xlog_do_recovery_pass(
 			}
 
 			error = xlog_recover_process(log, rhash, rhead, offset,
-						     pass);
+						     pass, &buffer_list);
 			if (error)
 				goto bread_err2;
 
@@ -5012,7 +5050,8 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err2;
 
-		error = xlog_recover_process(log, rhash, rhead, offset, pass);
+		error = xlog_recover_process(log, rhash, rhead, offset, pass,
+					     &buffer_list);
 		if (error)
 			goto bread_err2;
 
@@ -5025,10 +5064,17 @@ xlog_do_recovery_pass(
  bread_err1:
 	xlog_put_bp(hbp);
 
+	/*
+	 * Submit buffers that have been added from the last record processed,
+	 * regardless of error status.
+	 */
+	if (!list_empty(&buffer_list))
+		error2 = xfs_buf_delwri_submit(&buffer_list);
+
 	if (error && first_bad)
 		*first_bad = rhead_blk;
 
-	return error;
+	return error ? error : error2;
 }
 
 /*
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

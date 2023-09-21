Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8688DCD493D
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 01:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjIUBtD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 21:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjIUBtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 21:49:00 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E24DE
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:52 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-690bd59322dso312124b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695260932; x=1695865732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jr7o+h+1YcqphLBZmqt8RANttT0ZCL8tLIuzKTp6/OI=;
        b=AjOVSNuPKb/S7M4tZQa7/xX6nr5OkzmpzAHazz5aAXAcPvb9maaTTH2+hnhpigTzc5
         0snIbl4WnGwiQZGVJuAekZo6g18DQKF3T8TH1udEFKgU8K/+pdzX9dziA+1w4H3E0Sz4
         CWkFDECJRYkkulbigVjk91eHQ7RyzBBydCLCy1+03XfH3hORGnPc6INcIrLcyoardTQF
         olejrUBE759TUCeCLHkYfstuQqRdQD0NyCb5DM0nWxQEJOKXCcjYDw4wDq0ZwXEFccFK
         6mPNuHa3QpDR0Kw4diPh+cRsR4LuIu3sgoVerF2+dX9fpmjWEksukgdQoe6P5ShoyTbF
         Rh0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695260932; x=1695865732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jr7o+h+1YcqphLBZmqt8RANttT0ZCL8tLIuzKTp6/OI=;
        b=neM8yHAT3MCks0dByd9yqGzpAZEN++M00/TSJnM3GiatnTZD5kdqZX9y1nmhVvhp4X
         HRS41vtjiN71RWFiuja7Z15WMu4aU5/AwEfUkVjIE5smYtXAJIqyz5J0dcxZvcW/C5HX
         pJEtEvlnr+ckzyq02Ffh7rhmamQrbuOoTdUxotUS3lkGIIRmo3b3moUpfxKGybFIZ8wk
         KF1jRSAuBzstGH7HTrEBmCHJxGKCIiVZYzQMRYJ8FQewBLOIlK2tcWEw8nOcRQXBAFbY
         reSb90K7F83r42xiOhdTWj+jEd/IDDuHMgl3SyRIu2mBKBJiC+FdVV/6BGHb8DvbZ3/T
         n2iA==
X-Gm-Message-State: AOJu0YzDY0pU5zkhpj4/gFnAlWGyFbwKhJN5grKLpoO0jm7w7FLpAIkD
        +tgJzKLwByr8KKfBkVirJowgwB8SRF71pVjTuNA=
X-Google-Smtp-Source: AGHT+IEwOoj8bKtVt5Hd+VrSQQ5b3nXkBDfHWtK37ePIEOff1/IWOSQubcQJM212BaFvEUKDtYmr2A==
X-Received: by 2002:a05:6a20:5608:b0:154:e7e6:85bd with SMTP id ir8-20020a056a20560800b00154e7e685bdmr3843873pzc.20.1695260932290;
        Wed, 20 Sep 2023 18:48:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id b8-20020a170902d50800b001b891259eddsm148104plg.197.2023.09.20.18.48.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 18:48:51 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qj8oB-003T23-1q
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:47 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qj8oB-00000002VOS-1GE6
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: pass the full grant head to accounting functions
Date:   Thu, 21 Sep 2023 11:48:43 +1000
Message-Id: <20230921014844.582667-9-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921014844.582667-1-david@fromorbit.com>
References: <20230921014844.582667-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because we are going to need them soon. API change only, no logic
changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 157 +++++++++++++++++++++---------------------
 fs/xfs/xfs_log_priv.h |   2 -
 2 files changed, 77 insertions(+), 82 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 83a5eb992574..ed1e1f1dc8e4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -136,10 +136,10 @@ xlog_prepare_iovec(
 static void
 xlog_grant_sub_space(
 	struct xlog		*log,
-	atomic64_t		*head,
+	struct xlog_grant_head	*head,
 	int			bytes)
 {
-	int64_t	head_val = atomic64_read(head);
+	int64_t	head_val = atomic64_read(&head->grant);
 	int64_t new, old;
 
 	do {
@@ -155,17 +155,17 @@ xlog_grant_sub_space(
 
 		old = head_val;
 		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(head, old, new);
+		head_val = atomic64_cmpxchg(&head->grant, old, new);
 	} while (head_val != old);
 }
 
 static void
 xlog_grant_add_space(
 	struct xlog		*log,
-	atomic64_t		*head,
+	struct xlog_grant_head	*head,
 	int			bytes)
 {
-	int64_t	head_val = atomic64_read(head);
+	int64_t	head_val = atomic64_read(&head->grant);
 	int64_t new, old;
 
 	do {
@@ -184,7 +184,7 @@ xlog_grant_add_space(
 
 		old = head_val;
 		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(head, old, new);
+		head_val = atomic64_cmpxchg(&head->grant, old, new);
 	} while (head_val != old);
 }
 
@@ -197,6 +197,63 @@ xlog_grant_head_init(
 	spin_lock_init(&head->lock);
 }
 
+/*
+ * Return the space in the log between the tail and the head.  The head
+ * is passed in the cycle/bytes formal parms.  In the special case where
+ * the reserve head has wrapped passed the tail, this calculation is no
+ * longer valid.  In this case, just return 0 which means there is no space
+ * in the log.  This works for all places where this function is called
+ * with the reserve head.  Of course, if the write head were to ever
+ * wrap the tail, we should blow up.  Rather than catch this case here,
+ * we depend on other ASSERTions in other parts of the code.   XXXmiken
+ *
+ * If reservation head is behind the tail, we have a problem. Warn about it,
+ * but then treat it as if the log is empty.
+ *
+ * If the log is shut down, the head and tail may be invalid or out of whack, so
+ * shortcut invalidity asserts in this case so that we don't trigger them
+ * falsely.
+ */
+static int
+xlog_grant_space_left(
+	struct xlog		*log,
+	struct xlog_grant_head	*head)
+{
+	int			tail_bytes;
+	int			tail_cycle;
+	int			head_cycle;
+	int			head_bytes;
+
+	xlog_crack_grant_head(&head->grant, &head_cycle, &head_bytes);
+	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
+	tail_bytes = BBTOB(tail_bytes);
+	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
+		return log->l_logsize - (head_bytes - tail_bytes);
+	if (tail_cycle + 1 < head_cycle)
+		return 0;
+
+	/* Ignore potential inconsistency when shutdown. */
+	if (xlog_is_shutdown(log))
+		return log->l_logsize;
+
+	if (tail_cycle < head_cycle) {
+		ASSERT(tail_cycle == (head_cycle - 1));
+		return tail_bytes - head_bytes;
+	}
+
+	/*
+	 * The reservation head is behind the tail. In this case we just want to
+	 * return the size of the log as the amount of space left.
+	 */
+	xfs_alert(log->l_mp, "xlog_grant_space_left: head behind tail");
+	xfs_alert(log->l_mp, "  tail_cycle = %d, tail_bytes = %d",
+		  tail_cycle, tail_bytes);
+	xfs_alert(log->l_mp, "  GH   cycle = %d, GH   bytes = %d",
+		  head_cycle, head_bytes);
+	ASSERT(0);
+	return log->l_logsize;
+}
+
 STATIC void
 xlog_grant_head_wake_all(
 	struct xlog_grant_head	*head)
@@ -277,7 +334,7 @@ xlog_grant_head_wait(
 		spin_lock(&head->lock);
 		if (xlog_is_shutdown(log))
 			goto shutdown;
-	} while (xlog_space_left(log, &head->grant) < need_bytes);
+	} while (xlog_grant_space_left(log, head) < need_bytes);
 
 	list_del_init(&tic->t_queue);
 	return 0;
@@ -322,7 +379,7 @@ xlog_grant_head_check(
 	 * otherwise try to get some space for this transaction.
 	 */
 	*need_bytes = xlog_ticket_reservation(log, head, tic);
-	free_bytes = xlog_space_left(log, &head->grant);
+	free_bytes = xlog_grant_space_left(log, head);
 	if (!list_empty_careful(&head->waiters)) {
 		spin_lock(&head->lock);
 		if (!xlog_grant_head_wake(log, head, &free_bytes) ||
@@ -396,7 +453,7 @@ xfs_log_regrant(
 	if (error)
 		goto out_error;
 
-	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
+	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
 	trace_xfs_log_regrant_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
@@ -447,8 +504,8 @@ xfs_log_reserve(
 	if (error)
 		goto out_error;
 
-	xlog_grant_add_space(log, &log->l_reserve_head.grant, need_bytes);
-	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
+	xlog_grant_add_space(log, &log->l_reserve_head, need_bytes);
+	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
 	trace_xfs_log_reserve_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
@@ -1107,7 +1164,7 @@ xfs_log_space_wake(
 		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_write_head.lock);
-		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
+		free_bytes = xlog_grant_space_left(log, &log->l_write_head);
 		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes);
 		spin_unlock(&log->l_write_head.lock);
 	}
@@ -1116,7 +1173,7 @@ xfs_log_space_wake(
 		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_reserve_head.lock);
-		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
+		free_bytes = xlog_grant_space_left(log, &log->l_reserve_head);
 		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes);
 		spin_unlock(&log->l_reserve_head.lock);
 	}
@@ -1230,64 +1287,6 @@ xfs_log_cover(
 	return error;
 }
 
-/*
- * Return the space in the log between the tail and the head.  The head
- * is passed in the cycle/bytes formal parms.  In the special case where
- * the reserve head has wrapped passed the tail, this calculation is no
- * longer valid.  In this case, just return 0 which means there is no space
- * in the log.  This works for all places where this function is called
- * with the reserve head.  Of course, if the write head were to ever
- * wrap the tail, we should blow up.  Rather than catch this case here,
- * we depend on other ASSERTions in other parts of the code.   XXXmiken
- *
- * If reservation head is behind the tail, we have a problem. Warn about it,
- * but then treat it as if the log is empty.
- *
- * If the log is shut down, the head and tail may be invalid or out of whack, so
- * shortcut invalidity asserts in this case so that we don't trigger them
- * falsely.
- */
-int
-xlog_space_left(
-	struct xlog	*log,
-	atomic64_t	*head)
-{
-	int		tail_bytes;
-	int		tail_cycle;
-	int		head_cycle;
-	int		head_bytes;
-
-	xlog_crack_grant_head(head, &head_cycle, &head_bytes);
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
-	tail_bytes = BBTOB(tail_bytes);
-	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
-		return log->l_logsize - (head_bytes - tail_bytes);
-	if (tail_cycle + 1 < head_cycle)
-		return 0;
-
-	/* Ignore potential inconsistency when shutdown. */
-	if (xlog_is_shutdown(log))
-		return log->l_logsize;
-
-	if (tail_cycle < head_cycle) {
-		ASSERT(tail_cycle == (head_cycle - 1));
-		return tail_bytes - head_bytes;
-	}
-
-	/*
-	 * The reservation head is behind the tail. In this case we just want to
-	 * return the size of the log as the amount of space left.
-	 */
-	xfs_alert(log->l_mp, "xlog_space_left: head behind tail");
-	xfs_alert(log->l_mp, "  tail_cycle = %d, tail_bytes = %d",
-		  tail_cycle, tail_bytes);
-	xfs_alert(log->l_mp, "  GH   cycle = %d, GH   bytes = %d",
-		  head_cycle, head_bytes);
-	ASSERT(0);
-	return log->l_logsize;
-}
-
-
 static void
 xlog_ioend_work(
 	struct work_struct	*work)
@@ -1884,8 +1883,8 @@ xlog_sync(
 	if (ticket) {
 		ticket->t_curr_res -= roundoff;
 	} else {
-		xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
-		xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
+		xlog_grant_add_space(log, &log->l_reserve_head, roundoff);
+		xlog_grant_add_space(log, &log->l_write_head, roundoff);
 	}
 
 	/* put cycle number in every block */
@@ -2805,17 +2804,15 @@ xfs_log_ticket_regrant(
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	xlog_grant_sub_space(log, &log->l_reserve_head.grant,
-					ticket->t_curr_res);
-	xlog_grant_sub_space(log, &log->l_write_head.grant,
-					ticket->t_curr_res);
+	xlog_grant_sub_space(log, &log->l_reserve_head, ticket->t_curr_res);
+	xlog_grant_sub_space(log, &log->l_write_head, ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
 
 	trace_xfs_log_ticket_regrant_sub(log, ticket);
 
 	/* just return if we still have some of the pre-reserved space */
 	if (!ticket->t_cnt) {
-		xlog_grant_add_space(log, &log->l_reserve_head.grant,
+		xlog_grant_add_space(log, &log->l_reserve_head,
 				     ticket->t_unit_res);
 		trace_xfs_log_ticket_regrant_exit(log, ticket);
 
@@ -2863,8 +2860,8 @@ xfs_log_ticket_ungrant(
 		bytes += ticket->t_unit_res*ticket->t_cnt;
 	}
 
-	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
-	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
+	xlog_grant_sub_space(log, &log->l_reserve_head, bytes);
+	xlog_grant_sub_space(log, &log->l_write_head, bytes);
 
 	trace_xfs_log_ticket_ungrant_exit(log, ticket);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 1390251bf670..24dc788c02d3 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -574,8 +574,6 @@ xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
 	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
 }
 
-int xlog_space_left(struct xlog *log, atomic64_t *head);
-
 /*
  * Committed Item List interfaces
  */
-- 
2.40.1


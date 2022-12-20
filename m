Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435FEC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 23:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiLTXXV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 18:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiLTXXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 18:23:17 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4692AF7C
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:16 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d3so13797941plr.10
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c++6OYFdV2U0lktZ7Ykrx8pQFe/3/DEC8n1YNN7iJTA=;
        b=g+lAo3VNc5IJzy5Cm59UX57NmMFWvbrPjHH/5yUCjJWRl5Zb3txlYMKu+0GJ5FdFUd
         riE0c1PELYqR4/h/xNdWBdXbtQVrIGPbUlUqYjBAPzn1D0i9Sr8WgG5CIfEgqiUfmbSY
         AZdDTaGWaBuX18+ZhzAk6tMOFiaow2sXWZ46W4SmqmoUYKeqyyXfwFJoNBVvu3X8Pyvb
         UGWCDubbBSERaGeMODVz3MQbu3G+/k5LPR7abrX+DpmILefGxTYz0yvb9iyFK/XZekbM
         ocvtE5p7ASGZ9UO2tUkBBplkTcbkPDfQtqYRxQSNVvjIguom2sa7zt8O53M7tMGgSw75
         jvjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c++6OYFdV2U0lktZ7Ykrx8pQFe/3/DEC8n1YNN7iJTA=;
        b=w+FsnZT2wSLA6VEcsFR67kf/qSnSn1zRDHuL6OSA8+asJvd4Ou8mZJnoCekB2KlcwJ
         GOMYk1F9rKXGm6Vj59Iw1eLFPChZdiPfZcYkBVgsZlR00SJVEWKyg5zkf4peSFRwfV+p
         k354MyMpucTfn54j7Znq0pPfI2PrzgN0ZXbpQrIBOjkXpvpGcIdJ/j2jsk50fpsxd72n
         qBqwIJhXAdv1+Xgb5/IFY+j8nMV7fTqbnqtrtwrEDawFlJX/jgjpRFV1ezUJpBHGNcbF
         gRakbdaZLOpF+q0yBRhdieW9Rour2KnP73qPsAOpToGnyi1cISfzJYiWaCToBsEoVg5j
         Aidw==
X-Gm-Message-State: ANoB5pnO/ecYPyW6GaIeAo2hJ9I3tV2tyh4JDQyTnyxcIQGY5mhX64yB
        lCl4g8IuGDPuQGBWnFoRtxYDaMDCuRnk2l7M
X-Google-Smtp-Source: AA0mqf7UzECjoBtQd9zzxs280fQLXwrdHRB20k2fEtt9+yrE/2rTXP2bNKXetsb8+0D5/G0gfwOkDQ==
X-Received: by 2002:a17:90b:e98:b0:219:a6ab:b95a with SMTP id fv24-20020a17090b0e9800b00219a6abb95amr49383296pjb.22.1671578595659;
        Tue, 20 Dec 2022 15:23:15 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id om15-20020a17090b3a8f00b00218fba260e2sm58597pjb.43.2022.12.20.15.23.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 15:23:14 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1p7lx1-00Asnh-Ar
        for linux-xfs@vger.kernel.org; Wed, 21 Dec 2022 10:23:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1p7lx1-00Ec6O-11
        for linux-xfs@vger.kernel.org;
        Wed, 21 Dec 2022 10:23:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: pass the full grant head to accounting functions
Date:   Wed, 21 Dec 2022 10:23:07 +1100
Message-Id: <20221220232308.3482960-9-david@fromorbit.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221220232308.3482960-1-david@fromorbit.com>
References: <20221220232308.3482960-1-david@fromorbit.com>
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
index 25168b38fa25..677636653d39 100644
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
@@ -1141,7 +1198,7 @@ xfs_log_space_wake(
 		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_write_head.lock);
-		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
+		free_bytes = xlog_grant_space_left(log, &log->l_write_head);
 		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes);
 		spin_unlock(&log->l_write_head.lock);
 	}
@@ -1150,7 +1207,7 @@ xfs_log_space_wake(
 		ASSERT(!xlog_in_recovery(log));
 
 		spin_lock(&log->l_reserve_head.lock);
-		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
+		free_bytes = xlog_grant_space_left(log, &log->l_reserve_head);
 		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes);
 		spin_unlock(&log->l_reserve_head.lock);
 	}
@@ -1264,64 +1321,6 @@ xfs_log_cover(
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
@@ -1918,8 +1917,8 @@ xlog_sync(
 	if (ticket) {
 		ticket->t_curr_res -= roundoff;
 	} else {
-		xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
-		xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
+		xlog_grant_add_space(log, &log->l_reserve_head, roundoff);
+		xlog_grant_add_space(log, &log->l_write_head, roundoff);
 	}
 
 	/* put cycle number in every block */
@@ -2839,17 +2838,15 @@ xfs_log_ticket_regrant(
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
 
@@ -2897,8 +2894,8 @@ xfs_log_ticket_ungrant(
 		bytes += ticket->t_unit_res*ticket->t_cnt;
 	}
 
-	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
-	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
+	xlog_grant_sub_space(log, &log->l_reserve_head, bytes);
+	xlog_grant_sub_space(log, &log->l_write_head, bytes);
 
 	trace_xfs_log_ticket_ungrant_exit(log, ticket);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 9c173c48cbcd..86b5959b5ef2 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -571,8 +571,6 @@ xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
 	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
 }
 
-int xlog_space_left(struct xlog *log, atomic64_t *head);
-
 /*
  * Committed Item List interfaces
  */
-- 
2.38.1


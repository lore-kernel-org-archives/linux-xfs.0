Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C943AC4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 23:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbiLTXXT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 18:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiLTXXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 18:23:17 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91452BBF
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:15 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s7so13826910plk.5
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+sknzRXc6uxNYMDlGCEierIiGCTaTEw+b3RJv+ySZo=;
        b=JOeAMCI9+F9WRF85d30onamjlzvX8XQhFbX7tkZeO684BS8AnNMS/bFxvNDZUhpOU/
         V4uJ0/iM6EElpB0Wc6aEMOp7tqjr6UiBMvl4jRuJC4vWPf8viXKCSto5s+SFA0l/RD17
         7TkSZ/zFs04AAkxXFfb5uCFtKnZR1ZFxU4E7Mxn8wMjE38LztHLv64fcgFQUQsXU3uCL
         IisfgMbOa+N9cs3gg5v++rAX8svUiY4FLHUrbFNuEjcRD2aLRDM5yC4rJK9oNY+LGP7s
         y3uXGVihrtFADwkZs2izoKfl+1q5DqEhyV+td3BOvLugKousgQVPcV01cB+Ghp5vcMOp
         0dpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+sknzRXc6uxNYMDlGCEierIiGCTaTEw+b3RJv+ySZo=;
        b=XYH/Y3OaOMsMA2DJjdpYQbrbLNKhxpgoXrDkzAm+PStdBg3PzcG9d5JGk7w88zq2i4
         28WY1HltSlag9Bf+SHOr+yQKHryKnHPLPXmj5z/1GPcVQHZhDc6aPkOel3i3XpfgUnry
         wk+R+LgA+ZiVlGrO+KX6J+NgwOjjVdBtFYfvnYo+HPLaUPZt6Uo4OewD9egglo3AjsNu
         B/nbJq6rpCzpS7VZ32dP1VedRt6T4CClZiq6Gom5VpDGc7Fm6pZXG3ScDplOUAYAfomd
         DBZ4x65vjURLtHsRVDM8DJzj3BGZp1nx7AGYCYFiPh2QwxJTFAvmAx95noIe56R7K3gp
         wiKw==
X-Gm-Message-State: AFqh2kp9W17s5XKfcz0n7rhr9oo3RWjSjUmJfSM5sp2Tnt6b974LDmMr
        DRuMTI2DfJ5sa7z4xFSD8Vz0wJEg6skIR7IB
X-Google-Smtp-Source: AMrXdXvDEvUeSHD2kQMVcRFE195tyxpQJmnM/644GX6zOjbGkaAAE1Mhq2jJXkw8g3ko3NqDk5qmMQ==
X-Received: by 2002:a17:902:ba89:b0:189:c62e:ac34 with SMTP id k9-20020a170902ba8900b00189c62eac34mr15094559pls.47.1671578595097;
        Tue, 20 Dec 2022 15:23:15 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id n7-20020a170902e54700b0017f74cab9eesm9868998plf.128.2022.12.20.15.23.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 15:23:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1p7lx1-00AsnV-6t
        for linux-xfs@vger.kernel.org; Wed, 21 Dec 2022 10:23:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1p7lx1-00Ec62-0c
        for linux-xfs@vger.kernel.org;
        Wed, 21 Dec 2022 10:23:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: ensure log tail is always up to date
Date:   Wed, 21 Dec 2022 10:23:03 +1100
Message-Id: <20221220232308.3482960-5-david@fromorbit.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221220232308.3482960-1-david@fromorbit.com>
References: <20221220232308.3482960-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Whenever we write an iclog, we call xlog_assign_tail_lsn() to update
the current tail before we write it into the iclog header. This
means we have to take the AIL lock on every iclog write just to
check if the tail of the log has moved.

This doesn't avoid races with log tail updates - the log tail could
move immediately after we assign the tail to the iclog header and
hence by the time the iclog reaches stable storage the tail LSN has
moved forward in memory. Hence the log tail LSN in the iclog header
is really just a point in time snapshot of the current state of the
AIL.

With this in mind, if we simply update the in memory log->l_tail_lsn
every time it changes in the AIL, there is no need to update the in
memory value when we are writing it into an iclog - it will already
be up-to-date in memory and checking the AIL again will not change
this. Hence xlog_state_release_iclog() does not need to check the
AIL to update the tail lsn and can just sample it directly without
needing to take the AIL lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c       |  5 ++---
 fs/xfs/xfs_trans_ail.c | 17 +++++++++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7de23639a2a2..473f585aa930 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -530,7 +530,6 @@ xlog_state_release_iclog(
 	struct xlog_in_core	*iclog,
 	struct xlog_ticket	*ticket)
 {
-	xfs_lsn_t		tail_lsn;
 	bool			last_ref;
 
 	lockdep_assert_held(&log->l_icloglock);
@@ -545,8 +544,8 @@ xlog_state_release_iclog(
 	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
 	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
 	    !iclog->ic_header.h_tail_lsn) {
-		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
-		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
+		iclog->ic_header.h_tail_lsn =
+				cpu_to_be64(atomic64_read(&log->l_tail_lsn));
 	}
 
 	last_ref = atomic_dec_and_test(&iclog->ic_refcnt);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 7354b5379014..0274e478d8a0 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -715,6 +715,13 @@ xfs_ail_push_all_sync(
 	finish_wait(&ailp->ail_empty, &wait);
 }
 
+/*
+ * Callers should pass the the original tail lsn so that we can detect if the
+ * tail has moved as a result of the operation that was performed. If the caller
+ * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
+ * "did the tail LSN change?" checks. If the caller wants to avoid a tail update
+ * (e.g. it knows the tail did not change) it should pass an @old_lsn of 0.
+ */
 void
 xfs_ail_update_finish(
 	struct xfs_ail		*ailp,
@@ -799,10 +806,16 @@ xfs_trans_ail_update_bulk(
 
 	/*
 	 * If this is the first insert, wake up the push daemon so it can
-	 * actively scan for items to push.
+	 * actively scan for items to push. We also need to do a log tail
+	 * LSN update to ensure that it is correctly tracked by the log, so
+	 * set the tail_lsn to NULLCOMMITLSN so that xfs_ail_update_finish()
+	 * will see that the tail lsn has changed and will update the tail
+	 * appropriately.
 	 */
-	if (!mlip)
+	if (!mlip) {
 		wake_up_process(ailp->ail_task);
+		tail_lsn = NULLCOMMITLSN;
+	}
 
 	xfs_ail_update_finish(ailp, tail_lsn);
 }
-- 
2.38.1


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20886C3DA6E
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 23:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLTXXS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 18:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiLTXXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 18:23:16 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133B7D2
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:15 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so366179pjp.1
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XH0Af/kN7ZInRidEVnPhB06qxYUPQCuixBX8Udkd4Qw=;
        b=39/EIQKiyO2QKpalRlskpMgvoELraX4GNd917QDE6RU80DNWpgEai984dFIWNEJyd6
         Xbi95HY5bpiEBhCEWjFwicFJp1H76EPi6hCOMPIKmlclsAlhsdHVWcrrEpTCyfH6SMpV
         HtYjG92y0Y7UdDraNdwuJQiV6GZK1qISr2DVOnt8CUzK7LqEgC/tzoom1WTLn+8IFmcy
         qci9jL8J8B5V3w8Imq2u0IfXKTGXPjSgobINm3QAj5r2MPEIv+bybmFmWTda9ifIrt6b
         RgVaaoskem2RP59O9BheazesdsKOPrWDFeaxWkQUOc2uypqIeyfIm1pl0YUCY/A2HUy9
         Pt6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XH0Af/kN7ZInRidEVnPhB06qxYUPQCuixBX8Udkd4Qw=;
        b=ZTqzOAiRD4HYT2KG76HGxDoaSnBjM79zItyigOhBrsaEaQMzKhUOktTx5Okzp9XcSa
         5DJjetsZ5mH1hFl4uo0t25kztNxJFLwulD+XRZfCYVMnmIZAf1cqWHoM2rbarZfdyexj
         grAmSIMwyzIxhTAzMF000RkvbYT5MMKzUh+8pJAyK9E1USNluIdagP43KkJoAXDjs+oF
         ty3ieujFx+MUJHm6W4T3aHq1u8zlj3WCitAgpwDCQ2z3oVj5XUNdl7490IxQZ/MQLJOu
         724OejIXcCBvCseAJHShUwRK7INp1rqgDCXKKlEqS1JjjxgkHJtDOxzmpNsVWQjrs6mO
         4/ig==
X-Gm-Message-State: AFqh2kqIQP6ld5tjh2/9P7MhC+G/GU1+SVdczuPCeeVhJ6lMtUXQw7Qi
        lhVjbDAwy1/nbY997iIKBQ8mZ7CK+eLOmNq/
X-Google-Smtp-Source: AMrXdXu3s7WAwGEFypWytpacjzZNOQZ9SdJSjbOgJaF5GQTZ3+LV/sKZCCqB0IHeo9yvxabFiVDniA==
X-Received: by 2002:a17:90b:2d8a:b0:223:b1e4:146 with SMTP id sj10-20020a17090b2d8a00b00223b1e40146mr14004942pjb.37.1671578594494;
        Tue, 20 Dec 2022 15:23:14 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id s8-20020a17090a760800b00218e8a0d7f0sm71378pjk.22.2022.12.20.15.23.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 15:23:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1p7lx1-00Asnf-9z
        for linux-xfs@vger.kernel.org; Wed, 21 Dec 2022 10:23:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1p7lx1-00Ec6J-0v
        for linux-xfs@vger.kernel.org;
        Wed, 21 Dec 2022 10:23:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: track log space pinned by the AIL
Date:   Wed, 21 Dec 2022 10:23:06 +1100
Message-Id: <20221220232308.3482960-8-david@fromorbit.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221220232308.3482960-1-david@fromorbit.com>
References: <20221220232308.3482960-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently we track space used in the log by grant heads.
These store the reserved space as a physical log location and
combine both space reserved for future use with space already used in
the log in a single variable. The amount of space consumed in the
log is then calculated as the  distance between the log tail and
the grant head.

The problem with tracking the grant head as a physical location
comes from the fact that it tracks both log cycle count and offset
into the log in bytes in a single 64 bit variable. because the cycle
count on disk is a 32 bit number, this also limits the offset into
the log to 32 bits. ANd because that is in bytes, we are limited to
being able to track only 2GB of log space in the grant head.

Hence to support larger physical logs, we need to track used space
differently in the grant head. We no longer use the grant head for
guiding AIL pushing, so the only thing it is now used for is
determining if we've run out of reservation space via the
calculation in xlog_space_left().

What we really need to do is move the grant heads away from tracking
physical space in the log. The issue here is that space consumed in
the log is not directly tracked by the current mechanism - the
space consumed in the log by grant head reservations gets returned
to the free pool by the tail of the log moving forward. i.e. the
space isn't directly tracked or calculated, but the used grant space
gets "freed" as the physical limits of the log are updated without
actually needing to update the grant heads.

Hence to move away from implicit, zero-update log space tracking we
need to explicitly track the amount of physical space the log
actually consumes separately to the in-memory reservations for
operations that will be committed to the journal. Luckily, we
already track the information we need to calculate this in the AIL
itself.

That is, the space currently consumed by the journal is the maximum
LSN that the AIL has seen minus the current log tail. As we update
both of these items dynamically as the head and tail of the log
moves, we always know exactly how much space the journal consumes.

This means that we also know exactly how much space the currently
active reservations require, and exactly how much free space we have
remaining for new reservations to be made. Most importantly, we know
what these spaces are indepedently of the physical locations of
the head and tail of the log.

Hence by separating out the physical space consumed by the journal,
we can now track reservations in the grant heads purely as a byte
count, and the log can be considered full when the tail space +
reservation space exceeds the size of the log. This means we can use
the full 64 bits of grant head space for reservation space,
completely removing the 32 bit byte count limitation on log size
that they impose.

Hence the first step in this conversion is to track and update the
"log tail space" every time the AIL tail or maximum seen LSN
changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c   | 9 ++++++---
 fs/xfs/xfs_log_priv.h  | 1 +
 fs/xfs/xfs_trans_ail.c | 9 ++++++---
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f12e7e8dba30..b294e349798c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -761,14 +761,17 @@ xlog_cil_ail_insert(
 	 * always be the same (as iclogs can contain multiple commit records) or
 	 * higher LSN than the current head. We do this before insertion of the
 	 * items so that log space checks during insertion will reflect the
-	 * space that this checkpoint has already consumed.
+	 * space that this checkpoint has already consumed.  We call
+	 * xfs_ail_update_finish() so that tail space and space-based wakeups
+	 * will be recalculated appropriately.
 	 */
 	ASSERT(XFS_LSN_CMP(ctx->commit_lsn, ailp->ail_head_lsn) >= 0 ||
 			aborted);
 	spin_lock(&ailp->ail_lock);
-	ailp->ail_head_lsn = ctx->commit_lsn;
 	xfs_trans_ail_cursor_last(ailp, &cur, ctx->start_lsn);
-	spin_unlock(&ailp->ail_lock);
+	ailp->ail_head_lsn = ctx->commit_lsn;
+	/* xfs_ail_update_finish() drops the ail_lock */
+	xfs_ail_update_finish(ailp, NULLCOMMITLSN);
 
 	/* unpin all the log items */
 	list_for_each_entry(lv, &ctx->lv_chain, lv_list) {
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 70b4280086f2..9c173c48cbcd 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -435,6 +435,7 @@ struct xlog {
 
 	struct xlog_grant_head	l_reserve_head;
 	struct xlog_grant_head	l_write_head;
+	uint64_t		l_tail_space;
 
 	struct xfs_kobj		l_kobj;
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 1b5942ef378a..6b1556325277 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -731,6 +731,8 @@ __xfs_ail_assign_tail_lsn(
 	if (!tail_lsn)
 		tail_lsn = ailp->ail_head_lsn;
 
+	WRITE_ONCE(log->l_tail_space,
+			xlog_lsn_sub(log, ailp->ail_head_lsn, tail_lsn));
 	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
 	atomic64_set(&log->l_tail_lsn, tail_lsn);
 }
@@ -738,9 +740,10 @@ __xfs_ail_assign_tail_lsn(
 /*
  * Callers should pass the the original tail lsn so that we can detect if the
  * tail has moved as a result of the operation that was performed. If the caller
- * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
- * "did the tail LSN change?" checks. If the caller wants to avoid a tail update
- * (e.g. it knows the tail did not change) it should pass an @old_lsn of 0.
+ * needs to force a tail space update, it should pass NULLCOMMITLSN to bypass
+ * the "did the tail LSN change?" checks. If the caller wants to avoid a tail
+ * update (e.g. it knows the tail did not change) it should pass an @old_lsn of
+ * 0.
  */
 void
 xfs_ail_update_finish(
-- 
2.38.1


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04720CD493C
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 01:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjIUBs6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 21:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjIUBs6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 21:48:58 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4D3AB
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:52 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1c0c6d4d650so3611475ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695260932; x=1695865732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r63Y1c0sWYe57/4CSkh7AA0Bh5FRPJfwMyXaI6C4DhQ=;
        b=fn6/cv99d0LXg/G6aiRo5wp83FZCeJX4CnnLCyZARuC4cDWslmDbkrWv4wPcyzUMKB
         pprMsO8Bh29G4oqlG/e2q7ilarzY9zNtKBw///Yxb+jeLgaljn7LUZvcSpWg4j6We2Ld
         RUR9q9YKYIZi/qLxdyr5qwGXO2c9wRKVxhzEamzXWXAlwvUjB5Qwom5tRV1QtUNNl94u
         J5fInXI7mM7vikxt1fihlle9Z91C8xWWUU8yA/WyxaS73WnpCYWMPcTb79cC9edZp5vH
         ww++HuodA4NjOL4pQaN3W1iib7982+VvnQsLfLapDJM/e4U+aQOCGrJF+FAgiMIStcm2
         f3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695260932; x=1695865732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r63Y1c0sWYe57/4CSkh7AA0Bh5FRPJfwMyXaI6C4DhQ=;
        b=Ao7jvKvAXqVBGTBvuiv7ttyw57R3iS+wUj29R4pf4CeBwAazUxG6Q+IzHjgcfzhfmK
         nVoLRmttgDsBiY9f1Ds4KQWmh6fL054J2AoP1fJsD+VQhwUKYT3Cp5bfjWrWGFlb+HFk
         dHiPg70t8J1l1Li0/5AYLnzVKFGO4Jw+rTWEP2YTQ8OKOVnjCLqwtK1vu5aLOSkb8fbm
         nZC0u8KZYPe7qpnF/y61mRy8rdW47Fwdoo5Cu8RGPNo2JKd1KbzxyvPHO6UTvxfJnKr9
         HuhVOUdLAVFzhVnuO6H29r3pb/nZgiLESZJBPmYjuGqUry4612njR/+gRIoWe8n4qtHP
         foAA==
X-Gm-Message-State: AOJu0Yx890jFQZGdiZJ+3qudLQHFZP5ko/Sb/w19c+vVboTRrMPK5uKN
        G92/ibRsq7ef+82YLd/khWwbc/dRy3zhpy6Bzlk=
X-Google-Smtp-Source: AGHT+IFqdEyHRUDz9zwuX2R4MfjVh8ojJnPsFHAg791ltzilgyv8n++pN0FAkU2g8G+nv3pXQrURsA==
X-Received: by 2002:a17:903:191:b0:1c3:a4f2:7ca3 with SMTP id z17-20020a170903019100b001c3a4f27ca3mr5010077plg.66.1695260931778;
        Wed, 20 Sep 2023 18:48:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id i11-20020a17090332cb00b001bc0f974117sm159255plr.57.2023.09.20.18.48.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 18:48:51 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qj8oB-003T1z-1g
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:47 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qj8oB-00000002VON-10Uc
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: track log space pinned by the AIL
Date:   Thu, 21 Sep 2023 11:48:42 +1000
Message-Id: <20230921014844.582667-8-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921014844.582667-1-david@fromorbit.com>
References: <20230921014844.582667-1-david@fromorbit.com>
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
index 1bedf03d863c..6c05097ebfdf 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -773,14 +773,17 @@ xlog_cil_ail_insert(
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
index 106483cf1fb6..1390251bf670 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -438,6 +438,7 @@ struct xlog {
 
 	struct xlog_grant_head	l_reserve_head;
 	struct xlog_grant_head	l_write_head;
+	uint64_t		l_tail_space;
 
 	struct xfs_kobj		l_kobj;
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 4fa7f2f77563..38a631986ef0 100644
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
2.40.1


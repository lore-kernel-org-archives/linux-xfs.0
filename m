Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0823EC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 23:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiLTXXR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 18:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLTXXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 18:23:16 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49A1B6E
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:14 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so333381pje.5
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lOvEMabZNP9tp8fxKZvuU26KMP190ld+nJhrqriI51s=;
        b=k2AyjlaApBX9BH/p/bFKRQTq0WuZzR1z89sgnevxsPcasfTqCPWa7wd9qyhTD9cxSd
         N6LTsV4YmH7OwnRbPWAqmRhC3xbgqYEJl1h0lpVVLBIRXKXm7P+bfVdNbFqAeimZOtpJ
         VHQIAOuM2h/mvgRyl4/qm1CTWfIc/730Rle43/PXj+u0/Z5Q+CuugzbZb1Ac037uzPew
         p1c2O6q1NV0E4VFNRT6evrf7EUV88lwcyPhYTjux3++R+7/6t3pbOcDIm0CbyLoAHfGH
         xfOsEsigqEb1Gec2U0iQVkEOe7nzKWfpklwaHvxpOb/iIDobXnxXkb8o/HzH39diUS0w
         28RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lOvEMabZNP9tp8fxKZvuU26KMP190ld+nJhrqriI51s=;
        b=J2PPryWOj5Sa2HZbhQY3/aaOCc6BsI+Bet6bKD5cy9YMiwSyZxfmCgG+HvosO/7MTO
         MuLUvDTBo7OsHkZ0V1TT6DyrQyTZyqOc6D/wL1ZvYetlJ/dmItTw8i+nsQRNEI42I/CA
         gG7FlGRBZypJp0TscqQIEZ6kT8+/DIaQvxh64ZBszaCkprNyQQXbz4YPQ+ee40Ztgm7V
         M282bey7ifR/C4xDEIxb2N9fqSG1rLty+nSJWOQuZIDUVD6XLOgmOujTYflaq6k5iNSK
         6WTHNMvBxoaRm3CUdzkfb02sjjZJXWMSps2h5e0qEidXofIcSGz3m/jbzolHuDUSn3zi
         Anhg==
X-Gm-Message-State: ANoB5pk9u98EJgN1A/4ajNhJCDb5PPNcddP4STjFiY2N6Fta9nNNgNz0
        c5Kwgj2JIiLhgc3p1nK3gnM/2r/eiIETfsT3
X-Google-Smtp-Source: AA0mqf61Jp4wmLOdJeYivp3uP5R6fzu+rYgZWvPH5nPgXiZqaCxYiny3jqzhsfiLm93Q4yfA8+LJPA==
X-Received: by 2002:a17:90a:cf83:b0:219:d72:2ea5 with SMTP id i3-20020a17090acf8300b002190d722ea5mr49915348pju.2.1671578594221;
        Tue, 20 Dec 2022 15:23:14 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id j6-20020a17090a31c600b0020a81cf4a9asm82202pjf.14.2022.12.20.15.23.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 15:23:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1p7lx1-00AsnU-5x
        for linux-xfs@vger.kernel.org; Wed, 21 Dec 2022 10:23:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1p7lx1-00Ec5y-0W
        for linux-xfs@vger.kernel.org;
        Wed, 21 Dec 2022 10:23:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] xfs: background AIL push targets physical space, not grant space
Date:   Wed, 21 Dec 2022 10:23:02 +1100
Message-Id: <20221220232308.3482960-4-david@fromorbit.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221220232308.3482960-1-david@fromorbit.com>
References: <20221220232308.3482960-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently the AIL attempts to keep 25% of the "log space" free,
where the current used space is tracked by the reserve grant head.
That is, it tracks both physical space used plus the amount reserved
by transactions in progress.

When we start tail pushing, we are trying to make space for new
reservations by writing back older metadata and the log is generally
physically full of dirty metadata, and reservations for modifications
in flight take up whatever space the AIL can physically free up.

Hence we don't really need to take into account the reservation
space that has been used - we just need to keep the log tail moving
as fast as we can to free up space for more reservations to be made.
We know exactly how much physical space the journal is consuming in
the AIL (i.e. max LSN - min LSN) so we can base push thresholds
directly on this state rather than have to look at grant head
reservations to determine how much to physically push out of the
log.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_priv.h  | 18 ++++++++++++
 fs/xfs/xfs_trans_ail.c | 65 +++++++++++++++++++-----------------------
 2 files changed, 48 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f196b65b322a..205249f5a423 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -622,6 +622,24 @@ xlog_wait(
 
 int xlog_wait_on_iclog(struct xlog_in_core *iclog);
 
+/* Calculate the distance between two LSNs in bytes */
+static inline uint64_t
+xlog_lsn_sub(
+	struct xlog	*log,
+	xfs_lsn_t	high,
+	xfs_lsn_t	low)
+{
+	uint32_t	hi_cycle = CYCLE_LSN(high);
+	uint32_t	hi_block = BLOCK_LSN(high);
+	uint32_t	lo_cycle = CYCLE_LSN(low);
+	uint32_t	lo_block = BLOCK_LSN(low);
+
+	if (hi_cycle == lo_cycle)
+	       return BBTOB(hi_block - lo_block);
+	ASSERT((hi_cycle == lo_cycle + 1) || xlog_is_shutdown(log));
+	return (uint64_t)log->l_logsize - BBTOB(lo_block - hi_block);
+}
+
 /*
  * The LSN is valid so long as it is behind the current LSN. If it isn't, this
  * means that the next log record that includes this metadata could have a
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 8ea8b7d83e84..7354b5379014 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -398,51 +398,46 @@ xfsaild_push_item(
 /*
  * Compute the LSN that we'd need to push the log tail towards in order to have
  * at least 25% of the log space free.  If the log free space already meets this
- * threshold, this function returns NULLCOMMITLSN.
+ * threshold, this function returns the lowest LSN in the AIL to slowly keep
+ * writeback ticking over and the tail of the log moving forward.
  */
 xfs_lsn_t
 __xfs_ail_push_target(
 	struct xfs_ail		*ailp)
 {
-	struct xlog	*log = ailp->ail_log;
-	xfs_lsn_t	threshold_lsn = 0;
-	xfs_lsn_t	last_sync_lsn;
-	int		free_blocks;
-	int		free_bytes;
-	int		threshold_block;
-	int		threshold_cycle;
-	int		free_threshold;
-
-	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
-	free_blocks = BTOBBT(free_bytes);
+	struct xlog		*log = ailp->ail_log;
+	struct xfs_log_item	*lip;
+	xfs_lsn_t		target_lsn = 0;
+	xfs_lsn_t		max_lsn;
+	xfs_lsn_t		min_lsn;
+	int32_t			free_bytes;
+	uint32_t		target_block;
+	uint32_t		target_cycle;
 
-	/*
-	 * The threshold for the minimum number of free blocks is one quarter of
-	 * the entire log space.
-	 */
-	free_threshold = log->l_logBBsize >> 2;
-	if (free_blocks >= free_threshold)
+	lockdep_assert_held(&ailp->ail_lock);
+
+	lip = xfs_ail_max(ailp);
+	if (!lip)
+		return NULLCOMMITLSN;
+	max_lsn = lip->li_lsn;
+	min_lsn = __xfs_ail_min_lsn(ailp);
+
+	free_bytes = log->l_logsize - xlog_lsn_sub(log, max_lsn, min_lsn);
+	if (free_bytes >= log->l_logsize >> 2)
 		return NULLCOMMITLSN;
 
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
-						&threshold_block);
-	threshold_block += free_threshold;
-	if (threshold_block >= log->l_logBBsize) {
-		threshold_block -= log->l_logBBsize;
-		threshold_cycle += 1;
+	target_cycle = CYCLE_LSN(min_lsn);
+	target_block = BLOCK_LSN(min_lsn) + (log->l_logBBsize >> 2);
+	if (target_block >= log->l_logBBsize) {
+		target_block -= log->l_logBBsize;
+		target_cycle += 1;
 	}
-	threshold_lsn = xlog_assign_lsn(threshold_cycle,
-					threshold_block);
-	/*
-	 * Don't pass in an lsn greater than the lsn of the last
-	 * log record known to be on disk. Use a snapshot of the last sync lsn
-	 * so that it doesn't change between the compare and the set.
-	 */
-	last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
-	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
-		threshold_lsn = last_sync_lsn;
+	target_lsn = xlog_assign_lsn(target_cycle, target_block);
 
-	return threshold_lsn;
+	/* Cap the target to the highest LSN known to be in the AIL. */
+	if (XFS_LSN_CMP(target_lsn, max_lsn) > 0)
+		return max_lsn;
+	return target_lsn;
 }
 
 static long
-- 
2.38.1


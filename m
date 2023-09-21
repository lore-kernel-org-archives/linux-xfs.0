Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35EBACD493A
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 01:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjIUBs5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 21:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjIUBs4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 21:48:56 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C031AB
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:50 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1dc5df71745so237245fac.2
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695260929; x=1695865729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4AFXV0OsPKII9ZxUx13tD38dsvxB+MpCWFyYnczmSN0=;
        b=JXpV7UuB023QfroCTabwxotejzXbU5owdfvnDza5CY3DnjQ8rzsG0LRViLaGCmv3mx
         MJzcXtoFdgwB7+v4gY5jXP7htOHzafYq/Kf27bmzunBqjojLVo71O89MVQFIuPm83w/G
         qGRX0Z/iUOQyLXphHDRNU2H/8AuZ3BeX1cYeKeDc67bESQZRtFWmQbbr8kRvake5bwba
         blA/GtKbKmW7NziRUktJOKZLc0zzkNNjEGctt03Ab3TIHQhKuAVdaJQUDN1SVEmG0hte
         3pKJqymacISctqywTTGM63nDh19VeBvFCYQKnhTHygTAOQnTDJa9nUfyZUqcJhOpKAg4
         M4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695260929; x=1695865729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4AFXV0OsPKII9ZxUx13tD38dsvxB+MpCWFyYnczmSN0=;
        b=aSDxIW9WF5swqpPeFU69WIOx5FfioO/yqW3FVe61h0Y3YD5NzJm6OrwzVxM+Oqxw7L
         C+owx9pxCwL/covW1HPIEpp9NSItoMbRHGaPy61u91/ojSOQNa+AbSWYiDejd6XznoaH
         54wwyPgXm/chGXDVO9Y81sE5rBVLea2bYHosmr6M4yMF2GIMqPpHgqfvcrjWZo6mRzdV
         LWJmcZCjkFwvV42i55j2irGS9p8LxCQtEyluY/gJ/jiiewc0SVTE6XXADc4ZuG6fJofD
         3nmIoDTqj7yxcw/RYWKHaVFgg69uImH9tqhY/fgnY1n+j3WBwQ+Ed5mUi4/F8YCUX03Z
         XAtw==
X-Gm-Message-State: AOJu0YwtY7CONwj7onVaIagl4bJ0FXZhLfqWTZbGO7VR/R49MN6WtqGg
        TJG8UAT6gkbEdwYzsjQu/djHlbvDBLFMxXbRBSI=
X-Google-Smtp-Source: AGHT+IHnO47sRjlMFQrpo31rJHX9kO6aGwupwDZnLn9iJpIbVnJihybit8Iiv2ywRl3fGvZCqcwHuA==
X-Received: by 2002:a05:6870:c8a3:b0:1d2:4b4c:eb11 with SMTP id er35-20020a056870c8a300b001d24b4ceb11mr4717012oab.32.1695260929703;
        Wed, 20 Sep 2023 18:48:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id u20-20020aa78394000000b00690fe1c928esm166493pfm.91.2023.09.20.18.48.49
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 18:48:49 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qj8oB-003T1g-0w
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:47 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qj8oB-00000002VO2-07D2
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] xfs: background AIL push targets physical space, not grant space
Date:   Thu, 21 Sep 2023 11:48:38 +1000
Message-Id: <20230921014844.582667-4-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921014844.582667-1-david@fromorbit.com>
References: <20230921014844.582667-1-david@fromorbit.com>
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
 fs/xfs/xfs_trans_ail.c | 63 +++++++++++++++++++-----------------------
 2 files changed, 47 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index d4124ef9d97f..01c333f712ae 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -625,6 +625,24 @@ xlog_wait(
 
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
index 31a4e5e5d899..3103e16d6965 100644
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
+	struct xlog		*log = ailp->ail_log;
+	struct xfs_log_item	*lip;
+	xfs_lsn_t		target_lsn = 0;
+	xfs_lsn_t		max_lsn;
+	xfs_lsn_t		min_lsn;
+	int32_t			free_bytes;
+	uint32_t		target_block;
+	uint32_t		target_cycle;
 
-	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
-	free_blocks = BTOBBT(free_bytes);
+	lockdep_assert_held(&ailp->ail_lock);
 
-	/*
-	 * The threshold for the minimum number of free blocks is one quarter of
-	 * the entire log space.
-	 */
-	free_threshold = log->l_logBBsize >> 2;
-	if (free_blocks >= free_threshold)
+	lip = xfs_ail_max(ailp);
+	if (!lip)
 		return NULLCOMMITLSN;
+	max_lsn = lip->li_lsn;
+	min_lsn = __xfs_ail_min_lsn(ailp);
 
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
-						&threshold_block);
-	threshold_block += free_threshold;
-	if (threshold_block >= log->l_logBBsize) {
-		threshold_block -= log->l_logBBsize;
-		threshold_cycle += 1;
+	free_bytes = log->l_logsize - xlog_lsn_sub(log, max_lsn, min_lsn);
+	if (free_bytes >= log->l_logsize >> 2)
+		return NULLCOMMITLSN;
+
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
2.40.1


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5608C43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 16:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241565AbiFFQGC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 12:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241502AbiFFQF6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 12:05:58 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2ED7194245;
        Mon,  6 Jun 2022 09:05:56 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q7so20485566wrg.5;
        Mon, 06 Jun 2022 09:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wn1Y0ouYIlg+N/jjxBw0yK9UaqWrXu4rdEIsXBdfBz4=;
        b=Id2XcDvMXeGJVF8CP8qD0XBsFV2IrImmdisr0qE/hjB0P+E2eVVCpB7t1g+wuAEOEf
         ZxlhY9uQNNfYlZ47K1en1vwGfp6Wiaagvi38XTO40An8gKpOc+riYeKzy5DHLRPOR+3s
         yVuNHOsiqiJJYvNHqmnJILuCBH5Je2774KAj0RBfsawt/cSWX+oLPx/QcLi5zXLoztEm
         6LyRonDRunQuiGpUyGc5+XKhlcOxugkuEq3GgrSf3CHfEX9oclsD+UXMgCadoWhcNDQY
         +uHotwK7BiiVasMyj5FcGvVbTH83CKR+ra1/BGJAPHAka3l/rwFMlO39f90AD65M5Yqk
         HnxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wn1Y0ouYIlg+N/jjxBw0yK9UaqWrXu4rdEIsXBdfBz4=;
        b=GiK1WbiOgReJNmcvEdhCmniR5Ak8zPeZ5b+DUdxHgTwRv88mPdMRvEhIRKuqlOOzC5
         LZUWmIU2fjGfBut/np6t/M+0FKnzlsuJ42nhXllgz2Xfppyv/8C1eHURzlQQ2IkOkcp4
         7wjz7FxxN6iytpkEYD01ARbSXHNUfLmQO6TN2X+k3dJbl6BCLkYVl5jkODOdzDVjBrUY
         qyCgT1rhDm65FPZy/71sUNkNDluzxagMUoaBjIw8eZjRUskoJge7mFOwcRqKMNoeDPxq
         HyrYNtqoY5797V5oILR+wt2rIqlEpUtD91Leg5KWxhXPok3p9mk3PUON+LGEbQX43950
         8h7Q==
X-Gm-Message-State: AOAM531yUYJ9FQU+yqspUCLsYLwqgzQNsrJiU/ebK+mV7VdsP6dNvwLr
        E9wYHcaSUACSLub/LJD676R4uCIgdASN2A==
X-Google-Smtp-Source: ABdhPJx0EuuKTqHzjeEC05qbzWQ4uifR4RM5Wqs3QG0akKETn0fU0+QbLzy5R23D7sT5d3GKLsQQ4g==
X-Received: by 2002:a5d:5452:0:b0:216:f80e:f7c6 with SMTP id w18-20020a5d5452000000b00216f80ef7c6mr10240940wrv.472.1654531555333;
        Mon, 06 Jun 2022 09:05:55 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c3b9600b00397342e3830sm25681327wms.0.2022.06.06.09.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 09:05:54 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 6/7] xfs: update superblock counters correctly for !lazysbcount
Date:   Mon,  6 Jun 2022 19:05:36 +0300
Message-Id: <20220606160537.689915-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606160537.689915-1-amir73il@gmail.com>
References: <20220606160537.689915-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 6543990a168acf366f4b6174d7bd46ba15a8a2a6 upstream.

Keep the mount superblock counters up to date for !lazysbcount
filesystems so that when we log the superblock they do not need
updating in any way because they are already correct.

It's found by what Zorro reported:
1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
2. mount $dev $mnt
3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
4. umount $mnt
5. xfs_repair -n $dev
and I've seen no problem with this patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reported-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 16 +++++++++++++---
 fs/xfs/xfs_trans.c     |  3 +++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5aeafa59ed27..66e8353da2f3 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -956,9 +956,19 @@ xfs_log_sb(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*bp = xfs_trans_getsb(tp);
 
-	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
-	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
-	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	/*
+	 * Lazy sb counters don't update the in-core superblock so do that now.
+	 * If this is at unmount, the counters will be exactly correct, but at
+	 * any other time they will only be ballpark correct because of
+	 * reservations that have been taken out percpu counters. If we have an
+	 * unclean shutdown, this will be corrected by log recovery rebuilding
+	 * the counters from the AGF block counts.
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
+		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 2d7deacea2cf..36166bae24a6 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -615,6 +615,9 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
+	mp->m_sb.sb_icount += idelta;
+	mp->m_sb.sb_ifree += ifreedelta;
 	mp->m_sb.sb_frextents += rtxdelta;
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
-- 
2.25.1


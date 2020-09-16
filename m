Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCDFC35256
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 16:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 257E4224B1
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 16:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LH+y3Xlt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgIPQWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 12:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgIPQTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 12:19:55 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055F1C061D7F
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:25 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f18so3765870pfa.10
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rDWezRLezHCavFuI7GQtxYVHLfoRJmt6AeUjZaj//VI=;
        b=LH+y3XltLHvVt6VuYEJAyNJtDT+ZqU7NRC7t9CUCEaFbKFIG0rS3QRvGqwTZY3erp8
         YTc2oRkmzsiJQqajpkF63AZu2VjBR1L/Da8oLfB5DZ9HIOoVKheOniKPkQb7VUoYdeEO
         QyplmhG1SsPR1L1ilp1gJ3l6uFydYQHBkCaBKCAbl62tYBZtgPie4VPkK+nfwPKF3LYa
         r3V6KxoVQnMB5qGs1WqV+aLz05U4O/arGTGT+Lllj4RoOs3GlfCdlUfGKSeVIbX4uFIW
         BUM/1SDMoUmYdcaSR6vlKzc+G7GSnEI/vzM400jSTMa2M++FgMmFLACHqiIXLFoPTMpD
         ydwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rDWezRLezHCavFuI7GQtxYVHLfoRJmt6AeUjZaj//VI=;
        b=LZMrLNy2MSN3LrLDemKK9RTOcu7SJyeDVMWo1ClV/q2+0uSH7y0m2GR2Keevrbbkuc
         8FHgDegq8s6cPnDt2NR/C3o+0ph8cZbuMrNT9rsr/9e6de+EtNhEB8ISs47TyqV1jNkL
         o0Zo2eCjil3Ly8OZcQbt3mghIYhPI0cNDfd1KGIA32ZnsJnFRJ3zjxnFlom5cS/AHgsT
         +1yvvhr+Qzs0+LwbKH2ZzKXgq8O3s84o36bV1FyLhenayo/NmSyjf+AsX+lZDECZ8nI+
         KP6e9zrcI2Mvtr7yUlQhyZLLA/cdh7KqZAprhgDAg3NAnp9eRws8SkQz+1zrKUIOcP2W
         wvFQ==
X-Gm-Message-State: AOAM531jD/nzqTkSX6VBCAAZzeDvVq6/56ac+FkyIMmsTZqNAeN6FOBk
        /EoYsCjFCdqECCLIb3oQMRzc07FfAscD
X-Google-Smtp-Source: ABdhPJygr70dSVvPSV70Ble+qZW5A36wgjhG8wNO0hDn1sHN5aejDyO2rQOUr5bfDgpG1tvJZxt/UQ==
X-Received: by 2002:a05:6a00:2db:b029:142:2501:34ed with SMTP id b27-20020a056a0002dbb0290142250134edmr5721968pft.70.1600255165157;
        Wed, 16 Sep 2020 04:19:25 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v204sm3492195pfc.10.2020.09.16.04.19.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 04:19:24 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: remove the unnecessary variable error in xfs_trans_unreserve_and_mod_sb
Date:   Wed, 16 Sep 2020 19:19:09 +0800
Message-Id: <1600255152-16086-7-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We can do the assert directly for the return value of xfs_mod_fdblocks()
function, and the variable error is unnecessary, so remove it.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_trans.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d33d0ba6f3bd..caa207220e2c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -573,7 +573,6 @@ xfs_trans_unreserve_and_mod_sb(
 	int64_t			rtxdelta = 0;
 	int64_t			idelta = 0;
 	int64_t			ifreedelta = 0;
-	int			error;
 
 	/* calculate deltas */
 	if (tp->t_blk_res > 0)
@@ -596,10 +595,8 @@ xfs_trans_unreserve_and_mod_sb(
 	}
 
 	/* apply the per-cpu counters */
-	if (blkdelta) {
-		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
-		ASSERT(!error);
-	}
+	if (blkdelta)
+		ASSERT(!xfs_mod_fdblocks(mp, blkdelta, rsvd));
 
 	if (idelta) {
 		percpu_counter_add_batch(&mp->m_icount, idelta,
-- 
2.20.0


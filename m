Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A369C43463
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3ECE21D7F
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jozu4KGD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIRJsi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 05:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRJsi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 05:48:38 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7C4C06174A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:38 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 34so3145353pgo.13
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ybzMGAH7mRYLjz5sy5yNWonaXyIH8jR0aIDyNXY08k0=;
        b=Jozu4KGDdWxxZwJrzfCTWFfmVA2L7hFzYU/JkuwLBaXKPhcFQT+d9C/RED11FFrZaR
         6fAVZokGVvd2OHL5Gypb4sSdHjD3FXz6ADIHvqArIhKRNIQKE3WaiFh499EaXOV++RX3
         5HlvAEA+sDrwlL00hfLfrNDgwF4CoV3oGgXFYDLQdwDIIyqARyl1p41f1Yv2jzAAxioG
         SNXuv4u4i+5E7gRylYO3YL3oOgtu7sCChhesT0LO7C+UPd+xHFdvmp0D9CDMeZLZ041G
         woHU1hXdwtIfZuTwgC3Qcfu3EH0J4Lp/WT4pkPxy4R95ya5phfReVMaHXIaPMujoa0TD
         gd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ybzMGAH7mRYLjz5sy5yNWonaXyIH8jR0aIDyNXY08k0=;
        b=ZwoaIhsdrnWPoLqRbug1zqOPmBYIRZe+D8Fd0eCuERxjn/GOgiJjhbZuHxFuenbNNt
         YPARCEuRTEcXDkdnvkpbiTf+cwRpn6hq5WTQ+OubAT96mNQW03FqS7XxgEn1HxkP8UFW
         djNQqy7ySqOaZWmPxkbJqp1LmGDCpjd45WF2GfLNnwIGFpIU7h3Fac2cygLG0Rr5XWdK
         AHo4F+B1QuxW+oVNXf1XvaZiGPzikdfadcpw+185aUQwJG10kKnqhsMvrYoAFd1Km+W2
         9NdQN36b2Kgfgz2VYFgISp4BdepJHYa7mj3+4eSuz0F6V9OmK1GwpLrVHVbM73PDZoxP
         bJkA==
X-Gm-Message-State: AOAM531nSc3w6dscwMPKDVCLtccL1B7btqwXh0G32Ts9k6uIl8E4a80G
        IgDz5oxeQmH/pSpXyeObDNoWcjoHplo=
X-Google-Smtp-Source: ABdhPJxyJ7cHP/vOuR4RpsrXzGXvgQx5iPewZD+0lcA28ODa8pTAt9LnrsQ1tCt35BmB5D1uBs76FQ==
X-Received: by 2002:a62:3802:0:b029:142:2501:397e with SMTP id f2-20020a6238020000b02901422501397emr14738048pfa.67.1600422517647;
        Fri, 18 Sep 2020 02:48:37 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id s24sm2227194pjp.53.2020.09.18.02.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 02:48:37 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V4 07/10] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Fri, 18 Sep 2020 15:17:56 +0530
Message-Id: <20200918094759.2727564-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918094759.2727564-1-chandanrlinux@gmail.com>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Moving an extent to data fork can cause a sub-interval of an existing
extent to be unmapped. This will increase extent count by 1. Mapping in
the new extent can increase the extent count by 1 again i.e.
 | Old extent | New extent | Old extent |
Hence number of extents increases by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
 fs/xfs/xfs_reflink.c           | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index afb647e1e3fa..b99e67e7b59b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -78,6 +78,15 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
 
+/*
+ * Moving an extent to data fork can cause a sub-interval of an existing extent
+ * to be unmapped. This will increase extent count by 1. Mapping in the new
+ * extent can increase the extent count by 1 again i.e.
+ * | Old extent | New extent | Old extent |
+ * Hence number of extents increases by 2.
+ */
+#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 16098dc42add..4f0198f636ad 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -628,6 +628,11 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error)
+		goto out_cancel;
+
 	/*
 	 * In case of racing, overlapping AIO writes no COW extents might be
 	 * left by the time I/O completes for the loser of the race.  In that
-- 
2.28.0


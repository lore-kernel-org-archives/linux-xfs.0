Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A565C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA8B42075E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kj3Mkcuh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHTFo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgHTFo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 01:44:29 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3252FC061757
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:29 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v16so545185plo.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JIrVieHhvT8R70iEP7YntiN6S3pkk+mFo7AMAS/mcuY=;
        b=kj3MkcuhQMV+5LWTRuGnXsHuNf/gyBs8T9wLRQU5rnC4ClUCv6GR/6iJ2qzNTlmLjh
         H1b3PJYitQ6YYPFbMbZ7E8CGtKf83X2ltBvWv9EwcQPewjIZ1bJCMIiXgnRzAwZGV2ui
         PeD9G8Dd9/yd22U/TFeVM8/W64i0pDfVo/TDss8dH7YVHPvHFmViULiyOTX516Ie4RtF
         DZSi7rp8DIfVSPZ6RRNXEOeHWfnJhQH8OEek28aM3j8+175d83LhBaubUJBBiSIGNJ6B
         wfJ/BjXQ0yRPHlNmAY4/v9xgCK+ifR1oxI6+wrYdsRVgAImtLi5F6sk3XHG37hhrmOoi
         ys4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JIrVieHhvT8R70iEP7YntiN6S3pkk+mFo7AMAS/mcuY=;
        b=kJ0lNsb+9V0j7+LZuLfAWoIhhZiFAtYcz5b9ffQ29rQ8IFQP/Jq1c3u71hDUvrlsZS
         gUlJ2hX7pGx6Vg6eqmib73CF5IIip+7RQdpSFeY/SU9uO7D+GxVk95GgZGvIGhWBtzP4
         RvZKL+85PEefQ9KvRaMYtj5OelvilGKNU3/K7KwyzpX+iAAQ2h33AtB2ty07jfpIGRWZ
         qQmBjA7lUL/RMBETPZOm8/AXId2G6nvp39SfwPiWwauV+fDqCAEMUVqsHfYMUrw4LqVI
         gN2kjSzbuAfuWiQkeOo9tql/AdpTRfaiJqHkxlNxdj2b7hXdyaEaXztUdGRPi4aqV6av
         XODQ==
X-Gm-Message-State: AOAM5337CAI1I84y/zG8mPOewxPK2mkV32knwJ1y82JuWXuBvfUfTpI3
        2pJWs9zmm8KFN9Jd2PuKHhuMPlhpTa4=
X-Google-Smtp-Source: ABdhPJyCcIHfdqsC6thNfiz0F+P1DK6HGXnC0BJaVWZOeDREf83rg2aU/Mw5C1RffjbjS3xMPRhOdA==
X-Received: by 2002:a17:902:ba98:: with SMTP id k24mr1400473pls.277.1597902268480;
        Wed, 19 Aug 2020 22:44:28 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.150])
        by smtp.gmail.com with ESMTPSA id l4sm1044034pgk.74.2020.08.19.22.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 22:44:27 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V3 08/10] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Thu, 20 Aug 2020 11:13:47 +0530
Message-Id: <20200820054349.5525-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820054349.5525-1-chandanrlinux@gmail.com>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Moving an extent to data fork can cause a sub-interval of an existing
extent to be unmapped. This will increase extent count by 1. Mapping in
the new extent can increase the extent count by 1 again i.e.
 | Old extent | New extent | Old extent |
Hence number of extents increases by 2.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 9 ++++++++-
 fs/xfs/xfs_reflink.c           | 5 +++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index d0e49b015b62..850d53162545 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -78,7 +78,14 @@ struct xfs_ifork {
  * split into two extents causing extent count to increase by 1.
  */
 #define XFS_IEXT_INSERT_HOLE_CNT	(1)
-
+/*
+ * Moving an extent to data fork can cause a sub-interval of an existing extent
+ * to be unmapped. This will increase extent count by 1. Mapping in the new
+ * extent can increase the extent count by 1 again i.e.
+ * | Old extent | New extent | Old extent |
+ * Hence number of extents increases by 2.
+ */
+#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
 
 /*
  * Fork handling.
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index aac83f9d6107..c1d2a741e1af 100644
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


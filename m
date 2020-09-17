Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01837C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD94821D7F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:40:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qkx0NZMC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgIQLkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 07:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgIQLjI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 07:39:08 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F6DC061788
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:39:00 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x18so979744pll.6
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hUZcP0BN3wlO1l1Z3N6N1aWVC8ZS2qzKnuR+Tup5krQ=;
        b=qkx0NZMCvD7zDOg0/StWvRcF/BYjzjwCio7A+eH900nrQC5UsrpNZNu1KWZ6zZNJQV
         iwMmHr201zj+aQStWicxJyWcuvRPj0XUUiuZzIKxMLqHLeJJ6SMOAf1YwIgFMDIcF6qs
         n8a8mdv34e6ZY34AxqhSEPagq3cHf3qlWuSvJGF0rV5J6xuxNI6JLr90s1p7T+WuX5Ve
         PlPP8aGORVbo7gKSiebSNeARDF9x1WvmnF0HonCw5U8fa0tY5tjKKJxd9ZQfvep+Jrko
         LGXSioSLBGMrJ3LpAt2iQdvKHBLSq0ysFGak+IfKygAmSy5KkcIQsq5BYSda5yHae14T
         BmYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hUZcP0BN3wlO1l1Z3N6N1aWVC8ZS2qzKnuR+Tup5krQ=;
        b=Gepr8pasRhp3ORVy5GKO43C/o9wEslLbMKyoM0cXYL0fk88WPvxQkdlYZ0EEDFLLrt
         c19NQ0gO4karsDZyoPXT2yUR3c0Sp6mp2LFzj8OhJ7kkVHG5PjubgB9hGhP5QgDx9Nfr
         MmkeWYVQ2ywjskt3biYL8ryfy8/tYcGU+X5sKYGpS/fM2Ts7+k63qGGnxKPcUJI2/yba
         1+1t/JqarsBvONBvR+QNxfn0oGb6xpdboE6uiciU81x+ghWRtr8Zn73oyZM404QG6MVC
         XZXcwqhEXzDgIT6rU8mHpQ7uvojQnE7tkESvvycN6FGIKOH75SWb4XzlWSVrZWju4y3N
         eo2w==
X-Gm-Message-State: AOAM532gwnsjCQs9czrqTIBXEbox9pvcIjpI60Hu+fVjq9p36FldHu2K
        91io15WNL8nWtH9MH++g5C5E3RDk3g==
X-Google-Smtp-Source: ABdhPJzT48scEmsXus5LJ4oEEX6CwhB53t0ARzdQ2tjlgX9UBDi3Ohoz8O4w8WgBiMcu8njDTsWSnQ==
X-Received: by 2002:a17:90b:50e:: with SMTP id r14mr7924025pjz.230.1600342739966;
        Thu, 17 Sep 2020 04:38:59 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 64sm18761147pgi.90.2020.09.17.04.38.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 04:38:59 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 5/7] xfs: remove the redundant crc feature check in xfs_attr3_rmt_verify
Date:   Thu, 17 Sep 2020 19:38:46 +0800
Message-Id: <1600342728-21149-6-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We already check whether the crc feature is enabled before calling
xfs_attr3_rmt_verify(), so remove the redundant feature check in that
function.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 3f80cede7406..48d8e9caf86f 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -96,8 +96,6 @@ xfs_attr3_rmt_verify(
 {
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return __this_address;
 	if (!xfs_verify_magic(bp, rmt->rm_magic))
 		return __this_address;
 	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))
-- 
2.20.0


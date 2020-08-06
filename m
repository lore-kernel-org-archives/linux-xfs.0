Return-Path: <SRS0=zhh1=BQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9921EC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 17:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAAE520786
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 17:03:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=etsukata-com.20150623.gappssmtp.com header.i=@etsukata-com.20150623.gappssmtp.com header.b="YKSScdMP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgHFRDF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729820AbgHFRB6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Aug 2020 13:01:58 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02804C034616
        for <linux-xfs@vger.kernel.org>; Thu,  6 Aug 2020 06:19:13 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p3so26695180pgh.3
        for <linux-xfs@vger.kernel.org>; Thu, 06 Aug 2020 06:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V1nnod0YcV7H2TUfC8Gd96YGz+LSO9JcTYXXX1K5F8M=;
        b=YKSScdMPWzgWF7wSGiSqP95WaTCqorzQjkBnqwiKacTI0pfodkP5JNyOASut44yJ3s
         l5WouG2nks7VRPeOnmuKSKOFIZh8Ic0u8UuUxx45NqhalbT1S4f/9zdk9NtVZOzxRZIQ
         5aiTXswxQAVqbhKii8Csr+ntnUijgnCyA7hcfIOHIXy36EYCI/cakomgU/tpxjmQzq1D
         2pwabp9JoYYNme1qeEGLFdWuN+eKF79/Trev97gkXlSZWXu0VOo/HKohGN680R/9FDPI
         Ere7hd6MEpRJtverCfv4jb0jqpZkVGowXiQuFo/kT+QYEJlC6cIka8DF1SLC/s5p6s+X
         Ichw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V1nnod0YcV7H2TUfC8Gd96YGz+LSO9JcTYXXX1K5F8M=;
        b=rci5JyXqLBWMFMGE+fE8O+zTSHbNMJTpGznqzLZQtISZznfngA0bl3gEDSTZ64b6Wi
         8BxpHHhn+jW7Sw5QDxSaTEVMP8kfMDGLBKjxE4b4ebQlKSvP+Y532IjbLM9CSulOp4tu
         4zheqCPtdPGWi1RBA8GfUfA2QNCgf00pKT0eAR08GnUZkNtpSQC+9Bsk58ApnqdgXnEJ
         g29JteZJoFV3nVpg8QtAypseC5sDkIrl9p3ivxCw+BUdFnTrV6X5mHbH8DuaqEct/EDt
         2iV4s/ObVVq4dXmJpWAHM1F8KdrwBlXipeWejggVdrltiESZ3uVv4dOlS+Etkg6oNsQG
         ZYDQ==
X-Gm-Message-State: AOAM5301ADramcw4NvixhdKHjaVXyMzwRZjQMOw4pWuUIC2Z+zM2Rcq4
        OX61QbfnlknakNq+8HhHw8apnw==
X-Google-Smtp-Source: ABdhPJy5OWv4YebWEdmAk1TZNEahwpIKQsFkvMQ2u8mMNYwisz/N6njR6OtM1fCTbW1PDnm4LCQG4w==
X-Received: by 2002:aa7:982e:: with SMTP id q14mr8418876pfl.299.1596719950852;
        Thu, 06 Aug 2020 06:19:10 -0700 (PDT)
Received: from localhost.localdomain (p14232-ipngn10801marunouchi.tokyo.ocn.ne.jp. [122.24.13.232])
        by smtp.gmail.com with ESMTPSA id y72sm8790366pfg.58.2020.08.06.06.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 06:19:09 -0700 (PDT)
From:   Eiichi Tsukata <devel@etsukata.com>
To:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH] xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init
Date:   Thu,  6 Aug 2020 22:18:47 +0900
Message-Id: <20200806131847.2248244-1-devel@etsukata.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If xfs_sysfs_init is called with parent_kobj == NULL, UBSAN
shows the following warning:

  UBSAN: null-ptr-deref in ./fs/xfs/xfs_sysfs.h:37:23
  member access within null pointer of type 'struct xfs_kobj'
  Call Trace:
   dump_stack+0x10e/0x195
   ubsan_type_mismatch_common+0x241/0x280
   __ubsan_handle_type_mismatch_v1+0x32/0x40
   init_xfs_fs+0x12b/0x28f
   do_one_initcall+0xdd/0x1d0
   do_initcall_level+0x151/0x1b6
   do_initcalls+0x50/0x8f
   do_basic_setup+0x29/0x2b
   kernel_init_freeable+0x19f/0x20b
   kernel_init+0x11/0x1e0
   ret_from_fork+0x22/0x30

Fix it by checking parent_kobj before the code accesses its member.

Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 fs/xfs/xfs_sysfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index e9f810fc6731..aad67dc4ab5b 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -32,9 +32,9 @@ xfs_sysfs_init(
 	struct xfs_kobj		*parent_kobj,
 	const char		*name)
 {
+	struct kobject *parent = parent_kobj ? &parent_kobj->kobject : NULL;
 	init_completion(&kobj->complete);
-	return kobject_init_and_add(&kobj->kobject, ktype,
-				    &parent_kobj->kobject, "%s", name);
+	return kobject_init_and_add(&kobj->kobject, ktype, parent, "%s", name);
 }
 
 static inline void
-- 
2.26.2


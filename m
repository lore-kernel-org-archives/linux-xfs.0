Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBC1C433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 08:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A89F222240
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 08:29:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bi68kV9N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732438AbgJII3S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 04:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732847AbgJII3R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 04:29:17 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C42C0613D2
        for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2020 01:29:17 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id y14so6578776pgf.12
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 01:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3OcyM4ABbUZppFZaQk2giw87a2A3D0eGj1XdcVKZeDI=;
        b=Bi68kV9N7fw6znJEeTRF53cWpJscvewyqOeO5XcW8KJpTM/kp5Us9tB3HvU+U+grnw
         2/LUT3DH4W9XmyRYeNrcGuGk4cH4jz4USy6TMc/CWG4h5KYWXuQPtSx7VlLqWzKtMxmf
         /apAcrtz4fELRshTELeB6rMLsg2oArDTCmk4MXGsMmYKTwm/yzo/YyPgD0pREHl30pgm
         e5OCggzGNejOgJmW+C97xSQvpgg0pUBvcoQBez6OeI09FOz0DkNreOx6uoUCw4SG9pE0
         +HBRvueCt6bq+VrBvR7L3WFtrwEXZlXUJK3pEXnr0eV0wfyqyjzaFX7eIuC7KfiM5wPy
         7qDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3OcyM4ABbUZppFZaQk2giw87a2A3D0eGj1XdcVKZeDI=;
        b=rrU02mBnkyBJj6xkCrl99V3Y0qfXqLwyPgJIDKTegV0N4Qx8G1cilQc6PGHTj3Q3Lr
         YNit3nPUBM+wTjnc1UbxCWZu9LlEXPflfViU7TXNM3O1mMXM3d6OC748Kiu7lM36VXBZ
         OM/SxZFJ4yRiBkmMHANN2Py/09WfTxd6GxpzQ0BtSyN6N4kXaTHTYaQE2IAg28D0RHj9
         yEroZjjfsfBEjitiiCRxN93UbvfjAZX4GeKMQ5UUjXduE8xpT71gj1h27ejdspDEWx2O
         yxiL+D0OnEsmPQxS/lx4ru59ugdnQLXBEw8XTDw+SOiXk9q+iD5gwL3qpdRA/K9w+UZO
         fr9g==
X-Gm-Message-State: AOAM530mH+cu0zFpsnxVSWuxsES8xJunDdZAXLgWDvXbwMw78ZqmPQYw
        a5RSjJDXy0wLM0E2NQF9kVU0LaPmJQ==
X-Google-Smtp-Source: ABdhPJwKCklEojuMvDJCaLgRMJGHlkEOtzCd7a3dnIg3a/gmgPn8NtaG/QQyKQi7CNaYyAHoIEWsIA==
X-Received: by 2002:a17:90a:d317:: with SMTP id p23mr3436926pju.52.1602232156332;
        Fri, 09 Oct 2020 01:29:16 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 84sm9597968pfx.120.2020.10.09.01.29.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Oct 2020 01:29:15 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [RFC PATCH] xfs: remove unnecessary null check in xfs_generic_create
Date:   Fri,  9 Oct 2020 16:29:10 +0800
Message-Id: <1602232150-28805-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The function posix_acl_release() test the passed-in argument and
move on only when it is non-null, so maybe the null check in
xfs_generic_create is unnecessary.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_iops.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 5e165456da68..5907e999642c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -206,10 +206,8 @@ xfs_generic_create(
 	xfs_finish_inode_setup(ip);
 
  out_free_acl:
-	if (default_acl)
-		posix_acl_release(default_acl);
-	if (acl)
-		posix_acl_release(acl);
+	posix_acl_release(default_acl);
+	posix_acl_release(acl);
 	return error;
 
  out_cleanup_inode:
-- 
2.20.0


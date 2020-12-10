Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 006D8C4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 00:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFC9323D9A
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 00:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbgLKAAY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 19:00:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57584 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729231AbgLKAAE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 19:00:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607644718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cHnRhe0sp3yY9YzQbIRGJ99+ytbs+Z5CBQLUcYcIitM=;
        b=QqqkL5sU5kemeLGljCz/KHpb2c4hGTkBZlIdcYmRFZiStCtK8gq+SAOyFfxfVI87OtX0Zp
        cl3t0oxDtZR3goApNdi8+5znduzQuX2JSngT988ssiXwS5TjvqAABRDEMoXx/9BF6e8lv1
        VIwX1Dh52d40DKlOTUm8pfnI0/ki3/A=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-nKc7x625PPyZ5-Rp5ijvKQ-1; Thu, 10 Dec 2020 18:58:36 -0500
X-MC-Unique: nKc7x625PPyZ5-Rp5ijvKQ-1
Received: by mail-pl1-f197.google.com with SMTP id a17so4295005pls.2
        for <linux-xfs@vger.kernel.org>; Thu, 10 Dec 2020 15:58:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cHnRhe0sp3yY9YzQbIRGJ99+ytbs+Z5CBQLUcYcIitM=;
        b=YnW6IiDBtW2x5+aLckEZ44eo4ggZlMjeOFMID4y+UPTRmS/Ty3VjBB2T3Df77ukA2x
         gMgPv9W9QooZKIVi4976t7ZXTf+JztUWT+1yfCHoRT0P0Q6XxFS5sMFK/TGt7E2Ofho8
         TAoEX5HiMl50/S/J/VYpjV2kwA+tDXPYIvm9eaCDw85BLDhMkvvZ2DlG+Rq5qKk4XCUx
         jCQBQHtH9JJI3GkLZ87rAZPU3h23CvzyfEkZfS5HzhES21r7qUjFsZcruN01vqm6O5re
         kaU2I1zEHIu7DofEwwuYHiM6em/ifI8nt8TPt1MhZvaUBEJAP+/wNB09yiQzU3SwvAdt
         5Xvw==
X-Gm-Message-State: AOAM531XdRrhi32ZPdo/FpvZDFcY9NmmRJDXNlJqh7QE/De4AiZyZKfT
        pwj4y538z3ZfRBWe0+cD8Xx023Fdq7+cy2cLUeZvSWJRIxObQ16mDJn2Qz09PD2HChakpER2YHH
        ZPyAq3MH/zTxcTnoYZQF4FlwDwAQBtIfJKYdPayOAhhVKUW/pxBJiqfYqE7P87A6InPxwfoknQg
        ==
X-Received: by 2002:a17:90a:f486:: with SMTP id bx6mr10204775pjb.157.1607644715324;
        Thu, 10 Dec 2020 15:58:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhVF/XwCUIupZUr+gj1K78CWjo5iIQJUZdDERsGg1qk+HJmfKKIWsLoocjlbxZDafe2jytvw==
X-Received: by 2002:a17:90a:f486:: with SMTP id bx6mr10204753pjb.157.1607644714957;
        Thu, 10 Dec 2020 15:58:34 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b22sm7383525pfo.163.2020.12.10.15.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 15:58:34 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH] xfs: silence a cppcheck warning
Date:   Fri, 11 Dec 2020 07:57:47 +0800
Message-Id: <20201210235747.469708-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch silences a new cppcheck static analysis warning
>> fs/xfs/libxfs/xfs_sb.c:367:21: warning: Boolean result is used in bitwise operation. Clarify expression with parentheses. [clarifyCondition]
    if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {

introduced from my patch. Sorry I didn't test it with cppcheck before.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index bbda117e5d85..ae5df66c2fa0 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -360,11 +360,8 @@ xfs_validate_sb_common(
 		}
 	}
 
-	/*
-	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
-	 * would imply the image is corrupted.
-	 */
-	if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {
+	if ((sbp->sb_unit && !xfs_sb_version_hasdalign(sbp)) ||
+	    (!sbp->sb_unit && xfs_sb_version_hasdalign(sbp))) {
 		xfs_notice(mp, "SB stripe alignment sanity check failed");
 		return -EFSCORRUPTED;
 	}
-- 
2.27.0


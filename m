Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21ABBC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 06:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D89DA61973
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 06:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhCVGkC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 02:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhCVGji (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 02:39:38 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7228EC061574;
        Sun, 21 Mar 2021 23:39:38 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id g8so8161777qvx.1;
        Sun, 21 Mar 2021 23:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U3vqf31zx/P6mYrrygrvQtxsipFMbvBFOfUBzSBRGg4=;
        b=CZF/fa2GKiY7bAaXe+J6WwjouI8z3qWssNzjqFbMzPw/d9LhS3PsoCkF0ohxn2adDz
         m+riPTkocwXnMbBLxA+4uuVZBeyIuUPOi4mAeNNC6xyqMRfnrJOn2vNFBMlwFYFaN25q
         SZ9RZmV4BvmxgybqEEUJgyWoPPODnhBLNOTn7O3R1PU5ncXfWE5raG2MwAGof2ctv3uY
         nnTWP9LkKmBjhO+CNdjrNGI1zGJfhBaSClwd61HvEZApASFjo80wP/0zQ6dHtar04Z8n
         SA7w8F8EqYcSMwfaGs3aupttdBa/mZVqJbTGhAGOTQk/oWevFoZ8Q074GqQLdgcd0nnj
         xWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U3vqf31zx/P6mYrrygrvQtxsipFMbvBFOfUBzSBRGg4=;
        b=UGuQjZHcynAjmJwShuXb7eXJjlOdLByX5lvTL69EzaTfyLK5eRInIYzJsSUNFesYjy
         qlCpaeLuOuU4lqJ36NMjKkUCSt2vPf74tadciiuiGKRpRo9X2qrXE5djb+xTRFPCrGhw
         /oEMpnrDTvxwNVss3iqHIceHmZGV5lTSEv9zP9LlnK5vJsjzija4l5FmDBCpcVtaMMLO
         HFAN8olO1LUpzjljSlxMTXiY/qn0GXxGujmhSo/T0g44cXSPBZ7G+2xadVsPx5/0n2WF
         zQx2GCi3Ql+8bZBGlTK9M5IVU9Bvk8MG7Gk0Y+IE3B9vhAi4REc4VLEohbqgyMTXGUli
         +qQA==
X-Gm-Message-State: AOAM53153Yhx2K/rzf8A8NMQq9UZx0U3vKP1WcRZqIg01rUmrJg/5HRv
        h6tQVMbjuV6vQtxN+SZJKrmb+StT/IX+dS87
X-Google-Smtp-Source: ABdhPJw6OtW3SHgLEK9zOSMWCCWDXvtAkyc1UAExuJyh5PkdiJEqqN00w8ZTT/LA7MSLWKpRgzoFpg==
X-Received: by 2002:a0c:f946:: with SMTP id i6mr19900412qvo.40.1616395177633;
        Sun, 21 Mar 2021 23:39:37 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.40])
        by smtp.gmail.com with ESMTPSA id 66sm10471199qkk.18.2021.03.21.23.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 23:39:37 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] xfs: Fix a typo
Date:   Mon, 22 Mar 2021 12:09:26 +0530
Message-Id: <20210322063926.3755645-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


s/strutures/structures/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b4186d666157..1cc7c36d98e9 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -158,7 +158,7 @@ xfs_end_ioend(
 	nofs_flag = memalloc_nofs_save();

 	/*
-	 * Just clean up the in-memory strutures if the fs has been shut down.
+	 * Just clean up the in-memory structures if the fs has been shut down.
 	 */
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		error = -EIO;
--
2.31.0


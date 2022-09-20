Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBD3C6FA82
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 20:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiITUiL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 16:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiITUiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 16:38:10 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61F775CCD
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 13:38:09 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id u132so3843813pfc.6
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 13:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=G/0C7B0+iUHvJRByQjvKcXu0NCmE5hXSQbkmPmEaE54=;
        b=A+HfHZDp9QyXQCYio6r4kU2757b1XB+f+RMMLqGQp0ZT+s0kgZvMAdxOxA3/aawupq
         tf0Lwp+6gF3XveAe+fpDTPAH6sYOK6u+SBQLucFuugSNDdKfQD76DmxlPhNQLj7x8cB4
         kEwIMXah2JhsWjhNRTzqmfYdNTDXVDgrDPQqQno3vbjZcrTWZQLYHFv6zZltMRfYHVna
         c2yt8fZNe3bOL+3uyO+2bxm3LVmTZ0WaJx3SOixDvhppQgQ6CAndgq/aMARPdDEQpPC7
         ouQ1g5US3LxFho2RdUPEyDpzvSHMFPKkELVQoxSVEb3v4OjGer3ChBEOxwlwEsRH9RcD
         yPPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=G/0C7B0+iUHvJRByQjvKcXu0NCmE5hXSQbkmPmEaE54=;
        b=x+LzqjVdsM0wD8ysgP8MyweAvSDbNZbO5657+6//nmfQcRU/BOKxGhrhiQhv5cDe7f
         OP/nJQC9sspoNENDBp2HCoimKqM5abmPbDCvmXA3QIlpd3n6SI+n2Ib4eMs6axmLcV45
         GspNYbOxdA6zp+piB3hBW1X9JTau0IE2f3Rc83qPD00fWB8WtQDtOTFJA+iy0AY3M6jt
         LlNn1GFhG0P8WOJM4NVOSWfCMF+clPaHkZvv88bRMaNTkvvyOhew8kIwOyOnbLuxK6Li
         gxefnq1nOcLq+4p0QHqHaOfDaxnk3+gNQWKaPPTnjgG002Vd8yJoEu3G5GrI/SwyBsMR
         pvZg==
X-Gm-Message-State: ACrzQf0weRutdc743pcbcuq/g0ZuRX89RMBdfRBZcHlA6pccswiwHKvA
        OKb0xSkHmeObx4PKZnO0F1STK08Rl4kw5g==
X-Google-Smtp-Source: AMsMyM48rqsShLZ06uTj1sdoryqkLqWNiwoe2wpWHUQZV0WrBt1QeWTBjN7daFMYrCzlMoJqQBpTYQ==
X-Received: by 2002:a63:1317:0:b0:42a:e7a5:ef5a with SMTP id i23-20020a631317000000b0042ae7a5ef5amr21930254pgl.392.1663706288877;
        Tue, 20 Sep 2022 13:38:08 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6d85:bae2:555b:c2bf])
        by smtp.gmail.com with ESMTPSA id z9-20020a170903018900b00177c488fea5sm365963plg.12.2022.09.20.13.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 13:38:08 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 2/3] xfs: fix xfs_ifree() error handling to not leak perag ref
Date:   Tue, 20 Sep 2022 13:37:49 -0700
Message-Id: <20220920203750.1989625-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
In-Reply-To: <20220920203750.1989625-1-leah.rumancik@gmail.com>
References: <20220920203750.1989625-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 6f5097e3367a7c0751e165e4c15bc30511a4ba38 ]

For some reason commit 9a5280b312e2e ("xfs: reorder iunlink remove
operation in xfs_ifree") replaced a jump to the exit path in the
event of an xfs_difree() error with a direct return, which skips
releasing the perag reference acquired at the top of the function.
Restore the original code to drop the reference on error.

Fixes: 9a5280b312e2e ("xfs: reorder iunlink remove operation in xfs_ifree")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 36bcdcf3bb78..b2ea85318214 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2634,7 +2634,7 @@ xfs_ifree(
 	 */
 	error = xfs_difree(tp, pag, ip->i_ino, &xic);
 	if (error)
-		return error;
+		goto out;
 
 	error = xfs_iunlink_remove(tp, pag, ip);
 	if (error)
-- 
2.37.3.968.ga6b4b080e4-goog


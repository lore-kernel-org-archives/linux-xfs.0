Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B1EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 16:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239843AbiERQBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 12:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239876AbiERQBj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 12:01:39 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D8D12B01C
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 09:01:39 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id c22so2558309pgu.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 09:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=T6Jr0421jqt3AB0cNQHmtThD1ifxOvcUoS1NPKVt22w=;
        b=f9iEJHuX6TDQ/gD3vGvayymrOMamFtA7AKHx8cWtnXJLpAC2CTOD0ARGfelwTRK/Ad
         J16ltbRw/Tbd1XOD26+ylCco6bHRoZbfYp0bFRBsEw3WDvDm3VeWFuKLtEN1uF+2w96G
         OBvWv2uCRVv1I4uEjiISLv4cKS/SkIhaav4DXAIUmyfMiHQxekD4H8QQY6bcvGkVKhf+
         BqMJbocaKf4pRDtTUJTjxw8V5G8fFXspJvE/sNjNXanuDxF87Ac2anjlkBaNG1ipp0ce
         YEHKbVKBINaxuLlzLWbJxZAqJcih8VB3m4Ata1K0g+CbWPEl2XCY2J5sTEvXmAZ4PXkB
         gSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T6Jr0421jqt3AB0cNQHmtThD1ifxOvcUoS1NPKVt22w=;
        b=WE4m220AqWOpGRdZUzHGVoR32xe/iI+HJOVHbP+nQSY5KV88CQoJaB0Xuu7B+LtPLE
         zbV0+fmGS8cMmTjxPPj8Lbd5rpmjH/jeDc8HO0iZ0LkOzs8DTV+duVX+O6fUJQpIIuAk
         qsvya1qO6OEk7wXuuJtX9rHwIUnfS55U3AOWJLMLYKu/iQOHE2eVXwoNn+6HRfPx0qsi
         lwutgrKqIYm6gv48aEgLr2FF7ic3Bw9QGFf3dt1x0pJ1hLSoDv4j5NUgO9dA6dvcx2XG
         6w+8AOo6F7tSMrqY5FqGvhq6bwaQ232T/hKNGJ32DvgExicExxJgT39i+ojHW+TKfAmZ
         WqBg==
X-Gm-Message-State: AOAM530BSzECo4EBDEb7DEPgjzz4+5R55+z4m3QWn56QgTtOyVjqRb2G
        cOKMCe3ZLgxX6WxRmXNtsA1C9IfaLg==
X-Google-Smtp-Source: ABdhPJyJdclDSBJGyK9SmW+u7m4243d/muUAFRRdflsp79t5fdcdmcvAQkzqP49QRrF0xyc+gH7oWg==
X-Received: by 2002:a63:583:0:b0:3f2:3f20:ec1a with SMTP id 125-20020a630583000000b003f23f20ec1amr155833pgf.460.1652889698325;
        Wed, 18 May 2022 09:01:38 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id s44-20020a056a001c6c00b005181133ff2dsm2125581pfw.176.2022.05.18.09.01.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 May 2022 09:01:37 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: reduce IOCB_NOWAIT judgment for retry exclusive unaligned DIO
Date:   Thu, 19 May 2022 00:01:11 +0800
Message-Id: <1652889671-30156-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Retry unaligned DIO with exclusive blocking semantics only when the
IOCB_NOWAIT flag is not set. If we are doing nonblocking user I/O,
propagate the error directly.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5bddb1e9e0b3..250a3f97400d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -576,9 +576,9 @@ xfs_file_dio_write_unaligned(
 	 * don't even bother trying the fast path in this case.
 	 */
 	if (iocb->ki_pos > isize || iocb->ki_pos + count >= isize) {
-retry_exclusive:
 		if (iocb->ki_flags & IOCB_NOWAIT)
 			return -EAGAIN;
+retry_exclusive:
 		iolock = XFS_IOLOCK_EXCL;
 		flags = IOMAP_DIO_FORCE_WAIT;
 	}
-- 
2.27.0


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E85C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Dec 2020 12:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BF992225E
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Dec 2020 12:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438868AbgLLMtO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 12 Dec 2020 07:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgLLMtN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Dec 2020 07:49:13 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5C7C0613CF;
        Sat, 12 Dec 2020 04:48:33 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id v3so6107502plz.13;
        Sat, 12 Dec 2020 04:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bRL8EJ6k0luwxGr9nyjGvaWnrmapiVGTB3Vjulf/n54=;
        b=bdiv3BUJLeX5IMffHi06X6meOenP1C6uAiXHV0hhGOkIQvrOJfxwCrt3TOAI2UkCcl
         jOxlK7o2mlakk+97lvW7VuWoh45zgvyQs9qgxssiWOPwCG5sdj7dlsdoX06EQHSjnFpL
         dnfBaEthN3gKySJdR8AYZOJYAItj8YjrMchM+2rVvGiLPuvFignnwaOpLvTQIoN7/1Cy
         a2fTl9b2RnwUNb3Ds5OwHmEK5tE7OlV3FZjgJEYOF3c/9Fcp/sm0RKRQj4AKlnPFUKM6
         WwGP4phz9DXqzw7iiIRboPzraqcshu2gmR1oVeQpMgE+1ld+XhNaAasuI/rQS16NzxNk
         TaMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bRL8EJ6k0luwxGr9nyjGvaWnrmapiVGTB3Vjulf/n54=;
        b=YFG0w2PrfJh9O1o88XD+V2hUmomjlCV8mF1WAOu/g57f1llTzoIlSybBZnvJywPWlz
         hGVmO8AO1+Hng5eQPgAIU4JZEY99s7U7+sS5owrL5tqxwFZf7Iw55xuEUr89df6Q4Qbx
         DwQB2sEnLK7oKFUxCk54jjTYNlgOQ4sTxt7HA7wRTZXDyBiErrmt24e+b2zIfUGzkZdL
         07Xy5oqxrEDhVenDyysMan/jZuL6oZCBuR7v2jhA70fjYLNe/AwaIvWVXSdJuthP3cCC
         SMKPzde4h/8NLfKjDslDRJoXem/KLDfuHGN56Q7+MBYKa5PIbojqHgrNvuWjbKDVGeFb
         8eGg==
X-Gm-Message-State: AOAM531tB9UnD+IvE8h+SEd1EUNSrmyABNac44xIe4+ZFuutKbuaC2lC
        TV+cvr+54nIG9fyj/IEf4ys=
X-Google-Smtp-Source: ABdhPJxPShHkUt1AHHmKCAL1dMN/mFFyk+JZhJsAuXiXfeNf6rYsQwoDZ+NNLbUNdG83nJ9/DnUleQ==
X-Received: by 2002:a17:902:9a0c:b029:d6:c6a3:66f with SMTP id v12-20020a1709029a0cb02900d6c6a3066fmr15104830plp.52.1607777313041;
        Sat, 12 Dec 2020 04:48:33 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id x22sm14548405pfc.19.2020.12.12.04.48.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Dec 2020 04:48:32 -0800 (PST)
From:   chenlei0x@gmail.com
X-Google-Original-From: lennychen@tencent.com
To:     chenlei0x@gmail.com, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lei Chen <lennychen@tencent.com>
Subject: [PATCH] xfs: clean code for setting bma length in xfs_bmapi_write
Date:   Sat, 12 Dec 2020 20:48:17 +0800
Message-Id: <1607777297-22269-1-git-send-email-lennychen@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Lei Chen <lennychen@tencent.com>

xfs_bmapi_write may need alloc blocks when it encounters a hole
or delay extent. When setting bma.length, it does not need comparing
MAXEXTLEN and the length that the caller wants, because
xfs_bmapi_allocate will handle every thing properly for bma.length.

Signed-off-by: Lei Chen <lennychen@tencent.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index dcf56bc..e1b6ac6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4417,18 +4417,7 @@ struct xfs_iread_state {
 			bma.wasdel = wasdelay;
 			bma.offset = bno;
 			bma.flags = flags;
-
-			/*
-			 * There's a 32/64 bit type mismatch between the
-			 * allocation length request (which can be 64 bits in
-			 * length) and the bma length request, which is
-			 * xfs_extlen_t and therefore 32 bits. Hence we have to
-			 * check for 32-bit overflows and handle them here.
-			 */
-			if (len > (xfs_filblks_t)MAXEXTLEN)
-				bma.length = MAXEXTLEN;
-			else
-				bma.length = len;
+			bma.length = len;
 
 			ASSERT(len > 0);
 			ASSERT(bma.length > 0);
-- 
1.8.3.1


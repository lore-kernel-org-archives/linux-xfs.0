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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A661C43381
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AB5A2053B
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbhAZFSG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbhAYJ7L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 04:59:11 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51A1C061353
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 01:58:24 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r38so2642741pgk.13
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 01:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IrbOMXtzOAIl0vAOR1FEblbNFFGcw1TQRM/MD+GrjSY=;
        b=tO/6++0vFuk0HnZHLD7ahgYnYsfGRd/wU6z2z/a7vlALEjZIhlr/lQhzgIrqgUlPa1
         lq+QtndA7mVxg3NyCIZlFJZp2TBX2sUmE/5GmRsC0m0lmq8Kr5GHhyshrCjT8IyH03E5
         r8spd2388JLpnKIczYdQmOS5LS+wDL9TFox3/adOUVXrYEP1sLncOUk+dNX1hEr7B62I
         Z4q1OjYqF9ITaZNL4tSBp10bRaVFAeNmSVxVGQRrS/9VwqUFMUrWxyjsQJprAi0V1ljz
         qfGf4NZegnd+HyEwYsJpSoL+rqedbveFhtPAv2ZXsuhaymeowEoj80lS9pLedun5vBmZ
         n7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IrbOMXtzOAIl0vAOR1FEblbNFFGcw1TQRM/MD+GrjSY=;
        b=G9/e1oV+y97aM5V6/bD0mT2yZ0jdgBRwT9WigwowPezSUFXfHrJrEj4n/n30ZkM7HI
         7Dn4WinsvTG7cvNzS7QkuyrJlXK9+PKvNNj9PO/czL8A4oOotul7v7pgUteOtl/5t7uF
         7SYWrqDf+OJRXmaIMnPncMOBCCbj0Wv2DYE8tMuSvwjQ+7vClTS2JlfaHiz4GfrHejHT
         uUPkHcaeLjCX4n93xXPnMoreMFaGW+RI1KtFVr3ZdklJ5yIqQBiukeXZIs/MdGJ/Cgeg
         yHjnYvbfDEO23VFRTQv9rfOiuOOP4dN+sDSiKLc8Faec21uDPxOPKg4oABlfk4QrWc1v
         h29Q==
X-Gm-Message-State: AOAM532iJE6abT/fmoCXXdumAq3If91aBTCFUULY9d7KvfaiaK1wbEMT
        Kmqr9eRO3tdc2CusKDyOABTV4vkmLOg=
X-Google-Smtp-Source: ABdhPJwHgwQSozk6dk10LbrCHTS4vqgSYIlvjNir32U5PZ4klmqt39w2HEsk7n6eKBxXNklfRU6Cvw==
X-Received: by 2002:a65:6152:: with SMTP id o18mr555671pgv.392.1611568704097;
        Mon, 25 Jan 2021 01:58:24 -0800 (PST)
Received: from localhost.localdomain ([122.182.225.185])
        by smtp.gmail.com with ESMTPSA id e20sm2680269pgr.48.2021.01.25.01.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 01:58:23 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, sandeen@sandeen.net
Subject: [PATCH 1/2] xfsprogs: xfs_fsr: Interpret arguments of qsort's compare function correctly
Date:   Mon, 25 Jan 2021 15:28:08 +0530
Message-Id: <20210125095809.219833-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The first argument passed to qsort() in fsrfs() is an array of "struct
xfs_bulkstat". Hence the two arguments to the cmp() function must be
interpreted as being of type "struct xfs_bulkstat *" as against "struct
xfs_bstat *" that is being used to currently typecast them.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fsr/xfs_fsr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 77a10a1d..635e4c70 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -702,9 +702,8 @@ out0:
 int
 cmp(const void *s1, const void *s2)
 {
-	return( ((struct xfs_bstat *)s2)->bs_extents -
-	        ((struct xfs_bstat *)s1)->bs_extents);
-
+	return( ((struct xfs_bulkstat *)s2)->bs_extents -
+	        ((struct xfs_bulkstat *)s1)->bs_extents);
 }
 
 /*
-- 
2.29.2


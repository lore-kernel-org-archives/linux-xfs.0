Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D91CC35266
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAEDB2078D
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+/2XzTs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgIQE3C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 00:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQE3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 00:29:01 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1504C06174A;
        Wed, 16 Sep 2020 21:29:00 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 7so591119pgm.11;
        Wed, 16 Sep 2020 21:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9DWVWkszMPKfRkULRly7P6KDkkzxbhQNqxsXCnDa3Q=;
        b=a+/2XzTsFii166iqcEbXCmmMLxa+cbpoGYboBGexCY/0RQV0KAcx2j49iesL11YoTf
         RZJrP86z/CAiKHDjEKynOvh57ECDzDLYwWjgr2QbldtVHEf0VN6MQBvfYZF701IhK76e
         DqGNSEPM5j+xqT2OMEjw1N7ElG4CFQtABbydugiDNcGKlthrZaBiy9l9n7DSZANO0+/L
         S6ilWEequg2tQyFu19EBrmwA3mDL42vSSCnDgV3RFOlHuuPASeVLLmNwRFX91bnT9Klj
         vv5i9YdkQwn8OHuvS1nKln4ze90mVLc9yfU+w8Xo3Tf6G/FAc8VkQhLu+snXiHsZEghW
         SKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9DWVWkszMPKfRkULRly7P6KDkkzxbhQNqxsXCnDa3Q=;
        b=jSpT/Nlh947szLWQZ1F2P7e97eX7M3N3nCphWVLTwB7/ItYDSENpPRyAtm70AhaANN
         CS5WA0abI2r/ZEg5siJakehZ3vxsT7U3mJFvmmn0dr21MsIc2o5jJbh1iZig9HgkqJuy
         Zm4ZHTS/YEL7Au+ruiND8FYS7TjVA5RdXAwLgI6hCUDbV8oRqq6wtLD5bFW5yT/AKvfy
         jLg3Fx6humRF28WaebbldqJ1+z9MvL1TRTP/L4WLzV7VMhh0Haj1pMkgBzsC9pwd8fDB
         1x4uwnh6YiPcP7CRPNpijFEtHZxqPcxPAlF0aU3fD07uEJKSZkUof+UrpjFuJcdYGqS2
         jqeg==
X-Gm-Message-State: AOAM532rfxeAj9sthdSgWXH8lRJP/IY14ZCakfsxGYOWqu10cj90CtUF
        dFxyVTqlX4ol/UVuTVUsnVX3fW3ovtE=
X-Google-Smtp-Source: ABdhPJwWVwa8LljcG7yjG3Z59u/+wE/f93Ie+/7cUVLa+7MAGD+pTZJa/tqKe5rn014cK2w6Vts7VA==
X-Received: by 2002:aa7:84c5:0:b029:13f:ed60:b20b with SMTP id x5-20020aa784c50000b029013fed60b20bmr15672039pfn.26.1600316940070;
        Wed, 16 Sep 2020 21:29:00 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.198])
        by smtp.gmail.com with ESMTPSA id 31sm15955885pgs.59.2020.09.16.21.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 21:28:59 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, guaneryu@gmail.com,
        darrick.wong@oracle.com, zlang@redhat.com
Subject: [PATCH 1/2] xfs: Add realtime group
Date:   Thu, 17 Sep 2020 09:58:43 +0530
Message-Id: <20200917042844.6063-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new group to classify tests that can work with
realtime devices.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/group | 50 ++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/tests/xfs/group b/tests/xfs/group
index ed0d389e..b99ca082 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -87,11 +87,11 @@
 087 fuzzers
 088 fuzzers
 089 fuzzers
-090 rw auto
+090 rw auto realtime
 091 fuzzers
 092 other auto quick
 093 fuzzers
-094 metadata dir ioctl auto
+094 metadata dir ioctl auto realtime
 095 log v2log auto
 096 mkfs v2log auto quick
 097 fuzzers
@@ -119,7 +119,7 @@
 119 log v2log auto freeze
 120 fuzzers
 121 shutdown log auto quick
-122 other auto quick clone
+122 other auto quick clone realtime
 123 fuzzers
 124 fuzzers
 125 fuzzers
@@ -128,7 +128,7 @@
 128 auto quick clone fsr
 129 auto quick clone
 130 fuzzers clone
-131 auto quick clone
+131 auto quick clone realtime
 132 auto quick
 133 dangerous_fuzzers
 134 dangerous_fuzzers
@@ -188,7 +188,7 @@
 188 ci dir auto
 189 mount auto quick
 190 rw auto quick
-191-input-validation auto quick mkfs
+191-input-validation auto quick mkfs realtime
 192 auto quick clone
 193 auto quick clone
 194 rw auto
@@ -272,7 +272,7 @@
 273 auto rmap fsmap
 274 auto quick rmap fsmap
 275 auto quick rmap fsmap
-276 auto quick rmap fsmap
+276 auto quick rmap fsmap realtime
 277 auto quick rmap fsmap
 278 repair auto
 279 auto mkfs
@@ -287,7 +287,7 @@
 288 auto quick repair fuzzers
 289 growfs auto quick
 290 auto rw prealloc quick ioctl zero
-291 auto repair
+291 auto repair realtime
 292 auto mkfs quick
 293 auto quick
 294 auto dir metadata
@@ -329,17 +329,17 @@
 330 auto quick clone fsr quota
 331 auto quick rmap clone
 332 auto quick rmap clone collapse punch insert zero
-333 auto quick rmap
-334 auto quick rmap
-335 auto rmap
-336 auto rmap
-337 fuzzers rmap
-338 auto quick rmap
-339 auto quick rmap
-340 auto quick rmap
-341 auto quick rmap
-342 auto quick rmap
-343 auto quick rmap collapse punch insert zero
+333 auto quick rmap realtime
+334 auto quick rmap realtime
+335 auto rmap realtime
+336 auto rmap realtime
+337 fuzzers rmap realtime
+338 auto quick rmap realtime
+339 auto quick rmap realtime
+340 auto quick rmap realtime
+341 auto quick rmap realtime
+342 auto quick rmap realtime
+343 auto quick rmap collapse punch insert zero realtime
 344 auto quick clone
 345 auto quick clone
 346 auto quick clone
@@ -402,10 +402,10 @@
 403 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 404 dangerous_fuzzers dangerous_scrub dangerous_repair
 405 dangerous_fuzzers dangerous_scrub dangerous_online_repair
-406 dangerous_fuzzers dangerous_scrub dangerous_repair
-407 dangerous_fuzzers dangerous_scrub dangerous_online_repair
-408 dangerous_fuzzers dangerous_scrub dangerous_repair
-409 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+406 dangerous_fuzzers dangerous_scrub dangerous_repair realtime
+407 dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
+408 dangerous_fuzzers dangerous_scrub dangerous_repair realtime
+409 dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
 410 dangerous_fuzzers dangerous_scrub dangerous_repair
 411 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 412 dangerous_fuzzers dangerous_scrub dangerous_repair
@@ -415,7 +415,7 @@
 416 dangerous_fuzzers dangerous_scrub dangerous_repair
 417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 418 dangerous_fuzzers dangerous_scrub dangerous_repair
-419 auto quick swap
+419 auto quick swap realtime
 420 auto quick clone punch seek
 421 auto quick clone punch seek
 422 dangerous_scrub dangerous_online_repair
@@ -477,8 +477,8 @@
 478 dangerous_fuzzers dangerous_norepair
 479 dangerous_fuzzers dangerous_norepair
 480 dangerous_fuzzers dangerous_norepair
-481 dangerous_fuzzers dangerous_norepair
-482 dangerous_fuzzers dangerous_norepair
+481 dangerous_fuzzers dangerous_norepair realtime
+482 dangerous_fuzzers dangerous_norepair realtime
 483 dangerous_fuzzers dangerous_norepair
 484 dangerous_fuzzers dangerous_norepair
 485 dangerous_fuzzers dangerous_norepair
-- 
2.28.0


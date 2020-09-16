Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B906AC43461
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 05:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F34D221E7
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 05:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f4naeCDi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgIPFea (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 01:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPFe3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 01:34:29 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F89C06174A;
        Tue, 15 Sep 2020 22:34:29 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u3so948209pjr.3;
        Tue, 15 Sep 2020 22:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AfgkVm4p3IXckQJHDq4r+poVhTpZA9EBLPkqxuaAmr4=;
        b=f4naeCDi/JXnIXkW27+bp9vhpLWLrKGD9jCP+QRbAeeAbXsFa7QdsShelDsgs97ue9
         mpPxLIBzeH/W/T2wjnSpCv5W9kB4cxVS0FeAWchIFI1bOArGSIkc/Fo1HSxRCZZYU5HQ
         swljAYZuBIYmHVbZCiICKRHsbJeotFYdzCyDYf2/Yh22iVtdSVk3GRFnbcMZ3ivYZYwv
         uN4QHgupSyrU/ZhYh0Py6r1OCqyBHsDQ97C70y1CmE57Rvzg9De5CgDqQRjHTIstGJ9C
         yP27gt3DnnPxfNUwe3ynLGzvGS7hObl0DdmoOR0++UMGZFOwqvC0Myvro7ZdXaBxEJ66
         LdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AfgkVm4p3IXckQJHDq4r+poVhTpZA9EBLPkqxuaAmr4=;
        b=p1JdWfahm2jEhyaq1ExVkUSwbWqIS9k4nS3DWRL0H5W3cB24sVJW0Kw/sD6BMgq1fr
         r3EKAqgoCJSKTAhjI6I90ejkoZkDK3iPO70XhRLM10Kk/O+dJJOACr61btmBvYwKijf8
         f2kEckAWpSa3tC4XDWx0zqzFJvN5fe05Azv7m5syaxPmuT4f9EcF0xFOKUoErBXx7+pJ
         PCEclhkJJSKViUZ3NomsXqVPkZVktg5TKYc5rl+CS4AJqdPZyMFBUJFP6Cvs5hhrDQsD
         OxnDBL1UlWZNfAsYeM5Bxrw+Ts90syYpCVaZ6WJHmn76g9cCLrTyiyhlT6c0RfNMbuRj
         aIcQ==
X-Gm-Message-State: AOAM531+tNT0AGRWkQskWVCVKk1/BJLj5isVgIIa+WI6M7Mq6isoAaiR
        6iMD7WRC7m7NY0JDEw7OdWgs4fXCOPU=
X-Google-Smtp-Source: ABdhPJzcUi+GVgnjEy1Yh4jKBq0Ukinv8chM/tU1Xx5epcoB3PdIs2h7nF0DnmmLmekmIzEQu2nD5A==
X-Received: by 2002:a17:902:9349:b029:d0:cb2d:f26c with SMTP id g9-20020a1709029349b02900d0cb2df26cmr21779976plp.5.1600234468538;
        Tue, 15 Sep 2020 22:34:28 -0700 (PDT)
Received: from localhost.localdomain ([171.48.17.146])
        by smtp.gmail.com with ESMTPSA id m25sm14901701pfa.32.2020.09.15.22.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 22:34:27 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, guaneryu@gmail.com,
        darrick.wong@oracle.com, zlang@redhat.com
Subject: [PATCH 1/2] xfs: Add realtime group
Date:   Wed, 16 Sep 2020 11:04:06 +0530
Message-Id: <20200916053407.2036-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a new group to classify tests that can work with
realtime devices.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/group | 52 ++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/tests/xfs/group b/tests/xfs/group
index ed0d389e..3bb0f674 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -67,7 +67,7 @@
 067 acl attr auto quick
 068 auto stress dump
 069 ioctl auto quick
-070 auto quick repair
+070 auto quick repair realtime
 071 rw auto
 072 rw auto prealloc quick
 073 copy auto
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


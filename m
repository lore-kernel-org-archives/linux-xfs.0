Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC7FC43464
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 03:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F5D423730
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 03:30:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MSCi5WOh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIRDaY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 23:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgIRDaY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 23:30:24 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98577C06174A;
        Thu, 17 Sep 2020 20:30:24 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id u3so2280740pjr.3;
        Thu, 17 Sep 2020 20:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkdXd7rhWa2AHDPr/fZYXzerJHd+2RKkZy2grOonv+E=;
        b=MSCi5WOhDtn0nAYN1w5i7So0qSyQg5ZYRSdUBE95bhNdzrdebJ7X+G6uX2+hhe0eVZ
         YXZwlwx7LWXrv67usCB/IheU6yC+fOxn/j4BDok+HQ81HrFRfME4cvQLZ0IJbNCTeOBm
         6EgaVe2HO+aZGdcXSlvAHpZRVQF4s23CCASBW3P0uT753IetuhCsiLluMQ/Ap/Y0lLyS
         UQDNvPGGrIipCP4aXiN29IM8pVnrf18W6pqlkVaDcckMRPixfmuE00DkDG9hjb3bepCy
         3UE6lTQkqDqVjpGllwjtWvOLk2utU3XT4PIHKgGAA6+QRWp4/pmDTSYVzquZT8yOQ9Uw
         pYEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkdXd7rhWa2AHDPr/fZYXzerJHd+2RKkZy2grOonv+E=;
        b=qLqW+70cidjWUUQxhXMoFfM8le7MXDnjtC9bxi2ZIvMBHWukjpGZNB7VoqT7NnOXoy
         O1zkwyPNa6pwcpfKdg0HKjW7hHMf3PVmK/d+mXceR8k6d/JmQyd+0Bq2EOHau3Remgu5
         zFwJDBKlM8Mfld8zx5fyomRvRj0VUjNMWcj1mdYFqBNvflk98UFZqTNq+L8tQPakGj+p
         vF78D1wJCrcVQnxEdyUITOAF27XobLVB2xAokujanrbX1V2R1CWG+/phuktJRK67K7Vh
         mhRfZNEQAe9bLmF2ocY9lI4i6nk/fdU9eh9O6WSf5VHvgH1sU9wb1Zxw4UIcDAkDWlBP
         oVBQ==
X-Gm-Message-State: AOAM5311G0kyXdZecN/vzOSR6yxaHY6skWf70SH0ivu7QDCala6Nl9/3
        dTAYVmg5Hyxjj00xefuIYGMh0mLJMNs=
X-Google-Smtp-Source: ABdhPJx5Oofme1x0cAr2x0A02EFukfsArQFvYA+e8me/O8q1GvxoserRcFbSuDixTSJOYXGeNJsZzA==
X-Received: by 2002:a17:902:7103:b029:d1:e5e7:be75 with SMTP id a3-20020a1709027103b02900d1e5e7be75mr13502021pll.79.1600399823807;
        Thu, 17 Sep 2020 20:30:23 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id v21sm1111436pgl.39.2020.09.17.20.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 20:30:22 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, guaneryu@gmail.com,
        darrick.wong@oracle.com, zlang@redhat.com
Subject: [PATCH V3 1/2] xfs: Add realtime group
Date:   Fri, 18 Sep 2020 09:00:12 +0530
Message-Id: <20200918033013.10640-1-chandanrlinux@gmail.com>
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

Changelog:
V2 -> V3:
  Remove xfs/291 from realtime group. Darrick, sorry I missed this one
  before sending V2.
V1 -> V2:
  Remove xfs/070 from realtime group.
  
 tests/xfs/group | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/tests/xfs/group b/tests/xfs/group
index ed0d389e..b8374359 100644
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


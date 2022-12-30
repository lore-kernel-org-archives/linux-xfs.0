Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BDEC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbiLaDSG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbiLaDSF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:18:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF7F55BF;
        Fri, 30 Dec 2022 19:18:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23F56B81DDB;
        Sat, 31 Dec 2022 03:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C327EC433D2;
        Sat, 31 Dec 2022 03:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456681;
        bh=ZRJPF0uRKcrpXq4DlcvL0kg27K8N2R3k5+5g2K1s3wg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BXPcEn1VFvYA44wxGKgpk5ldlFTn7UsZ+o0B8w0sLBN9SZ+d2+BfJPu64HfxFAgrK
         XaoQKxavVJeNluM6597ufyf4UNMTt9lPjPxOwfByk7UI+PWeDByzYkRcSieOa90GgH
         IJwHR/1s9fsG9K6hSy4Ge+hRIWZyi2yTHOxp5Cv9Pp7VU6LqnN5YMybQFzzzrdzTWA
         hdciwmH3JFHGGcqkcT/GPphrJ2FrWbRkHYKIk3pPQ3pFbEKZwAR3HG2wRsF70JcVQQ
         Yg1L2uHJcCi1FCFue1WRvluVe4nMKyYhttYMfg2hDjl/Kck8kKgYChIQktNleCA50K
         NCr0ea1JavJuw==
Subject: [PATCH 08/10] xfs/769: add rtreflink upgrade to test matrix
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:49 -0800
Message-ID: <167243884959.740253.1741124706572702348.stgit@magnolia>
In-Reply-To: <167243884850.740253.18400210873595872110.stgit@magnolia>
References: <167243884850.740253.18400210873595872110.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add realtime reflink to the features that this test will try to
upgrade.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/769 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/769 b/tests/xfs/769
index ccc3ea10bc..72863a6e83 100755
--- a/tests/xfs/769
+++ b/tests/xfs/769
@@ -196,12 +196,13 @@ function post_exercise()
 # upgrade don't spread failure to the rest of the tests.
 FEATURES=()
 if rt_configured; then
-	# rmap wasn't added to rt devices until after metadir
+	# reflink & rmap weren't added to rt devices until after metadir
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
 	check_repair_upgrade bigtime && FEATURES+=("bigtime")
 	check_repair_upgrade metadir && FEATURES+=("metadir")
 	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
+	check_repair_upgrade reflink && FEATURES+=("reflink")
 else
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")


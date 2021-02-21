Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3123DC433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 09:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 009A364EB3
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 09:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhBUJlB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Feb 2021 04:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbhBUJkh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Feb 2021 04:40:37 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44514C061574
        for <linux-xfs@vger.kernel.org>; Sun, 21 Feb 2021 01:39:56 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id 7so15813504wrz.0
        for <linux-xfs@vger.kernel.org>; Sun, 21 Feb 2021 01:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t/TVIMRsmutQLpepsAFKd0Pnt/rt+FRP7RsQQFJU2TA=;
        b=CHAl9MfnKKH33OU/5T6UnXyLG/R7EolJj6eED22rSi2KUqWnlr7OcQ6tIvWygzXQ4z
         EqpvlwM9toVtEHf4LlVawApx1s477OGrRfHWwcOpwf5Jnw8IZpktoTA0V76JkyoN2E2/
         S5QnsGx90+duBvSkjtn6BGVp58uTu6BmluzJgAnUXh5FMl21gpJhrFShsCKP+dvFfO6+
         AsDgd+EBSgU+1K1rioeqW0LgJzCrl5QI/1IzsFAEbbG9fBSlFQPUkvk0LJpGT3RdNd5l
         3hyQGk3O2xgCpol/8KwaZeDgzA1KHtTTiB7Yn1CbMdetxmzNfgJVcKOz+x39eGTqFEIW
         fmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t/TVIMRsmutQLpepsAFKd0Pnt/rt+FRP7RsQQFJU2TA=;
        b=PdfCxRp8wG/EKQ+t8VeF7joM2EX6hlNN4qsMg2eszyMOILdLjyrouMiWRqov5oA1jJ
         1+f+e0g4EARMfRbKtcZiRsG+1/9eVJJBucy7jMWCEws+YDfW5OT62Uzua5PZfM10Rs1E
         04iVIrqjUD0EWnj4D0A0GDUAvOyd6tkcL955scn4243gDINsbjsS78jezMs7m6hozIXI
         Q1/IZWP/Khn4WStw3h8tG6InlR+UnutsvaMGXTR+iVYrYkvv2pO8HOYXLAE0qdLmVd/l
         fj5jbA0yXF2bW/T/9kvSMLYkvZSeaRlqHqWBlT0vHvp3CSI97W60Zlza58LLEBkv+REl
         dB0Q==
X-Gm-Message-State: AOAM531L86zu4y801pNgw1+Umhboenl59bv+NlvRheoTTFU/7ucxqpqH
        uGG5Za4D9CUJ8TeV1jCHl1xdbf4L9yTswA==
X-Google-Smtp-Source: ABdhPJxa+pdnlufYg55ZaBZZwF+s8jq87EhAPsDQxL2mIZu65+539VFjIXUDVCPLkOlHau5TqcByuQ==
X-Received: by 2002:adf:cd91:: with SMTP id q17mr5054092wrj.228.1613900394941;
        Sun, 21 Feb 2021 01:39:54 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id 7sm11273845wmi.27.2021.02.21.01.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 01:39:54 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH v2 0/2] debian: Fix problems introduced with 5.10.0
Date:   Sun, 21 Feb 2021 10:39:44 +0100
Message-Id: <20210221093946.3473-1-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There were two bugs introduced with the 5.6 -> 5.10 change in Debian:
RISC-V does not build. Fix that by regenerating it.
The new libinih package did not have a udeb package which is needed by
xfsprogs-udeb. Explicitly depend on newer libinih versions.

Changelog:
 v2: Drop Dimitri's Ubuntu changes (related to CET)

Bastian Germann (2):
  debian: Regenerate config.guess using debhelper
  debian: Build-depend on libinih-dev with udeb package

 debian/changelog | 10 ++++++++++
 debian/control   |  2 +-
 debian/rules     |  1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

-- 
2.30.1


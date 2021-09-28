Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AA6C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 240CB60D42
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238336AbhI1A1n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbhI1A1n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 20:27:43 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A03C061575
        for <linux-xfs@vger.kernel.org>; Mon, 27 Sep 2021 17:26:04 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id b192so1949415wmb.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Sep 2021 17:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=stNblUEltNnbJlko2VRTFD7ipHRkldkQJMsYEjE8bO4=;
        b=rGyIDEVkOwAaShuumlfQVBCXkfhSZ8jwM1T8cR1pc6VO6/1CWm65y0zCfUIb69CoHQ
         rTB4RMz+qEGizw7aT93uUnjUjf8BcCqYUmhnJy+XD2AgIjaUPJxf8mN9tHDjMSWoJMBu
         a/DyOn3nnsDyny0cUjqRay70Nw7DD+bqQZnFhIBr5LEhBtgeqtRrVD80GOYSr0m783So
         I81CmNXTr55Uds/KHj/TcxTeXRueXhZ4fyMysSOOfVtomoaOJ4qPyKIO3GYbzZhMxrBh
         Hz0n2Lnhu+C3n7PVYYwHY6Yp9h9Udrz3KZImvUxuTPgIH/xmwEeiU6T0W9WT4Gg9PQ1m
         UyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=stNblUEltNnbJlko2VRTFD7ipHRkldkQJMsYEjE8bO4=;
        b=TnKmF0RGZ+huTkxdzWkD1J1PMJIx/BsrcB8ErLgw7KqYSEB70sdgmM47PJY71Qivd/
         R3lXBLpYAY676iI1mhC8vw4Ivb+QIZqAGuHro7yXTqw9LECHaJBtsHoeRCcBUIvTiumO
         nDux9PRU7lpdkFd+GWhajBbnZSaNb4cVO1yefKKmLsTObeBre4lu9+u+Bupy3bq+b80r
         k46VQsLWmkSg7GgQVJjH02t5LMztJJvAAWJP008OLkUnYX2A38Yv6VKeu0R1cAehwgTO
         Gy4j+8gU8/tj0h5B/W2XrsXRYIv0fPuL5Hf/JBV0VBpj8/fw9Ykrngs2kVmp/+rCmDlR
         OeGA==
X-Gm-Message-State: AOAM533R+eqnFBc9LBMNS4UM2Lar474TQd8oWvODnAZHLe0dy+iWdicc
        plzdE4HZ1tNAda2tQGcO/8wRxsUGwyd42YsHQkw=
X-Google-Smtp-Source: ABdhPJyEhPMRMc8NKAB81jD7ZHedOjSJBnzZ/xMmQZEKMYqJDaqwvXtef/RPNDNkp5NxW5MaLTHzLA==
X-Received: by 2002:a7b:cc14:: with SMTP id f20mr1771319wmh.137.1632788763572;
        Mon, 27 Sep 2021 17:26:03 -0700 (PDT)
Received: from thinkbage.fritz.box (p200300d06f1f7300176a2a162e6525fe.dip0.t-ipconnect.de. [2003:d0:6f1f:7300:176a:2a16:2e65:25fe])
        by smtp.gmail.com with ESMTPSA id p3sm4755814wrn.47.2021.09.27.17.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 17:26:03 -0700 (PDT)
From:   Bastian Germann <bastiangermann@fishpost.de>
X-Google-Original-From: Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>
Subject: [PATCH 3/3] debian: Tag xfslibs-dev "Multi-Arch: same"
Date:   Tue, 28 Sep 2021 02:25:52 +0200
Message-Id: <20210928002552.10517-4-bage@debian.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928002552.10517-1-bage@debian.org>
References: <20210928002552.10517-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Tag the binary package xfslibs-dev "Multi-Arch: same" because it has all
properties that qualify for this tag.

Link: https://wiki.debian.org/MultiArch/Hints#ma-same
Signed-off-by: Bastian Germann <bage@debian.org>
---
 debian/changelog | 2 ++
 debian/control   | 1 +
 2 files changed, 3 insertions(+)

diff --git a/debian/changelog b/debian/changelog
index 8b5c6037..b1414369 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,5 +1,7 @@
 xfsprogs (5.13.0-2) unstable; urgency=medium
 
+  * Tag xfslibs-dev "Multi-Arch: same"
+
   [ Helmut Grohne ]
   * Fix FTCBFS (Closes: #794158)
     + Pass --build and --host to configure
diff --git a/debian/control b/debian/control
index 57131bb4..11f8cf08 100644
--- a/debian/control
+++ b/debian/control
@@ -32,6 +32,7 @@ Section: libdevel
 Depends: libc6-dev | libc-dev, uuid-dev, xfsprogs (>= 3.0.0), ${misc:Depends}
 Breaks: xfsprogs (<< 3.0.0)
 Architecture: linux-any
+Multi-Arch: same
 Description: XFS filesystem-specific static libraries and headers
  xfslibs-dev contains the libraries and header files needed to
  develop XFS filesystem-specific programs.
-- 
2.33.0


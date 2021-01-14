Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED73C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A1BF23B6E
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbhANSim (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 13:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbhANSil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 13:38:41 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDBFC0613C1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:00 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id g12so9652726ejf.8
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4NoaVPE1adysSdQgYTUV3WGTdbmXRq3qFa6v/dsYBPQ=;
        b=c5M1EyOlFZcxqRJ2ZmOIy7SJ6hscOofnvX6fa5mZag6OdPUZobC+CH9WYL5hEKLStO
         tL55VmKpqCHexQ5X+y7MeQvoaedJs8GN+QpTmjcEWhnCmpuPQlRnn7S1hV3JjUINsBBM
         xZ77UoyEsA+IAgdECqVc4M4fJ5Rns6Qg0CMwYNpZc1jE9NDrttYNmxtMRnVc7a3pn/9m
         CmzrrT9MzpkcSKSlFn3YCG0yeZSk2XM4Q8tRLSCB7xqS1oL195OuRH5kMzE5Sd5odfXX
         73raUCZjvWUH9OjRhfRvv7tbP/5oj6jjmAxmJ99sfl8M0mmVJDLC9Y1sEL5RangnJjYn
         1+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4NoaVPE1adysSdQgYTUV3WGTdbmXRq3qFa6v/dsYBPQ=;
        b=Xl8es7U6o8+QzWAKYOmUHw6aBEjpiqfxnU4cTfmYOMyunxWFY7rwAViwn6+LEwpxxG
         bo/6+zRdqvHiDDAOOCusdn0rdjjX3g8lxMunnevTdU5EuIXExSlwNnnxHCEX8++RwilQ
         f7ZEN2Zu7wcKiw04XQ8pMT/jsVhJiE2mDwVU8Dr4yLfvLSdZHY/nt0FXmYnINpiZmuL7
         NsFy/f2uHko75fNSrfkrE41iRis7TgDf0BQZNlx6Rdea3x+2BCZz39UT2cZ2EidtynEf
         4QN3SEMsZ9wv/XR8zFRECXlARKex+vqmP0U5zWfspvwoEHzlw/87w5bSQ5HJCLrqumMI
         8HYA==
X-Gm-Message-State: AOAM533lK5wR9YazsnFLG9lKpOXyefti/ebYAY0n+w5T/4iJHqIIqHWp
        LKFbF3n/XAsyE0j19mNkP22L6xqGed/Qnaxh
X-Google-Smtp-Source: ABdhPJyakyejbIj9aOl2RWx7mD9G67q7bEGwoVonVVF1z/Amv2qmxxbRt2P5QbhKKIW2pCjhL5pQjw==
X-Received: by 2002:a17:907:b01:: with SMTP id h1mr6104669ejl.450.1610649478955;
        Thu, 14 Jan 2021 10:37:58 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id s19sm2540876edx.7.2021.01.14.10.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 10:37:58 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 1/6] debian: cryptographically verify upstream tarball
Date:   Thu, 14 Jan 2021 19:37:42 +0100
Message-Id: <20210114183747.2507-2-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210114183747.2507-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Debian's uscan utility can verify a downloaded tarball. As the
uncompressed tarball is signed, the decompress rule has to be applied.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
---
 debian/upstream/signing-key.asc | 63 +++++++++++++++++++++++++++++++++
 debian/watch                    |  2 +-
 2 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 debian/upstream/signing-key.asc

diff --git a/debian/upstream/signing-key.asc b/debian/upstream/signing-key.asc
new file mode 100644
index 00000000..5a9ec9b8
--- /dev/null
+++ b/debian/upstream/signing-key.asc
@@ -0,0 +1,63 @@
+-----BEGIN PGP PUBLIC KEY BLOCK-----
+
+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
+=El1H
+-----END PGP PUBLIC KEY BLOCK-----
diff --git a/debian/watch b/debian/watch
index 88f6a0f1..ecf0648c 100644
--- a/debian/watch
+++ b/debian/watch
@@ -1,3 +1,3 @@
 version=3
-opts=uversionmangle=s/(\d)[_\.\-\+]?((RC|rc|pre|dev|beta|alpha)\d*)$/$1~$2/ \
+opts=pgpsigurlmangle=s/xz$/sign/,decompress,uversionmangle=s/(\d)[_\.\-\+]?((RC|rc|pre|dev|beta|alpha)\d*)$/$1~$2/ \
 https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-(.+)\.tar\.xz
-- 
2.30.0


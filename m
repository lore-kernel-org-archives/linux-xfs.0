Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CC2C43331
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10A8123B87
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbhANSiz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 13:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbhANSiz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 13:38:55 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3529C061793
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:05 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ke15so2013090ejc.12
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LkWosuir/GP6qomSqhRhsMKBDpwtYCz5V/XuQvvfqSI=;
        b=im6lSXtwt0KheWA9Ql4xdJ1/mw1FkTo0BojtTxHsW81aPtDtFB5flwV2fTtFh7x84U
         RAhQo/25Pvvfv15ShE6McrZkImQqRhNKwDa6VW0qO42RsdR7nl9G/4+GUjj5RX82kg+9
         IfazecLxJEM6wN12nFn5nTpCv6Vkb+7Ke63kEjDx7ooo+ttdZ/6SvV+eqvYxyE3l7708
         cnibIcwqW1Wv4ktLnmDxFwyLu6BUUWETVeMGMV/CBJxyvl6JJFhR04FJcSPEyeZ/08zM
         6isWF1gs7oDMbcG/fWTzfWYSn/28SCjCUe5SOOWqhXO9vloPl3Jb4MU12N4Hh0Ii9hp9
         COlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LkWosuir/GP6qomSqhRhsMKBDpwtYCz5V/XuQvvfqSI=;
        b=fn60NHWZKh25xVxZTjjt+wiIPNAt24FR3PbUrP45svzAHrsht1KgVvap37CH7lbAtL
         VZAhk8ntMmbH+G6JwfAYf+IisVkg4lOK7MtcBR1FpdYVzp5oI5i/E/dqZcxaeMJAZdFe
         ZWv88idxX2pZSOH1HlBEwQflJ/hioJkvG5WzLaaJpZsABZ/s6Lu9bi7miN5JCvpXl4tp
         ViI/Qo3oITfkSxbI+Ei6mgQSs9CNjEonyFM6/e75XWvzz3ep+GANbPENXD1nXTNYChGc
         hfO7ElLoKy+QJpYdKidYLt88mrYV1jz1UKXazzy6seblfJx7XtEdqF66o9+n6PxU/QXO
         9bXg==
X-Gm-Message-State: AOAM531WwaD1f3c31gMORXKlSIk77kedzEL2L0com0U6d2VKX3VuMqui
        2A0iAnYZ7d4I3+qqkZontNIDq7McPT2BK1Af
X-Google-Smtp-Source: ABdhPJz9MMg00ZBLdf3QuCXzWBaPBnfM23N4YjgC/nRbNjGwjJ8y6kdvNd6ru2jxkhft/t60q24KfQ==
X-Received: by 2002:a17:906:22d4:: with SMTP id q20mr5970855eja.259.1610649484294;
        Thu, 14 Jan 2021 10:38:04 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id s19sm2540876edx.7.2021.01.14.10.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 10:38:03 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 6/6] debian: new changelog entry
Date:   Thu, 14 Jan 2021 19:37:47 +0100
Message-Id: <20210114183747.2507-7-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210114183747.2507-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
---
 debian/changelog | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/debian/changelog b/debian/changelog
index 5d46f0a3..ce4a224d 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,14 @@
+xfsprogs (5.10.0-2) unstable; urgency=low
+
+  * Team upload
+  * debian: cryptographically verify upstream tarball (Closes: #979644)
+  * debian: remove dependency on essential util-linux
+  * debian: remove "Priority: extra"
+  * debian: use Package-Type over its predecessor
+  * debian: add missing copyright info (Closes: #979653)
+
+ -- Bastian Germann <bastiangermann@fishpost.de>  Thu, 14 Jan 2021 18:59:14 +0100
+
 xfsprogs (5.10.0-1) unstable; urgency=low
 
   * New upstream release
-- 
2.30.0


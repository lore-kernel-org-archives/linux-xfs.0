Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261F1C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 12:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD63564ED7
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 12:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhBTMRF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 07:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhBTMRE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 07:17:04 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048E3C061574
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 04:16:23 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id w4so9329175wmi.4
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 04:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CWZO2kjOdnAQribzuDgbDbtNfbHi6yOp4QgUUjTggYg=;
        b=suCd2GTDmlZ8TGlrAXaNlI+ND9Jgu7QrywT4x0VMzbm8nvNgQ1Fgr8080YjBbktBAV
         hynNMQppiivBXpQcMTY5X3OBp4iKHMpQf9DzyQIH42KMCsux+duHiyDoMLGwfNtJzbNt
         wWzXRysIK1+lehiiICxr57KRdJekaEV7g+jt1txZetSdocnIPtDuMZTLk9X3e7DJC3BW
         Hy7a2C++V+CcGIpByJATAgrzzJPaawRWHLyB3b35aeb1aYk6i9SMcJ3oWuoP/OK1sDX+
         tet3sZAlmD+/D5kyvvjCfCwYhkM+DTDakCAxFZB+/hNUx5cRjMlC9GG9IWmFoiTUeZgS
         q8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CWZO2kjOdnAQribzuDgbDbtNfbHi6yOp4QgUUjTggYg=;
        b=laXJ8/yAESnXL4Y/h5hlVm6GMLTvNJ33CfbjdauuTH5VyB/0Np4GkWOtL9uXr5DFdH
         zD9fjN5R2FzztzOcYsgvlWQNJR7yxDtSoHk/RFyZRshkZjyRRMhJorg7fXhPwJUnOggM
         1g2OD/STcr4EjJXRjpiz4JJeAcxbQdKUWJLpiEkZ4ioKTP+76lOc03xucTdXz4RPnAqq
         4hrKl5s7Mah3VNod3OeIFQ7JMsG8GL56ZWh0/m9HUkzqhOKnjG8Zj5SHW9cwAMXDfSTL
         2spolrqWJ78keGk95494h+4Ysg1CSmAtcpcupyM6fIXnA9siyFHBjyoQHCh2mqL6QjQD
         3nYA==
X-Gm-Message-State: AOAM532Rq1rezOMRn3+FvnZi06D0KyRizlZf5o5+IKFKK0u0wmW2jDLR
        VqGfzgHxXcD6H6uVsI5mbutiOuZ7DGFDdA==
X-Google-Smtp-Source: ABdhPJwxkjoVK8AFtx1Iavwm04v0JpJYncNqamRYvAkkNIzlG9DhNjLPAPlK1ChFNwGwGlfd8d4qEQ==
X-Received: by 2002:a1c:9843:: with SMTP id a64mr12165747wme.44.1613823382734;
        Sat, 20 Feb 2021 04:16:22 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id h13sm18708286wrv.20.2021.02.20.04.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 04:16:22 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 0/4] debian: Integrate Debian/Ubuntu changes
Date:   Sat, 20 Feb 2021 13:16:05 +0100
Message-Id: <20210220121610.3982-1-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ubuntu has changes on xfsprogs. Integrate the useful ones so that Debian
and Ubuntu differ less.

There was one bug introduced with the 5.6 -> 5.10 change in Debian: The
new libinih package did not have a udeb package which is needed by
xfsprogs-udeb. Explicitly depend on newer libinih versions.

Bastian Germann (4):
  debian: Drop trying to create upstream distribution
  debian: Enable CET on amd64
  debian: Regenerate config.guess using debhelper
  debian: Build-depend on libinih-dev with udeb package

 debian/changelog | 14 ++++++++++++++
 debian/control   |  2 +-
 debian/rules     | 10 ++++++++--
 3 files changed, 23 insertions(+), 3 deletions(-)

-- 
2.30.1


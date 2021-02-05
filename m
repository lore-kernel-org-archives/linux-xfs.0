Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB3AC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 20:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 855BD64EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 20:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhBESwt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Feb 2021 13:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbhBESwd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Feb 2021 13:52:33 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4C0C06174A
        for <linux-xfs@vger.kernel.org>; Fri,  5 Feb 2021 12:34:16 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id c127so6898466wmf.5
        for <linux-xfs@vger.kernel.org>; Fri, 05 Feb 2021 12:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v6nlP1w1UDl73559MvBbgFYy6HvG/HEBs2Gz7EQUBD4=;
        b=dbkfREIgrBwG/ke9Um1CnwTX3PhTK/9YWTT8GntYc52T2DPx3Q6PvRQiB262rTtPpx
         LwoaKdbpF+3x7NKH/J9ixEXece8U4BqVpz2MhtsiySjtSVtT0JtydGV8MKO2VU3U6iZb
         avYQLlVpbmXKk1wIW2JvHFbHhM0VxUMnsncm+bspDgIt2RmQJa7r5YV1xW3iAt04A173
         V0ceBexjU1zfYuqCkgJS4XfFXPfAH7pdSuwj2k0ED3u9g9wMvXjCBiLupwilph4iRi3G
         DJ7XSZq7d6msHzF7ODS/FgCW1jZNZ5aitccnnlmabR2qospy0uyzkMFjAi6LF7x4G0wT
         1IjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v6nlP1w1UDl73559MvBbgFYy6HvG/HEBs2Gz7EQUBD4=;
        b=DS/MjFd6shB1mR5FB1Zf8igE0bVFaowQiT1ZITLxU4skSyiQcYRXqBBFyNsFaRU+3n
         K7ZWpBdG4zLkLZMg7n7CZBSusNRvTXLtNqApNljMe+Zr/v6bHkWNUVxT7b7HStUSoVOo
         zm2K4PWK5tjsvowPfiYmQ/w3Uuk+FptLTG3vkFnvpi1I4OgNnhW5P/QRuazol7v890oz
         6fd+COFFBFk0ntCs1oQta7zVc1+QumgEixDJoXOAfk7O8a+kbEp1WKf+0t5CviJix2oa
         MQ4CiBW95dMfQFKH0E0NFCq3VO4O5B6sX5pCigTW5Jl5Cv0jsDoW4Ln/Yb/kspPVa99N
         n0QQ==
X-Gm-Message-State: AOAM531IAHkKnqlVonPWUu+X8kzYpuITpgeNdxzLAN4oAe6FAxczZ/PR
        1wl0GalccTVbAvi+uxBj/jjymChGtmPbOwrXpDI=
X-Google-Smtp-Source: ABdhPJwUzPYbgL6SHXuczbiw2+GBonFsYiZ1wqmxk5CUpprWSzYH0p5ulfLaRnhyvX8QsFZmwyxXAw==
X-Received: by 2002:a1c:3286:: with SMTP id y128mr4975336wmy.104.1612557255569;
        Fri, 05 Feb 2021 12:34:15 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id j14sm15664985wrd.36.2021.02.05.12.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 12:34:15 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH v2 0/3] debian: minor fixes
Date:   Fri,  5 Feb 2021 21:34:02 +0100
Message-Id: <20210205203405.1955-1-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series contains unrelated changes for the xfsprogs Debian package.

v2: Resend with Reviewed-bys applied.

Bastian Germann (3):
  debian: Drop unused dh-python from Build-Depends
  debian: Only build for Linux
  debian: Prevent installing duplicate changelog

 debian/changelog | 8 ++++++++
 debian/control   | 8 ++++----
 debian/rules     | 2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

-- 
2.30.0


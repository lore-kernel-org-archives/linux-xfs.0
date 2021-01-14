Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37969C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0081223B55
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhANSik (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 13:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbhANSik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 13:38:40 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9824BC061575
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:37:59 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id w1so9635413ejf.11
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NKu6okPIVX8U5mfBvAkWta58s30OzzLjsLRaji0K/9k=;
        b=bO0aaqSIuq7MWBPH2Hlfut15AKT5tBM1X2dtd/z7xZ7d9mVi/ncqxHvyV1unMDXe8l
         m98LTpbRNVU6trtY7I5q5wKoFwZdbJ/jkNuVsx58/pT0skPP+CfaxXDg1s136Z6naBTe
         /tgjpGhMQTxnyrTixPecxDgZiIBi4G2V6Cu6VcfegrmbZjX7PNtIYo3AhgjzqT24yne1
         0uch+yeoTU7f2604C/jwQxaAUle+y7eihS/YgXBFn1SfMWEN7Hdc9H+TeOprVvq7sbe5
         JwAda2MdSUKoIsqHsohsXOIP6xs9ix7pID3wsT0yV+1aHkihBZzmHhCd+1vtNEPjdV3h
         7pKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NKu6okPIVX8U5mfBvAkWta58s30OzzLjsLRaji0K/9k=;
        b=LwRAxX38zrN4k4+gs8npOBZkOsxgNsvf30bB4yVcXo5QOXNse3TLIhKzepsLksIPlf
         /xXp60uGjqSoXpD7E4lcCv5doRKqNhNUNAO1BGVniPbNvy9tY/rYfWJjoDgRiogeayTI
         41Ha4wOzDQSpTKL5PmxOTtP154b1TEeuiAigJdnYeXdgBvmaXjOWUo3/7/Gx9qbWsIyr
         m86yNjG2wBqf7+GFMFSJvPnTiOZDfrnrLYFma6hoWbUQPyvaYBkLSw4om4RXBylNR6gc
         J989rIO4MGi+HkksCxieI0mgxDlJjh6IjOpRpVAyDE4cesHyG6h5y73OmrEKHK2P2yZV
         URkg==
X-Gm-Message-State: AOAM532DZ3ajWYr1PlWHezLRiLg70QkbM17AGfjXqOCXbcVIUpuDeT74
        VnzyRJYjWMauwIKEaVucHWBeZPT2wvSuZcK7
X-Google-Smtp-Source: ABdhPJzTD4+0uOBAj7/Ar/LjcB7hAF9bss5P0g1fM3EMGjkkbKIYKho91fAl3xg/aZX25Y8IoIfCFg==
X-Received: by 2002:a17:906:98d4:: with SMTP id zd20mr6229424ejb.532.1610649478050;
        Thu, 14 Jan 2021 10:37:58 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id s19sm2540876edx.7.2021.01.14.10.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 10:37:57 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 0/6] debian: xfsprogs package clean-up
Date:   Thu, 14 Jan 2021 19:37:41 +0100
Message-Id: <20210114183747.2507-1-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Apply some minor changes to the xfsprogs debian packages, including
missing copyright notices that are required by Debian Policy.

Bastian Germann (6):
  debian: cryptographically verify upstream tarball
  debian: remove dependency on essential util-linux
  debian: remove "Priority: extra"
  debian: use Package-Type over its predecessor
  debian: add missing copyright info
  debian: new changelog entry

 debian/changelog                |  11 ++++
 debian/control                  |   5 +-
 debian/copyright                | 111 ++++++++++++++++++++++++++++----
 debian/upstream/signing-key.asc |  63 ++++++++++++++++++
 debian/watch                    |   2 +-
 5 files changed, 175 insertions(+), 17 deletions(-)
 create mode 100644 debian/upstream/signing-key.asc

-- 
2.30.0


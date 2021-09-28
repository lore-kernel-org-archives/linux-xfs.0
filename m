Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F74C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E462960E73
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbhI1A1l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbhI1A1l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 20:27:41 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2D4C061575
        for <linux-xfs@vger.kernel.org>; Mon, 27 Sep 2021 17:26:02 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso1314707wmd.5
        for <linux-xfs@vger.kernel.org>; Mon, 27 Sep 2021 17:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kOQ+DA5jAt2xgN5/riZkbnKBTz/3d0Uus7prsTxBALA=;
        b=XWK12IuQKVm4jeu+yLbibMoa3RrnqNrfLXvwXc1qCOF8qs2MQIphG300ZCzm+U1dIp
         kM5qZ0ixJeCMS+d2JPGUAjZv8oCaE21SvrgVzdy2iiRYBfYmGn1zdAeIz5FejVACPVrr
         NBIUzE57gnDUTKmb9/pg7qJBnohppX0YPTys2kc0ePeHcpHMKlhlixuqayE1SnRwmtC6
         2yCYBD3M0m33EB7ODZ1251Q34GGvtIhvSxgpTWbHTQujHSoLSPburJxo/thZc9baI9jA
         kDeVT5tgMjqe49kgmyub9Xn9YbX/sJrmQUuCbeuOHluDBN8cFJCplh8mafyf+vAiT2xY
         f3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kOQ+DA5jAt2xgN5/riZkbnKBTz/3d0Uus7prsTxBALA=;
        b=qSNyhxNngiwjR9bKrccCoLg7LQ23gwda6AymorqiWpLhwaS148uUxOn5eMeWInxLxP
         Q0un+vwMHKvc54KLkv89rMAeHZ2p8hcTP+iCjoPlkV+gSNIvfg45dhzh1FGnPPtA4Ygf
         LRXAkCzyq7cXIz2q5J5jyza2rZ72cNdgs/qgKPvi3BQwBLB4KJhTt6bbtxhpAkNEMoA4
         qJvjSf8qrRJFJiKfCJjh3YpHm8pUNC2pYog2moiOObfuOxh/BQtmlBGIRsLCW5deHiFD
         nh9tHmB2oe6XbTgFr9hPAInOuTQuixiRZC6q2fDFR/I2aewvBpM7wUqlesgwlvnW7taq
         Zd2g==
X-Gm-Message-State: AOAM533RhwfYOY9u4A15iK9fG7vWXmtpA1qn57zkt5KvcppiwRpfB+bH
        sLwYyDHd2UJZHQYYjMShHXxaFM72uzmUwaF4Z3Y=
X-Google-Smtp-Source: ABdhPJynTBkrPae5ZsHZqvigpO0tKwcG/DTSmePcHnZF2ESgS2tPR9F4o+ia9b3HWT9OjRm5JeSIsA==
X-Received: by 2002:a05:600c:2201:: with SMTP id z1mr1830879wml.55.1632788761467;
        Mon, 27 Sep 2021 17:26:01 -0700 (PDT)
Received: from thinkbage.fritz.box (p200300d06f1f7300176a2a162e6525fe.dip0.t-ipconnect.de. [2003:d0:6f1f:7300:176a:2a16:2e65:25fe])
        by smtp.gmail.com with ESMTPSA id p3sm4755814wrn.47.2021.09.27.17.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 17:26:01 -0700 (PDT)
From:   Bastian Germann <bastiangermann@fishpost.de>
X-Google-Original-From: Bastian Germann <bage@debian.org>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bage@debian.org>
Subject: [PATCH 0/3] debian updates
Date:   Tue, 28 Sep 2021 02:25:49 +0200
Message-Id: <20210928002552.10517-1-bage@debian.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These are three independent changes for xfsprogs' debianization.

Bastian Germann (3):
  debian: Update Uploaders list
  debian: Pass --build and --host to configure
  debian: Tag xfslibs-dev "Multi-Arch: same"

 debian/changelog | 10 ++++++++++
 debian/control   |  3 ++-
 debian/rules     |  9 +++++++--
 3 files changed, 19 insertions(+), 3 deletions(-)

-- 
2.33.0


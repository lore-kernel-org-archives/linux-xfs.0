Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F041C2D0E2
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 09:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D43F4208A9
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 09:04:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/BwjGfV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgIVJEJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 05:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIVJEJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 05:04:09 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8356C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 02:04:08 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x22so7022547pfo.12
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 02:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ORXri5H5xpQfyB5dEM2S1kdLdfNN+GDXS+hTBGFeb3o=;
        b=Y/BwjGfVrOx1o+9hR8hhJ2432u5Dmjm7mylVum/XMxeg9kcAXtMea1ptfkOX17uWWp
         Yo5bRglGP0/0LnMKwLdiTBv36j66LV1Fk23Iyg+ejjACvRKkTBtzGzKzuyLIsr6P1IuN
         Q3zSdDnjv2+S8NpBaJAKE3cNndZ3JxO2GEQsc7HQ2wzvt8G6Jsu3jtIeF8eptwooTcUu
         FaDeayxikbhiOsYr5OJmotRXjli1NH1Ey3ChoE+QDzbOsWaaOqbAGF60WOw+1ujVdXzK
         bWsz/aHFuKqbdOZjMkREeGc7dcp2uJRP636m/XcSZsW/nOLpuX9RYeDppOBU9lTUhviD
         vjBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ORXri5H5xpQfyB5dEM2S1kdLdfNN+GDXS+hTBGFeb3o=;
        b=m07KLbBpi0uVC+133ZHQzBF8i8VKB7ER27M5Px0FD47B6PQNcrHCsFkfTqvLwStzHn
         Q1t+JcYN+GsHwFHeCbuH8lNaYI5akUdn0q3rZaufhpxMzdRflj265Y+3ERkhRCD2pDSW
         BuBxkHGmNoKZ9UbLH4Ckqx/lbr7Vc9N4niQ98n0VM1qVTDsvH4L3ehNagKP6s7FNEEBn
         ql6wgzgrojKVMeGyBW4dVlbpNKCaLZfk05LPs5hftUcrOXEexrqk4VktPOHYEAHCFx5F
         kwDPU1VJ4x+2BjUjb8SuFRA1OzvFZtcLUUn3C4HkOvAXxQSYkcJrKbMTMwoae6T45b/w
         +X8w==
X-Gm-Message-State: AOAM533xbsR/0mTJ9Toa8XyhVdKzIX24udJ8zl1X9RHH7vJmlvoiroyY
        jldejmQIBuMXKhcevyjX+3sLcvS/8A==
X-Google-Smtp-Source: ABdhPJzQNgYXIHeE4KwGD4l05TQLftaCsT9bsEzqr0k0DzVAHzo2VrBqFFTfOSLjBbzHjDwYzfOhCg==
X-Received: by 2002:a17:902:b586:b029:d1:bb0f:2644 with SMTP id a6-20020a170902b586b02900d1bb0f2644mr3757404pls.34.1600765448126;
        Tue, 22 Sep 2020 02:04:08 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id h8sm13815653pfk.19.2020.09.22.02.04.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 02:04:07 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [RFC PATCH 0/3]xfs: random fixes for disk quota
Date:   Tue, 22 Sep 2020 17:03:59 +0800
Message-Id: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi all,

This patchset include random fixes and code cleanups for disk quota.
In order to make it easier to track, I bundle them up and put all
the scattered patches into a single patchset.

Kaixu Xia (3):
  xfs: directly return if the delta equal to zero
  xfs: remove the unused parameter id from xfs_qm_dqattach_one
  xfs: only do dqget or dqhold for the specified dquots

 fs/xfs/xfs_qm.c          | 24 +++++++++---------------
 fs/xfs/xfs_trans_dquot.c | 12 ++++++------
 2 files changed, 15 insertions(+), 21 deletions(-)

-- 
2.20.0


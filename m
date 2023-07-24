Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765DCC41513
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 22:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjGXWzS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 18:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjGXWzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 18:55:17 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF6B100
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 15:55:16 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1bba9539a23so1825795ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 15:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690239316; x=1690844116;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5vbE+fvxcfqcGlcUweeJezgJR140xPsdhDXGONuK0ws=;
        b=TGTBUnjNchsE/sUgqdaYTlPa91mYzB9LJJ1RaLSU7XArc67EG4pHVihDnNGnQfHOlg
         AikB1Mn1pZbJZgggCz+1i4tVX1FUPqVgQmF8YK4C+xqpwK6KkVaAQr7Kdc+LJYseIKpZ
         1UsPiNeZeMMvuvdyOquLDVu8tAovDvwp6rU9cECmLBb8OUXt3h8HZzRp2uwUQpWhyQXM
         q3JJ56xNuKBIhnjSL0g5HVrFHOrpXI6G7m1a9wtIO9vgFEHoy0WMx23138HAVKliBFbF
         MPrYiVPN5zskpSm38XliZ+icR8zOXRovFR6nf8D7S+biSdNduA+WBBJ2l+iQdqRIvqT2
         +dxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690239316; x=1690844116;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5vbE+fvxcfqcGlcUweeJezgJR140xPsdhDXGONuK0ws=;
        b=YSxHFyxdnjf6x4eDvAI3Coo2R1WWS4AZcXpeRkZG0AmaxvtWztm1Hit2Eyw4r4q2Qn
         orqHgsGdxZ+brp9yOkbl7l74Xi2LR41wSu3MXjmnJjDv5CfM3Ti3J8aYLXT9raWFA65d
         OuUB5tLF979adOumvpEbH1hiLjFGVzHLHvy9IEr8Ia/lSR+qUV1SK8Sgf5WxeqyjrjmO
         LQERaxjOQLAlc136ywluLoxeyGbIvMRKccUkvj9PnAMdJROPzjKQDIpUQLPjIOps07SO
         JBNKtZbVhxoEghcek21g+kFRHscqKEt0zjn6i1eehTrSGggVMEO/WOAklKVSnNAirBWH
         D/uA==
X-Gm-Message-State: ABy/qLZfwO+9mpRqhUOLQ4hLWw4c5k8BFxVdfiuwOkt+UIhcFq3MvWCM
        Yl7bmxn/KGwB70oKvRDpMYVn4w==
X-Google-Smtp-Source: APBJJlHaMVXsvz/HkyReGjqnXNN6GkPrAgZbTGqZalmfohjd31l08yYCgwfTOvSscoHxbGoWf5gd+g==
X-Received: by 2002:a17:902:f682:b0:1b3:ec39:f42c with SMTP id l2-20020a170902f68200b001b3ec39f42cmr14612880plg.5.1690239315679;
        Mon, 24 Jul 2023 15:55:15 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709026b8700b001acae9734c0sm9424733plk.266.2023.07.24.15.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:55:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org
Subject: [PATCHSET v6 0/8] Improve async iomap DIO performance
Date:   Mon, 24 Jul 2023 16:55:03 -0600
Message-Id: <20230724225511.599870-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Hi,

This patchset improves async iomap DIO performance, for XFS and ext4.
For full details on this patchset, see the v4 posting:

https://lore.kernel.org/io-uring/20230720181310.71589-1-axboe@kernel.dk/

 fs/iomap/direct-io.c | 163 ++++++++++++++++++++++++++++++++-----------
 include/linux/fs.h   |  35 +++++++++-
 io_uring/rw.c        |  26 ++++++-
 3 files changed, 179 insertions(+), 45 deletions(-)

Can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio.6

No change in performance since last time, and passes my testing without
complaints.

Changes in v6:
- Drop the polled patch, it's not needed anymore
- Change the "inline is safe" logic based on Dave's suggestions
- Gate HIPRI on INLINE_COMP|CALLER_COMP, so polled IO follows the
  same rules as inline/deferred completions.
- INLINE_COMP is purely for reads, writes can user CALLER_COMP to
  avoid a workqueue punt. This is necessary as we need to invalidate
  pages on write completions, and if we race with a buffered reader
  or writer on the file.

-- 
Jens Axboe



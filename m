Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 428CDEB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 16:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbjGUQSa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbjGUQSC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 12:18:02 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E5D3AB4
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:17:00 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-7748ca56133so21202439f.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956215; x=1690561015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9Z4GfdIvP0cWj+7cSoJCHgRJvNZq6ZhXKfmbj+hn8J0=;
        b=ias5JUDZ3tq8ae5uHA/19+ln3sr3GGiSL4aY4OYtqmw6b5Ykzp8HBdJ5EWPUDcKpTZ
         kUbOrGG793ChM0hiZc5PpOkgn3eW803dmPxMaYhtZD1IsPrWGo9NmRMux6NOiOp5UAKA
         c46y3AEvS6GIsF9acYNcXIoyaoRwDMlCx8ZCtik6MGZOS9R4Y6S4ZWM9XqUuZpMV54/I
         QB2y6DVsQTwwSHEGlqEFew7zpnOQYQLDrUMeu953BalihNJXD0zZ2rWU7D11eyzCclDM
         pHjHyUbP9zQsCRkegnjUBvlmSB28Biu0WKTsFGaIjMcR3HbL5Kk2H5HhWAXGqH9yfB+d
         AXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956215; x=1690561015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Z4GfdIvP0cWj+7cSoJCHgRJvNZq6ZhXKfmbj+hn8J0=;
        b=Lej5HA61lxfZSHgFn5WLuCUGbZLSfLYtlrmmP3QmE8CsR92nz1VBzn78KE05dQ5VZk
         H8C4+YuQAI6WMdIbEszUvmrVO6cJ2aIVdfvIuq2Gdwsfr8oTGhAJ2bmshIcj7XFmGpr3
         k2p1fy3aVxYkikiLZhlwmKVnjD0Z9/AfOvySB9QSTjjlcqGbwvCur03Js1zYRyFxYjDc
         2EItHQa09O8lM4M5seRzv1p0GKsI3ekDv7MpT6uoTZZgmrkcoGb4llIIsgskkHXcJXyX
         UAbWMU/YednRpMyPzuAhVkxfIw5hQJ4RWAU92ONK7pyYd8kw9z171+moYVddab83SAYs
         +OnA==
X-Gm-Message-State: ABy/qLaIMnTIIwSLrncJH0ipja95YEyhMX2wJq/EPeYsHz+jzvGQZPbZ
        iOdHUkN+K06Y6i/ggLfTrLzsPw==
X-Google-Smtp-Source: APBJJlFzE90dIy306ZSNc18NyX/8nrPojsecFUtZtRrMo1z+7bC/G7q/jOsn/FecsSN2Ao8FMKqgDA==
X-Received: by 2002:a05:6602:8c9:b0:787:16ec:2699 with SMTP id h9-20020a05660208c900b0078716ec2699mr2032011ioz.2.1689956215434;
        Fri, 21 Jul 2023 09:16:55 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:16:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org
Subject: [PATCHSET v5 0/9] Improve async iomap DIO performance
Date:   Fri, 21 Jul 2023 10:16:41 -0600
Message-Id: <20230721161650.319414-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

This patchset improves async iomap DIO performance, for XFS and ext4.
For full details on this patchset, see the v4 posting:

https://lore.kernel.org/io-uring/20230720181310.71589-1-axboe@kernel.dk/

Darrick, if you want to queue this up, that works for me. Risk of
conflict on the io_uring side is small.

Changes in v5:
- Collect reviews
- Rename IOCB_DIO_DEFER to IOCB_DIO_CALLER_COMP
- Rename IOMAP_DIO_DEFER_COMP to IOMAP_DIO_CALLER_COMP
- Improve some comments based on Darrick's feedback
- Rename IOMAP_DIO_STABLE_WRITE to IOMAP_DIO_WRITE_THROUGH
- Add patch making the IOMAP_DIO_* defines unsigned

-- 
Jens Axboe



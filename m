Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2117DC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 12:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C379A22EBF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 12:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392499AbhAZM7D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:59:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404055AbhAZM6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 07:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611665826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6gokyX20rgR4YjLR/5QZrMGr4vkvE0xFuErdNlDjns4=;
        b=JG0zeq9BdGCzy/oXz9KWoibHuRk2blfVmXNJ25ndEerzSVk+fG4Jpef7ZQX2vXp1yTVD1L
        xKAxfAUTOEEgtA7AgH4yrSUbSaKNBnC66/aYZsyvyBIPDOy4J08R96cTsmdV6ueqov0K4c
        cevO8EDUCP1w9s81BZeXkVxg/JhhLQ8=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-bxmuEJrbMuqdT0xbsefq8A-1; Tue, 26 Jan 2021 07:57:02 -0500
X-MC-Unique: bxmuEJrbMuqdT0xbsefq8A-1
Received: by mail-pg1-f198.google.com with SMTP id i124so8214563pgd.4
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jan 2021 04:57:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6gokyX20rgR4YjLR/5QZrMGr4vkvE0xFuErdNlDjns4=;
        b=pTmRbhCD+YDPDXU4HrJQKamk5wSZLX7hElJAdiIDtRbJjEMInfe3Aj1h3UEXE8QynV
         cEqtOn1zjw0OjU9Tn59VPJsvfRUW61hZgf7V9oyaF6z3n0ZTZmJDUY2hH+kKt7micl2V
         48wgs5A+Z74DsF33HyxsH5Pw9INaS9kxPdBQuUFjCU1FJtxN5XTkS/91zJfxtbnYttCX
         k9kWtH1CXbmrN9gWXuAAfW9TgTD31zWHDrTYDm8m5AsGLe2pNk5ZY1coZ8B9pGNUyhfq
         SlsccKpIVsqaoydO2782BGmmoRoU8BHEAkGVDWZC99b1dC4w54VRx5MWXBdoSyi/d3o0
         b/Zw==
X-Gm-Message-State: AOAM530sFa7+gzB+8z4XYlJylVID+L3VLYKwJi09BQ/uyhQ3ltfWwt51
        KZK8/rx8mGd/i/Om2gtNBTtqaZFLQqRd7Iohl99f3xCQiaEivxgffbIxP3X8Pr6LqEX8HiTh6hK
        5pwkVUWWlbAI0FJ/93QT0thIQJxwbjqwxU776roAVkjYOjSpLw5LfS38F+JsKUZO4TRD8ekWPSQ
        ==
X-Received: by 2002:a62:1b95:0:b029:19b:178f:84d7 with SMTP id b143-20020a621b950000b029019b178f84d7mr5277752pfb.70.1611665820600;
        Tue, 26 Jan 2021 04:57:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTetDFrPUoSllEZZf7glpfY3TRqvrB1FHwH53QKLN9EssgVP9upOxlTTKTOqBBhsfkOhpBcA==
X-Received: by 2002:a62:1b95:0:b029:19b:178f:84d7 with SMTP id b143-20020a621b950000b029019b178f84d7mr5277727pfb.70.1611665820211;
        Tue, 26 Jan 2021 04:57:00 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b203sm19243174pfb.11.2021.01.26.04.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 04:56:59 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 0/7] xfs: support shrinking free space in the last AG
Date:   Tue, 26 Jan 2021 20:56:14 +0800
Message-Id: <20210126125621.3846735-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

v5: https://lore.kernel.org/r/20210118083700.2384277-1-hsiangkao@redhat.com

This patchset attempts to support shrinking free space in the last AG.
This version addresses Darrick's review of v5, aside from that I'm not
sure if seperating the whole shrink functionality is a good idea (I just
tried but it seemed that ~90% is duplicated code.) IMHO, It'd be better
to separate when needed (I'm investigating shrinking the whole AGs as
well, it seems not too much invasive than the current approach...) Yet
if people have strong opinion of this, I will resend the next version
instead.

Thanks for the time!

Thanks,
Gao Xiang

xfsprogs: https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com
xfstests: https://lore.kernel.org/r/20201028230909.639698-1-hsiangkao@redhat.com

Changes since v5 (Darrick):
 - [3/7] use a separate patch to update lazy sb counters;
 - [5/7] introduce the xfs_ag_shrink_space() helper first
         as a seperate patch... I think it'd be better to "define
         xfs_ag_shrink_space() as a stub that returns EOPNOSUPP..."
 - [5/7] roll the transaction in advance so the new trans can be
         canceled safely.
 - [6/7] "nagcount != oagcount" ==> "nagcount < oagcount"

Gao Xiang (7):
  xfs: rename `new' to `delta' in xfs_growfs_data_private()
  xfs: get rid of xfs_growfs_{data,log}_t
  xfs: update lazy sb counters immediately for resizefs
  xfs: hoist out xfs_resizefs_init_new_ags()
  xfs: introduce xfs_ag_shrink_space()
  xfs: support shrinking unused space in the last AG
  xfs: add error injection for per-AG resv failure when shrinkfs

 fs/xfs/libxfs/xfs_ag.c       | 113 +++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h       |   2 +
 fs/xfs/libxfs/xfs_errortag.h |   4 +-
 fs/xfs/xfs_error.c           |   2 +
 fs/xfs/xfs_fsops.c           | 158 ++++++++++++++++++++++-------------
 fs/xfs/xfs_fsops.h           |   4 +-
 fs/xfs/xfs_ioctl.c           |   4 +-
 fs/xfs/xfs_trans.c           |   1 -
 8 files changed, 224 insertions(+), 64 deletions(-)

-- 
2.27.0


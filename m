Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7A6C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 19:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66A8961131
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 19:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348470AbhDNTxn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 15:53:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353514AbhDNTxn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 15:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618430000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=od9gclV85jd4NwN2HvQ8HNn6ZH0vfh8ae4J26WkYxa0=;
        b=JkQ3D2txedRo89aEVmSpQ33AJuodlP/x9ZgQhLCb8PobbqEwSp6bEIWd/7Bsiuwi2am1qR
        1z2FDAg5Knodrf3u5yBgxRoCUC4kRUJOVNXrhvahl/Kp8exG55gRYSK9r73h5RTRE0IJfM
        InWeEh9ZOKASzkJFGJIGjB390zemdgY=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-tK0WWrtVM9iGkSKQ307zJw-1; Wed, 14 Apr 2021 15:53:19 -0400
X-MC-Unique: tK0WWrtVM9iGkSKQ307zJw-1
Received: by mail-pg1-f200.google.com with SMTP id s20-20020a63af540000b02901fb4a1fe304so113856pgo.13
        for <linux-xfs@vger.kernel.org>; Wed, 14 Apr 2021 12:53:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=od9gclV85jd4NwN2HvQ8HNn6ZH0vfh8ae4J26WkYxa0=;
        b=abZt0O9TRfxxMyrzfhXasWC62Sq3D2n76cV4wePI2dtjwFgGcwaEjKTEyrqxs571XY
         BUT4kq4m+PPtDraYowKo+IoZT6PkJjOuM9aZQr8z9NB1P+b5ccvV2VhRpHVM0hNKyztY
         qz3WTwDBb+oF6mY34McQCz7QWf57Vb+lYghD6EKRk5evVv0E7AW2mb6e98uHJmp4ySXI
         lwr69ODocFtrBosBsnGUqUOBM66TsK6FUbyvngTQLdNXFUyzpSZ/jynf/EpHqeQ8uwfb
         SKs3Je+vrjHZmhVVwU1+LSpbIqMJxxNoUaYUiAIoFGl3xg8fuZI8E41bjl8RsA5FsIRx
         CO7Q==
X-Gm-Message-State: AOAM531o231fPrSlXNGn/sT0K3T8nwg3csnM8HDYII7mDZoWI1Y50ujG
        cQC1sVgTzRwZ+7WxldeVKoOHJA3VQOYEzJdCNYKxDrk/VsSCBlrZ0SFQ/hWeZRcYvR/9pEw0Arz
        f6JcWW8O4O6pXKYQlAQC27Rq0gjSxwgsg2qi2BAq3AfQ5WquVk/a80t8WlcQuniUocdUk2QCubQ
        ==
X-Received: by 2002:a17:90b:1190:: with SMTP id gk16mr5151584pjb.57.1618429997922;
        Wed, 14 Apr 2021 12:53:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5LVp+V+DUU+t1ILo4fFwHK0cUz7z2HPKI7nykOF6SNRQ1mnfWsH7vrAbCV58vNGhhktvjZg==
X-Received: by 2002:a17:90b:1190:: with SMTP id gk16mr5151558pjb.57.1618429997624;
        Wed, 14 Apr 2021 12:53:17 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm215787pjm.0.2021.04.14.12.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 12:53:17 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH 0/4] xfs: support shrinking empty AGs
Date:   Thu, 15 Apr 2021 03:52:36 +0800
Message-Id: <20210414195240.1802221-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Sorry for some delay... After "support shrinking unused space in
the last AG" patchset was settled for-next, I spent some time working
on arranging this patchset in order to shrink empty AGs as well.

As mentioned before, freespace can be shrinked atomicly with the
following steps:

 - make sure the pending-for-discard AGs are all stablized as empty;
 - a transaction to
     fix up freespace btrees for the target tail AG;
     decrease agcount to the target value.

All pending-for-discard per-ags will be marked as inactive in advance
and excluded from most fs paths. A per-ag lock is used to stablize
the inactive status together with agi/agf buffer lock. It also
introduces a new max_agcount in order to free such inactive perags.

This patchset has been preliminary manually tested by hand and it
seems work. but I still haven't tested with other fs workloads
together. I will work on refine previous fstests to cover this.
But meanwhile I think it'd be better hear more ideas about this
first.

Kindly point out any strange or what I'm missing so I could revise
it and get it in shape as soon as possible...

xfsprogs is still:
https://lore.kernel.org/r/20210326024631.12921-1-hsiangkao@aol.com

Thanks for your time!

Thanks,
Gao Xiang

Gao Xiang (4):
  xfs: support deactivating AGs
  xfs: check ag is empty
  xfs: introduce max_agcount
  xfs: support shrinking empty AGs

 fs/xfs/libxfs/xfs_ag.c     |  17 ++++-
 fs/xfs/libxfs/xfs_ag.h     |   2 +-
 fs/xfs/libxfs/xfs_alloc.c  | 111 +++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_alloc.h  |   4 +
 fs/xfs/libxfs/xfs_bmap.c   |   8 +-
 fs/xfs/libxfs/xfs_ialloc.c |  28 ++++++-
 fs/xfs/libxfs/xfs_sb.c     |   1 +
 fs/xfs/xfs_extent_busy.c   |   2 +-
 fs/xfs/xfs_fsops.c         | 148 ++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_mount.c         |  89 ++++++++++++++++++----
 fs/xfs/xfs_mount.h         |   7 ++
 fs/xfs/xfs_trans.c         |   3 +-
 12 files changed, 379 insertions(+), 41 deletions(-)

-- 
2.27.0


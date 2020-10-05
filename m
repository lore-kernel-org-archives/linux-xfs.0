Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8D5C4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 21:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AC1F2083B
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 21:38:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OETLDuJW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgJEVi6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 17:38:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725616AbgJEVi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 17:38:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601933937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/uKh6ABwi27qSOaqtppF+9iENKGQCpVsVBpROYvnfLE=;
        b=OETLDuJWuRHxMhS0CCJKrevXwT9B5XR+Mt+edXxALaHSXQ+MPRMwnZcpGPkNrPTCg4d2cO
        dy43unkGyDQDq421o6Aj5VvPVKT8YIawrNUgFdZAuQctTPwOiscOI6S8ZU0khK++GA5Mbx
        n+PcPb6KQVHw5kuq0tmbRihry0KMjxs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-g3lT7u5vOLmlDyOqn0yeGA-1; Mon, 05 Oct 2020 17:38:55 -0400
X-MC-Unique: g3lT7u5vOLmlDyOqn0yeGA-1
Received: by mail-wm1-f70.google.com with SMTP id g125so338430wme.1
        for <linux-xfs@vger.kernel.org>; Mon, 05 Oct 2020 14:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/uKh6ABwi27qSOaqtppF+9iENKGQCpVsVBpROYvnfLE=;
        b=F7T+JbzXe1IiPcvdo+RJazsnH7sX+AK05fWmuRbqA9o8qbYl5dQLnZJS5DhTrSaHI7
         CMfc3mSGg0fQ3DNMWyhsKFZIhDW+19reiqCJt5XmmGCM0wZRqFdKmxBmXKsPRIzUvsIM
         tn2S3w6WOU0MXO8T/k04B6sy94qonSthyNK6DruOYccfnvAXUTtRPLSlnrRTSGwQGXzP
         HfY+pu9Wb/OSYubtTjiYUKyz2fwrCXUMGa+ZE3m6LZijK1tWU5E9TOZY6RZXA8U+IeAp
         /M7dUt3a7WRH+dauezhyXp/Lp2yc/i+9rG9lCn/kY83owmULIoggbKL16q9pTim1hJXK
         /SRw==
X-Gm-Message-State: AOAM5332jdoQNyAUWEBotH45N/M6jjvYKKHlJek9Nva9nHTaQSmUGwGc
        qQZMZFbzMkqRZyQ71v4BCJoF8vMGBlS02zmIz2yt+eITpIurTGes39Cjwm21QgKu7QIqcpjXUc0
        53d0GaqweGkW+SPsTOzWR
X-Received: by 2002:adf:dcc7:: with SMTP id x7mr1354371wrm.203.1601933933881;
        Mon, 05 Oct 2020 14:38:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx78XmOCMzIsAp6024TuU7DYUqd4iLXSajPH/o4um6N79pyy3c7WvDky/8ITTU6RiUXMKXPrQ==
X-Received: by 2002:adf:dcc7:: with SMTP id x7mr1354360wrm.203.1601933933704;
        Mon, 05 Oct 2020 14:38:53 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id r5sm1576499wrp.15.2020.10.05.14.38.52
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 14:38:53 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 0/4] xfs: Remove wrappers for some semaphores
Date:   Mon,  5 Oct 2020 23:38:48 +0200
Message-Id: <20201005213852.233004-1-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove some wrappers that we have in XFS around the read-write semaphore
locks.

The goal of this cleanup is to remove mrlock_t structure and its mr*()
wrapper functions and replace it with native rw_semaphore type and its
native calls.

Changes in version 8:
Patchset was rebased so it applies cleanly.

The patch 'xfs: replace mrlock_t with rw_semaphores' contains change in
xfs_btree.c which transfers ownership of lock so lockdep won't assert
(This was reported by Darrick and proposed change fixes this issue).

Pavel Reichl (4):
  xfs: Refactor xfs_isilocked()
  xfs: clean up whitespace in xfs_isilocked() calls
  xfs: xfs_isilocked() can only check a single lock type
  xfs: replace mrlock_t with rw_semaphores

 fs/xfs/libxfs/xfs_bmap.c  |   8 +--
 fs/xfs/libxfs/xfs_btree.c |  10 ++++
 fs/xfs/mrlock.h           |  78 -----------------------------
 fs/xfs/xfs_file.c         |   3 +-
 fs/xfs/xfs_inode.c        | 102 +++++++++++++++++++++++++-------------
 fs/xfs/xfs_inode.h        |  25 ++++++----
 fs/xfs/xfs_iops.c         |   4 +-
 fs/xfs/xfs_linux.h        |   2 +-
 fs/xfs/xfs_qm.c           |   2 +-
 fs/xfs/xfs_super.c        |   6 +--
 10 files changed, 107 insertions(+), 133 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.26.2


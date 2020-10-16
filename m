Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F43DC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 02:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1983520897
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 02:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YJ4fLBRU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393341AbgJPCKN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:10:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393343AbgJPCKM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 22:10:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602814211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jMiGNGpXqKt25h2CqG+9QquRU8ZaCujJwLDDrcgzWdc=;
        b=YJ4fLBRUnJ3L+tGjJQwKQov8mR69BBniSR8wUT4664V3q4JDPlAMWk3M3mysxDCupHB+Jy
        1DZGMgMiONV1RMebdzAB+NpuZBmru7UFxM4eSn4kNS7Y5/HqokGXYK5db1v7d7LDZ261Ix
        eqFi3l6WLvyRtnbmOA9+VWz+Avmg4g4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-6-vOWOgoNyus1BQ7yuu3Dg-1; Thu, 15 Oct 2020 22:10:09 -0400
X-MC-Unique: 6-vOWOgoNyus1BQ7yuu3Dg-1
Received: by mail-wm1-f69.google.com with SMTP id f26so265695wml.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 19:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jMiGNGpXqKt25h2CqG+9QquRU8ZaCujJwLDDrcgzWdc=;
        b=LNSBzLw0L3ZAnsfYA8NM0XQwvehHQ/56XxSeap7qwNMyyaBWwQlIiOYa+6KnlDzjs6
         PMC2LIGs5GzblO40a1xGPDsAieMtr2hvg5zboCwn1vzhlufDHs+nG8LXPG2R9rtvJ5Xn
         W0W3TQNInIurd0NWeeXPdkw8VCYDViZrgLR0crvQ+ALu8wq6Xhe/JyxPDsvk96UmDBU7
         XHitfC6uCxevV+O54kB0wcFzYUx+FBar7AmkYTiyr2nxI1lsomJujSpRyUZv336Us7Fj
         PwyVKGi5weOe5POeg/waJ5XsmnxVjj5e27SUr6J4kkMDTHuM59cpkSkraonigFajd19t
         x71Q==
X-Gm-Message-State: AOAM531PjBz38DinDDjKbDxno61CZvpeiAo2nEKd3LXIlUzK8QFaMvOh
        YjtSkE1AouONztWYH8e6Tz1nWVqhnk2rmVyPK3ldLeklDrw+LPWQn4oszgAD+eqmGyKsxSpYhhe
        HCniS7btte6cCAuxxtzU/
X-Received: by 2002:adf:dc47:: with SMTP id m7mr1127513wrj.100.1602814207798;
        Thu, 15 Oct 2020 19:10:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwv61qPYwz4symFw85prbVZI7Ujzzy+MjXrQIm87eqwMTtfCV7nOcneD7C5EwSEmvT2hqHX+w==
X-Received: by 2002:adf:dc47:: with SMTP id m7mr1127494wrj.100.1602814207589;
        Thu, 15 Oct 2020 19:10:07 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id v3sm1420685wre.17.2020.10.15.19.10.06
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 19:10:07 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 0/4] xfs: Remove wrappers for some semaphores
Date:   Fri, 16 Oct 2020 04:10:01 +0200
Message-Id: <20201016021005.548850-1-preichl@redhat.com>
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
* Patchset was rebased so it applies cleanly.
* The patch 'xfs: replace mrlock_t with rw_semaphores' contains change in
xfs_btree.c which transfers ownership of lock so lockdep won't assert
(This was reported by Darrick and proposed change fixes this issue).

Changes in version 9:
*Fixed white space in patch 'xfs: Refactor xfs_isilocked()'
*Updated code comments as suggested by djwong (thanks!) in patch: 'xfs: replace mrlock_t with rw_semaphores'

Changes in version 10:
* Fixed use-after-free in 'xfs: replace mrlock_t with rw_semaphores' (thanks Darrick)
* Moved part of refactor of xfs_isilocked() from patch 'xfs: Refactor xfs_isilocked()' to patch 'xfs: replace mrlock_t with rw_semaphores' - to fix compilation error
* Typo in comment in 'xfs: replace mrlock_t with rw_semaphores'

Changes in version 11:
* Dropped typedef xfs_node_t from xfs_isilocked in 'xfs: Refactor xfs_isilocked()'

Changes in version 12:

xfs: Refactor xfs_isilocked()
* Moved shifting lock_flags from xfs_ilocked() to __xfs_rwsem_ilocked()
* Changed comment in __xfs_rwsem_islocked()
* Removed the arg variable from __xfs_rwsem_islocked()
* Removed the extra parentheses around the lock 'defines'

xfs: replace mrlock_t with rw_semaphores
* Moved shifting lock_flags from xfs_ilocked() to __xfs_rwsem_ilocked()
* Updated comment in xfs_btree_split() before the rwsem_release()
* Added assert to  xfs_isilocked() for IOLOCK flags

Pavel Reichl (4):
  xfs: Refactor xfs_isilocked()
  xfs: clean up whitespace in xfs_isilocked() calls
  xfs: xfs_isilocked() can only check a single lock type
  xfs: replace mrlock_t with rw_semaphores

 fs/xfs/libxfs/xfs_bmap.c  |  8 ++--
 fs/xfs/libxfs/xfs_btree.c | 25 +++++++++++
 fs/xfs/mrlock.h           | 78 --------------------------------
 fs/xfs/xfs_file.c         |  3 +-
 fs/xfs/xfs_inode.c        | 95 +++++++++++++++++++++++++--------------
 fs/xfs/xfs_inode.h        | 25 +++++++----
 fs/xfs/xfs_iops.c         |  4 +-
 fs/xfs/xfs_linux.h        |  2 +-
 fs/xfs/xfs_qm.c           |  2 +-
 fs/xfs/xfs_super.c        |  6 +--
 10 files changed, 115 insertions(+), 133 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.26.2


Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF926C00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2B9720731
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QUM5xG1I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgKBTme (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 14:42:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgKBTme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 14:42:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604346152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pmSFaqvMagseyjLGEkWqhhoQi0d3wf5BGcLU7a+0Ro4=;
        b=QUM5xG1IoGLAAVYU8Ncr/NH18fnhJGFmiojUgRA4t9cjjh0dSu6STygsfyT1sVmK0jHDLd
        7uaUCwTP7ceTuk5fw/fLt/y7LKsCa8e9pGPzfaN8aOH5R7h88OrmEsOSTef0VCawnuFqWw
        dXZY+SHN23jo1HmVeF1eALWX8HEU6nA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-Kj6XhlPEP2SHr7xzikuQGA-1; Mon, 02 Nov 2020 14:41:39 -0500
X-MC-Unique: Kj6XhlPEP2SHr7xzikuQGA-1
Received: by mail-wr1-f72.google.com with SMTP id w1so6818078wrr.5
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 11:41:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pmSFaqvMagseyjLGEkWqhhoQi0d3wf5BGcLU7a+0Ro4=;
        b=XWkDxZVlP38xyA81yzEVzrBZjF5mUOFJnpw5Rrm91Hr5Swd42HD17d8ATModsRBYeS
         9CvZrgw3OLlEiipH9bCK4mG0fCubJhX7DY6lXCTrTh+qzZQ0zJOqTfhbn6WDUFCkw+xM
         zrHCC28QA3fFrhul1DzL/j/J7E0Ox9nERQTPBKoCVWJKBnCSsrXt+Nfp1MbImec7yQHq
         4KGkz+snUlKsLtNtaTenoWBkufrjHF+Bz0qFVgDIjWZmS9X6VeT68UujcpVAMIkC/ou+
         WZJrATYfMpVJLQiPLp+EAgMuewSLhJg5rNS7iPzJ6KrSj3enMefo7jxgoRVyFU994JRA
         ZoGg==
X-Gm-Message-State: AOAM532oPcwmChHdL9Qw51mH4iWnoZPAN77SHepbYRyVQ2RgmvnFBh57
        BeFjO5I3INNPWksQfTpsibcO9L7eTzSw+ofkKxpCtBE9ZKDAuIkMRZEPO7fFpRqcfwn5X8220sz
        mwCa34SV7GotRsF8G6iim
X-Received: by 2002:a7b:c7c9:: with SMTP id z9mr20251291wmk.91.1604346097843;
        Mon, 02 Nov 2020 11:41:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/RyuYVyU315UHIJUEUuN5xoHTX9komBuYq2i1x7ez2XHXOA6h8bwkTkF1y6jq7hQ9vP/Jxw==
X-Received: by 2002:a7b:c7c9:: with SMTP id z9mr20251280wmk.91.1604346097659;
        Mon, 02 Nov 2020 11:41:37 -0800 (PST)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id 6sm11742465wrc.88.2020.11.02.11.41.36
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 11:41:36 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 0/4] xfs: Remove wrappers for some semaphores
Date:   Mon,  2 Nov 2020 20:41:31 +0100
Message-Id: <20201102194135.174806-1-preichl@redhat.com>
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

Changes in version 13:

Rebased against 5.10-rc1 as requested by Darrick.

The changes Brian asked for:
	1st patch - dropped the unnecessary parentheses
	4th patch - reduced the comments about passing the lockdep ownership 

Pavel Reichl (4):
  xfs: Refactor xfs_isilocked()
  xfs: clean up whitespace in xfs_isilocked() calls
  xfs: xfs_isilocked() can only check a single lock type
  xfs: replace mrlock_t with rw_semaphores

 fs/xfs/libxfs/xfs_bmap.c  |  8 ++--
 fs/xfs/libxfs/xfs_btree.c | 16 +++++++
 fs/xfs/mrlock.h           | 78 --------------------------------
 fs/xfs/xfs_file.c         |  3 +-
 fs/xfs/xfs_inode.c        | 95 +++++++++++++++++++++++++--------------
 fs/xfs/xfs_inode.h        | 25 +++++++----
 fs/xfs/xfs_iops.c         |  4 +-
 fs/xfs/xfs_linux.h        |  2 +-
 fs/xfs/xfs_qm.c           |  2 +-
 fs/xfs/xfs_super.c        |  6 +--
 10 files changed, 106 insertions(+), 133 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.26.2


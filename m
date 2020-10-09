Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9E1C832E9
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 19:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E427C22B48
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 19:55:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IfowdChE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732941AbgJITza (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 15:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732979AbgJITzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 15:55:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602273321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=STN/yEUR/r592zDTnc0uET4FfiKkP1nMZNH5kp20WrM=;
        b=IfowdChEwD3Ef788BsGU+qbgoMZpnIxm1uhP1GSkIv9AdCSsmvuslkFwSDdEM2LpuvgfXQ
        nkIeuRKGwirylaCVHcmxuyIXElsk3VVeU1eod/RZoNhUnW2Erz0mdJtYxXhDXc/bgzJRLA
        7p9DlMAVN9TLg3Lzvtq0bcYifYwthfE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-WAMaMw21M9yPfrrPyCLDUQ-1; Fri, 09 Oct 2020 15:55:19 -0400
X-MC-Unique: WAMaMw21M9yPfrrPyCLDUQ-1
Received: by mail-wm1-f69.google.com with SMTP id c204so4606762wmd.5
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 12:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=STN/yEUR/r592zDTnc0uET4FfiKkP1nMZNH5kp20WrM=;
        b=SPV7TXVrIWc92PNEeQhZzGdVOoCPOzxhUruYmetTyDplK7vO+izYSUUsZT85MEK7zs
         t2iNCGCtN3Oyc/3mgzTLBWNWmVHLUV9HStBAuFkrinHfDLTSgZU2D9CHb9Z7t1ZlvRWf
         6Ye99YmAhzTMkyfry2IvK1SpQEF340vfjgPfkYFb9qm+PzQDizA12/ZYPZ5sAuzCIiTq
         nH8kLfRlu1YsErv/ASQ24FGUcrji9xjl3lF6XSwqP/ki9P/5fF3zpF3wknGwS2rKE0dK
         4BO1JVcQHTzKL/dV1Y+DrXDak7qGe3HcE5LYKCclZBrbh1Uhdpk3Ztws9tEV9fCDbJNe
         mTWw==
X-Gm-Message-State: AOAM530xCJIel6HTjsdR2dHV33ycZUFD2AaeoNaz2rjUBtLPlgPFS7hn
        TW5Fa7VAcW9zlvQ81IGePrrxzWhOzBfVnjzz4ApU+p7LqWYiI4LWYKWnuVcIJa14R04HhQvGMQk
        5cWSI/6K7CzI8OuQlwGXF
X-Received: by 2002:a5d:6ac6:: with SMTP id u6mr16469997wrw.65.1602273317577;
        Fri, 09 Oct 2020 12:55:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/z6mlwUAGuHgND6LiBMz6ZDRLahftLrFOPIDK8zzgZYH5Ibt3BeG2JYZUEbO9KiNeK5IHtg==
X-Received: by 2002:a5d:6ac6:: with SMTP id u6mr16469981wrw.65.1602273317325;
        Fri, 09 Oct 2020 12:55:17 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id u2sm14069451wre.7.2020.10.09.12.55.16
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 12:55:16 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 0/4] xfs: Remove wrappers for some semaphores
Date:   Fri,  9 Oct 2020 21:55:11 +0200
Message-Id: <20201009195515.82889-1-preichl@redhat.com>
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

Pavel Reichl (4):
  xfs: Refactor xfs_isilocked()
  xfs: clean up whitespace in xfs_isilocked() calls
  xfs: xfs_isilocked() can only check a single lock type
  xfs: replace mrlock_t with rw_semaphores

 fs/xfs/libxfs/xfs_bmap.c  |   8 +--
 fs/xfs/libxfs/xfs_btree.c |  24 +++++++++
 fs/xfs/mrlock.h           |  78 -----------------------------
 fs/xfs/xfs_file.c         |   3 +-
 fs/xfs/xfs_inode.c        | 102 +++++++++++++++++++++++++-------------
 fs/xfs/xfs_inode.h        |  25 ++++++----
 fs/xfs/xfs_iops.c         |   4 +-
 fs/xfs/xfs_linux.h        |   2 +-
 fs/xfs/xfs_qm.c           |   2 +-
 fs/xfs/xfs_super.c        |   6 +--
 10 files changed, 121 insertions(+), 133 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.26.2


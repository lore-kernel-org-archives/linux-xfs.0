Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAD2C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 18:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348690AbiFCSsw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348686AbiFCSsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 14:48:51 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5682612B
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 11:48:50 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n10so7957049pjh.5
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jun 2022 11:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uTVfzS+0ECW2qdfY9MjbLbj8RgSwxtmy0cm0SXMQjYk=;
        b=eIah5nV1V36sHyE2lvTGOjMEP/Ik1zm01AV4yy+RJpKi+NVGEYDH61z3MtM5RKWiBs
         4TezFRng9P7jDenKVouETEJzwjwUVZ7x+M0AUXtRiwm6L6RJT+kL+ecoKH1xAIxkytWG
         WYR20EJGgA6l/uFi0BJLiARCJa1VRmk3YhXP8yzB8En+WSB/oCyBDBfh0n+yG6dMBeTZ
         mdTsZwZy0Pr+aftIhh0uMGy69j6NEIxjwyJ7Na8xGLy/IWJoChLmeOwTNxcAW1sNZqHF
         OV3s7wyfJvIKl3tGZOXZuNZEWdv6oWUCYxwQB/9ika2ciVT8FosryhgAvEZFxnNRVxJq
         Dycg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uTVfzS+0ECW2qdfY9MjbLbj8RgSwxtmy0cm0SXMQjYk=;
        b=gn4qQni1m8a9G5oXWwVghl/Y3qBaV4Jd9toq7mm+7V+Zk37CY8RrGSaLtCb7VTHyST
         ncfQr/qWYoczT/OWj+7yVaK8qQMkLNjFVES5ml3C2MEz0j38s2q9oxWxC5zfd9dwPHxj
         2+lsdsF0LHj4aWyNzQkmPzFxZNf5g3g8YxfwJmc5EPkt3/zvjfg7QO7N+rBfK2xfyqbF
         QQ471cdrJwU7SxykHe+NDV+BDedRz1W+NTLxJ+witNJp+gmmdg/bUMcr78KNI/mA9Adm
         R+Ab2gckdWQavbFnrn2jTJAvq2Rm47B/nAwWh7TNXK3nds6M2Ir6+NMoPAVZQLQr/Tx/
         iUEw==
X-Gm-Message-State: AOAM530xSPjCBDOAeAzD0IC9wLqFQYRlWknjsr1NOL8J191zqwPp8/NJ
        gOQAvvXEjdESMlNWcUz+ZJUHhdmAxIE=
X-Google-Smtp-Source: ABdhPJzZCw4qtmEEdrizBYL01S0b4Lh/qpaCYWBJ7Vpyd23TqF49v35WvYDryNzrnRa0EJBVaAzHBg==
X-Received: by 2002:a17:90b:4a8e:b0:1e4:e2bd:7ff1 with SMTP id lp14-20020a17090b4a8e00b001e4e2bd7ff1mr16089237pjb.58.1654282129900;
        Fri, 03 Jun 2022 11:48:49 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:e74e:a023:a0be:b6a8])
        by smtp.gmail.com with ESMTPSA id z27-20020aa79e5b000000b0051bba3844d2sm5422134pfq.162.2022.06.03.11.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:48:49 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     leah.rumancik@gmail.com, linux-xfs@vger.kernel.org,
        djwong@kernel.org
Cc:     Leah Rumancik <lrumancik@google.com>
Subject: [PATCH 5.15 00/15] xfs stable candidate patches for 5.15.y
Date:   Fri,  3 Jun 2022 11:46:46 -0700
Message-Id: <20220603184701.3117780-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Leah Rumancik <lrumancik@google.com>

This first round of patches aims to take care of the easy cases - patches
with the Fixes tag that apply cleanly. I have ~30 more patches identified
which will be tested next, thanks everyone for the various suggestions
for tracking down more bug fixes. No regressions were seen during
testing when running fstests 3 times per config with the following configs:

xfs defaults
quota
quota 1k
v4
pmem and fsdax
realtime
8k directory blocks
external log
realtime and external log devices
realtime with 28k extents, external log devices
overlayfs atop xfs
overlayfs atop ext4
ext4 defaults

Thanks,
Leah

Brian Foster (1):
  xfs: punch out data fork delalloc blocks on COW writeback failure

Christoph Hellwig (1):
  xfs: remove xfs_inew_wait

Darrick J. Wong (7):
  xfs: remove all COW fork extents when remounting readonly
  xfs: only run COW extent recovery when there are no live extents
  xfs: prevent UAF in xfs_log_item_in_current_chkpt
  xfs: only bother with sync_filesystem during readonly remount
  xfs: don't generate selinux audit messages for capability testing
  xfs: use setattr_copy to set vfs inode attributes
  xfs: don't include bnobt blocks when reserving free block pool

Dave Chinner (4):
  xfs: check sb_meta_uuid for dabuf buffer recovery
  xfs: async CIL flushes need pending pushes to be made stable
  xfs: run callbacks before waking waiters in
    xlog_state_shutdown_callbacks
  xfs: drop async cache flushes from CIL commits.

Rustam Kovhaev (1):
  xfs: use kmem_cache_free() for kmem_cache objects

Yang Xu (1):
  xfs: Fix the free logic of state in xfs_attr_node_hasname

 fs/xfs/libxfs/xfs_attr.c      | 17 ++++-----
 fs/xfs/xfs_aops.c             | 15 ++++++--
 fs/xfs/xfs_bio_io.c           | 35 ------------------
 fs/xfs/xfs_buf_item_recover.c |  2 +-
 fs/xfs/xfs_extfree_item.c     |  6 +--
 fs/xfs/xfs_fsmap.c            |  4 +-
 fs/xfs/xfs_fsops.c            |  2 +-
 fs/xfs/xfs_icache.c           | 21 -----------
 fs/xfs/xfs_inode.h            |  4 +-
 fs/xfs/xfs_ioctl.c            |  2 +-
 fs/xfs/xfs_iops.c             | 58 ++---------------------------
 fs/xfs/xfs_linux.h            |  2 -
 fs/xfs/xfs_log.c              | 58 ++++++++++++-----------------
 fs/xfs/xfs_log_cil.c          | 70 +++++++++++++++++------------------
 fs/xfs/xfs_log_priv.h         |  3 +-
 fs/xfs/xfs_log_recover.c      | 24 +++++++++++-
 fs/xfs/xfs_mount.c            | 12 +-----
 fs/xfs/xfs_mount.h            | 15 ++++++++
 fs/xfs/xfs_pnfs.c             |  3 +-
 fs/xfs/xfs_reflink.c          |  5 ++-
 fs/xfs/xfs_super.c            | 30 ++++++++-------
 kernel/capability.c           |  1 +
 22 files changed, 154 insertions(+), 235 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog


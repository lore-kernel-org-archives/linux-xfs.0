Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27577C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiGRUa3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbiGRUaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:30:13 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B800B87D
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:13 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c6so10087130pla.6
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B/L8zHdbmBeQE12R0NU1tRYt1EAsffoAV+p4XCNKV+E=;
        b=E4cSC9dBQcJHqENxKq9elhBXQDbXsgiwSz/AfIf7i2PDB6Xc9CbGJ6ty35Q7gKXZWh
         irTl6FLHZT0BcHJs7VqnIw12yTL4I5Fmdg+3tFhlR3HcnP7zROieYc4pgvtaFcNBlgAJ
         1sPolCA3WJzVYaEDNlfjgAZaqxdbz+Fc6S2QVJWsst/OPhDy++GQAExGU5UlRouCzSsN
         iRjKuN7meSLs7TRBtwLdL/k/MSDW599xuYqaPVwoMMQK7FgyFdQZM6mhxmDHMN5BLzjn
         Adjl0k5+tFNh5hq2l95Omkspw9NyzHxWfLDvo0bUq3nHuf9S3sNbLEOCFc/uMotWAb8I
         gjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B/L8zHdbmBeQE12R0NU1tRYt1EAsffoAV+p4XCNKV+E=;
        b=AoRCSy72c343RqZRzEQa1upVQ3ZFGIaXZJB7QOcwpa0udO0RPB3rjdpnFhlavRUjfW
         Sh/XXGaGHLUe1lJyv43NHZaBpari1iNmm41uojrON6Zr2HMgMNymXkOliJen6HB4iU0F
         jXWbAn4Hxsmege5u7S2TxkaurDeaMptQp5F9jyQjozION0pUEOM2Q5iEZUSeZfXbthQF
         Wp+rqDj71P5DC5YMrRVqsKrq6rPfb1+FvDE+cs+0m5x3LNQkLi5pSBkNt+ONvPinm4uy
         MOrlKcIjwfgNJYk2GWFVKgPQ9G9y3YhqRwjCF3kKBTkyvbTiclGrwdbNORu2gPbrL56r
         VXmA==
X-Gm-Message-State: AJIora+OOk+gaZkfNtmKvzoq8SRJZQrdQUccQTK1Y9a2afkwzZZan8Nx
        GyUjHIB5J1JG3GJaaenEVX9shww3tjQ=
X-Google-Smtp-Source: AGRyM1sRZdaiQuIuYnoJc3Y1fuMtEzVSr1oFH0D4XEKwPiClqsM7jtcafi/Tv065QHcw4qZLcnk3yA==
X-Received: by 2002:a17:90b:1808:b0:1f0:5e5a:f6e7 with SMTP id lw8-20020a17090b180800b001f05e5af6e7mr41572597pjb.193.1658176212300;
        Mon, 18 Jul 2022 13:30:12 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cd67:7482:195c:2daf])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0ccb00b001ef7fd7954esm11890148pjt.20.2022.07.18.13.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:30:12 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 0/9] xfs stable candidate patches for 5.15.y (part 3)
Date:   Mon, 18 Jul 2022 13:29:50 -0700
Message-Id: <20220718202959.1611129-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi again,

This set contains fixes from 5.16 to 5.17. The normal testing was run
for this set with no regressions found.

I included some fixes for online scrub. I am not sure if this
is in use for 5.15 though so please let me know if these should be
dropped.

Some refactoring patches were included in this set as dependencies:

bf2307b19513 xfs: fold perag loop iteration logic into helper function
    dependency for f1788b5e5ee25bedf00bb4d25f82b93820d61189
f1788b5e5ee2 xfs: rename the next_agno perag iteration variable
    dependency for 8ed004eb9d07a5d6114db3e97a166707c186262d

Thanks,
Leah


Brian Foster (4):
  xfs: fold perag loop iteration logic into helper function
  xfs: rename the next_agno perag iteration variable
  xfs: terminate perag iteration reliably on agcount
  xfs: fix perag reference leak on iteration race with growfs

Dan Carpenter (1):
  xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()

Darrick J. Wong (4):
  xfs: fix maxlevels comparisons in the btree staging code
  xfs: fix incorrect decoding in xchk_btree_cur_fsbno
  xfs: fix quotaoff mutex usage now that we don't support disabling it
  xfs: fix a bug in the online fsck directory leaf1 bestcount check

 fs/xfs/libxfs/xfs_ag.h            | 36 ++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_btree_staging.c |  4 ++--
 fs/xfs/scrub/dir.c                | 15 +++++++++----
 fs/xfs/scrub/quota.c              |  4 ++--
 fs/xfs/scrub/repair.c             |  3 +++
 fs/xfs/scrub/scrub.c              |  4 ----
 fs/xfs/scrub/scrub.h              |  1 -
 fs/xfs/scrub/trace.c              |  7 +++---
 fs/xfs/xfs_ioctl.c                |  2 +-
 fs/xfs/xfs_ioctl.h                |  5 +++--
 fs/xfs/xfs_qm_syscalls.c          | 11 +---------
 11 files changed, 48 insertions(+), 44 deletions(-)

-- 
2.37.0.170.g444d1eabd0-goog


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932FBC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7737B60F37
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhGZLHG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbhGZLHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5D3C061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:35 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b1-20020a17090a8001b029017700de3903so796158pjn.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P7EbrKD82+V5N/f+v2JXbXWMxlDD2n7AP6n1J2U6UOA=;
        b=cm7jM2gI5Y63ab8yogR7bhB/JeDneGoEvySUC5xRRJcabSR+30jaFPXZ8PNzO/tOWc
         99M53+pHxK1DEBClpuU8TN4XeWqQaQOEWuUdyd/BIPfM1qzuWdhiul680ujEu5hEey09
         hAcHcZsee0bc3IlQZjEvWDUQpachPyoFVaUzbW9ueNgt1ZaQd5TXvQ0s5OXensghs8AF
         ftAw+eDgIZVS9sG5g3y9pcjKS2MA9ce2UsF7X44bZsqDFwqXjSUy0sPy8g0bQzg0oSiE
         b0qBWO8leIeMQ7ftOeloJfDC7JTtrNGft1pjhbzujSeG3cD749S+M+o7KVUDGBl1JUxK
         IJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P7EbrKD82+V5N/f+v2JXbXWMxlDD2n7AP6n1J2U6UOA=;
        b=nF5L6WW2NIX4qnaGq9s6s2xfsKnR+knMNBNGe2WhuPOV+YP0J7XcO9P0XOxAuqqe1z
         6VGwxeoHS2uOpwcV8m0VOSj/Je/GA7HFg9ssB/HFVgXukezFU2sRIcpaosdwm5qTpgJQ
         VExcL9QfPNOQUMMdQIrmG/ZR97rTEuCmhh/4BjnvKndsvOjeKAnWg3DzvF9SBoPWBtxT
         sZQqIjOWa9ftMjTSqDUqrxSsmo6Dt1nDkIBINV6cH0hPeXXAeBLWJjzK44XPZnev2tdD
         dJ+NvokWYlmhM9NqMRFVJgvMOOATBoNbyw6h3kytVESBz8c6XBda1ewRwvXdYpIbZURY
         B9FA==
X-Gm-Message-State: AOAM533KuLR2fdxQdAFLDuPE8nL039CDnILdL+xcLq7EWT38z9FnSa5d
        DqLLqoLglmV8HNHudjpylg5VSMGOdCE=
X-Google-Smtp-Source: ABdhPJxaPhCteS5a+fCkOw2LQys04ir2Z7SUsPP0hB5xGw2lZdGSdjouzexKg0uj5KdM9nYWzFbLdA==
X-Received: by 2002:a63:9c5:: with SMTP id 188mr14504386pgj.187.1627300054918;
        Mon, 26 Jul 2021 04:47:34 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:34 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 00/12] xfsprogs: Extend per-inode extent counters
Date:   Mon, 26 Jul 2021 17:17:12 +0530
Message-Id: <20210726114724.24956-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patchset implements the changes to userspace programs that are
required to support extending inode's data and attr fork extent
counter fields. It adds the following capabilities to xfsprogs,
1. Add support to programs in xfsprogs to be able to create and work
   with filesystem instances with 64-bit data fork extent counter and
   32-bit attr fork extent counter fields.
2. Enable support for the newly introduced XFS_IOC_BULKSTAT_V6 ioctl.

The patchset is based on Darrick's btree-dynamic-depth branch.
These patches can also be obtained from
https://github.com/chandanr/xfsprogs-dev.git at branch
xfs-incompat-extend-extcnt-v2.

Changelog:
V1 -> V2:
1. Rebase patches on top of Darrick's btree-dynamic-depth branch.
2. Add support for using the new bulkstat ioctl version to support
   64-bit data fork extent counter field.
   
Chandan Babu R (12):
  xfsprogs: Move extent count limits to xfs_format.h
  xfsprogs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32,
    XFS_IFORK_EXTCNT_MAXS16
  xfsprogs: Introduce xfs_iext_max() helper
  xfsprogs: Use xfs_extnum_t instead of basic data types
  xfsprogs: Introduce xfs_dfork_nextents() helper
  xfsprogs: xfs_dfork_nextents: Return extent count via an out argument
  xfsprogs: Rename inode's extent counter fields based on their width
  xfsprogs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
    respectively
  xfsprogs: Rename XFS_IOC_BULKSTAT to XFS_IOC_BULKSTAT_V5
  xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
  xfsprogs: Extend per-inode extent counter widths
  xfsprogs: Add extcnt64bit mkfs option

 db/bmap.c                  |  21 +--
 db/btdump.c                |  11 +-
 db/check.c                 |  44 +++++--
 db/field.c                 |   4 -
 db/field.h                 |   2 -
 db/frag.c                  |  11 +-
 db/inode.c                 |  62 +++++++--
 db/metadump.c              |  12 +-
 fsr/xfs_fsr.c              |   9 +-
 include/libxlog.h          |   6 +-
 io/bulkstat.c              |  10 +-
 libfrog/bulkstat.c         | 264 +++++++++++++++++++++----------------
 libfrog/bulkstat.h         |   7 +-
 libfrog/fsgeom.h           |   5 +-
 libxfs/xfs_bmap.c          |  19 ++-
 libxfs/xfs_format.h        |  30 +++--
 libxfs/xfs_fs.h            |   9 +-
 libxfs/xfs_inode_buf.c     |  86 ++++++++++--
 libxfs/xfs_inode_buf.h     |   2 +
 libxfs/xfs_inode_fork.c    |  38 ++++--
 libxfs/xfs_inode_fork.h    |  18 +++
 libxfs/xfs_log_format.h    |   7 +-
 libxfs/xfs_types.h         |  11 +-
 logprint/log_misc.c        |  23 +++-
 logprint/log_print_all.c   |  34 ++++-
 logprint/log_print_trans.c |   2 +-
 man/man8/mkfs.xfs.8        |   7 +
 mkfs/xfs_mkfs.c            |  23 ++++
 repair/attr_repair.c       |  11 +-
 repair/bmap_repair.c       |  22 +++-
 repair/dinode.c            | 139 ++++++++++++-------
 repair/dinode.h            |   4 +-
 repair/prefetch.c          |   7 +-
 repair/scan.c              |   6 +-
 34 files changed, 665 insertions(+), 301 deletions(-)

-- 
2.30.2


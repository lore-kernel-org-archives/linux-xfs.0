Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBB2C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjKNBxv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjKNBxu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:53:50 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFF7D43
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:47 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1cc34c3420bso39053115ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926826; x=1700531626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vBkFTSdI2/KhkAv/PVvPGUlWdSIRmUeAPQB1bjlH7kU=;
        b=SpjcwpMQJYDePBGeiVnTOw0J3fuiYfR6jSLvvMN5Q19vo245YIvTggtE3mq4goZVqM
         IXsnP91WvrNR7tIdQQV3pCAU7rqkI56BUM4xIRG2o20K+A24w70fsCB3fVrzdKf8sGbl
         fFHLxnbQ5WYSi9P+hPOgR1H583yPuoydUFoPT5LHmQoFoj713mlBckFciaLWReK9Ovq7
         dO/UpdNrPeWSyrYepjU9ymNvKvaQhU2Q+D246jduxfBVVRc9fDMvdXka+y5YbrwEAASb
         bubp6suvSXFxmGHMi0priwpMGzFTYQVCAsQebAPYvbNI+ou10YlkcPBlFcRMawRVv8xB
         Ishw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926826; x=1700531626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vBkFTSdI2/KhkAv/PVvPGUlWdSIRmUeAPQB1bjlH7kU=;
        b=J2B0bii9mVzjB86GSTGCoSvWtJMR3jGUvcGsH6GWtHoy8dhRCzgUfk0l2AcdF0123Y
         4+tbkuL8ZyTBrkhrzY7zAu9kKzq7v7Is6DGin58TKW/b0zSV+cdNu0Abeb1YEJF1nwF8
         VRNRazycR9bqQkaESgUnnvrcyuxmQSesaIJDzoThKVaEj8hDe1kRNHhLptREhcxlvBHq
         s00ufUZJLRyMX9neNIzc9agI9kCOEseUY7ljMlaCc3Au/GDqQWpUnz/Qf2idt0Slq7zN
         xIz5vxOyPpQNu2pUoRHG7o/jABXUJRRYDa2dLT0Y4lFvRpQk0peLBWfW7doLMi1XhQ2q
         5BoA==
X-Gm-Message-State: AOJu0YwzLQQ1t/LMz0y7+17Q3lpIJQqqKei82RbGW/V2YRXsF9iE1mc+
        vVfa0Vv7a/volB0U7Ef72kBYGpuzeWw=
X-Google-Smtp-Source: AGHT+IFIxupDdWyDLLWQmiNamPu+9xPrB7MlNAK/a1y2wmdJaTjA+/6Qlt+Y4HrsT+80kqPOf3sRYA==
X-Received: by 2002:a17:903:2346:b0:1c9:9e33:3a7d with SMTP id c6-20020a170903234600b001c99e333a7dmr1261301plh.20.1699926826598;
        Mon, 13 Nov 2023 17:53:46 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:46 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 00/17] 5.15 backports from 5.19..6.1
Date:   Mon, 13 Nov 2023 17:53:21 -0800
Message-ID: <20231114015339.3922119-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

Here is the next set of fixes for 5.15. Tested on 10 configs x 30 runs
with no regressions seen on these commits. Commit 7d839e325a "xfs: check
return codes when flushing block devices" is in this range but was left
out for now as it revealed a regression which exists upstream. I'll
include it in a future set once its fix is accepted.

- Leah

Chandan Babu R (1):
  xfs: Fix false ENOSPC when performing direct write on a delalloc
    extent in cow fork

ChenXiaoSong (1):
  xfs: fix NULL pointer dereference in xfs_getbmap()

Darrick J. Wong (8):
  xfs: refactor buffer cancellation table allocation
  xfs: don't leak xfs_buf_cancel structures when recovery fails
  xfs: convert buf_cancel_table allocation to kmalloc_array
  xfs: prevent a UAF when log IO errors race with unmount
  xfs: fix use-after-free in xattr node block inactivation
  xfs: don't leak memory when attr fork loading fails
  xfs: fix intermittent hang during quotacheck
  xfs: avoid a UAF when log intent item recovery fails

Gao Xiang (1):
  xfs: add missing cmap->br_state = XFS_EXT_NORM update

Guo Xuenan (1):
  xfs: fix exception caused by unexpected illegal bestcount in leaf dir

Kaixu Xia (1):
  xfs: use invalidate_lock to check the state of mmap_lock

Li Zetao (1):
  xfs: Fix unreferenced object reported by kmemleak in xfs_sysfs_init()

Zeng Heng (1):
  xfs: fix memory leak in xfs_errortag_init

Zhang Yi (1):
  xfs: flush inode gc workqueue before clearing agi bucket

hexiaole (1):
  xfs: fix inode reservation space for removing transaction

 fs/xfs/libxfs/xfs_dir2_leaf.c   |   9 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |   1 +
 fs/xfs/libxfs/xfs_log_recover.h |  14 ++-
 fs/xfs/libxfs/xfs_trans_resv.c  |   2 +-
 fs/xfs/xfs_attr_inactive.c      |   8 +-
 fs/xfs/xfs_bmap_util.c          |  17 +--
 fs/xfs/xfs_buf_item_recover.c   |  66 +++++++++++
 fs/xfs/xfs_error.c              |   9 +-
 fs/xfs/xfs_inode.c              |   4 +-
 fs/xfs/xfs_log.c                |   9 +-
 fs/xfs/xfs_log_priv.h           |   3 -
 fs/xfs/xfs_log_recover.c        |  44 +++----
 fs/xfs/xfs_qm.c                 |   7 ++
 fs/xfs/xfs_reflink.c            | 197 ++++++++++++++++++++++++++------
 fs/xfs/xfs_sysfs.h              |   7 +-
 15 files changed, 307 insertions(+), 90 deletions(-)

-- 
2.43.0.rc0.421.g78406f8d94-goog


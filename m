Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284B9C43461
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 19:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDE8E206B2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 19:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GG+yeQda"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbgIPTC4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 15:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727478AbgIPRsf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 13:48:35 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5029EC061A86
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:19 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f1so3013143plo.13
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AALbruuPPraRLpDoXeJYoUkBqG+rKrUyiHS5RNr4WRg=;
        b=GG+yeQdaU10Nj7/yBVuuCeVxns0MuG7tbN8JHzANMZ7oUrtEemv90gE94Mh6rkbvqq
         2+saK/pOyJlxT6jU7uGvfD8C6yEL5XagaExs+udl5YLDYkaMleBIww/GghEec/IzZcEh
         MHgW7IaYgKtjMQiWbg4h/bxGc//9vxHlLR3oswiROtHrgLCq885IrO/8ttBeNFu/U6n2
         FTELcVQtYgFEYFViuPUZI8oZJw3sJ4l9BXzzn0VDcREOy9azir09/bA1EOYglmFmCCjl
         4A9y5skGeHuv4Ap2asq2QFFMjF1GXrtCn5NTsitFCxyjDJutO5RbFKdj0+i7tvmiM/NV
         xGcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AALbruuPPraRLpDoXeJYoUkBqG+rKrUyiHS5RNr4WRg=;
        b=adtt+Pp1QaVWKBoD5rSwCb1VztF+D4iRjfizc957AJ6mF3HWh64KN90EkCfmvvl2KW
         n7gb27+kLvmYK7dY2AkJ39GUBo7FwXTqmLuApveycM/riGCLDQURYLSSnX0ZUvQ0xf6q
         ekjhz/C06GJlsd2mUEQnTYxAB1jhGH+q0X8H6UkebYoMJlAm09hFejA+k3Bx5UXMIWMK
         L3Rjvg+Lglmp0rYwabk4tLOYeSX5PK7sgftJ2O3hVMGAZsi6ou1AmmRRzPIKne9evbhd
         eWr/wSqkdbS/btcFkbFG5+6oxIeWPN4WdHfaXHCUXqgIaNgXnil66K3aNLAox5ppBUGd
         cYbg==
X-Gm-Message-State: AOAM531Gnc3E+nU+mNP2ilZcq5EZQw6J9US3MmAo/A40xdTLQH5e9vob
        S8aGO7t9W5e0ibdCwOPC0OUXOE3E+w==
X-Google-Smtp-Source: ABdhPJwBGs3ucpoGmmhUn5PqheOn9IWy7A5tqEuStT283aMoX+P7wHrrt77Pqt6aWMhMWBlqmLQjYg==
X-Received: by 2002:a17:90a:71c9:: with SMTP id m9mr3450503pjs.146.1600255158347;
        Wed, 16 Sep 2020 04:19:18 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v204sm3492195pfc.10.2020.09.16.04.19.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 04:19:17 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [RFC PATCH 0/9]xfs: random fixes and code cleanup
Date:   Wed, 16 Sep 2020 19:19:03 +0800
Message-Id: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi all,

This patchset include random fixes and code cleanups, and there are no
connections among these patches. In order to make it easier to track,
I bundle them up and put all the scattered patches into a single patchset.

Kaixu Xia (9):
  xfs: remove the unused SYNCHRONIZE macro
  xfs: use the existing type definition for di_projid
  xfs: remove the unnecessary xfs_dqid_t type cast
  xfs: do the assert for all the log done items in xfs_trans_cancel
  xfs: add the XFS_ITEM_LOG_INTENT flag to mark the log intent item
  xfs: remove the unnecessary variable error in
    xfs_trans_unreserve_and_mod_sb
  xfs: remove the repeated crc verification in xfs_attr3_rmt_verify
  xfs: cleanup the useless backslash in xfs_attr_leaf_entsize_remote
  xfs: fix some comments

 fs/xfs/libxfs/xfs_attr_remote.c |  2 --
 fs/xfs/libxfs/xfs_da_format.h   |  6 +++---
 fs/xfs/libxfs/xfs_inode_buf.h   |  2 +-
 fs/xfs/xfs_bmap_item.c          |  3 ++-
 fs/xfs/xfs_dquot.c              |  4 ++--
 fs/xfs/xfs_extfree_item.c       |  3 ++-
 fs/xfs/xfs_linux.h              |  1 -
 fs/xfs/xfs_log_recover.c        | 15 ++++-----------
 fs/xfs/xfs_qm.c                 |  2 +-
 fs/xfs/xfs_refcount_item.c      |  3 ++-
 fs/xfs/xfs_rmap_item.c          |  3 ++-
 fs/xfs/xfs_trans.c              |  9 +++------
 fs/xfs/xfs_trans.h              |  5 +++++
 13 files changed, 27 insertions(+), 31 deletions(-)

-- 
2.20.0


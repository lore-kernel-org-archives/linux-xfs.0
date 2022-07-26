Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE32C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 09:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiGZJVd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 05:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbiGZJVc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 05:21:32 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6DF2B62F;
        Tue, 26 Jul 2022 02:21:31 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id tk8so25022615ejc.7;
        Tue, 26 Jul 2022 02:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KUc7K2/MUs2SgPKS71HgrrbL4+FBYqvSCQg21Jxaskw=;
        b=WZKMOsbp4J+Lcb6qwQRNYH7DIbk1Qtg3Qu44NI/Zmstff7+cJ6Aa0R40PBXJ9i72zE
         0DYk0Vp/1Cg2njud6uemHGJ3GPqp8mh9JhJwE87NmTENadgnQ6L4AwpZ6CkaBOkS38Wp
         BU3TgclI/DEhaQxZEYyJZurFZ7AKF8iz/qV/9qgzZ7+WddDpiTEOnaEZMVrcnp03tNyo
         JcS1FvJeOOOSUn/hgHCvEHKlcLMWdsfZx0TY45aJWcmJwTtA63wrkdSsLLgr0QcfWBzi
         WzQKBT7xHl3rv7oCoieYe4+g+ZWHxFtCVpNg0dLrf9XkLe+G+M07L12eQ+Lkl5qNblj6
         90aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KUc7K2/MUs2SgPKS71HgrrbL4+FBYqvSCQg21Jxaskw=;
        b=HXiAW4Z3WIFUNQz/eF2SAcq67FM5wnLj37bdoFnVoOzG3ZPAC+bNmVyblqfCMIcS7h
         XEGE2h/YvYBLgqhDPcqWd7/9PXQKh8SKwhnej7j9O1JlMsocVHh05bQ84za2HNC8UYGO
         gKsFtWqvUwTUYTj+C03N/Omo4E2JVJoMgTipLl4M+mESAuk396oEgt4KJ+VSCfvYRLOQ
         cEQr4iR2+wnRYMNCHYSA7nGyIefM153GWIa9ejRL1LoqWeZ6MRkD3wNeuHufnJhN9cM7
         hYO4MV2//bsuv2VA7mmYuPYZp00dAJCdMe2iatoUlKuTHg9eUCayf140WpkLuOK1p2vG
         3ZFw==
X-Gm-Message-State: AJIora+dWOhicCs6lEZzKDVi8GjHCFpbERA7fTU4zkQUmgS3S8StD3Wx
        aeWGWd3Or0ywheRXDkwbfIZWDyYuGhb+CQ==
X-Google-Smtp-Source: AGRyM1v7BUsUnzFmS+TAzf3f0h8THFlQZW8uqj+IViCNzv2pAav/0rIH4rAB3yLqOZ3hzK+c/XKYNw==
X-Received: by 2002:a17:907:1c01:b0:6f4:2692:e23 with SMTP id nc1-20020a1709071c0100b006f426920e23mr13292207ejc.243.1658827289808;
        Tue, 26 Jul 2022 02:21:29 -0700 (PDT)
Received: from amir-ThinkPad-T480.kpn (2a02-a45a-4ae9-1-7aa-6650-a0dd-61a2.fixed6.kpn.net. [2a02:a45a:4ae9:1:7aa:6650:a0dd:61a2])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402071100b0043aa17dc199sm8161528edx.90.2022.07.26.02.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 02:21:28 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 0/9] xfs stable candidate patches for 5.10.y (from v5.13+)
Date:   Tue, 26 Jul 2022 11:21:16 +0200
Message-Id: <20220726092125.3899077-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick,

This backport series contains mostly fixes from v5.14 release along
with three deferred patches from the joint 5.10/5.15 series [1].

I ran the auto group 10 times on baseline (v5.10.131) and this series
with no observed regressions.

I ran the recoveryloop group 100 times with no observed regressions.
The soak group run is in progress (10+) with no observed regressions
so far.

I am somewhat disappointed from not seeing any improvement in the
results of the recoveryloop tests comapred to baseline.

This is the summary of the recoveryloop test results on both baseline
and backport branch:

generic,455, generic/457, generic/646: pass
generic/019, generic/475, generic/648: failing often in all config
generic/388: failing often with reflink_1024
generic/388: failing at ~1/50 rate for any config
generic/482: failing often on V4 configs
generic/482: failing at ~1/100 rate for V5 configs
xfs/057: failing at ~1/200 rate for any config

I observed no failures in soak group so far neither on baseline nor
on backport branch. I will update when I have more results.

Please let me know if there is anything else that you would like me
to test.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-xfs/20220617100641.1653164-1-amir73il@gmail.com/

Brian Foster (2):
  xfs: hold buffer across unpin and potential shutdown processing
  xfs: remove dead stale buf unpin handling code

Christoph Hellwig (1):
  xfs: refactor xfs_file_fsync

Darrick J. Wong (3):
  xfs: prevent UAF in xfs_log_item_in_current_chkpt
  xfs: fix log intent recovery ENOSPC shutdowns when inactivating inodes
  xfs: force the log offline when log intent item recovery fails

Dave Chinner (3):
  xfs: xfs_log_force_lsn isn't passed a LSN
  xfs: logging the on disk inode LSN can make it go backwards
  xfs: Enforce attr3 buffer recovery order

 fs/xfs/libxfs/xfs_log_format.h  | 11 ++++-
 fs/xfs/libxfs/xfs_types.h       |  1 +
 fs/xfs/xfs_buf_item.c           | 60 ++++++++++--------------
 fs/xfs/xfs_buf_item_recover.c   |  1 +
 fs/xfs/xfs_dquot_item.c         |  2 +-
 fs/xfs/xfs_file.c               | 81 ++++++++++++++++++++-------------
 fs/xfs/xfs_inode.c              | 10 ++--
 fs/xfs/xfs_inode_item.c         |  4 +-
 fs/xfs/xfs_inode_item.h         |  2 +-
 fs/xfs/xfs_inode_item_recover.c | 39 ++++++++++++----
 fs/xfs/xfs_log.c                | 30 ++++++------
 fs/xfs/xfs_log.h                |  4 +-
 fs/xfs/xfs_log_cil.c            | 32 +++++--------
 fs/xfs/xfs_log_priv.h           | 15 +++---
 fs/xfs/xfs_log_recover.c        |  5 +-
 fs/xfs/xfs_mount.c              | 10 +++-
 fs/xfs/xfs_trans.c              |  6 +--
 fs/xfs/xfs_trans.h              |  4 +-
 18 files changed, 179 insertions(+), 138 deletions(-)

-- 
2.25.1


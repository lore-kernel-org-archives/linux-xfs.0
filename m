Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259FBC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E41A4206BE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 11:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gx5fu8Ml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgIQLnI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 07:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgIQLi4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 07:38:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0221C061756
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:38:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d9so1051624pfd.3
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4ufCmlG0OIXvg8AR4mi/CXQ658A7yveBgWXLRlBhbX8=;
        b=Gx5fu8MlnxF77OcIvnzzimJOhBjqISZiCctVzVyZaH7uCnjcJtway0uS7z1sAHDIMG
         AH9+hyrEFXCg5g3pexf11S7EQ0iikLJ++IW14PLuuz0lzAr2HDGCnNTbAxcZ/usSN/8N
         9hPssjJacDmJ6ilT3NPNoVi/MhUW9M/q12UcSysR3VDyesc6b+1AudcgW5uat/L0Eou2
         02LvWd+fgNkJYi9Ust3/YNFt8sclyclQRBD7uPHnJQ3wLcciC4H6NuBn2sCjfI/HWqlr
         8st6nTD8zxh02pxkEnNuGvgIAAgrrEbojNDCUopN6wh525LvpzUj9rr+iik9cSk7Ht7L
         mngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4ufCmlG0OIXvg8AR4mi/CXQ658A7yveBgWXLRlBhbX8=;
        b=rw034KBda5SoRLEmd3kLRWYJhPlw0cMgb3OxUVO3QesAtoRQQUXtXlUAbStCC/N1gZ
         GXK9BSc/U7HT5qWHlyj8duNyYnbvpRb6UJSOyNSkqxX0FjNz7/DkQeTE+f8LcSsTlaqT
         lJW1rw14RrshYleRQbjTQSKQMXmtyJTx8GFPOgIk7VOqWgEutVZ6GV2Hog/jxLbYN8/w
         Mu9fmE2kOuHtnxsUxZ2R+mV2iVhkMWsqtvx2NgUlfhl6hZcGtOuTsc0dGU9N8ZLsVZZE
         ExO9suSw2rcPhtz6b3a1n07h0xA1HKo3PtDba5aQzTub5TtnBPkX0go/HZXLwkdKmtjO
         JRgg==
X-Gm-Message-State: AOAM533lLi+4Gbwg8cMJefiUuhXk/NDC5mwmq8EAZJ6uNKrvG5ZNJtVp
        +DLiPUcHLuo3No40fV7F0NxpPg4+8A==
X-Google-Smtp-Source: ABdhPJzcTaCN8X5x3R9Xvkn40swRYtBc8E8AIMLqLihNvjAurXDwPXnNSJeqMJDnu+I+mLaNYhnI+g==
X-Received: by 2002:a62:301:0:b029:13c:1611:6528 with SMTP id 1-20020a6203010000b029013c16116528mr26543881pfd.8.1600342733709;
        Thu, 17 Sep 2020 04:38:53 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 64sm18761147pgi.90.2020.09.17.04.38.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 04:38:52 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 0/7] xfs: random fixes and code cleanup
Date:   Thu, 17 Sep 2020 19:38:41 +0800
Message-Id: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi all,

This patchset include random fixes and code cleanups, and there are no
connections among these patches. In order to make it easier to track,
I bundle them up and put all the scattered patches into a single patchset.

Changes for v2: 
 -detect intent-done items by their item ops.
 -update the commit messages.
 -code cleanup for xfs_attr_leaf_entsize_{remote,local}.

Kaixu Xia (7):
  xfs: remove the unused SYNCHRONIZE macro
  xfs: use the existing type definition for di_projid
  xfs: remove the unnecessary xfs_dqid_t type cast
  xfs: do the assert for all the log done items in xfs_trans_cancel
  xfs: remove the redundant crc feature check in xfs_attr3_rmt_verify
  xfs: code cleanup in xfs_attr_leaf_entsize_{remote,local}
  xfs: fix some comments

 fs/xfs/libxfs/xfs_attr_remote.c |  2 --
 fs/xfs/libxfs/xfs_da_format.h   | 12 ++++++------
 fs/xfs/libxfs/xfs_inode_buf.h   |  2 +-
 fs/xfs/xfs_dquot.c              |  4 ++--
 fs/xfs/xfs_linux.h              |  1 -
 fs/xfs/xfs_qm.c                 |  2 +-
 fs/xfs/xfs_trans.c              |  9 ++++++++-
 7 files changed, 18 insertions(+), 14 deletions(-)

-- 
2.20.0


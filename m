Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DF2C433E7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 03:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E103207F7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 03:38:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F8uJuZmv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394240AbgJPDif (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394231AbgJPDif (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 23:38:35 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12671C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 20:38:35 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id w11so511758pll.8
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 20:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=12TFOlxKBEoV8xmAat4X3l0NrJyieQjEtEif/7WAH0k=;
        b=F8uJuZmvtX1/g1BJNkFtiAX/Qd/MaWfIID9hYfjutSNGNW0U7o59DEuoKqRTGCS5k/
         Am/JCxClt3h+vBBdqkiPhJ86bpLdV1zXIln9Sy7Nzd0farc6KfEMH9CbL60q6JliHHpm
         LZLUoDHwhBJJkTyD39HKy4itqDEq52gyjaMULH02TX4VCLkUfwrXdSXPO88l6QQXb7oN
         W0+s41kTZVgye7BzFPkW2oSYtzaa5UsKwu05IaKAFk7lvtwqQu+VcSEj8HjmDy8/xjkg
         uwaxH88Pq6zJprkwUeV34KZglvdNuq7CyInaK2m1iurIEGTZxxkJI2SJiE4vTPd7D+vi
         5hlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=12TFOlxKBEoV8xmAat4X3l0NrJyieQjEtEif/7WAH0k=;
        b=aUwPNC3KJolVeIaWSYo4WuhRSHkqU89funVcTJJeYJpblu02kH/h068Bn13T4W7jgO
         vXze+y5fuUKZSUuw7qZ8MeEDarrf6HimA0ekolO6/7TiFNUAT5E3B1dYRxyToqXXZx84
         Ab/aql+LIXthAF/GURIhcISFnaqJcxZolFiiwKn5hnxE7z2eI5tK0NWmNkaBSo5sN8Q/
         FKdqd/PUUrMMQBp5lpy3GqmRvsM8B01eFZms2HpZ8Pz/lw3p4ScC3/MdDsNDmXxQSsYs
         SPYlMJQ2NpG3SJVz0Kv9x+LcZZCaLDIQHkOVot6U2VXxONJ6dvcXLNQWSAUOQGLGo+nE
         FXPw==
X-Gm-Message-State: AOAM530qo10ZrideiELQbcnnIZkzuX3BBOWwZiXNika7DQjcAa4N43h0
        dd4wTDvbPpnlmFQTp7bRw8Uzf9BNrw==
X-Google-Smtp-Source: ABdhPJyk7lYPuX6Lkjmka2oEAv0VeVhyBl7M5jx3LTqqYeiXf0qxcDaROBDCI129iuZe0f31wh5f2g==
X-Received: by 2002:a17:902:c286:b029:d4:e3fa:94f6 with SMTP id i6-20020a170902c286b02900d4e3fa94f6mr1955282pld.15.1602819514302;
        Thu, 15 Oct 2020 20:38:34 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id o15sm890238pfp.91.2020.10.15.20.38.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2020 20:38:33 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v6 0/3] xfs: random fixes for disk quota
Date:   Fri, 16 Oct 2020 11:38:25 +0800
Message-Id: <1602819508-29033-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi all,

This patchset include random fixes and code cleanups for disk quota.
In order to make it easier to track, I bundle them up and put all
the scattered patches into a single patchset.

Changes for v6:
 -fix the long line warnings in commit messages and some formatting
  issues.

Changes for v5:
 -drop the check for delta != 0 in xfs_trans_dqresv().

Changes for v4:
 -delete duplicated tp->t_dqinfo null check and allocation in one
  patch.
 -drop the first two patches that have been applied.

Changes for v3:
 -add a separate patch to delete duplicated tp->t_dqinfo null check
  and allocation.

Changes for v2: 
 -add the ASSERT for the arguments O_{u,g,p}dqpp.
 -fix the strange indent.
 -remove the XFS_TRANS_DQ_DIRTY flag.
 -add more commit log description for delta judgement.

Kaixu Xia (3):
  xfs: delete duplicated tp->t_dqinfo null check and allocation
  xfs: check tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag
  xfs: directly return if the delta equal to zero

 fs/xfs/libxfs/xfs_shared.h |  1 -
 fs/xfs/xfs_inode.c         |  8 +------
 fs/xfs/xfs_trans_dquot.c   | 43 ++++++++++----------------------------
 3 files changed, 12 insertions(+), 40 deletions(-)

-- 
2.20.0


Return-Path: <SRS0=54mU=DR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26FCC433E7
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 03:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D43E2076B
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 03:09:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhX6Sea1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbgJJDId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 23:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730273AbgJJCy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 22:54:28 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3582EC0613CF
        for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2020 19:54:28 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id g10so8437680pfc.8
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 19:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qqATmTFahsP8t600YGQZybxUpkfXGnZKkoYLa00v09s=;
        b=HhX6Sea1WTLJviivP/pYu8NDTlLMl2DKO4rdtQQYhUyfQYPEw1SPTjFaT7zCwTWZuN
         a5DafoLJZMg3BQyIDqKXFtwyTPSaeVt7Hm/Uq+jh2rOFiyyEiRg2edjTeOW2jA2nXRF5
         YfHWYCHc5y6daVIshStqH7jZiaiKsbBVtya+YGF7WW28ihSMjq8LiKsVwNjZGwidUWJ/
         IyvaoCrJKTabPpdgOYHZPXJ3c/5NBsU3WgIg4ngGEjKCXbV/7Qg99DoxmgO3heC6Zn3C
         cD2ABgEjMGSPDHXAU9uIflMiryoJLV4rM0Tpnwc2r4nD7s3xFy9X4ULKcna1BtoI8aR0
         sEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qqATmTFahsP8t600YGQZybxUpkfXGnZKkoYLa00v09s=;
        b=HFr6tDJk2jON4SL8r87JbfASptZbNq9NQBkdZzY7B7MnrHJv0hTokUaKIYvDGezBr/
         WwtVDUkjCRzMgXJa9Dcs9RUPKAtZvBvfUmSCgdGgJwFaItBKhcTQHOpHmo4S1lJTKmJM
         HXgW5aYxjHzzxB3e5dZ5yAHvhkEVmxouzyVH9F//KIrmdCtLqDXIHX9M3hblrLOFeprT
         U3wTIwSpFiOP9Qm0Gsyu2EHfMFRxmXnVlTM5WbJ7slVUlZmafFAT05DwDKGSb6p6DuuV
         nx2Sq4rLvFrFu2WcaHLURBzJpr996ERE94iRUmUbp6A8aejM9C3vKynR8k6WIhuwVyru
         5ykg==
X-Gm-Message-State: AOAM531zjX4OAAh1OG1/28/vaODoK3MH5s3ZmMOvqt+DPaSY4/P5WrwL
        Z/lskCpxKKyZz7moHbDt9j39lOfZ6sgH
X-Google-Smtp-Source: ABdhPJxcD480HzTXa7+kavAIh4kO6ycMbdlVRMvEHJl1WgGNFFVpp9YfMviEcr/xU5idlnpXDAC4pg==
X-Received: by 2002:aa7:8249:0:b029:142:2501:34db with SMTP id e9-20020aa782490000b0290142250134dbmr15199953pfn.52.1602298467255;
        Fri, 09 Oct 2020 19:54:27 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id kc21sm4800826pjb.36.2020.10.09.19.54.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Oct 2020 19:54:26 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v5 0/3] xfs: random fixes for disk quota
Date:   Sat, 10 Oct 2020 10:54:18 +0800
Message-Id: <1602298461-32576-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi all,

This patchset include random fixes and code cleanups for disk quota.
In order to make it easier to track, I bundle them up and put all
the scattered patches into a single patchset.

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
 fs/xfs/xfs_trans_dquot.c   | 46 ++++++++++++--------------------------
 3 files changed, 15 insertions(+), 40 deletions(-)

-- 
2.20.0


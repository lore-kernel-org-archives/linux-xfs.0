Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5631DC4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF31D208C7
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="utEloKxS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgJGOvV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgJGOvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 10:51:21 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D34C061755
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 07:51:21 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p11so1123246pld.5
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 07:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=G1VEGJN5kl0xdQPD+w+UcbuhtI9z1nGQhktbcM7/qKQ=;
        b=utEloKxSsQT0D1gDro3XgEXfrDPxpyo+ExZSOU3CQDWHV0S6wBsBsB1QTkfp7K5G3U
         QlULKr0GzEh2bC/PXAf4e7qU6MFF6RfPAVLfvqHkypfi9yu1rx/ENKPsmF9d67+kHRsx
         +3UDvQH1T+6DTfKl/KCg0NO98dc99lVMsOW857vFT0KqETi1a+sZyrvFiQapGTYwfpJk
         dJfHJq1NcoZyoX1i5ZgMJLt6U0SD3v58qXR8yhHrJZb2GPsPOv2ZBLfU5ctB2EMfVGbc
         /xuN6Z6eS24uKaIThw6f0BzWtuuNLsbLp2r6LLz/cB3xZembEb68/fX+MbJlBWAJuf91
         L3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=G1VEGJN5kl0xdQPD+w+UcbuhtI9z1nGQhktbcM7/qKQ=;
        b=LKE5eavdRvG6s+o+zc3mAsNR7HDqs02N5a80CvZRalasGoGiWQ39G2ahTiRQVl8FTz
         cgjoxurkRwBGXhOpGM7f49qpv6QZubzIVMGxaQxYRGY6AsVYc8y2qY1+3oUcJfd+tAHw
         rVmYGj9144StoPoaSpDscEQC415RFjFhku/t2+bMT68Ip9v4mMBfZbFuHRHUUcubuTr/
         VB4EdAyZHcxYDZEO03XN+e79DjnU7Op3SnHOvOSKfCDu07HqIshXmavObqGxPLB4QSZZ
         bFFirSRjSKgvJB37w61Bpp9RWKj1xQ9oE6R+gTdzqb5Y+Ij57sWdA5EuE88r2ZDx9OXF
         c2Kg==
X-Gm-Message-State: AOAM533EFDmJXEqPvPzGGHLWPIJwvCMWxKO+C89IEFqJ+KUZOuwJ9bdm
        yDwDTKyB2JE5m7AS1nCD6d0ArL3MAg==
X-Google-Smtp-Source: ABdhPJxBxO2AWOHHOgxkQWqIR4wvWvhvXq6J4XRjBFTNKUwBpXvHeDA5A+DwyYfaS0MOfcmrflE38Q==
X-Received: by 2002:a17:90a:3846:: with SMTP id l6mr3163540pjf.189.1602082280183;
        Wed, 07 Oct 2020 07:51:20 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id x22sm3443402pfp.181.2020.10.07.07.51.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 07:51:19 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 0/5] xfs: random fixes for disk quota
Date:   Wed,  7 Oct 2020 22:51:07 +0800
Message-Id: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi all,

This patchset include random fixes and code cleanups for disk quota.
In order to make it easier to track, I bundle them up and put all
the scattered patches into a single patchset.

Changes for v3:
 -add a separate patch to delete duplicated tp->t_dqinfo null check
  and allocation.

Changes for v2: 
 -add the ASSERT for the arguments O_{u,g,p}dqpp.
 -fix the strange indent.
 -remove the XFS_TRANS_DQ_DIRTY flag.
 -add more commit log description for delta judgement.

Kaixu Xia (5):
  xfs: do the ASSERT for the arguments O_{u,g,p}dqpp
  xfs: fix the indent in xfs_trans_mod_dquot
  xfs: delete duplicated tp->t_dqinfo null check and allocation
  xfs: check tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag
  xfs: directly return if the delta equal to zero

 fs/xfs/libxfs/xfs_shared.h |  1 -
 fs/xfs/xfs_inode.c         |  8 +---
 fs/xfs/xfs_qm.c            |  3 ++
 fs/xfs/xfs_trans_dquot.c   | 75 ++++++++++++--------------------------
 4 files changed, 27 insertions(+), 60 deletions(-)

-- 
2.20.0


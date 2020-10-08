Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551C5C4363C
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB6942173E
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 04:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USNNLDei"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgJHETS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 00:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbgJHETS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 00:19:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33E4C061755
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 21:19:16 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n9so3146966pgf.9
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 21:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wriYpJ3ItD5ofKWlPRmsrVlPXsP3g5EKwvP1tyIx0gQ=;
        b=USNNLDeixe2znCO7tsupYh+3H6U+gvjPuxXX1NnaOC1djBau9oZYWa5KawlhqLOuqy
         3tN5E8qr6wolFL+wJafN2qAi8b/sgtosPo/DxW2875Uk5311YOlNQ2k4B35fxhlrgRCB
         Ybz0gJieS9gNm8beXHuw4HsTl83cTmW4uMJ25UJL+s833227AVmt8GtZYX31/VMxHFhA
         k7j9lRiDZrG0qE7JbPENtO0M+ERhAyK4dHyjWHNYC+QQAdUUnpB9znlHNRF54pIsB3RG
         m8zwABZeC7zpPWXqjFVb4VNbLTCdb6hYyGMq3Tr0cV0Pl/wuMB7sFZEKX/GqbW6DcgL7
         twqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wriYpJ3ItD5ofKWlPRmsrVlPXsP3g5EKwvP1tyIx0gQ=;
        b=dw1MkVFWcctFNCe8NQf+UV6lqAwX3KAs7e9GO7GUTl9IfOpiW6H02k1Ah/TSSaK9TE
         1tv9fHVd7lSKcN/97FgG72qcD3WuNLYWf39TeiLYODcKV5CAp0l+HKzAXlZxt7iRpDWo
         CnV6mnhMdgKpwEZXwgikZFwXNf37l/D4zlsLEsoApI3q3yE3KdIcIVuHSOtjDZdjqKqj
         TsEPbqRTSezCDlWCFRkLxQmoFJVWSr3SWuUW3dXKP/85PAFR2ns6o33NDVTZUCJPaTE2
         N2nDFJ8rrs0UhzLrY4SV6ul90pzb+Ns+iF72+ViaVFCBeRHwUVoT7PIbXNXR/0gDHL9F
         vD8g==
X-Gm-Message-State: AOAM531KGG5XrD5UJlFbpSfIlbYw48taj1sVQfEmIxnFV8mGbzZOckD1
        OBqBpF9rQUnl8qHxFaKDHiBrWcQQPn6s
X-Google-Smtp-Source: ABdhPJwiqCeDDrJXVD8Job1aEs20dvdOZbFlfXYlYK9c80RSTg1XfH3CWD08/TcOCG/nopbrNS7WTg==
X-Received: by 2002:a65:584a:: with SMTP id s10mr5651807pgr.89.1602130756046;
        Wed, 07 Oct 2020 21:19:16 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id q8sm5299970pff.18.2020.10.07.21.19.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 21:19:14 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v4 0/3] xfs: random fixes for disk quota
Date:   Thu,  8 Oct 2020 12:19:06 +0800
Message-Id: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi all,

This patchset include random fixes and code cleanups for disk quota.
In order to make it easier to track, I bundle them up and put all
the scattered patches into a single patchset.

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
 fs/xfs/xfs_inode.c         |  8 +-------
 fs/xfs/xfs_trans_dquot.c   | 32 ++++++++------------------------
 3 files changed, 9 insertions(+), 32 deletions(-)

-- 
2.20.0


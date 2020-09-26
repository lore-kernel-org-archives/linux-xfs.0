Return-Path: <SRS0=Ae7g=DD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47010C2D0A8
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Sep 2020 13:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E68B9221EA
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Sep 2020 13:14:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="po4FJAzM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIZNOk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Sep 2020 09:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIZNOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Sep 2020 09:14:40 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E5BC0613CE
        for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2020 06:14:40 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g29so4711413pgl.2
        for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2020 06:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1nOVUhN5rhFT1oHNAjd8W8GBJwNdw6HpjT0HR6t+sEg=;
        b=po4FJAzM0w5rjroI/FD4fRF7MTYcXnroEUMXi8+iDk3ZorkjnggGgRhp7Fmj2GvZYr
         JAZkWNmZP31vK2vymbOMwDPY9X8y6PEkzvXbwOzQ6QQoEU3G4EAmQsU/xYoapmGliobu
         62Or5WcQidZnMP2TJiiLg9V5Ht8ITS/ZHDQEsx+4N0A7Cy3TolypYFRhdKlVOQG/4RmL
         6iwqI/9ZG0l+QnUQvVKFdY0pNdAiMNb+bXSt+v4kqlseqG2lj3oj4SQ+XF1JJ/+h80cw
         peFKu/jQSsMbGA4CJWjW2Vl3M89Z/8PU1zbLqxylnWV5PWchJl3NpgqWxQJUkAmxWzbf
         z9OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1nOVUhN5rhFT1oHNAjd8W8GBJwNdw6HpjT0HR6t+sEg=;
        b=cYtKmR1MHswfoSUTfLal+hPAIOdfNZzAZfXftZw2F8k9LJGzxU1pJC+VIY711t1UhC
         yDqhQZDhW53WEA0q9+lBwkwTUNYNb5DHurUlEnhhCe5ZXnKXngsPMJtclButMofXVWto
         vNeiKM1R4MpBrrMSOlQ18mZpoKBqeoE8FDCD85PELJVinuLXSwwjhtGmYKnlpdTinWte
         OjXp4tn3/NWW8pcuTTYqHJFaNm9Amq255pqIQsQua2oLm6usmEHk+RwxwtNmCbK2fcII
         mhVE6+lWwdDHNNayam+lPJEfcYJu3558DFezBb9Qr7fAnyhogrFzYAiSq4S0EX0LGjdL
         RNcw==
X-Gm-Message-State: AOAM5329Xeq0mbdWQe3aoasNpWgInK5EV+DN4dYwGG6e94zhZjktiqiU
        7CH9s4gStPLZbpUgiaYWqgpZLfOKJw==
X-Google-Smtp-Source: ABdhPJzdl5EIUIm7UvONw6fAp9/lbliIh+3OJn8q9MeZRPSNT6owPWBF8qXBfePH2sAQfT1zrXSKuA==
X-Received: by 2002:aa7:9e4e:0:b029:13c:1611:6589 with SMTP id z14-20020aa79e4e0000b029013c16116589mr2979674pfq.6.1601126079516;
        Sat, 26 Sep 2020 06:14:39 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id h12sm5623846pfo.68.2020.09.26.06.14.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Sep 2020 06:14:38 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 0/4] xfs: random fixes for disk quota
Date:   Sat, 26 Sep 2020 21:14:29 +0800
Message-Id: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Hi all,

This patchset include random fixes and code cleanups for disk quota.
In order to make it easier to track, I bundle them up and put all
the scattered patches into a single patchset.

Changes for v2: 
 -add the ASSERT for the arguments O_{u,g,p}dqpp.
 -fix the strange indent.
 -remove the XFS_TRANS_DQ_DIRTY flag.
 -add more commit log description for delta judgement.

Kaixu Xia (4):
  xfs: do the ASSERT for the arguments O_{u,g,p}dqpp
  xfs: fix the indent in xfs_trans_mod_dquot
  xfs: check tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag
  xfs: directly return if the delta equal to zero

 fs/xfs/libxfs/xfs_shared.h |  1 -
 fs/xfs/xfs_inode.c         |  8 +---
 fs/xfs/xfs_qm.c            |  3 ++
 fs/xfs/xfs_trans_dquot.c   | 75 ++++++++++++--------------------------
 4 files changed, 27 insertions(+), 60 deletions(-)

-- 
2.20.0


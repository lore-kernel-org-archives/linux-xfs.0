Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AABC433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 08:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C70206CA
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 08:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgIDIZu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 04:25:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36578 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726655AbgIDIZt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 04:25:49 -0400
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-P1pjnzdbM3mzg4nWWOMWWw-1; Fri, 04 Sep 2020 04:25:47 -0400
X-MC-Unique: P1pjnzdbM3mzg4nWWOMWWw-1
Received: by mail-pl1-f200.google.com with SMTP id bd4so750718plb.17
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 01:25:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1juGUjS+HJi7/hKzXUbrGr0WbbqVdVe4BJzQvywS7hU=;
        b=HwPL8eKrFbzC/rk93tP/ipQIlImKS4Ar7XXmcp8swrxv3HOa32/ufgcsKKHoORtmbM
         pMq6Atv+laqkVGVCdeDOhvm6RyvPcTRZg2RN8Pn08zytvi5PZwLW+P9Dmpg6BM3YILxO
         H5jcr6NtdqYlb+k7nILJYzK32csWHiHYW1mOq/k4OsSxi93uvfe8nTf20PsHBez31V+y
         /mlW3y1TmkLLuiMlr4QFUW+8egs8WAMtfxttuR8iqzIKQ/N6YJbAYEYfvjabrMe5wffo
         2RaF13oavihnjuwZBK5GNf50umqM64oOWMcBE/RmxXBIiARt1YxqCoYqZHVKxAATylRH
         2duA==
X-Gm-Message-State: AOAM530pU3Cz5Efy+xVWGDsos8Z1Dso4rMGIAq9eOB0xDh1drsQ6qdOS
        xAGZ75W/dDdvMpiI6fFaHz7xz23fujavhAtFSQlz0aGJDOVHRhtEgfnpoZvawYwI4WsjuRER2Cg
        7CrjghhB7zwKHipqOdAOs
X-Received: by 2002:a17:902:b115:: with SMTP id q21mr7854559plr.191.1599207946369;
        Fri, 04 Sep 2020 01:25:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuzozwBgR1UeyOrSLZA4QMO1/nyaDPcclx32KwvOQFhukIVuvtw+brca0JdIXTkFi1YbpcRw==
X-Received: by 2002:a17:902:b115:: with SMTP id q21mr7854543plr.191.1599207946132;
        Fri, 04 Sep 2020 01:25:46 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b64sm5721012pfa.200.2020.09.04.01.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 01:25:45 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 0/2] xfs: random patches on log recovery
Date:   Fri,  4 Sep 2020 16:25:14 +0800
Message-Id: <20200904082516.31205-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Here are some patches after I read recovery code days ago.
Due to code coupling from this version, I send them as a patchset.

I already ran fstests and no strange out and
changelog is in each individual patch.

Thanks,
Gao Xiang

Gao Xiang (2):
  xfs: avoid LR buffer overrun due to crafted h_{len,size}
  xfs: clean up calculation of LR header blocks

 fs/xfs/xfs_log.c         |   4 +-
 fs/xfs/xfs_log_recover.c | 103 +++++++++++++++++++--------------------
 2 files changed, 51 insertions(+), 56 deletions(-)

-- 
2.18.1


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C28AC433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B3C264FDB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 02:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhCEC5n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:57:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhCEC5n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 21:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614913062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WOVKPLYPjjsbFAPsZx3ii5kQP2LCMEyQszkE9yDODMo=;
        b=FVWZepkwXHGL98VvChr8ycGdjNVJzyrQqbVUJrmPrZ0U+lSC9xzbPxejx9EW3uliU1FTpr
        sOjvj5Xt2b5HjkjsltaO2i5lJBktBB18GuaWCdsznSn9RYFTELvdYkTA5aVHxdSXxqSnQd
        bpJw9uWV60HzOl8xDX0myDZs+0hctZw=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-kaWcOEFGPHyjC2EU3XdlFA-1; Thu, 04 Mar 2021 21:57:41 -0500
X-MC-Unique: kaWcOEFGPHyjC2EU3XdlFA-1
Received: by mail-pf1-f198.google.com with SMTP id j7so374892pfa.14
        for <linux-xfs@vger.kernel.org>; Thu, 04 Mar 2021 18:57:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WOVKPLYPjjsbFAPsZx3ii5kQP2LCMEyQszkE9yDODMo=;
        b=AnILXowVGiPvxTmOHVopi7Yjx2qkX66y8XTpA4C1lJqd/txRH0E9EdU4mCespM59rm
         w8AILRz1spXPQogFzLewtG4K7QMHUkklG8yFUAP69SIJgNmahO37JoJx0qailDuyCyMt
         DJ4YAdZJi1TSIRojzjmjOIJ9bcqSmDFclq5cmMRz9UTwA+MrKFR2r+suY7SgpLXyz/ze
         7VCyMI/Q01LMGw6XJQknk1s1ebcV2pDoPw1bb5nW6DdxgnoYWpBvbR+QL3iEWscB2vBJ
         RFMc9Mts9bn+OeLaLj+tl+cJZcyq4a30+Gl3i6eda0Z66MwR19n3W33S/IRD55l93EEl
         5Ibw==
X-Gm-Message-State: AOAM533rpQCcFdDqbkDJS5WrO2hHHfW0JS7WafqNQr38hRdLQ69ByM0J
        TKMJphes/EicAhdOvxY4twLon5pqh8hgSuWsYYX1KBfwfvruJlZE7VK7Rah3km8w6WSZ5rPYAMY
        QsiqFEDOa45ZRr1QFxhBNvT1soZbbfxQEEWDNJi44NtTvRBKfF2m9i/sG2N06nFXWpQW9ZMPK8g
        ==
X-Received: by 2002:a17:90a:7c48:: with SMTP id e8mr8130610pjl.89.1614913060030;
        Thu, 04 Mar 2021 18:57:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEo93Z4jEMpU6z4e8GkAJxiCUa4IywrxBOK+8X61G0mLHmcfkrcbpbIQLKBwXVk2qnwwUcGw==
X-Received: by 2002:a17:90a:7c48:: with SMTP id e8mr8130587pjl.89.1614913059746;
        Thu, 04 Mar 2021 18:57:39 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m19sm533414pjn.21.2021.03.04.18.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 18:57:39 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v8 0/5] xfs: support shrinking free space in the last AG
Date:   Fri,  5 Mar 2021 10:56:58 +0800
Message-Id: <20210305025703.3069469-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

v6: https://lore.kernel.org/r/20210302024816.2525095-1-hsiangkao@redhat.com

This patchset attempts to support shrinking free space in the last AG.
This version mainly addresses previous review of v7. Hope I don't miss
previous comments...

gitweb:
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/ tags/xfs/shrink_lastag_v8

changes since v7:
 - [3/5] rename `len' to `delta' (Darrick);
 - [3/5] add agi->length vs `delta' check (Darrick);
 - [4/5] drop an necessary blank line (Darrick).
 - Also xfs_errortag_random_default has been fixed in [5/5].

Thanks for the time!

Thanks,
Gao Xiang

xfsprogs: https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com
xfstests: https://lore.kernel.org/r/20201028230909.639698-1-hsiangkao@redhat.com

Gao Xiang (5):
  xfs: update lazy sb counters immediately for resizefs
  xfs: hoist out xfs_resizefs_init_new_ags()
  xfs: introduce xfs_ag_shrink_space()
  xfs: support shrinking unused space in the last AG
  xfs: add error injection for per-AG resv failure

 fs/xfs/libxfs/xfs_ag.c       | 111 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h       |   4 +-
 fs/xfs/libxfs/xfs_ag_resv.c  |   6 +-
 fs/xfs/libxfs/xfs_errortag.h |   4 +-
 fs/xfs/xfs_error.c           |   3 +
 fs/xfs/xfs_fsops.c           | 196 ++++++++++++++++++++++-------------
 fs/xfs/xfs_trans.c           |   1 -
 7 files changed, 247 insertions(+), 78 deletions(-)

-- 
2.27.0


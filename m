Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A820C43381
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 13:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7504621919
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 13:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbhAKNZF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 08:25:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730651AbhAKNZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 08:25:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610371417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/G7UC1lF0jiIaXYwbvWVWSf7LtS7/wlaJsd+lC7SaOs=;
        b=WXG8qb+TFkDjijNktLvU8zHRDLJ7AjMbJeKCcw8S0Gj9+GZv0pMuaQXHGAQsp0V2ycg04J
        iShZoNCMDyTkmkhSj7ECHZ17kgUmtKsXqbAm+A376gC9URm9PphSaOQDPKSfVD3E21qFAf
        PlGUsy1/4UbJqwML/NffEizptz/QA5s=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-3b3fSAIXNQC8EWQD7VrJkw-1; Mon, 11 Jan 2021 08:23:36 -0500
X-MC-Unique: 3b3fSAIXNQC8EWQD7VrJkw-1
Received: by mail-pg1-f198.google.com with SMTP id y34so12300161pgk.21
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 05:23:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/G7UC1lF0jiIaXYwbvWVWSf7LtS7/wlaJsd+lC7SaOs=;
        b=kmnPDl6DZU6mLJfdwdr2QDHxcJzDsHFl0BOc2f5m+msR/dPr7Ac3DMdam9X0A3O3mZ
         dR+K8gaEkfbX6ZAfR4QNFi13f32T5MOQzOzNJdRIpUyUjNefERcxtneHqPjnvlxf48vy
         bgkmQZraqPOLN8cGuHFq9axNp6xUWaa49SaVnUrpni4pmL9cEjPAMrBPmCP8sYQlXGNp
         VzJZAzkrfQiD8GeHEJrnbFUw3YYOdsa8spJVibpTxWa7CRfqLUESNoWqSbZeojdW6Ayy
         Oyq4IASAVxvLI0uYwpE04E5Vke2v0tcjfunudtHs7ASY3ZB8t33KCtte2RwP3xZyOzxi
         pXgg==
X-Gm-Message-State: AOAM533aE+Qn+/xCFJqEijIrGZ8UPrBDr0IW1T2kX+a0xL2W1a+0BRfG
        TPt86mlwPRcDIuzD1Kr8VE13dsyhSShRedMhZgD7+oGSXrFFGiVOqosO0C/dUfm0Svd5m3w7Do6
        kN8W9S7zT0kr2htT7CgyMBUt35j4FQ0p/7B2uZhZGSetEpIw9HFybFhzn1+2Xli6Q0W6SgANUww
        ==
X-Received: by 2002:a63:551d:: with SMTP id j29mr19469817pgb.115.1610371413290;
        Mon, 11 Jan 2021 05:23:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy0T/DMfuoTCQWmkEfj4d1bzZfTKBXrvSm8NhSjUkG0jgTX/dtMFAannb5e3nu/BBWFDZkcdQ==
X-Received: by 2002:a63:551d:: with SMTP id j29mr19469687pgb.115.1610371411346;
        Mon, 11 Jan 2021 05:23:31 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cu4sm16179355pjb.18.2021.01.11.05.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 05:23:30 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 0/4] xfs: support shrinking free space in the last AG
Date:   Mon, 11 Jan 2021 21:22:39 +0800
Message-Id: <20210111132243.1180013-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

v3: https://lore.kernel.org/r/20210108190919.623672-1-hsiangkao@redhat.com

This patchset attempts to support shrinking free space in the last AG.
Days ago I also made a shrinking the entire AGs prototype at,
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/log/?h=xfs/shrink2
which is still WIP / rather incomplete, yet any directions/suggestions
about that would be greatly helpful to me as well.

Kindly leave your thoughts, insights about this. Thanks!

xfsprogs: https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com
xfstests: https://lore.kernel.org/r/20201028230909.639698-1-hsiangkao@redhat.com

Thanks,
Gao Xiang

Changes since v3:
 - [1/4] make division/mod have its own variable (Darrick);
 - [2/4] leave xfs_growfs_{data,log}_t definitions alone (Darrick, Eric, Dave);
 - [4/4] switch `delta' to int64_t (Darrick);
       * however, we couldn't let (delta {>,<} 0) be {growfs,shrinkfs}
         since laterly `delta' becomes the adjusted delta value of last AG
         due to the original growfs design, so I still keep `bool extend`
         variable this time.
 - collect some RVB tags from v3.

Gao Xiang (4):
  xfs: rename `new' to `delta' in xfs_growfs_data_private()
  xfs: get rid of xfs_growfs_{data,log}_t
  xfs: hoist out xfs_resizefs_init_new_ags()
  xfs: support shrinking unused space in the last AG

 fs/xfs/libxfs/xfs_ag.c |  72 +++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h |   2 +
 fs/xfs/xfs_fsops.c     | 160 ++++++++++++++++++++++++++---------------
 fs/xfs/xfs_fsops.h     |   4 +-
 fs/xfs/xfs_ioctl.c     |   4 +-
 fs/xfs/xfs_trans.c     |   1 -
 6 files changed, 181 insertions(+), 62 deletions(-)

-- 
2.27.0


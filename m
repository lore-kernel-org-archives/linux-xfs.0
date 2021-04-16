Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9E1C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAAA66100C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239216AbhDPJLd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:11:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235252AbhDPJLd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618564268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rkRmd79qsp1iFc3yoSoKJNogiourHCntGupaeFa9SeI=;
        b=T/WVNpzzMWqqh6q2Q9YgvJBo1oro/4VjG+Goz9G30nMdqYz/k4JpnEVmUf2779XcIS9vZ+
        TzVPiprlq1GI3quEh9dnTsWn5fGsKRqZT1QxivJNJhiH+UHKppq1Ojaly9l7mky/nAAPbM
        dEQibJA5b/hZ84cFPKJTeVeRv2lv5Oo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-0f81X1W6MZ6Kbq2JUB-X-Q-1; Fri, 16 Apr 2021 05:11:07 -0400
X-MC-Unique: 0f81X1W6MZ6Kbq2JUB-X-Q-1
Received: by mail-pl1-f199.google.com with SMTP id z12-20020a170903018cb02900e5e0c43d00so10208372plg.0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 02:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rkRmd79qsp1iFc3yoSoKJNogiourHCntGupaeFa9SeI=;
        b=DwTEzDCfYJwqSSlQD7nqOeDt3z23aSTpKByKgX4dV24JN9/Lf0jX5qdkp9XJ1CdPMQ
         za5fCIQMlZT/41Vkw/kMD5kOg5CHQKwXewegmsj4ulqbZdL/sjYgCAdvnLmhJYPp8mgl
         frf1ELZC+yt2v1076Hfn9vzrMf6stsX0uUkQnA4XIyPfzoRxIjz8VgxpIpa4HHzz2SDJ
         LjTePJW6Urepr34V3GY60RvvJo7kZAlL7/SGGpNDz3bQ/stNr+xzKdyaVljlPJLZ1fs5
         WcvD1b2cXoRHZCdeCUsrIi6EouXfg4HbFJOud59cLmNEJUAlk5PZKkcojZFdt8/EP8SK
         DSQg==
X-Gm-Message-State: AOAM530TxAkyzXsACSYMws0/r15tE4SqZuI2HLWlia1XE/3s+q9yr6Sn
        83Gex/2SExT3++81kMb/ZUo4mnR8N9nf6H0qJ5ptJYpDbqx00aSdrMuR4CSwLlDDOdCttRF4b7u
        mRk8c7ptJU6aMbfPQFgCGBjsrsIrxsOa4un8+FIknT4wQQv7tMJJHLEHvdMtlsgvvW59ZGo4wPw
        ==
X-Received: by 2002:a17:902:bd41:b029:e6:933a:f3ef with SMTP id b1-20020a170902bd41b02900e6933af3efmr8505094plx.19.1618564265801;
        Fri, 16 Apr 2021 02:11:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPtKEyz94djDw8QPVBA4ioz5ffbdo1qiDk6OJFsPLRo3fJPO4oequHLSKHGf+WLUQLV91mDw==
X-Received: by 2002:a17:902:bd41:b029:e6:933a:f3ef with SMTP id b1-20020a170902bd41b02900e6933af3efmr8505070plx.19.1618564265468;
        Fri, 16 Apr 2021 02:11:05 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 11sm5196475pjm.0.2021.04.16.02.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 02:11:05 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>, Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Date:   Fri, 16 Apr 2021 17:10:23 +0800
Message-Id: <20210416091023.2143162-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There are many paths which could trigger xfs_log_sb(), e.g.
  xfs_bmap_add_attrfork()
    -> xfs_log_sb()
, which overrided on-disk fdblocks by in-core per-CPU fdblocks.

However, for !lazysbcount cases, on-disk fdblocks is actually updated
by xfs_trans_apply_sb_deltas(), and generally it isn't equal to
in-core fdblocks due to xfs_reserve_block() or whatever, see the
comment in xfs_unmountfs().

It could be observed by the following steps reported by Zorro [1]:

1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
2. mount $dev $mnt
3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
4. umount $mnt
5. xfs_repair -n $dev

yet due to commit f46e5a174655("xfs: fold sbcount quiesce logging
into log covering"), xfs_sync_sb() will be triggered even !lazysbcount
but xfs_log_need_covered() case when xfs_unmountfs(), so hard to
reproduce on kernel 5.12+.

After this patch, I've seen no strange so far on older kernels
for the testcase above without lazysbcount.

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1949515

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 60e6d255e5e2..423dada3f64c 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -928,7 +928,13 @@ xfs_log_sb(
 
 	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
 	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
-	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+		struct xfs_dsb	*dsb = bp->b_addr;
+
+		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
+	} else {
+		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
-- 
2.27.0


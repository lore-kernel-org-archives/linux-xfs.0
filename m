Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F14C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 11:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 025536135F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 11:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhDTLJy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 07:09:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231811AbhDTLJy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 07:09:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618916959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WWmsrF4faJEnp1S5INMWfUkp7qcYVlQ2DHdFpcVWGmY=;
        b=RtTP4YXv72jdagLvudasdxXYMIe/lIFITS0X9g2kIYoya6kTKNcNoLuJFBaN19ywEZEaxR
        QZ9aOMujM5TJomY3ySSSjulSbF9O5JqHudWJbxgSwT+d040FFtci/FjntLKslDSm54D3rI
        a5cMew5U+SsTwUoU99sFHav1TH9wUiw=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-GZE8qmmdN5i9x7ozqJ_icA-1; Tue, 20 Apr 2021 07:09:18 -0400
X-MC-Unique: GZE8qmmdN5i9x7ozqJ_icA-1
Received: by mail-pg1-f198.google.com with SMTP id l25-20020a6357190000b02901f6df0d646eso7698838pgb.23
        for <linux-xfs@vger.kernel.org>; Tue, 20 Apr 2021 04:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WWmsrF4faJEnp1S5INMWfUkp7qcYVlQ2DHdFpcVWGmY=;
        b=ScNtUJtFYCH7/Q8h/PK1nj0xP+qYZCxO1SGy/9onXFZAzFZIML8Wc22V37wNC8JEG1
         8e/Kyoj0ugjQULRHxweNCV8J1TQXtCeT/NOK2P/XIiXnx1OcOQfc7XCwpD1SF5PEl3R1
         VI/onymebVTZlyZEfeR/JeJwnb37qTCf2M2ec+yl4/W87+qeWyu7rkx+1tv6CNPBuUg2
         5c8x/18o9QGd09SSUB9aZGOcJXgDmo3SPWJA5EHXrdeP0V5vdzX/kqPgVkH5fz03/o6y
         qYYl2CCaSGZCew6/ElLqGFJ+ldq7VvGnjMozJLsW0504TO9R37SmsWJ8zdp6F4A988dH
         ohkA==
X-Gm-Message-State: AOAM532/zNtKqBFHsAMwTVO959gMH8jganL9hdGUZ7rZfsBPJIvqH+nV
        999FE4wNJn7S8pfEc17e1YRBZfGS6MD8pvLfn21rLkmgvzyWjmX8mATNoxK+4orYacYZxEHAwrV
        C0/cPdkfesAjnMeJttQ/1MGJoGicSdC5436+1YUDlyKWI/JKRj6SGHlQEUnAeEslfNiIPyldjUg
        ==
X-Received: by 2002:a63:a16:: with SMTP id 22mr2670633pgk.345.1618916956801;
        Tue, 20 Apr 2021 04:09:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGxj99aL1NhB77p/3SBfnTHgjL8hlX7RdvrjgWLJzcRmp5W0EvXNCoPl8DtyCjhL/97bvXRw==
X-Received: by 2002:a63:a16:: with SMTP id 22mr2670599pgk.345.1618916956439;
        Tue, 20 Apr 2021 04:09:16 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fw24sm2247063pjb.21.2021.04.20.04.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 04:09:15 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Zorro Lang <zlang@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH v2 1/2] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Date:   Tue, 20 Apr 2021 19:08:54 +0800
Message-Id: <20210420110855.2961626-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There are many paths which could trigger xfs_log_sb(), e.g.
  xfs_bmap_add_attrfork()
    -> xfs_log_sb()
, which overrides on-disk fdblocks by in-core per-CPU fdblocks.

However, for !lazysbcount cases, on-disk fdblocks is actually updated
by xfs_trans_apply_sb_deltas(), and generally it isn't equal to
in-core per-CPU fdblocks due to xfs_reserve_blocks() or whatever,
see the comment in xfs_unmountfs().

It could be observed by the following steps reported by Zorro:

1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
2. mount $dev $mnt
3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
4. umount $mnt
5. xfs_repair -n $dev

yet due to commit f46e5a174655 ("xfs: fold sbcount quiesce logging
into log covering"), xfs_sync_sb() will also be triggered if log
covering is needed and !lazysbcount when xfs_unmountfs(), so hard
to reproduce on kernel 5.12+ for clean unmount.

on-disk sb_icount and sb_ifree are also updated in
xfs_trans_apply_sb_deltas() for !lazysbcount cases, however, which
are always equal to per-CPU counters, so only fdblocks matters.

After this patch, I've seen no strange so far on older kernels
for the testcase above without lazysbcount.

Reported-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
changes since v1:
 - update commit message.

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


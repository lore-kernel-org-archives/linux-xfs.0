Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4665C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 01:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD0C613AE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 01:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbhD0BNH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 21:13:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41014 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232022AbhD0BNH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Apr 2021 21:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619485944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LLUkqiyk25XL4X5tA4U2Ofc03A2d1RxZIsyMBAuQArE=;
        b=Oe9zNUByKgqq4rGDvPDnNB3N+idfn9uvnXytcjwF77Q/INZEdqJDpW09kXAyps4dveck0r
        jMKsiCiqjjaruLUTyA3iLh+VZnlNac5pj4j9qBQYPGZZF7JNDV+rNBLxED/SPV/h+jky/F
        NoVP6B4hdY1LiwZEEuvlz++tSJszHZE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-O0_1Pq4UOO20Klgd-dWbow-1; Mon, 26 Apr 2021 21:12:22 -0400
X-MC-Unique: O0_1Pq4UOO20Klgd-dWbow-1
Received: by mail-pj1-f69.google.com with SMTP id w9-20020a17090a4609b0290150d07df879so11223569pjg.9
        for <linux-xfs@vger.kernel.org>; Mon, 26 Apr 2021 18:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LLUkqiyk25XL4X5tA4U2Ofc03A2d1RxZIsyMBAuQArE=;
        b=HXb8JWsnwpbusNYlB3+co2t8+gRa7O5edb2WIDSJlREw3LbOVS4RG/5TNj1kgCoanO
         YEwn39AkZks33nfTAShkLT3wzAhw7cG86Lq0BdaUP2iit9g4bWhWch020776h6Y7c4WF
         6kiECMntk7BnQ3yCOLSb8VFGaaZAWZmUPJklSRl6fYV3QX+J2g7C7NX9y8QQzBQ1/Fj0
         cURuttKBRCa1xh1HFo8S44EyvFEBHuytpPgk43UCcuRpPNd8NZMpWTEJP6ii2tMuCP60
         Sy5yNouYVD4pNZvNPzp7yjLgYYq3UtJaStYQ4fMjyTCtUioJLn5WQFvOZggMJgP0D28l
         L4Bw==
X-Gm-Message-State: AOAM531GZ7v0nWIwHNoYpTl9Cj34E+o+1P9R0DfSFKHiBBbK74KkkBGn
        s2nS7kfn/58EMQCQzRUGoJ3d27uwI00I6oezD7MvTv6HfUOWWmDsKdjdG7+uKYP4e9g6MdkA2R2
        Vm6noinzyRDxZsOs0sAeqqMpe612uuTWYpG3kRYA0ovplgFKZjT9qDqiWaO4sUeF0aMnQi1aUjw
        ==
X-Received: by 2002:a63:4d50:: with SMTP id n16mr18930918pgl.237.1619485941417;
        Mon, 26 Apr 2021 18:12:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlxi26drtbdHdocXajpw9nmorU44FINgo30q0IZzm3ig2ZfK0vukmQ+RMoeDyRLxCGlil8Pw==
X-Received: by 2002:a63:4d50:: with SMTP id n16mr18930889pgl.237.1619485941053;
        Mon, 26 Apr 2021 18:12:21 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n20sm11884251pgv.15.2021.04.26.18.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 18:12:20 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH] xfs: update superblock counters correctly for !lazysbcount
Date:   Tue, 27 Apr 2021 09:12:01 +0800
Message-Id: <20210427011201.4175506-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Keep the mount superblock counters up to date for !lazysbcount
filesystems so that when we log the superblock they do not need
updating in any way because they are already correct.

It's found by what Zorro reported:
1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
2. mount $dev $mnt
3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
4. umount $mnt
5. xfs_repair -n $dev
and I've seen no problem with this patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reported-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---

As per discussion earilier [1], use the way Dave suggested instead.
Also update the line to
	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
so it can fix the case above.

with XFS debug off, xfstests auto testcases fail on my loop-device-based
testbed with this patch and Darrick's [2]:

generic/095 generic/300 generic/600 generic/607 xfs/073 xfs/148 xfs/273
xfs/293 xfs/491 xfs/492 xfs/495 xfs/503 xfs/505 xfs/506 xfs/514 xfs/515

MKFS_OPTIONS="-mcrc=0 -llazy-count=0"

and these testcases above still fail without these patches or with
XFS debug on, so I've seen no regression due to this patch.

[1] https://lore.kernel.org/r/20210422030102.GA63242@dread.disaster.area/
[2] https://lore.kernel.org/r/20210425154634.GZ3122264@magnolia/

 fs/xfs/libxfs/xfs_sb.c | 16 +++++++++++++---
 fs/xfs/xfs_trans.c     |  3 +++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 60e6d255e5e2..dfbbcbd448c1 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -926,9 +926,19 @@ xfs_log_sb(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*bp = xfs_trans_getsb(tp);
 
-	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
-	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
-	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	/*
+	 * Lazy sb counters don't update the in-core superblock so do that now.
+	 * If this is at unmount, the counters will be exactly correct, but at
+	 * any other time they will only be ballpark correct because of
+	 * reservations that have been taken out percpu counters. If we have an
+	 * unclean shutdown, this will be corrected by log recovery rebuilding
+	 * the counters from the AGF block counts.
+	 */
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
+		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
+		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bcc978011869..1e37aa8eca5a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -629,6 +629,9 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
+	mp->m_sb.sb_icount += idelta;
+	mp->m_sb.sb_ifree += ifreedelta;
 	mp->m_sb.sb_frextents += rtxdelta;
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
-- 
2.27.0


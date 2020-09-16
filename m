Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C184EC43461
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 17:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F5AB2083B
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 17:49:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uxZ9BJMQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgIPRs6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 13:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbgIPRsf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 13:48:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AF3C0698C0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:27 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so3735708pgl.2
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZXfbdp9yyNT7t7bavNdq0KImIkV0lMJlaTmszOv75io=;
        b=uxZ9BJMQwNGupGzlfkNLQCcBf5VndK4bwtPTAaLK24yLsOsNqdv6GV5bfA6yv2/a7g
         E2cTtREZ+DQGttrcaW2s4i4fVW/iOkwI0VMk40HRcwyzTM2vzsHAmnetG/c0Smi3w1tk
         J9ZkmKWEcEexPEiAF/dB2w7RAlQYLidwNYVb18ikJkWcKCfyQ0YCT4/NYPuOnm9rl2Qe
         +J67N1quZe8zv10+IeGJhihPAf9K93FzaMbL5qCW2Has10uORhqYXeFuPWo53oY5hzKd
         +62BRXItkOAIou9Ds2+RNiHtmTeD6xBFKlBOcWhUI1veziVtktg78ZeZ6BxA4THIxQYG
         P7lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZXfbdp9yyNT7t7bavNdq0KImIkV0lMJlaTmszOv75io=;
        b=jx1AMFNQLffcW5XbbiM0KhviiKeOQaf7nmLZknHbHM9vwPNwH4tcaJtJFQ6zERaB+U
         z/kdzyrpbXnMYM9ifFscq4HsOHunR6Vxo62JjuwS45dqSAM55G3ocb+WyMHICo3sFO+C
         za8mgl7F7n6FhDvSoY6AU/SIXVY0LPhPC/xFrclLK4N+reXB5sIF6NEkgeZ/t5dLA5Lc
         eLNJPb8rbo8MXL6acyK+Pxh8hKLVxLAvd+NILlr8gRCELkVRfB2HsWXqQMz0Hly2b10U
         QVVnyJNtVPf5a59I8v+PpEaRlfed3qG9qsZO57u3S+3o2CZ4caFzpNOz/XuRJVK26ONX
         4ZmQ==
X-Gm-Message-State: AOAM5327U2TUEVRVrWcmeFF2g1aGeO+nQVHzKju6U8nUSdC/zTk2Nt6h
        JUTM653uzL6ffrK4KLcFSd1iUn7Vt1SV
X-Google-Smtp-Source: ABdhPJzIGK0h+PF19F98zDU9NlfYCkByvgTWB8iIyctVxSPjOGHfrtMohXQQNSSeBcKqq+HtKDLU6w==
X-Received: by 2002:a63:d43:: with SMTP id 3mr17905607pgn.170.1600255166239;
        Wed, 16 Sep 2020 04:19:26 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v204sm3492195pfc.10.2020.09.16.04.19.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 04:19:25 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: remove the repeated crc verification in xfs_attr3_rmt_verify
Date:   Wed, 16 Sep 2020 19:19:10 +0800
Message-Id: <1600255152-16086-8-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We already do the crc verification before calling the xfs_attr3_rmt_verify()
function, and just return directly for non-crc buffers, so don't need
to do the repeated crc verification in xfs_attr3_rmt_verify().

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 3f80cede7406..48d8e9caf86f 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -96,8 +96,6 @@ xfs_attr3_rmt_verify(
 {
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
-	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return __this_address;
 	if (!xfs_verify_magic(bp, rmt->rm_magic))
 		return __this_address;
 	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))
-- 
2.20.0


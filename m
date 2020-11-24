Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B82C64E75
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 15:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C69B206FA
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 15:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JwfKDPvt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389629AbgKXPwW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 10:52:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389676AbgKXPwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 10:52:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606233139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=5Q/jjcA5ifwOtsh8jyArTjjVWuhZSisA03wE7hFKMGg=;
        b=JwfKDPvtvDcE8vuKFvFCx+dKHX9P/qwhaJojflVLxwvObSuBrPb/BN2SFP8/a1rZ9nj8yU
        Y8AVST8nIvTOelwiqeumnebvJFFx39jX5M25/3hjoI5yfnNY2bAlGH7dIddfb8XxULBqY+
        SD/3bkwuPUaJA/NfQxss4cpIrGfkhWc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-vgekxR2HN_Ot4rRv1evOzA-1; Tue, 24 Nov 2020 10:52:16 -0500
X-MC-Unique: vgekxR2HN_Ot4rRv1evOzA-1
Received: by mail-pl1-f198.google.com with SMTP id b4so5733427plk.17
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 07:52:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5Q/jjcA5ifwOtsh8jyArTjjVWuhZSisA03wE7hFKMGg=;
        b=EYPF1BcV2LXl419nzm8hk0MP2OprxJOurqX8Dj28YhF8bbHdcsNKTFaj7KyDFBMKgL
         MnjahVlfgIKCJkmwCWjdUx0LgE8fbTQg1U7F/WIFxcs/wShVYhALH28TumkIa97BuuVD
         lUvCSbw7F/8UKekBIrskg+6uP3yoov5e77c/JzxZRQFQb3OnUK/z9OaGvXNgVUsUNtRu
         JcvAMs65jLeUawKZz5JF28v8+1wE3Y8eVrv3oCEP0+6sXJ+e5hlOoPF4hAN1Mxfk0EDu
         7Fsu+oSDEaY+TjRze2Y/C3UJPdSOPMu76sluQdI4VAmO+haQY/Q7VL2URrCWk23OHLg5
         AATA==
X-Gm-Message-State: AOAM533y9K6XVJPcTEMdvmRoVLvLEBv7QulK5bgJPRk1j+fF10eWEsQO
        PdMvYKbIx035qS9KbbGOp2GdhsVcid2wJdHEhXJy/cU1dEZuGJeRiLHm6/ePcWMn9NzwGO1M6EH
        vD/U+WDGAwNH+LP4lOZRzAJdwdJZeWNVHve+0YZuFihEQ20c7ZnympfNH5Bre6wkUZTXz3tlsGg
        ==
X-Received: by 2002:a17:90a:a50b:: with SMTP id a11mr5856054pjq.170.1606233135477;
        Tue, 24 Nov 2020 07:52:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVgCrflLPZdPYHD5UrJignCoJNpXxIH1WfDBTKXB5v/+LvdWVQdePUKWEsqCZfyoSpbsjcbQ==
X-Received: by 2002:a17:90a:a50b:: with SMTP id a11mr5856024pjq.170.1606233135107;
        Tue, 24 Nov 2020 07:52:15 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mn21sm3723909pjb.28.2020.11.24.07.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 07:52:14 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 1/3] xfs: convert noroom, okalloc in xfs_dialloc() to bool
Date:   Tue, 24 Nov 2020 23:51:28 +0800
Message-Id: <20201124155130.40848-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Boolean is preferred for such use.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 974e71bc4a3a..45cf7e55f5ee 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1716,11 +1716,11 @@ xfs_dialloc(
 	xfs_agnumber_t		agno;
 	int			error;
 	int			ialloced;
-	int			noroom = 0;
+	bool			noroom = false;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	int			okalloc = 1;
+	bool			okalloc = true;
 
 	if (*IO_agbp) {
 		/*
@@ -1753,8 +1753,8 @@ xfs_dialloc(
 	if (igeo->maxicount &&
 	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
 							> igeo->maxicount) {
-		noroom = 1;
-		okalloc = 0;
+		noroom = true;
+		okalloc = false;
 	}
 
 	/*
-- 
2.18.4


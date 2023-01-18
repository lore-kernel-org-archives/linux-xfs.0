Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8EEC32793
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjARWsJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjARWrt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:47:49 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943F566025
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:34 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id g68so85267pgc.11
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mcHcjqAtQ/8ITHolGO2Jkc+y/Vqb1PaZfvTWg60uLE8=;
        b=Ueg4T3/nJcAaTg1v5DXf4a9HPa+S+HFsKvoW+KJMpDOuTOa3OJ1cVweHOtseGENhl2
         /2gvLTvAtBqvMHpzA2h/M9yhy3PB7MfdAI3bs7lto/Y4CqeR04fWZUUawHJhvmeIU0/O
         CcKFmtm6/HVN4fAuLbQPRVN8wvGOysySYwABB0VOTs0EC0XyzXDQmqHoxvYm9YiQ1pGL
         ExZSQPzCIia9uoxDC65EFbs2VFg6uKI1rjR8uRe5YBi1HyojXsVIW+O5XnA46Uz6G/OX
         uGguayzLdikaUYOJYaCVJZIJJja40SjtuLB/Z5E13y/ySbrnCjnv3GvbZvq6h0ATvTLj
         xjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mcHcjqAtQ/8ITHolGO2Jkc+y/Vqb1PaZfvTWg60uLE8=;
        b=vvnTqZba2YHem1OPGDvu4d+HNMSw3pVM5P3EKh8g8Vg0I0+g7YCP7+KoBUMcRBNX2y
         mN/bTC+ixUCkTYQD3gTrFEjDUT+zPELbDv8n1D7V/k9mHDfLv7iaRYZV++UTySBC3z5T
         F2pptfgFzbyCgwBS4L1O8f3wcaAgxnu1kyTtw3DnDC2NnmtXdLoRMNTcM/CRVEu0DVrh
         +vqywViDK/IxR5GB1dcb7b8BkegYCUWiPS33vd4v0Fs3oMhSe9AYB/jTDL9fS1F67RNa
         43bA27zqWbz94A5R/pQQtaKXgnA4I+BA94/13LjyoubB1kI4PgGL2Q2EcfI72O5J+HLU
         WIIA==
X-Gm-Message-State: AFqh2kquRetDPP3eox7LvM+strL9A/CkudlF5LQZKLPlgdQKu3FUQYwq
        EnZ/NKYrIftCho+g0iosOIxUQOMQ1Bdm4mGb
X-Google-Smtp-Source: AMrXdXtRMcPC/VJXfD9MceMvK/adSVThbQ9611qm0RREz73PZ1moe0TX4IHGlQUxSSIBEEYBKhrFHA==
X-Received: by 2002:a05:6a00:a27:b0:566:900d:a1de with SMTP id p39-20020a056a000a2700b00566900da1demr11229855pfh.26.1674082052475;
        Wed, 18 Jan 2023 14:47:32 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b0056c2e497b02sm7328397pfq.173.2023.01.18.14.47.32
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:47:32 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iYK-QS
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FFP-2e
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 36/42] xfs: remove xfs_filestream_select_ag() longest extent check
Date:   Thu, 19 Jan 2023 09:44:59 +1100
Message-Id: <20230118224505.1964941-37-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Picking a new AG checks the longest free extent in the AG is valid,
so there's no need to repeat the check in
xfs_filestream_select_ag(). Remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 713766729dcf..95e28aae35ab 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -276,7 +276,7 @@ xfs_filestream_select_ag(
 	xfs_agnumber_t		agno = NULLAGNUMBER;
 	struct xfs_mru_cache_elem *mru;
 	int			flags = 0;
-	int			error;
+	int			error = 0;
 
 	args->total = ap->total;
 	*blen = 0;
@@ -351,27 +351,11 @@ xfs_filestream_select_ag(
 		goto out_error;
 	if (agno == NULLAGNUMBER) {
 		agno = 0;
-		goto out_irele;
-	}
-
-	pag = xfs_perag_grab(mp, agno);
-	if (!pag)
-		goto out_irele;
-
-	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-	xfs_perag_rele(pag);
-	if (error) {
-		if (error != -EAGAIN)
-			goto out_error;
 		*blen = 0;
 	}
 
-out_irele:
-	xfs_irele(pip);
 out_select:
 	ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
-	return 0;
-
 out_error:
 	xfs_irele(pip);
 	return error;
-- 
2.39.0


Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DAEC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8AC822263
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aXtUcafa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgJSGlp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJSGlp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 02:41:45 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4948C061755
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:43 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id lw2so432789pjb.3
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jj+OmV4bSzlVtHqGoh4lq0/qRQzdRIuP8pXxg0hXABo=;
        b=aXtUcafasqHKRx5KL8VFfZZiV7uiSqRmPU6DF3g751G7G6z/pvO+xgvwlshVIT8xMg
         891t6tPDJ7qvahfAV1qJDGEY2I5gYlP+cqQQZFSPoNpAL1LEreyVFSgLLaKFINV+FQYQ
         r3wpPC4KesH4J9jAKe4pDj90UDGxgA5vZtzzYgJ6etfd1Xj7GNzhOfaI7FcEOS5f8bVa
         /7M88UB7VCBL0g4nPSbnu4tvSr5YeurQaZFvtpOYQ5072ndctKxpIJYrBjgZoO47QDM1
         hMfuIbAfS5uuT9zd5DQWtSmIlc/Q9pfXsMjb/63zFJ8EZgs/VD5crD2T3ojVAE48jtvI
         q2eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jj+OmV4bSzlVtHqGoh4lq0/qRQzdRIuP8pXxg0hXABo=;
        b=pDpCNYLyvDpStr6/SYQZ9vg8ZaMFPakpzw3Vz21N8pYhA0Xrq5BGKU8hvM68z+POzJ
         DRm1xaTp7jrQdU9F04UjI7/9FP4f3B5byRfPkx06R5+zZNfVsgcpTJNQbez08UUKUxHf
         Pt+VkhIGQ5zUxasFVS/Yl55DQTKZqVix2rfjgZ4VW38n0DHe7GD+fjAiKQdv0/E7yZ5O
         8AuA2FZoqKcp+HNbeZ/jeVtR6Jqq6SKx9WxMUJpu+Qxipphtz1vbdoOOCd+3iuGbqgYw
         fXxkYSB2HkMek+IL2uwf7prXhu9lLdKPY9J8zmHyXMsPD6QDiPAFSBfbn8LBVgj8ii/b
         GcVQ==
X-Gm-Message-State: AOAM532D5w+o8q3jrwfieB4kUcYNuOQ3fuWHnXwCSCHEnM0ytZYgp6Yt
        rcxJiby9P9DrMIQBgPNMX6ILJoxBaYE=
X-Google-Smtp-Source: ABdhPJyVdYiF1pq5T08ifv5T+PvV5X+WQj2m5zLfmMHFydgISfTfPbjVi99uBx34JQaoxrVAntVqbQ==
X-Received: by 2002:a17:90b:4a10:: with SMTP id kk16mr16499561pjb.77.1603089703138;
        Sun, 18 Oct 2020 23:41:43 -0700 (PDT)
Received: from localhost.localdomain ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id w74sm11164189pff.200.2020.10.18.23.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 23:41:42 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V7 11/14] xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
Date:   Mon, 19 Oct 2020 12:10:45 +0530
Message-Id: <20201019064048.6591-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019064048.6591-1-chandanrlinux@gmail.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The check for verifying if the allocated extent is from an AG whose
index is greater than or equal to that of tp->t_firstblock is already
done a couple of statements earlier in the same function. Hence this
commit removes the redundant assert statement.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 505358839d2f..64c4d0e384a5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3699,7 +3699,6 @@ xfs_bmap_btalloc(
 		ap->blkno = args.fsbno;
 		if (ap->tp->t_firstblock == NULLFSBLOCK)
 			ap->tp->t_firstblock = args.fsbno;
-		ASSERT(nullfb || fb_agno <= args.agno);
 		ap->length = args.len;
 		/*
 		 * If the extent size hint is active, we tried to round the
-- 
2.28.0


Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62596C00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00D652231B
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TiBxH1bL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgKBJve (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 04:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJve (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:34 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230B7C0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:51:33 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id y14so10620352pfp.13
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fYn4Dk1EXYBsRc4PsiEBtvGWQor3CttFr0ltlRTYZIQ=;
        b=TiBxH1bLooei3A/+of/xYTulxYirY+AUkYwmz2bZPa3QTZ67HnbCMujM0TT1+PJ+/w
         kpQA1WBvgBhtmOG+Qvz8S0qSvhJBcHymNYAdZmhrS9ruTmtGPXyakvW+I2h+64YaeDmZ
         fT2nJrIZgKJ1E3v1eQ6dZk5rCnisrkq3+kkZ18m2sYVWWuEZNr49FQdUMcOMZa2TaFJm
         u1PVd+6jKOA0alMx8+2e6lzFd36UvmN/KLbmhLiZm1xRq3OyypsXwvL2Vp/qH6H8sFdP
         X2RbMufhmipbYjPPsGeKFKzoJM3nZM3xCfmIh47P9CbMziai6Vm3DzqeTCJqS8/OnHrt
         Jisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fYn4Dk1EXYBsRc4PsiEBtvGWQor3CttFr0ltlRTYZIQ=;
        b=ojEQO9+xHXvbwx3DQMGeW242S0Irua/wiAVEEA9YFvTWjfWpzZZJAJJQW7+t0IW04e
         7R9Q3LYXqIr9Rek4xBke2zGFbAFBxoTRMkYIU89eZakbsSFZBswP+s4CRZ8u0PbGXZED
         eZ8D/9farfQQa17MqHlMziukalxuIyg6nA4dwCpf4PfKVsGnRwbgB8IA2gyVv0lZ2eLG
         sbzdtYmjZvYTaz5sVwfIROHBWDvKzNnmXqLyWrbc4cPZhMjVW2J68S/URzeKtDD3r1Co
         LQc9b1Nc/dB5rQ6mLqqaszfqXZzeOrfGBN4Eri/82OqQy3nrdxlix7TLui9zRTEZiYVP
         fURw==
X-Gm-Message-State: AOAM530C9Q28xvcB/YeoaSpqwQNdObQYuFjtBdvRZKJkjHEu+tqHB7BZ
        n0B5hhBp8N/5Xecp3n5ukMgVlK0gHlw=
X-Google-Smtp-Source: ABdhPJxMpOAeSBVUFIoCg3vHSKXPo4YKdQYvYmGZafiNtvW+4rho3le6siwkhgVuAALddlO9EyQVHg==
X-Received: by 2002:a63:495d:: with SMTP id y29mr12314306pgk.384.1604310692492;
        Mon, 02 Nov 2020 01:51:32 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:51:31 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V9 11/14] xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
Date:   Mon,  2 Nov 2020 15:20:45 +0530
Message-Id: <20201102095048.100956-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102095048.100956-1-chandanrlinux@gmail.com>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The check for verifying if the allocated extent is from an AG whose
index is greater than or equal to that of tp->t_firstblock is already
done a couple of statements earlier in the same function. Hence this
commit removes the redundant assert statement.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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


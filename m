Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81808C6379F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CF3C246B1
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHHGXui3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733208AbgKQNpS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732768AbgKQNpR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:45:17 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8E5C0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:17 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id i8so3588039pfk.10
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fYn4Dk1EXYBsRc4PsiEBtvGWQor3CttFr0ltlRTYZIQ=;
        b=QHHGXui3WtoLe1izQRcewyKQpjwoORI8JGZ3ttSe5uL9PZuMwj+KsaKQNkFwNEtQmu
         9sgA6SN3wKcylyvzv9Gqn18FKAEXf4zZWB1maum2rqIzaqOnbNiqrjKlKzZtNOJ68DZ4
         fIUOOmwHiQ/soWGvKCrGi25tDC4ym2Xw6rtfWiQOQB5+hzgn0RJix4oIWFt91LjTukDs
         1CihnR+q9cXDjSc6IoGhKpr9i1UroKg0Py9C7U4CGNChmZeGeyS6xlMIAIrKfqU7BVAJ
         iTAADa+mJ9t31PaO2m7J/DIO6Djk9qlN0W6ZxjoYoGw827C8vn1kmViwkzgF79ePBSVR
         uxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fYn4Dk1EXYBsRc4PsiEBtvGWQor3CttFr0ltlRTYZIQ=;
        b=ufwQ6ADC/QgxeAIBfEKnHFzmne1VBQnh9A4iuJFwgG18pdO0t/nNp1Wfy3VuwGrKVZ
         /SlGvFulfxIGBYdU15XkYPcTpWS7maNaPirsRqWhU9u1mwYYnCKLHaT95ELUeQoYAdmO
         O2ftygXHcDnhDUQwBGSIuPigGHvXLreSVM27cadDGHGfBAtNp5lHlzxsLKIypBZroctG
         1cdglpmV+lIulF2kOlUIuXa+plo12W1AC/awRiMVzz3VaajpE+RcxaJnhRFFti7LtFCk
         lcYaSNxODNg+BMLFy8kOmE91Kr4J2tuAa4vsKuRcSxQdo0byn3ByGpF2+RDBF4eq3sxi
         rBZg==
X-Gm-Message-State: AOAM5309ARSHDeevrI13xO1JXlppDLxDWSINdGNt6+CvFE3N2fq2pz3v
        PlSip9KLTgWQLUI2gZTO5PMyWrZ70HM=
X-Google-Smtp-Source: ABdhPJzNR36Btgc+FBt3/qk4uqviXmmA/kPxUQ9+9Tf3pW8ZUyOoTa4ExcLEebnMs3ACsbZ5M1MKxg==
X-Received: by 2002:a62:18d1:0:b029:18b:7897:579d with SMTP id 200-20020a6218d10000b029018b7897579dmr1521262pfy.10.1605620716550;
        Tue, 17 Nov 2020 05:45:16 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:45:15 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH V11 11/14] xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
Date:   Tue, 17 Nov 2020 19:14:13 +0530
Message-Id: <20201117134416.207945-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
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


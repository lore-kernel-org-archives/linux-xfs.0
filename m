Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC2DC433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24D4B22A99
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbhAJDbM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbhAJDbM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:31:12 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F5BC0617B9
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:30:12 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id h10so8850676pfo.9
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2WVMaspHNxdyvXTwMeniwIJ4ii/47tlUYvcEvLyZ18s=;
        b=k7nQFz6aqJgURF+TcSJnFDM811Tt4s7hWXZE8uwEAX1N0c7+LPYhoB1iKyLNg09mn1
         26U5G6s5LdT7/icHcH2ipbRdUU+KD4Hve8TWD6iMddiwCegIork4TZaym9IBqJthqNK4
         vvOuVjqtA6yea4itCKWeXGFhKL8WI4/sAhFhzjbkgLrapRrlZfaTbD62/WhD9KFGU2pg
         QirxSZPqr7MvK/hqkL4+UbtgVr2Y9v8TFrR0QvXmLhZ5MUtHABU3b2ossrEUFf/msOYE
         WSEkBG3RW1gQ1XtUw72js9czoxKGFEl8Mr3HWyUwgaoTIw0IG+AbHkRfK4hRLW62DizT
         DDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2WVMaspHNxdyvXTwMeniwIJ4ii/47tlUYvcEvLyZ18s=;
        b=I5qcREDhxmMGzoBdp12GiYZwxHAzh3Nas1uIZk4SONbOphvN5KrFCZrpVgRq3njR5G
         VoFavRLkFIm4lW5YCMzrQbNVY8hl/NF1BuRRljO4XeBATwDlSvo3Djmilkvwa7nlmmBZ
         QPGSbvDPOcTvVgvaSjsudESjN4qv/O/8yRR1E+mCqjtzpuBZ8JIrCuZMNXzUzXKpzgm5
         Hd78AJ7uULSFc6Sna/+w5UhiPKAN7tbjhuFhDhqiMBzjt2dk1wlElRuogRO7wgnLHFg/
         NRzzF2I81IcWrEFw/uwC36FpS4npMr4FGZr9OW37GgL70FCdSgcYj5KWdAKg2pZ/iy5/
         CQ5w==
X-Gm-Message-State: AOAM5308A+nmkHGN4cfw/EXahZqclWSKPP+3v2ZCYTwlIt9pmaA/WVKB
        6Rd9IbZusp7p+4HF0ZoOl0N1A3dppOyfLA==
X-Google-Smtp-Source: ABdhPJww4phYLJiKSc7aAwjGsH0ggi05EJJZIf9gjfOOadOtxvjn5U8YxAnVwZuzGLFRspWZWE1ofg==
X-Received: by 2002:aa7:8159:0:b029:1a5:54e4:7cf2 with SMTP id d25-20020aa781590000b02901a554e47cf2mr10495579pfn.69.1610249412422;
        Sat, 09 Jan 2021 19:30:12 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:30:11 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 13/16] xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
Date:   Sun, 10 Jan 2021 08:59:25 +0530
Message-Id: <20210110032928.3120861-14-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
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
index 44ed30d0f662..0102aefcf4a6 100644
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
2.29.2


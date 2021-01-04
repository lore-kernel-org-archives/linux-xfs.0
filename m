Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69141C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D23222211
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbhADKdI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbhADKdI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 05:33:08 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45494C0617A3
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 02:32:07 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id x18so14325673pln.6
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 02:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kyItOAxhQVFCAwJy3UPQZzsTSvH+HPyEAsRRtLmtugk=;
        b=btFv+kJFKKQq3WjB55mWUnhDaASxMHc5ikGJ2jNITwPCAepmpP3m9wA9/uxbU4l6s1
         P0YKxxUXhDU08qUDWZ+ZrD2Y+qTnz4KwLurzpZgAVCEZbj5rCUpkacpPfpCBxQdfpPPz
         yFSzAGAQC1g7yFhqoRHElhTYNlfGFdB9KLihhhfZa1pNpG5SBSsMPXyHff8zXuWJEccf
         YFP1KIQo5025SkI+vCDWWgmHRC7IpgIbMGTrLQVGWWs60LEv1dWCPdjweJBn8VicM5iG
         /fawvT7Py8F3PY+ad7fHay2LmfeV3cEFlIIJ2dGkCBQjRLwXQGo9F6PpIiDT1JkPlR2/
         LQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kyItOAxhQVFCAwJy3UPQZzsTSvH+HPyEAsRRtLmtugk=;
        b=md8zfnrRrm07mtogAs0G2Plj5mJyH45uEPD6e9k5ikRYlmLg9cLZBtu65WvvqgjOUJ
         XgCod3NtpzyPOD6u2SCzxkaVgFxYTxZ5aAIKRvZMSWN2snIU+b2LKO9lyi4noTW5Si5E
         GBorBK/7p0eABYWAaaSgIPfspi5s5xgfenG4TaHQEJFNGpTjNY4vOK++Bf6xJpiIm6oR
         NSVHbj15DZjigxuM/2B9V9//9hH6XO9QuOXiLgoifq1npfpduCKTyudkg6YJx37XTsH/
         N2Dq8EQUybkX5T4GWls8ttETuUnJ3oCgxaKIhiM6wL9JlR2XyBe7zLXwBrAjwxFVJO0e
         cu1w==
X-Gm-Message-State: AOAM53126nXYy4Dwb+o6FF2B5EyOH9Fa87/4uo3xZsKL7pDSQRWG/5+w
        GBOzJ8zWWYdtzseEsNDepU1oB5X+S90mqw==
X-Google-Smtp-Source: ABdhPJz81NKa9dd/xHw8q4NRhjE0dKxMRXyurRmIcQUSlmYeYeozaGiolh4+t+QsqrZo7JAj0yBkaw==
X-Received: by 2002:a17:90a:e551:: with SMTP id ei17mr28712859pjb.187.1609756326844;
        Mon, 04 Jan 2021 02:32:06 -0800 (PST)
Received: from localhost.localdomain ([122.167.42.132])
        by smtp.gmail.com with ESMTPSA id q6sm51265782pfu.23.2021.01.04.02.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:32:06 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V12 11/14] xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
Date:   Mon,  4 Jan 2021 16:01:17 +0530
Message-Id: <20210104103120.41158-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104103120.41158-1-chandanrlinux@gmail.com>
References: <20210104103120.41158-1-chandanrlinux@gmail.com>
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
index 5fd804534e67..90147b9f5184 100644
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


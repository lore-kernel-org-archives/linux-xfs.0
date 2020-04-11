Return-Path: <SRS0=7tHi=53=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD48C2BA2B
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 067882078E
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 09:13:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gU/jj7Je"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgDKJNJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Apr 2020 05:13:09 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45736 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgDKJNJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Apr 2020 05:13:09 -0400
Received: by mail-pf1-f195.google.com with SMTP id r14so2100266pfl.12
        for <linux-xfs@vger.kernel.org>; Sat, 11 Apr 2020 02:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AhyZfqePr9qLSt0J3hH0m3c4xHZNF3izSj2jUgCn8rI=;
        b=gU/jj7Jee2hnNpeSK2wKzZw79yJVAoXGnodUrqEJUWd1yt24peFt/T7NyQ3v0BSsT8
         SLqcRoKQj8a8lNjMlB+UCJW0tRvYaWmDFI6S6CYIrxANh8sBJJCtebol5kzUFZsthTta
         kOUmeB8HOW2tI0UwWT2rdpX00HRt3safBonnLx54FDnUJiKWm9CL1GojZLhcELp1QXsO
         ctzgJkjYYxz9tEijscdoTbrLx6q53ueGwZ+kRK58vVkxgiPcI01iKYkGop5q1cQptIyB
         bzVI1OqcG/rQbY82Jt7NK2gBO+haMGqG0Yyw8/hAgwTXLR6URqsErxEhgA+gt56vTz6n
         tyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AhyZfqePr9qLSt0J3hH0m3c4xHZNF3izSj2jUgCn8rI=;
        b=fd0rAFkrALL2BbzHT4ukOVZ1pN4F/7k0Hu6d9pQUaqLdlurgRPyu6boqCsT9GR7290
         0vp74Vi6cBG9WhCxuqoURRrgbimJTElwp7gJShL5bxNLss2mzFbZHac49WtSYVPsGIe7
         sJi7dbyxhkaaQUkoOzFjB0uyIq1RTzLltRneVY+CWozDATthVF+6y4hoSBhSkwkZoxJA
         BYcRM94HnEXcWS4dTBhC+XvIPBmwmKqhOZXy+gAu9TbuGVcsy7rhtIgcVH23Rr2v8ABx
         RVAwKlCN9yYKjszcpDutmaxJlNmgh4KcGfQyq2FQANcWaKeKppCgsDan4DzBhnVwkJb6
         pqgQ==
X-Gm-Message-State: AGi0PuaVRLb8mMUS0hrzKFD3MERPPj1IZMFgUAkOaSLuMRP+PYHFbrai
        VFukhRUl3+uYfSc78wJtdEzyqAI=
X-Google-Smtp-Source: APiQypJ4ynvx5B5e08ot9vNjLbg9t/IITFODCJHl+Ip1HO2uBUq8DwzCsoeslwAN0WXY7qHtUHerqw==
X-Received: by 2002:aa7:940f:: with SMTP id x15mr8895019pfo.312.1586596388713;
        Sat, 11 Apr 2020 02:13:08 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id n7sm3280364pgm.28.2020.04.11.02.13.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 02:13:08 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 2/6] xfs: combine two if statements with same condition
Date:   Sat, 11 Apr 2020 17:12:54 +0800
Message-Id: <1586596378-10754-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
References: <1586596378-10754-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The two if statements have same condition, and the mask value
does not change in xfs_setattr_nonsize(), so combine them.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f7a99b3bbcf7..e34814590453 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -738,12 +738,7 @@ xfs_setattr_nonsize(
 			if (error)	/* out of quota */
 				goto out_cancel;
 		}
-	}
 
-	/*
-	 * Change file ownership.  Must be the owner or privileged.
-	 */
-	if (mask & (ATTR_UID|ATTR_GID)) {
 		/*
 		 * CAP_FSETID overrides the following restrictions:
 		 *
-- 
2.20.0


Return-Path: <SRS0=6Z+e=CI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F84C433E6
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 01:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D866D207BB
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 01:31:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="snIHPNIt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgH3BbY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Aug 2020 21:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728384AbgH3BbX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Aug 2020 21:31:23 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FF7C061575
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 18:31:22 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id 60so2426108qtc.9
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 18:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=oTXPJKxAg5XxTQVL81YppTbJbKKdp2qoMjgryaZThzc=;
        b=snIHPNItiSzMiNbfMvHkwKcuLJe8cG++Oz2ae8qgnrH1ekSHdofCVjHTa1VxsLoeYQ
         kY0fJQw17HrhhvbknPyQU/+X2QJodjqBIL7rjSl0u+38tvX6s4n2Wla57G/6YcU1Q4YG
         yY4w0S5FAIv+SbABcIvu/T4WSScBA/64RzO6UC6leqD4skku42yNm9Tf5qF4sXguMP9D
         dJtoK1aXxn5zgfJIREsXq9lAZ7QcP/JT+MFLzFUBdHDorjQyScUo8DvQuM/mAj2K6Sel
         s4KotxmA3eplfUQ2FecY/AX3Pma+7DhPYL2MATUNCQDeCb4Ax5fxktpf6dLOQiHay9Yp
         NJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oTXPJKxAg5XxTQVL81YppTbJbKKdp2qoMjgryaZThzc=;
        b=UlAh3tvOX9IMDhpN9atRnq4Pdwg08ZByMwX5AZcrvCFsTvn1fZT56gqiWblBxvJRRQ
         ALItDbsEKnMgLCqOu8+HPfWNcJ+S3mb8IJjGmyTsOahmfxWrsK6jHhY9Uh+saNHzo0vj
         t36pxbcijNVSTB/+WPkrzm9bRvDXr5S9OXw0VmI3SXDTHqG6nJ2gpGvi7FqrDzF/q8at
         gXnMhZfJqeUmxXiiIfiaZam56OgkRj/i12XGm0hZht8kk8/SA9UK6hD0lo62y8B8/V2Q
         O9TG88629CLuZP9+T3H/ENeY3mfy+gOnzanFVxFU0eqoVhhbqq0/fqFcJH5+kxXcsb00
         RZtQ==
X-Gm-Message-State: AOAM5313J3z13wnkPjW2rqI+2mexf7lY9jJwGYs4sRQ93sznq2Bv98GI
        5FP16oAWQq6zHQ9fNg69IZovOFHkIfiDyQ==
X-Google-Smtp-Source: ABdhPJzwUsBp/+777eFsa+X2LXOqWrmMmxFxP7fZxqjoql/YJZT6UN4uCbSqzHfAc+XBjx1QqoB52g==
X-Received: by 2002:ac8:2baa:: with SMTP id m39mr7636519qtm.204.1598751080998;
        Sat, 29 Aug 2020 18:31:20 -0700 (PDT)
Received: from localhost.localdomain.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id e21sm4017553qkl.88.2020.08.29.18.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2020 18:31:20 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     darrick.wong@oracle.com
Cc:     hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>
Subject: [PATCH] iomap: fix WARN_ON_ONCE() from unprivileged users
Date:   Sat, 29 Aug 2020 21:30:57 -0400
Message-Id: <20200830013057.14664-1-cai@lca.pw>
X-Mailer: git-send-email 2.18.4
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It is trivial to trigger a WARN_ON_ONCE(1) in iomap_dio_actor() by
unprivileged users which would taint the kernel, or worse - panic if
panic_on_warn or panic_on_taint is set. Hence, just convert it to
pr_warn_ratelimited() to let users know their workloads are racing.
Thanks Dave Chinner for the initial analysis of the racing reproducers.

Signed-off-by: Qian Cai <cai@lca.pw>
---
 fs/iomap/direct-io.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index c1aafb2ab990..6a6b4bc13269 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -389,7 +389,14 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 	case IOMAP_INLINE:
 		return iomap_dio_inline_actor(inode, pos, length, dio, iomap);
 	default:
-		WARN_ON_ONCE(1);
+		/*
+		 * DIO is not serialised against mmap() access at all, and so
+		 * if the page_mkwrite occurs between the writeback and the
+		 * iomap_apply() call in the DIO path, then it will see the
+		 * DELALLOC block that the page-mkwrite allocated.
+		 */
+		pr_warn_ratelimited("page_mkwrite() is racing with DIO read (iomap->type = %u).\n",
+				    iomap->type);
 		return -EIO;
 	}
 }
-- 
2.18.4


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B46C43333
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8AC922AAD
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhAJQLH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbhAJQLG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 11:11:06 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C77FC0617B1
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:10:07 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id u4so7249149pjn.4
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qL5piTAh1aSsUUaP1sY2S+E5lRi3K6MY3JGZu20fr+0=;
        b=hs8XJNB0CCyUaE932CYIhZb+0X+G8kK/WBIECZ9CX4QNYNzo9KlQj4GBnjKQKZHnVs
         Ul/N9xybfXH47HYicFU24kc7S4BHNcwXDiFhJJUUuJtx+v1+dfgK1PYhxHWjw3DTzWLP
         pociBO37Oe0+NfdyfCyRvzk/+5sMMuBTcnhOk0HnuxIVVg2v4+Ygy61PpOA9wscHdcUL
         LEIgCMo7X3mjlDTOXdhKHk2lCGkfTgV6oPllSkmv69kNUGzGIrYq7Cm4reCnRZP8QjWY
         oU5Z0GhxP2K7q5NN3hIy9iIhRicoJj1ItvR4A4Mna+riNpPwoQixVdcjz2hXkKEEWY2/
         C5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qL5piTAh1aSsUUaP1sY2S+E5lRi3K6MY3JGZu20fr+0=;
        b=p1X1IESNNNmwtFMsIPUcBhIeheaJEjfkdV5HBCZvMWbsq3IkFUFdWQn/6Tr0oe5WAx
         iRVIx8EtMt0w6U0Z3/kcLOcjWNddrAa2olQ2ntJYtBhWtI/mHtllnTsql1o49b5CaJt/
         zuCGLv2Fem1SSYcI9WxN0z2e34bjBYrZ1VVepBsC8G8AgksXH8ihbdH4HTdQHRcBUtCX
         tipqKlRz8EevPIcGuG8lgSnAvyXj2/U74VOfg48DeuCpULhlSvKb6xQlMnGe50PmQwXe
         wx/8cdbXMzXjhBVVYkSXj8K34Pl7XKO1ws/bzwwl5/8ap4fKgsPfNsm5YbGivrAIfwhU
         EKTQ==
X-Gm-Message-State: AOAM5301jrVyoC3T3sSPaiaPgHk/EuCMa6WBJ0p1oJ/VqkBUocKmQyRk
        qxafQfsq7Fhfr7R5BNKgU0NJ0p/7oro=
X-Google-Smtp-Source: ABdhPJyWqYyCbdk++yG4ZJO8H87CQPJsLbtPnXKZuIteroLz0GletjcpLczLUe5g9nnAJg2OoXUF+A==
X-Received: by 2002:a17:902:6b01:b029:da:d295:2582 with SMTP id o1-20020a1709026b01b02900dad2952582mr12916007plk.14.1610295006812;
        Sun, 10 Jan 2021 08:10:06 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id d6sm15525896pfo.199.2021.01.10.08.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 08:10:06 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V14 13/16] xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
Date:   Sun, 10 Jan 2021 21:37:17 +0530
Message-Id: <20210110160720.3922965-14-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110160720.3922965-1-chandanrlinux@gmail.com>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
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
index 8ebe5f13279c..0b15b1ff4bdd 100644
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


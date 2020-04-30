Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E30C4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 21:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC2520731
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 21:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="K0b9BUEb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgD3Vwq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 17:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbgD3Vwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 17:52:45 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023E3C08E859
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 14:52:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id rh22so5958813ejb.12
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 14:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LDEyu4DqGHwJ7t/wlLTaUyFP1PKV8rYydYP0xvjnvj8=;
        b=K0b9BUEbUMN4c/HcO3EMetbwDKa/bQB7gEHoueMz+xCk9NFN8tJEEGyelIxvpaZToN
         ECQhJ9+wuy6qVtEwW9mUbisrOp3Pj/n5ULKfaLTMyrAgHJ/y7vfV7+QRzZcu/ByCJwZV
         CPuAb8QHPy18fm4QKel2ZHntwvTIDJWCm5hPjM+GtW6xp2scc5EbWir72q2kghoVWPxH
         Az6OQH50Tuf5V695TOo+L4tAZIwvPVOvxxLMV5G8tX86ymSPIZ2N9QR403Il6RFjXg4b
         ouaTyJZDdGlDGYke3obk+Sa+ExaUEl1q26wAKLnV/KKIMOjQcxkwBOITpksORcNhKjYu
         O75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LDEyu4DqGHwJ7t/wlLTaUyFP1PKV8rYydYP0xvjnvj8=;
        b=Gzeg+X4BSuFmbp0jWcbRCP9UdYYHib+5uMmPT2EwUbR7tdwGd/DCIbWp77N77LK3Pb
         JDwhvMMTkb6lYzT9atGQl7+fDlmhUdfuVh6Rmlwx4Yylo3ax+SSZfJ1Y5mhDzkFV1F8d
         pL6LRd/sRoOr7wcbOlny4nkAJWI04W0wmrmMhx3jeZvRoNig05j1JiNz0URTRV42gDje
         DSNRyrQ+xCQoqEM3nKNbw9nb1sS7/qM1LNmhkWEo73YPCYnn9aDXX2qtEFiwvNYQSsHV
         Ad6qXyLPCQjQANvxDKs2N1/Nxt/3oRgC4j1vpJgKcZcDTMoBgo0xsdbBCkKlVSjAmKKW
         ZFcQ==
X-Gm-Message-State: AGi0PuZTXnEVo4SMohCejgazyIZ9dR9oiX066ZypyGYdFdgK32X2mq+Q
        KQc5aOIk/xmS61KKGkbxFhGuEA==
X-Google-Smtp-Source: APiQypJYcY11pPgGBq9YSYemUl02BKlG2gtWtnLYjB8d8jL0gxleYPu+2YtHv3X6Kc4Pait6eLK1vg==
X-Received: by 2002:a17:906:5918:: with SMTP id h24mr537740ejq.210.1588283562672;
        Thu, 30 Apr 2020 14:52:42 -0700 (PDT)
Received: from ls00508.pb.local ([2001:1438:4010:2540:b82f:dfc:5e2a:e7cc])
        by smtp.gmail.com with ESMTPSA id f13sm92022ejd.2.2020.04.30.14.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 14:52:42 -0700 (PDT)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     hch@infradead.org, david@fromorbit.com, willy@infradead.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [RFC PATCH V2 6/9] iomap: use attach/clear_page_private
Date:   Thu, 30 Apr 2020 23:44:47 +0200
Message-Id: <20200430214450.10662-7-guoqing.jiang@cloud.ionos.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430214450.10662-1-guoqing.jiang@cloud.ionos.com>
References: <20200430214450.10662-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since the new pair function is introduced, we can call them to clean the
code in iomap.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
RFC -> RFC V2
1. change the name of new functions to attach/clear_page_private.
2. call attach_page_private(newpage, clear_page_private(page)) to
   cleanup code further as suggested by Matthew Wilcox.
3. don't return attach_page_private in iomap_page_create per the
   comment from Christoph Hellwig.

 fs/iomap/buffered-io.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 89e21961d1ad..cf4c1b02a9d8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -59,24 +59,19 @@ iomap_page_create(struct inode *inode, struct page *page)
 	 * migrate_page_move_mapping() assumes that pages with private data have
 	 * their count elevated by 1.
 	 */
-	get_page(page);
-	set_page_private(page, (unsigned long)iop);
-	SetPagePrivate(page);
+	attach_page_private(page, iop);
 	return iop;
 }
 
 static void
 iomap_page_release(struct page *page)
 {
-	struct iomap_page *iop = to_iomap_page(page);
+	struct iomap_page *iop = clear_page_private(page);
 
 	if (!iop)
 		return;
 	WARN_ON_ONCE(atomic_read(&iop->read_count));
 	WARN_ON_ONCE(atomic_read(&iop->write_count));
-	ClearPagePrivate(page);
-	set_page_private(page, 0);
-	put_page(page);
 	kfree(iop);
 }
 
@@ -554,14 +549,8 @@ iomap_migrate_page(struct address_space *mapping, struct page *newpage,
 	if (ret != MIGRATEPAGE_SUCCESS)
 		return ret;
 
-	if (page_has_private(page)) {
-		ClearPagePrivate(page);
-		get_page(newpage);
-		set_page_private(newpage, page_private(page));
-		set_page_private(page, 0);
-		put_page(page);
-		SetPagePrivate(newpage);
-	}
+	if (page_has_private(page))
+		attach_page_private(newpage, clear_page_private(page));
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
 		migrate_page_copy(newpage, page);
-- 
2.17.1


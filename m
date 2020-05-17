Return-Path: <SRS0=e/GO=67=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96E6C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 21:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 997AB207E8
	for <linux-xfs@archiver.kernel.org>; Sun, 17 May 2020 21:48:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="OnCwteZT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgEQVsD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 May 2020 17:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgEQVra (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 May 2020 17:47:30 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E159C05BD0D
        for <linux-xfs@vger.kernel.org>; Sun, 17 May 2020 14:47:30 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so9562774wra.7
        for <linux-xfs@vger.kernel.org>; Sun, 17 May 2020 14:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KhLF+EAo4dGVe9BW/cZoXpOODpgV89tLSnKlct0jr14=;
        b=OnCwteZT1cB8ocCGH1aeVFrR4EgF5VX00CwdKk8KWUvXv5ftfo0fsjEkaKXrYyqAko
         mv8QW8YvOau+ddNZijQJPWJlc875CMZRCq5jPs47LtKcK0iAs7w4XKAdfWadVkwF5yh0
         vbZ8lxoep7MmAuEH6k47PeqCAdK68/ugEpDe30/qtwZ9iClzkmuyh8DAmed8tdkPBipP
         jtwANFKLPWtFlbDtTJ0ozTDQyrJ/8MF+yVMxoywDnUPV0eAnzFwGIvF1UFAWTh1jfkPy
         frPno0kwJWfIWzY+KzjmatENTMD8D9ajyV22QBav5R+pK9+lpGb7JXY4w7s1coccPTEN
         Jq9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KhLF+EAo4dGVe9BW/cZoXpOODpgV89tLSnKlct0jr14=;
        b=Pvt3yMCi0mxXe2PiaI2jxIt3awmx1bTzFZ+8EqjmVErbiniC0fGqw+fKPXF5IIs8oj
         01uMlDOWlkWZwxPTMGDVrsoSpWkXMH0Qu1HI7eUvJLG5XROCvp1xdl30rFsTEbnTJEuZ
         NEA0+XsTBsVmZAjLOdzTpDcIW9aoGn4xS4TIuBalqLaVsJOKMegKV8L3+pKgWxudDgHM
         pLdOic/POFBEFQsSylQTzTiXu6lC755fjN6Bkm8lwY/LQN7b2dxOIUcv4Uj8ebRnps0J
         vC3vq5fkb6HPr9qFKB7zPXV5+1WV7CnKYjWlfCIKK+0LVgbhHJMGPYyT0Oa0BW+6LKNU
         4JeA==
X-Gm-Message-State: AOAM5320ktomhBrS71VnrbpK6N2TOQSk6/egE5WJ2WXeeoYFELu39Xc7
        NL3Uc7XuX7jv6hlnWScvOjVyzw==
X-Google-Smtp-Source: ABdhPJxxkRT4OGk3cy6v3FeXQDoR5/LNYOrP29Np5Cq4jtgQoATViCQkp2walv4nqYI4LHoZCE16MQ==
X-Received: by 2002:a5d:5228:: with SMTP id i8mr16279223wra.359.1589752049269;
        Sun, 17 May 2020 14:47:29 -0700 (PDT)
Received: from ls00508.pb.local ([2001:1438:4010:2540:bc3e:92a1:7010:2763])
        by smtp.gmail.com with ESMTPSA id v126sm14441244wmb.4.2020.05.17.14.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 14:47:28 -0700 (PDT)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To:     akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org, willy@infradead.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 06/10] iomap: use attach/detach_page_private
Date:   Sun, 17 May 2020 23:47:14 +0200
Message-Id: <20200517214718.468-7-guoqing.jiang@cloud.ionos.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200517214718.468-1-guoqing.jiang@cloud.ionos.com>
References: <20200517214718.468-1-guoqing.jiang@cloud.ionos.com>
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
No change since RFC V3.

RFC V2 -> RFC V3
1. rename clear_page_private to detach_page_private.

RFC -> RFC V2
1. change the name of new functions to attach/clear_page_private.
2. call attach_page_private(newpage, clear_page_private(page)) to
   cleanup code further as suggested by Matthew Wilcox.
3. don't return attach_page_private in iomap_page_create per the
   comment from Christoph Hellwig.

 fs/iomap/buffered-io.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 890c8fcda4f3..a1ed7620fbac 100644
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
+	struct iomap_page *iop = detach_page_private(page);
 
 	if (!iop)
 		return;
 	WARN_ON_ONCE(atomic_read(&iop->read_count));
 	WARN_ON_ONCE(atomic_read(&iop->write_count));
-	ClearPagePrivate(page);
-	set_page_private(page, 0);
-	put_page(page);
 	kfree(iop);
 }
 
@@ -526,14 +521,8 @@ iomap_migrate_page(struct address_space *mapping, struct page *newpage,
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
+		attach_page_private(newpage, detach_page_private(page));
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
 		migrate_page_copy(newpage, page);
-- 
2.17.1


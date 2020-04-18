Return-Path: <SRS0=FK3z=6C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE3CC352BE
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 22:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE4921974
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Apr 2020 22:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="BydKuw3C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgDRWve (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Apr 2020 18:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbgDRWvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Apr 2020 18:51:32 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40A9C061A0C
        for <linux-xfs@vger.kernel.org>; Sat, 18 Apr 2020 15:51:31 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id nv1so4651389ejb.0
        for <linux-xfs@vger.kernel.org>; Sat, 18 Apr 2020 15:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vI+qH6PQl8iOTuF91icuURnJsbkLpyoxA3JGpFFvgGY=;
        b=BydKuw3C1yL1Zrxj6fxlQJkXD633PCUQ9qVzyPGmiKRT14W89wfOFNSS+Hn26SuP+5
         Vo8HJw8MYYtBGBAka0mqnlZlMMpd0ptQhbl7X6NKiKmz4XXv30cOi6hUfbAMo1UA7lWS
         aMU2m7g8WpHmjULDeYJfoOER9Zb+JUo/YdxUvVip7Ug9p+yE4waD/O7MAU+DT11IeVhf
         eqz4E0nWeK0hqywttveVAT7SDsG3iT3349J/4hDoFu+IhWgBCaLPqa6KndDTuxt9G1sG
         s72FVBDp83nZald1aA+FeIOXFjl43cVKu/bvFr+ZUIbsx5uGs5MIlycbgyxqgGR7wXjM
         J6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vI+qH6PQl8iOTuF91icuURnJsbkLpyoxA3JGpFFvgGY=;
        b=bblz87thro1BiXFOt4xbLPY0M3FwERJzbJe5Mwpil4RbWrg77KFc2kthrwWWRip0F7
         pt4q7MpCqnGQddYrI3T+Ra2CyvP//+WDh0Tyue1fG7AN1SVG52qw1M7bgaqlm7qyTuw3
         ggV3X+UGOhv17JaXxdNhJ9JX9YwIcJ+Fq2j1NohBDEATEPTj46fE/C3JphFTHz/gASS0
         FpNjhUdDktYGTScGRz2WTGe4VTThh9wcUz5wglof+viBn6LiQ8RGO6Qiju32m3/OFvwe
         jcgt7fjRepCFqiF5DVZsU2EwFp0ErgDfwQ/U7v/O/5rJqBSbQ+PGNZIt1fZaEbbvtZee
         WLtg==
X-Gm-Message-State: AGi0PuZr1EfHvYzQw3nBhmsSH+yAK7zClhdhPPx9+ytVthQSWB2Guc6I
        3m8oQ7zgw87+CCVrLUEbMxt2G8vp5O7sbQ==
X-Google-Smtp-Source: APiQypKY3BdcqjF3Tf4l/0w0TOoBeBknIwydV9wTBcWqQDgCxj4Pnxn7JcavMI4hhcMA45D9jzledw==
X-Received: by 2002:a17:907:72c9:: with SMTP id du9mr3995735ejc.146.1587250290578;
        Sat, 18 Apr 2020 15:51:30 -0700 (PDT)
Received: from ls00508.pb.local ([2001:1438:4010:2540:6c58:b8bc:cdc6:2e2d])
        by smtp.gmail.com with ESMTPSA id g21sm2616767ejm.79.2020.04.18.15.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 15:51:29 -0700 (PDT)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] iomap: call __clear_page_buffers in iomap_page_release
Date:   Sun, 19 Apr 2020 00:51:21 +0200
Message-Id: <20200418225123.31850-4-guoqing.jiang@cloud.ionos.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200418225123.31850-1-guoqing.jiang@cloud.ionos.com>
References: <20200418225123.31850-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After the helper is exported, we can call it to simplify code a little.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 fs/iomap/buffered-io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 89e21961d1ad..b06568ad9a7a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -74,9 +74,7 @@ iomap_page_release(struct page *page)
 		return;
 	WARN_ON_ONCE(atomic_read(&iop->read_count));
 	WARN_ON_ONCE(atomic_read(&iop->write_count));
-	ClearPagePrivate(page);
-	set_page_private(page, 0);
-	put_page(page);
+	__clear_page_buffers(page);
 	kfree(iop);
 }
 
-- 
2.17.1


Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B617C4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 21:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAA6A20731
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 21:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="NGAEKGru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgD3Vwl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 17:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgD3Vwk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 17:52:40 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8CCC08E859
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 14:52:38 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id s3so5986747eji.6
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 14:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2Cwm7q37wd5a49T4hM9tpsz7D3qzUxu8CT8JBwv0w4c=;
        b=NGAEKGruhKtx7ZWTrFdEqTmqAVl/YDbNX5SVHiheCt5mgGQXMvPqVsB2mWj4W+6TZx
         avj1y2aqFM2fM4mYbpeY1mNHjz5L5wFBJHZ7nqGDO/UfrsVe7K3fK+19Qz0xhaRBCJF8
         cnG9jsv0Y3cuCHExnrUC59PgGg5ldN6zReZ4l/MkqDih/pWf2Qq5leOqyJa1Ea1uUvqL
         KSJUgjKhSgiIMTbhcESV0rK/2/wlrqs0rRp/j53oVanG3NSXpHazoglUXFC2CIoq8QGs
         T0RBK7fYVyj0odwSJ7t5g5PDfIz9c6vhMkT7fz1ruAgadlRAj8EWlz0SjkauUs46ppHW
         r7PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2Cwm7q37wd5a49T4hM9tpsz7D3qzUxu8CT8JBwv0w4c=;
        b=fEseS7tZn+XqnBA1kUz64LphC5f+ySVKWVTGW0wcXOOpV3C6z6lGNrX8OZUWR2MVvR
         s9n+N6LzNT7Y7oGRqNMox3H6JOE2+/pui6J8y1zhLxdV7bXXtffwm/pka4+jevlcAiaN
         7AOE9NZQIW/96s11LJO1Qn8WvsP4hX5tP/hm0H66AKQm7X2LLImtm9BBD1wLhcbjxOhm
         2K8Y8mrrAhxTDir/9J0X9ejXYzEXrJnZ51zKw6jXh3XxSw0jgQipYnkG7vmK07VgjM2e
         kBifbargRnLHrSScoZb34+S9kR3YnrRMn1fiH99CYHCRRvjqUNtTFdYB6klklngud0TU
         ZaVA==
X-Gm-Message-State: AGi0PubYv3jWW8FEgL+rWr69VgPEwzIkZo1MIcxf/TwI/m7U0RLHi3sf
        nxKWLQwBL4MPXazP7V6xi94GEw==
X-Google-Smtp-Source: APiQypIDTj3Uj7biPphTd2Cba892cORi5pdinqFvBm6XPxrzHDikqrxlAy/dZ1nN6NDVa1Eq5TMhqw==
X-Received: by 2002:a17:906:b2c4:: with SMTP id cf4mr538626ejb.340.1588283557346;
        Thu, 30 Apr 2020 14:52:37 -0700 (PDT)
Received: from ls00508.pb.local ([2001:1438:4010:2540:b82f:dfc:5e2a:e7cc])
        by smtp.gmail.com with ESMTPSA id f13sm92022ejd.2.2020.04.30.14.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 14:52:36 -0700 (PDT)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     hch@infradead.org, david@fromorbit.com, willy@infradead.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        William Kucharski <william.kucharski@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Yafang Shao <laoar.shao@gmail.com>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        devel@lists.orangefs.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roman Gushchin <guro@fb.com>,
        Andreas Dilger <adilger@dilger.ca>
Subject: [RFC PATCH V2 1/9] include/linux/pagemap.h: introduce attach/clear_page_private
Date:   Thu, 30 Apr 2020 23:44:42 +0200
Message-Id: <20200430214450.10662-2-guoqing.jiang@cloud.ionos.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430214450.10662-1-guoqing.jiang@cloud.ionos.com>
References: <20200430214450.10662-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The logic in attach_page_buffers and  __clear_page_buffers are quite
paired, but

1. they are located in different files.

2. attach_page_buffers is implemented in buffer_head.h, so it could be
   used by other files. But __clear_page_buffers is static function in
   buffer.c and other potential users can't call the function, md-bitmap
   even copied the function.

So, introduce the new attach/clear_page_private to replace them. With
the new pair of function, we will remove the usage of attach_page_buffers
and  __clear_page_buffers in next patches. Thanks for the new names from
Christoph Hellwig.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: linux-ntfs-dev@lists.sourceforge.net
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Martin Brandenburg <martin@omnibond.com>
Cc: devel@lists.orangefs.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Roman Gushchin <guro@fb.com>
Cc: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
RFC -> RFC V2:  Address the comments from Christoph Hellwig
1. change function names to attach/clear_page_private and add comments.
2. change the return type of attach_page_private.

 include/linux/pagemap.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index a8f7bd8ea1c6..2e515f210b18 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -205,6 +205,41 @@ static inline int page_cache_add_speculative(struct page *page, int count)
 	return __page_cache_add_speculative(page, count);
 }
 
+/**
+ * attach_page_private - attach data to page's private field and set PG_private.
+ * @page: page to be attached and set flag.
+ * @data: data to attach to page's private field.
+ *
+ * Need to take reference as mm.h said "Setting PG_private should also increment
+ * the refcount".
+ */
+static inline void attach_page_private(struct page *page, void *data)
+{
+	get_page(page);
+	set_page_private(page, (unsigned long)data);
+	SetPagePrivate(page);
+}
+
+/**
+ * clear_page_private - clear page's private field and PG_private.
+ * @page: page to be cleared.
+ *
+ * The counterpart function of attach_page_private.
+ * Return: private data of page or NULL if page doesn't have private data.
+ */
+static inline void *clear_page_private(struct page *page)
+{
+	void *data = (void *)page_private(page);
+
+	if (!PagePrivate(page))
+		return NULL;
+	ClearPagePrivate(page);
+	set_page_private(page, 0);
+	put_page(page);
+
+	return data;
+}
+
 #ifdef CONFIG_NUMA
 extern struct page *__page_cache_alloc(gfp_t gfp);
 #else
-- 
2.17.1


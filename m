Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F307C4743E
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 21:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09C7C61403
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 21:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhFDVMK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 17:12:10 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:49099 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhFDVMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 17:12:08 -0400
Received: by mail-yb1-f202.google.com with SMTP id v63-20020a2561420000b029053606377441so13521701ybb.15
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 14:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RT0RrB/jxKMI6YW+PFYA3ymIrlH2UsJVKGU6y0kBnOw=;
        b=IlZOZ7kDYPui8ADSyBSgg53Xoy729/anXoL9HE6GnxaUrhX/OSd1UbLB0u1F+7d9Td
         JVxj6n9wuW+E0OZ7vDRXrTfbCD6XuwNVY9v22kKfJVNYb9WY404LeKW4yQ2tpPmzigpm
         V+j0KbaKVIPgWl/XtyfWFGvYkgLJlkemDaCQc25sAFQeYkHSg34+XxpgajWSGIfj4/be
         V52CdBnBn4uGgdqBlgjFpwgA4zIXigOLYYLcck1Ox7vAMAb0YTWh94/lpF9I2Q7F7RI/
         gPD6HaFeiyqVyFUYSb1DYREYy6u9CegrBeWpsXNHM9mK3f2L+mshA5baEf6Ew6vzjwfA
         VpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RT0RrB/jxKMI6YW+PFYA3ymIrlH2UsJVKGU6y0kBnOw=;
        b=B+kgBvD4AzhKxXKfisttd/yNMQh3hVcegmcjkMRhuqNkEZSRkE8JKPbVe5GJlA0mtV
         t4oMHTIQD28uwwo+d0ZhcbBN983fI5YhnDTXF32TcNLgcXa7Q1kKXwyTttSJOUJrfgZT
         PW1R4DRuQnF6HEBbpymmpdIJYqUHB36rSQ7RQYYeAYELaQl58uOgzaEzyJQOpcHtWSIQ
         FDuQsnaZGtAXaVVJMx3K+O2dVHjpdkohwiQVQc+A8ED6faJfmd/Dxu70HpFMvPoAuVei
         FU2tsUkyCC+flprNf4A9C80d/bFgmuQ5aTmgDrIu/y4ayf+DSMKcHQALQqrzvfP8vPRN
         jVWg==
X-Gm-Message-State: AOAM533xyC7MzeAgbdTdqAVyw/Gx+CbEbZuDi5liaZLSPJ8KXB8zteQ8
        WFZTld51fRVEYfApCgjYZvaIFqurzz0=
X-Google-Smtp-Source: ABdhPJzJE4zslyGfGvcDlz07boMQ5nRjs8yyzCWvA2MMz8AlycCO4TqXJ8BnIMpWw/eg+X7rMUBks6idOm4=
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a25:8185:: with SMTP id p5mr7728654ybk.54.1622840961400;
 Fri, 04 Jun 2021 14:09:21 -0700 (PDT)
Date:   Fri,  4 Jun 2021 21:09:05 +0000
In-Reply-To: <20210604210908.2105870-1-satyat@google.com>
Message-Id: <20210604210908.2105870-7-satyat@google.com>
Mime-Version: 1.0
References: <20210604210908.2105870-1-satyat@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v9 6/9] iomap: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Set bio crypt contexts on bios by calling into fscrypt when required.
No DUN contiguity checks are done - callers are expected to set up the
iomap correctly to ensure that each bio submitted by iomap will not have
blocks with incontiguous DUNs by calling fscrypt_limit_io_blocks()
appropriately.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/iomap/direct-io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 9398b8c31323..1c825deb36a9 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/compiler.h>
 #include <linux/fs.h>
+#include <linux/fscrypt.h>
 #include <linux/iomap.h>
 #include <linux/backing-dev.h>
 #include <linux/uio.h>
@@ -185,11 +186,14 @@ static void
 iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 		unsigned len)
 {
+	struct inode *inode = file_inode(dio->iocb->ki_filp);
 	struct page *page = ZERO_PAGE(0);
 	int flags = REQ_SYNC | REQ_IDLE;
 	struct bio *bio;
 
 	bio = bio_alloc(GFP_KERNEL, 1);
+	fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
+				  GFP_KERNEL);
 	bio_set_dev(bio, iomap->bdev);
 	bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 	bio->bi_private = dio;
@@ -306,6 +310,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		}
 
 		bio = bio_alloc(GFP_KERNEL, nr_pages);
+		fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
+					  GFP_KERNEL);
 		bio_set_dev(bio, iomap->bdev);
 		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 		bio->bi_write_hint = dio->iocb->ki_hint;
-- 
2.32.0.rc1.229.g3e70b5a671-goog


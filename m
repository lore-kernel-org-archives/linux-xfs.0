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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBD7C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 23:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78CA120769
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 23:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbhAUXZP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 18:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbhAUXG0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 18:06:26 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7BFC061220
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:03:49 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c9so3661030ybs.8
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Dk48xoljaDfKrHrHMhr41MTHc48m5tHc6K5cc6+60c0=;
        b=AOwqVIYhEfj64Av4uEMJ8dSXxk8ne2BkUsUnz+ACunkTKRrxPpI/6sLcfbRBs7cNfl
         h5qPnwUs6LddC54j2mpWSWeh77OnP521QsSDsA2EqHU3eTeUqnT+oe4HtfLSjcnqB5V7
         D9cvChljpRJNuYOjKg9Oyj+cAe/xvu+QkQ1VIJQm6uloPLqIY07SFnMq2UBqecaSUDHp
         +Ajt62MR8Fp5RrZ7TibPGcZK9kJVvNizT+AUEgltWWilJcA7Fu0O34Tf4Eoqz77HP5X3
         wtX06Ui8oahF007Y1fWYBzCRcteJTi0Ni09bl5j2Z9rw84yplKdcqpX6r+O7nek4Me+V
         fvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Dk48xoljaDfKrHrHMhr41MTHc48m5tHc6K5cc6+60c0=;
        b=ViC8XUUq/27lzHPuRo1qqrJFfMgwT1fJ3ClIjmtLbzQYafqZIW2czy7DCHPx3mQ1jz
         QluSozmPnVqVBiRsBocgjGE6Ir/tpROMVmxs/jidmhsWIgbcezGiEz45iJ553QzyeSsJ
         GQ4WB1DKukI5qB4SoSyftzvmVmOquzZeqdadzGz8rUC8UGMjRrzJExyPcN/+oye0EUXn
         sxbsn4P7W7v9T11/XXXRkgURAbX94HzLa1HPICd+9auGoE1WdOFX2ogV1rZiod5ei7tJ
         hn612HHd5J0iyV7kI20/kueVJLBkhH7dfEqhTcYqscPCEHlXcjvYbfE+hXi0IsYkdIRG
         6LiQ==
X-Gm-Message-State: AOAM530zaVF+6mo6anD6xwZ5a2iAw1au//h3Vk95Y8qlKbjiGjogvgLS
        jouTM8zMfXNxDpTKx2N2WRRULrlkkSg=
X-Google-Smtp-Source: ABdhPJyX5dl3YFdc0cGF8/opvXclsHMhLvELrPXG/G+g5KWNEjBlc4t0ZdcLzDJrZ/b4VlIyaHc4NeW9Ir8=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a25:cbca:: with SMTP id b193mr2572599ybg.324.1611270229151;
 Thu, 21 Jan 2021 15:03:49 -0800 (PST)
Date:   Thu, 21 Jan 2021 23:03:33 +0000
In-Reply-To: <20210121230336.1373726-1-satyat@google.com>
Message-Id: <20210121230336.1373726-6-satyat@google.com>
Mime-Version: 1.0
References: <20210121230336.1373726-1-satyat@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v8 5/8] iomap: support direct I/O with fscrypt using blk-crypto
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
index 933f234d5bec..b4240cc3c9f9 100644
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
@@ -272,6 +276,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		}
 
 		bio = bio_alloc(GFP_KERNEL, nr_pages);
+		fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
+					  GFP_KERNEL);
 		bio_set_dev(bio, iomap->bdev);
 		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 		bio->bi_write_hint = dio->iocb->ki_hint;
-- 
2.30.0.280.ga3ce27912f-goog


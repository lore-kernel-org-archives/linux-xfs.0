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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C11C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 23:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4265B2087E
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 23:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbhAUXG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 18:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbhAUXGF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 18:06:05 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0033C061356
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:03:47 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id n123so2129569pfn.10
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=73jUIQHuj0265QRP8P3oVVOaSevfoFr6R3Pxp4Z8uk0=;
        b=RpM4qKLA+63xTwFiz255mspkEHNICv4dlhm7EHfnRU0UFN2Ihke5P4zOrKCiazdR7d
         bXOol4JvqiZOdRVsLQZnm4+9mSTLVh42aPGA5Y4Y5IB+y5B3KInSnmfMLfUe5WfbPlV5
         VxFwpZ2Vqn0u1sbV9D8cI0VjEg3QNpJhpPWDPwb+anXbPJOiIr/ySdiPWgUfOjgjdgkA
         IdEjApFDSNmguJFxEjGJY6eDJTmCCZhgIUZiGfP7Ni5urYiytgymML2bkgTyZ9IBfFd0
         PUCS2z8FThCRQC0kEqTRjWh5yf4h+dirIoOYGRoPF8cFverIpktw4+4nKzBCaAqBcI22
         stXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=73jUIQHuj0265QRP8P3oVVOaSevfoFr6R3Pxp4Z8uk0=;
        b=sCQEfq0gP/gRfelwBK5k8qci8m+t2yHcOlg5mV09nwFDtJuw15frf92EtPvauzTbTE
         H1u+iu4CKFn0w1vbF7K7zr51iCwhCE71pZfSmvwHpa0bykWV9oSS5q8dR1guhORM0Uz9
         qf4rvSxQOyk5gZbKU6GbelFEX5ZitHSkZOU+Gyudu6WsVKuGneqOi6SdeRHdFHwgTi0k
         HtxdAUS06l8XtHp6P2UkunlIrucJvuFFsUACOCof5IQG6nxiGejfT0NR6L0+7cmy5WP1
         WPgX9tNjH1pGfWpyXmqA+WnnOlNd4hCr0k4MXB6AweF4J340XmYCUb+Si8zMsek3STRH
         4EFw==
X-Gm-Message-State: AOAM530Ws/cQsuQMJ8jyO8ERP47Tj6J7q0v7yyaQoMN0RgW5i/GqWH+d
        /3jurlM2BYXkhee4A9eVplw8pVAPuiA=
X-Google-Smtp-Source: ABdhPJwJkQ2FWOp1yUHZk7nzCbAeBUq10CoEvBoJQOw9xo3NYsJVQXsuE+AArFPbdsM6X5/w9fvQdGdj3Ek=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a17:90b:370d:: with SMTP id
 mg13mr1905409pjb.161.1611270227094; Thu, 21 Jan 2021 15:03:47 -0800 (PST)
Date:   Thu, 21 Jan 2021 23:03:32 +0000
In-Reply-To: <20210121230336.1373726-1-satyat@google.com>
Message-Id: <20210121230336.1373726-5-satyat@google.com>
Mime-Version: 1.0
References: <20210121230336.1373726-1-satyat@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v8 4/8] direct-io: add support for fscrypt using blk-crypto
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

Set bio crypt contexts on bios by calling into fscrypt when required,
and explicitly check for DUN continuity when adding pages to the bio.
(While DUN continuity is usually implied by logical block contiguity,
this is not the case when using certain fscrypt IV generation methods
like IV_INO_LBLK_32).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/direct-io.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index d53fa92a1ab6..f6672c4030e3 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/fs.h>
+#include <linux/fscrypt.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -392,6 +393,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	      sector_t first_sector, int nr_vecs)
 {
 	struct bio *bio;
+	struct inode *inode = dio->inode;
 
 	/*
 	 * bio_alloc() is guaranteed to return a bio when allowed to sleep and
@@ -399,6 +401,9 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	 */
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
 
+	fscrypt_set_bio_crypt_ctx(bio, inode,
+				  sdio->cur_page_fs_offset >> inode->i_blkbits,
+				  GFP_KERNEL);
 	bio_set_dev(bio, bdev);
 	bio->bi_iter.bi_sector = first_sector;
 	bio_set_op_attrs(bio, dio->op, dio->op_flags);
@@ -763,9 +768,17 @@ static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
 		 * current logical offset in the file does not equal what would
 		 * be the next logical offset in the bio, submit the bio we
 		 * have.
+		 *
+		 * When fscrypt inline encryption is used, data unit number
+		 * (DUN) contiguity is also required.  Normally that's implied
+		 * by logical contiguity.  However, certain IV generation
+		 * methods (e.g. IV_INO_LBLK_32) don't guarantee it.  So, we
+		 * must explicitly check fscrypt_mergeable_bio() too.
 		 */
 		if (sdio->final_block_in_bio != sdio->cur_page_block ||
-		    cur_offset != bio_next_offset)
+		    cur_offset != bio_next_offset ||
+		    !fscrypt_mergeable_bio(sdio->bio, dio->inode,
+					   cur_offset >> dio->inode->i_blkbits))
 			dio_bio_submit(dio, sdio);
 	}
 
-- 
2.30.0.280.ga3ce27912f-goog


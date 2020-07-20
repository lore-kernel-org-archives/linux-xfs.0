Return-Path: <SRS0=nIBV=A7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04122C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 23:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5027207FC
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 23:38:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GaSqESuQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgGTXhu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 19:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbgGTXhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 19:37:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B092C0619D4
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2020 16:37:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p22so23592848ybg.21
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2020 16:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t24CFwj7eZURk4UC7tWBzhFCIdKtl5EAgLElefYpFNE=;
        b=GaSqESuQmG/FX3ZRcGOFu7fgGXrhxJFfKAhlwNTUj+EUo/QWtj1/gnsPkrnngQvj5V
         OCaCL4Arakh0xG2ANKdDLEK2Kr0jXfkjA314DNINIOX7PyCSqNdOENOjVR3HN4kRjoTe
         Ckb8M7zLSVBcNHHxkf0XEdBL3nyZUKDzbqsLy0nsi6qh9y4LiUD8gKQa0XiXwgNz/Cyr
         fM27fuLxzicL36J0NF1SZe8k2UzcoOG29PR0pMRcty8QEHHb0WlG2udOwmaG1Jnx/tIS
         xZsKBL0sO++BgwCN9/MpdLVM1BnHyGGslEvZ9vYx2BvrQsD1+skFNa+WEdXaeXOVsjEy
         Qucg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t24CFwj7eZURk4UC7tWBzhFCIdKtl5EAgLElefYpFNE=;
        b=oWSstAqFCnLQiePeCAGPUtdu8kdjvDBwQYVHDHaHMFH+9AdrWtp7sVSs7PI2QXtJ1g
         W2umkhD+v6RWr1kuKoFd1+37Wm85bgbe4jLuHkAevp01CWnfM9rCDjEOMukdKqTmwTdP
         x891VlIjQOqtSSe/mJEAUF1v0tpCQOH6VWGGyk+xxtNckcU914xY4NLivN9b4Xul6Olr
         BtmzqjgSOTkQRyLe1hvYHzlMMRsaMrJLN/LnYkjTSFLnH/vosdIbXu9Ir5aNHf7xrXz5
         DfQXAYQrbSeQf4V9nXmOc/14A1CeDJo8I1uILPrDY8S0R+DJzjrY8kUbyugSPvFShe0L
         U8lw==
X-Gm-Message-State: AOAM532tPZb2aVPXDLkzVh44i5eH4vMHlZsg5qs6zCYqG4opRo3bpQnx
        kGJlEn+0LbIE+yQeOAqRse9OUufr7JE=
X-Google-Smtp-Source: ABdhPJwDsMMJwPLHK9Bp+Cwu9CfcdZpjyQWJiHRkZx1avD2YLM3cw3lkr8Pd/tl4V7GYFevYfYj6wMk5AGY=
X-Received: by 2002:a25:a441:: with SMTP id f59mr37237298ybi.412.1595288267387;
 Mon, 20 Jul 2020 16:37:47 -0700 (PDT)
Date:   Mon, 20 Jul 2020 23:37:35 +0000
In-Reply-To: <20200720233739.824943-1-satyat@google.com>
Message-Id: <20200720233739.824943-4-satyat@google.com>
Mime-Version: 1.0
References: <20200720233739.824943-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v4 3/7] iomap: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up iomap direct I/O with the fscrypt additions for direct I/O.
This allows ext4 to support direct I/O on encrypted files when inline
encryption is enabled.

This change consists of two parts:

- Set a bio_crypt_ctx on bios for encrypted files, so that the file
  contents get encrypted (or decrypted).

- Ensure that encryption data unit numbers (DUNs) are contiguous within
  each bio.  Use the new function fscrypt_limit_io_pages() for this,
  since the iomap code works directly with logical ranges and thus
  doesn't have a chance to call fscrypt_mergeable_bio() on each page.

Note that fscrypt_limit_io_pages() is normally a no-op, as normally the
DUNs simply increment along with the logical blocks.  But it's needed to
handle an edge case in one of the fscrypt IV generation methods.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/iomap/direct-io.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ec7b78e6feca..12064daa3e3d 100644
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
@@ -183,11 +184,16 @@ static void
 iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 		unsigned len)
 {
+	struct inode *inode = file_inode(dio->iocb->ki_filp);
 	struct page *page = ZERO_PAGE(0);
 	int flags = REQ_SYNC | REQ_IDLE;
 	struct bio *bio;
 
 	bio = bio_alloc(GFP_KERNEL, 1);
+
+	/* encrypted direct I/O is guaranteed to be fs-block aligned */
+	WARN_ON_ONCE(fscrypt_needs_contents_encryption(inode));
+
 	bio_set_dev(bio, iomap->bdev);
 	bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 	bio->bi_private = dio;
@@ -253,6 +259,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		ret = nr_pages;
 		goto out;
 	}
+	nr_pages = fscrypt_limit_io_pages(inode, pos, nr_pages);
 
 	if (need_zeroout) {
 		/* zero out from the start of the block to the write offset */
@@ -270,6 +277,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		}
 
 		bio = bio_alloc(GFP_KERNEL, nr_pages);
+		fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
+					  GFP_KERNEL);
 		bio_set_dev(bio, iomap->bdev);
 		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 		bio->bi_write_hint = dio->iocb->ki_hint;
@@ -306,9 +315,10 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		dio->size += n;
 		copied += n;
 
-		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
 		iomap_dio_submit_bio(dio, iomap, bio, pos);
 		pos += n;
+		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
+		nr_pages = fscrypt_limit_io_pages(inode, pos, nr_pages);
 	} while (nr_pages);
 
 	/*
-- 
2.28.0.rc0.105.gf9edc3c819-goog


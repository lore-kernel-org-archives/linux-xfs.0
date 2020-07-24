Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 729C1C4345D
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 12:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 516442065E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 12:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KoB83sJ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgGXMMe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 08:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgGXML4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 08:11:56 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F12C0619E5
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 05:11:54 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p14so5321468plq.19
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 05:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cZRHJd9vm6wSJv/XnptuJQLr+rxaeXJfolkFtRJQLFQ=;
        b=KoB83sJ7CUVdLVzAAXXB1d5HIww3b9w4WXANf6RJDhlArPSiHhTK/PK8WuhB2tEWdE
         kCcFKQn/yySmnkf4jT6de1v2OPxpX9sjJn+U5/tromL2TKBfU60c+bjV00XwXIrTLEu4
         8vI0PugTGuvm/QxFdiB0sqTcNW/MonZSsudP+hxmFGx4UuhVFhTp54Uxrhu5H9iG4l9R
         KkcujV6MJnRby0uWob+6hiQIuEJret9I5UCLvXr8+0CAJYPwHv6lDGhKsfT9uWS8Cli0
         18olVrcMqQGc8/lazYnAKA5yuqsfJKFeFrR+BYovE5b8eq9DSEwSvqm/zrJXl71JukyE
         b5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cZRHJd9vm6wSJv/XnptuJQLr+rxaeXJfolkFtRJQLFQ=;
        b=mP15fEJt5U9+IqGs3nvecNT+Eu+q6HgoKiAUAmV/3sr4H+jesaZSi5zfooLA/0lbQo
         DPEqxucbkv9L5ElM+OX9yjAppeJcf0Tin0VufLZ3VmWPH1tdNRUct0QNha8zr9mh4CnM
         ljqMZrDgi1ARWZThJwEBuiSOborFh+cTOh330M+VaePiqC/dXQHXUUJuz2w5E4csgjmk
         1tB97H1xzoQvUghnVWj7gT2lJN7AzLZXGshlemJRNHnA+ru8adMAfAKrhhcn18bwLO1x
         LjcGqXZ2gCWqoF5qqXv8OBpVCqjRWrD16D7J5mhZBrIRG/TPEGbQxd8tJjm2Plx1+T1m
         K1Mg==
X-Gm-Message-State: AOAM530v4TiTZVHdud9+ds98l46mZjTofW9t9AbMXToFJWTpJFYWBayz
        ywsXVJqlQADlwYeT+eVyNWNHp07KJ2U=
X-Google-Smtp-Source: ABdhPJzqW0b3TqyL5cn0deoeV5HaYLyzoiAc0kf0C/GsHjnYYMOhspEGJ3mRFCHxl3UhNASvV8FA7vQBd2k=
X-Received: by 2002:a17:90b:f05:: with SMTP id br5mr5218030pjb.42.1595592714411;
 Fri, 24 Jul 2020 05:11:54 -0700 (PDT)
Date:   Fri, 24 Jul 2020 12:11:39 +0000
In-Reply-To: <20200724121143.1589121-1-satyat@google.com>
Message-Id: <20200724121143.1589121-4-satyat@google.com>
Mime-Version: 1.0
References: <20200724121143.1589121-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v5 3/7] iomap: support direct I/O with fscrypt using blk-crypto
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
index ec7b78e6feca..a8785bffdc7c 100644
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
@@ -183,11 +184,14 @@ static void
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
@@ -270,6 +274,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		}
 
 		bio = bio_alloc(GFP_KERNEL, nr_pages);
+		fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
+					  GFP_KERNEL);
 		bio_set_dev(bio, iomap->bdev);
 		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 		bio->bi_write_hint = dio->iocb->ki_hint;
-- 
2.28.0.rc0.142.g3c755180ce-goog


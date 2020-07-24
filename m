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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD9FC43463
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 12:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF7862074A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 12:12:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="na82ZxXR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGXMMn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 08:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgGXMLx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 08:11:53 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C834C0619D3
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 05:11:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id w4so6112638pfq.11
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 05:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VSwfu85pneIFmS24X/ynlOi1yjIof1V3mRCitL8rAYY=;
        b=na82ZxXRU6iClGLM8WY9JUbwRK5YUa3sTtXEJAwHrO98aL18NfbYyftkYmWDIOxxyy
         T7SrhCfspxsNEqAec7X7g0yjtog3uy198m3utKXpdn7FbCKK0qBZG8GBlG8OCgy3XFE/
         5XCvWfE+NTp0lUxEsObWjCs2V/DckxSrQrrU8oa1zrQKItVDbp62lcQYDpavVyrZMPM7
         ByWbVURq2ZA4ucRoJ/VmZy6LBkfXKaamgP2vD8nyqzCK9MrVVcSIbVcZArUge1ZYouNV
         4f7KLUEJmaR9jMsaPGAXBzn6Du2kuxt5zMM82QtJX1ciG3D+Sl3PlDIEWmgq3XUx74Xj
         KrUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VSwfu85pneIFmS24X/ynlOi1yjIof1V3mRCitL8rAYY=;
        b=e4W80Zevgg62VUqr3O8NI8wQzLfgMwgzLQ8sN2woqQVqQYCXc2+BEbQnuUrf++FMtI
         XX5NRKih2b+Nx4cStdydIaiprtF/LIq+WMA0hd6yzt/YVbveL83mM9TgqJMWA6zyWZmT
         ARxpr/ZvAkmx8vQVlX7K4t8szmTHm+qw6nHLq6pleUYlhZbBJ8MN/wKz7iaF5liFodDy
         9Q45wTCrpKVnTo4DwZIhYeQmxIDBCxbet0+1cmURA2k6JgvuH3lRdLIWLxJin8WwPCnG
         QBildV96KaARS67Xc9PgdGg5KkKmTQJVbalCZUOWaKeUVOvmGlb458Lz+K86gyssKgzH
         F08g==
X-Gm-Message-State: AOAM533I0sFehDL7s2BBtFcAVKNKjyk4kQ2zAcVqU1D+8KhFQb1BZ113
        1gkYnhDIYuD/d0Dnjm2KyF+z/2lbkkk=
X-Google-Smtp-Source: ABdhPJyXvc5X+E5fgB1RgalJIQFlddeppaa/6YZOev6UFYpfCi49Ptm7h7gpD9+XTeJEMJcFHxhtOWgZXzk=
X-Received: by 2002:a63:e114:: with SMTP id z20mr7242047pgh.300.1595592712586;
 Fri, 24 Jul 2020 05:11:52 -0700 (PDT)
Date:   Fri, 24 Jul 2020 12:11:38 +0000
In-Reply-To: <20200724121143.1589121-1-satyat@google.com>
Message-Id: <20200724121143.1589121-3-satyat@google.com>
Mime-Version: 1.0
References: <20200724121143.1589121-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v5 2/7] direct-io: add support for fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
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
index 6d5370eac2a8..f27f7e3780ee 100644
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
@@ -411,6 +412,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	      sector_t first_sector, int nr_vecs)
 {
 	struct bio *bio;
+	struct inode *inode = dio->inode;
 
 	/*
 	 * bio_alloc() is guaranteed to return a bio when allowed to sleep and
@@ -418,6 +420,9 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	 */
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
 
+	fscrypt_set_bio_crypt_ctx(bio, inode,
+				  sdio->cur_page_fs_offset >> inode->i_blkbits,
+				  GFP_KERNEL);
 	bio_set_dev(bio, bdev);
 	bio->bi_iter.bi_sector = first_sector;
 	bio_set_op_attrs(bio, dio->op, dio->op_flags);
@@ -782,9 +787,17 @@ static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
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
2.28.0.rc0.142.g3c755180ce-goog


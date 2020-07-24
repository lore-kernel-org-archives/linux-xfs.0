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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA033C433F1
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 18:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD3EF2070E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 18:45:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fiwV9W1r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgGXSpL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 14:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGXSpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 14:45:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB0EC0619E4
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 11:45:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k75so11431180ybf.19
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 11:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=e3QQnyJEAo5uWrYUDsDCPQeAxWHqtOZ6h6W8L9vv5Ok=;
        b=fiwV9W1rn8xIx3eZin4HllP1i3QSz+XUBPdewpcOoRimkQuoOrFrKuu38oLKdxH/DL
         vjPZdSY437ObQqT07i4flLI+1fCaVT7Ymuca2SmUy4H+CrkIrxGI6jsA4EgPZZauHHUt
         w/Tg2NAvoP98hkyUVK+5yBTBUA/3l8/6rYlDlWHfAmPIHHvKIXtSVukfxFwkMujd4Zv2
         aD16Gnr0+DPz3kaVcz9meN+oEqmVMDwbCt7HOOFTt1XvP0x1pFx5ASr/LQ43SiIqmiEF
         dJNIHgPR6/zhiU7zn6P9EKElVptiQsjVOLZRH9RuAggnZ6iX8hjjZSEwMbuHQegF+4MK
         IBnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=e3QQnyJEAo5uWrYUDsDCPQeAxWHqtOZ6h6W8L9vv5Ok=;
        b=O3HTGV1EeF5F4C7UA3BU7E/N+9gfjUx3QrLA6oS16XrbAN0CEZlnW7odMX7P+rY5M1
         GK4s3Xj16E1y031XQF57VePhb0UedEeE7BxFgr5LyvqHy8I+rD/6Y7DcbbhJrC3c8uNn
         +cp52uohFMJ5TRDgzRu+0D2jhBjTQhnYOa33LNbxtmUcmHoGCuwpmPtTs/6GJA4K3JQD
         pZ6k6CpgX2pYuR9DfVcDpIJVSmAOujNqDjFyGh1nVkvISFNGuOnGMrlKxipWTtDWJIEb
         +vSgCJLxcLwsq3U9D09zWVXxKNWsg+Vzsp2SiweGeNEEItdarjxUQ/ZAL7iDPYiza9YH
         GHxQ==
X-Gm-Message-State: AOAM532Hhm099RP43/BTmql4AxEoG5FDr9YS8gXQ8evhZyCKnYv3ippL
        b2WUUSUKYgbNPY1W5oPEkR+Frtt5+eU=
X-Google-Smtp-Source: ABdhPJwl1gKyF3pfJ5ie868kPXKBua9doUzwDRqGLr8lKTqxr1HHAMw3xL4wn/F/CGySesYoXqUp4cD0u0I=
X-Received: by 2002:a25:2417:: with SMTP id k23mr15167611ybk.300.1595616307826;
 Fri, 24 Jul 2020 11:45:07 -0700 (PDT)
Date:   Fri, 24 Jul 2020 18:44:55 +0000
In-Reply-To: <20200724184501.1651378-1-satyat@google.com>
Message-Id: <20200724184501.1651378-2-satyat@google.com>
Mime-Version: 1.0
References: <20200724184501.1651378-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v6 1/7] fscrypt: Add functions for direct I/O support
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

Introduce fscrypt_dio_supported() to check whether a direct I/O request
is unsupported due to encryption constraints.

Also introduce fscrypt_limit_io_blocks() to limit how many blocks can be
added to a bio being prepared for direct I/O. This is needed for
filesystems that use the iomap direct I/O implementation to avoid DUN
wraparound in the middle of a bio (which is possible with the
IV_INO_LBLK_32 IV generation method). Elsewhere fscrypt_mergeable_bio()
is used for this, but iomap operates on logical ranges directly, so
filesystems using iomap won't have a chance to call fscrypt_mergeable_bio()
on every block added to a bio. So we need this function which limits a
logical range in one go.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/crypto/crypto.c       |  8 +++++
 fs/crypto/inline_crypt.c | 74 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h  | 18 ++++++++++
 3 files changed, 100 insertions(+)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 9212325763b0..f72f22a718b2 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -69,6 +69,14 @@ void fscrypt_free_bounce_page(struct page *bounce_page)
 }
 EXPORT_SYMBOL(fscrypt_free_bounce_page);
 
+/*
+ * Generate the IV for the given logical block number within the given file.
+ * For filenames encryption, lblk_num == 0.
+ *
+ * Keep this in sync with fscrypt_limit_io_blocks().  fscrypt_limit_io_blocks()
+ * needs to know about any IV generation methods where the low bits of IV don't
+ * simply contain the lblk_num (e.g., IV_INO_LBLK_32).
+ */
 void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 			 const struct fscrypt_info *ci)
 {
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index d7aecadf33c1..4cdf807b89b9 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -16,6 +16,7 @@
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/sched/mm.h>
+#include <linux/uio.h>
 
 #include "fscrypt_private.h"
 
@@ -362,3 +363,76 @@ bool fscrypt_mergeable_bio_bh(struct bio *bio,
 	return fscrypt_mergeable_bio(bio, inode, next_lblk);
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio_bh);
+
+/**
+ * fscrypt_dio_supported() - check whether a direct I/O request is unsupported
+ *			     due to encryption constraints
+ * @iocb: the file and position the I/O is targeting
+ * @iter: the I/O data segment(s)
+ *
+ * Return: true if direct I/O is supported
+ */
+bool fscrypt_dio_supported(struct kiocb *iocb, struct iov_iter *iter)
+{
+	const struct inode *inode = file_inode(iocb->ki_filp);
+	const unsigned int blocksize = i_blocksize(inode);
+
+	/* If the file is unencrypted, no veto from us. */
+	if (!fscrypt_needs_contents_encryption(inode))
+		return true;
+
+	/* We only support direct I/O with inline crypto, not fs-layer crypto */
+	if (!fscrypt_inode_uses_inline_crypto(inode))
+		return false;
+
+	/*
+	 * Since the granularity of encryption is filesystem blocks, the I/O
+	 * must be block aligned -- not just disk sector aligned.
+	 */
+	if (!IS_ALIGNED(iocb->ki_pos | iov_iter_alignment(iter), blocksize))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(fscrypt_dio_supported);
+
+/**
+ * fscrypt_limit_io_blocks() - limit I/O blocks to avoid discontiguous DUNs
+ * @inode: the file on which I/O is being done
+ * @lblk: the block at which the I/O is being started from
+ * @nr_blocks: the number of blocks we want to submit starting at @pos
+ *
+ * Determine the limit to the number of blocks that can be submitted in the bio
+ * targeting @pos without causing a data unit number (DUN) discontinuity.
+ *
+ * This is normally just @nr_blocks, as normally the DUNs just increment along
+ * with the logical blocks.  (Or the file is not encrypted.)
+ *
+ * In rare cases, fscrypt can be using an IV generation method that allows the
+ * DUN to wrap around within logically continuous blocks, and that wraparound
+ * will occur.  If this happens, a value less than @nr_blocks will be returned
+ * so that the wraparound doesn't occur in the middle of the bio.
+ *
+ * Return: the actual number of blocks that can be submitted
+ */
+u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
+{
+	const struct fscrypt_info *ci = inode->i_crypt_info;
+	u32 dun;
+
+	if (!fscrypt_inode_uses_inline_crypto(inode))
+		return nr_blocks;
+
+	if (nr_blocks <= 1)
+		return nr_blocks;
+
+	if (!(fscrypt_policy_flags(&ci->ci_policy) &
+	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
+		return nr_blocks;
+
+	/* With IV_INO_LBLK_32, the DUN can wrap around from U32_MAX to 0. */
+
+	dun = ci->ci_hashed_ino + lblk;
+
+	return min_t(u64, nr_blocks, (u64)U32_MAX + 1 - dun);
+}
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index bb257411365f..5de122ec0464 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -559,6 +559,10 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 bool fscrypt_mergeable_bio_bh(struct bio *bio,
 			      const struct buffer_head *next_bh);
 
+bool fscrypt_dio_supported(struct kiocb *iocb, struct iov_iter *iter);
+
+u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks);
+
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 static inline bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
@@ -587,6 +591,20 @@ static inline bool fscrypt_mergeable_bio_bh(struct bio *bio,
 {
 	return true;
 }
+
+static inline bool fscrypt_dio_supported(struct kiocb *iocb,
+					 struct iov_iter *iter)
+{
+	const struct inode *inode = file_inode(iocb->ki_filp);
+
+	return !fscrypt_needs_contents_encryption(inode);
+}
+
+static inline u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk,
+					  u64 nr_blocks)
+{
+	return nr_blocks;
+}
 #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 /**
-- 
2.28.0.rc0.142.g3c755180ce-goog


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58979C43466
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 18:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C89B206F0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 18:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wIgyWZnm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGXSp0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 14:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgGXSpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 14:45:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C3DC05BD0F
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 11:45:15 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u12so11677935ybj.0
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 11:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oZN8SnIpsU7aOjS5+8MoI/0a82Ym0e3d0O/7K4J6ac4=;
        b=wIgyWZnmLwySzWDZSlBrKLMi9o7JvXabuPmirleI8ql4xoXo7sERCN6n1iqc7ulrPe
         +0bTFhJB6lh8er/OHOe2MXTTa4FGq9Z3I6vsRXEScezsqzlDDr2vnow9hUL76dFd4t73
         LSY7AXOCLmvkf5lykey7j+KVR2MMALlndNl2R6YrkZFHfXwGZkrfnHwyHn1h/uaaOf9l
         uJnX4cyIXqW+w1n+7Eb7Pxn4EQVXztt3YcG5WdnGQg5++z/bnqsVqqqlx/TYg5agIJhj
         WavGB7UKwBzo7jCeULL7RegHdYo0aLeV9COGmhAu19Pyol/rjfmG50iF+cCQ2zkbz44I
         mBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oZN8SnIpsU7aOjS5+8MoI/0a82Ym0e3d0O/7K4J6ac4=;
        b=iQ6Yy6juvdqd8ps9djB9vrE+5krCRKCxtCeZHT7FWf8lMw9sXZqXkCQ+XbAF0w7OSW
         bU3bkJNqGDcYpX6cHWwT+W/w+gkJ1L+TasDcCPEk/qYX0tPjXIMxlDwyOEhY/bMOMeuD
         gQBi8hq8S4TGWvx5v7k34jT+tW2YUvWLiyWQCFqnutQczf/qxl6tvSi1WuAnFf37UPCB
         oulcBrHNyHxDw0DOQ35pDVtBsWiAzmtZMF12Wno01meFtAtJws92MPJ1FVXYmXVNqY0b
         dSdwMTc+XK3R0zJfyK8d77XMIQOknzudBW74GeEZjcXbd8x/yX3vr1PDqeAlL/vZVERy
         Afog==
X-Gm-Message-State: AOAM533G5yyywYYhZEfzgHy7NJOo/rALGuaE9PDgc2Ox0giYnAK3D1J2
        ERG+/M7RL6XO9TvzGax3+KcCjgyEfa4=
X-Google-Smtp-Source: ABdhPJzmZ43+VRZcOd+tePRiD99mq4GfMup1JpMkWtUBzFz9rcQiFfN2MHUCR4TgOqatdZ2Tf8jsOOl0B2c=
X-Received: by 2002:a25:c483:: with SMTP id u125mr16946975ybf.194.1595616314284;
 Fri, 24 Jul 2020 11:45:14 -0700 (PDT)
Date:   Fri, 24 Jul 2020 18:44:59 +0000
In-Reply-To: <20200724184501.1651378-1-satyat@google.com>
Message-Id: <20200724184501.1651378-6-satyat@google.com>
Mime-Version: 1.0
References: <20200724184501.1651378-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v6 5/7] f2fs: support direct I/O with fscrypt using blk-crypto
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

Wire up f2fs with fscrypt direct I/O support. direct I/O with fscrypt is
only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
have been enabled, the 'inlinecrypt' mount option must have been specified,
and either hardware inline encryption support must be present or
CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
direct I/O on encrypted files is only supported when I/O is aligned
to the filesystem block size (which is *not* necessarily the same as the
block device's block size).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b35a50f4953c..978130b5a195 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4082,7 +4082,11 @@ static inline bool f2fs_force_buffered_io(struct inode *inode,
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int rw = iov_iter_rw(iter);
 
-	if (f2fs_post_read_required(inode))
+	if (!fscrypt_dio_supported(iocb, iter))
+		return true;
+	if (fsverity_active(inode))
+		return true;
+	if (f2fs_compressed_file(inode))
 		return true;
 	if (f2fs_is_multi_device(sbi))
 		return true;
-- 
2.28.0.rc0.142.g3c755180ce-goog


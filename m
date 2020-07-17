Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D7CC43462
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76A9D20578
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:35:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oxCwlxw8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgGQBfp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgGQBff (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:35:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3332EC08C5C0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:35:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u64so9389248ybf.13
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=oxCwlxw8hiOmpc9dDE5VHP0nyw8uhX2w43IaKudLEwrXxdgnP120llEreKyOOyh1yb
         1WL8Dz+vf62oDSYhDCJMemrgkfz8WYWqfwvE/k3RuBACwKsg9UN/b/70jtV8Bh5s5ZUl
         WrqxtcHQKHwvgHTdS5R/09Di9WRfeq7aFwIAp6PB4QWEH0TDZQQYq6ccRf0UpNNMbFFl
         k4ZGdek4wV3r5+sTAIYfuP/jWrOw9Pbl+P1VkdzDRNqXM7DL0BJSJwO91JPyC0vA5ApC
         ngAIgB1BKgaFCSFN5dAUqxUK11W1Cw9dSBzo0il3J6r3PmLNgtmOY/hVfrka9zORhpXj
         ZLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=RhSh2eYGdVPpD8YeN2ODOrdVqVUy9wf7xNvXmVOJpUXapyj9eaeioW5OHIhifxdN+B
         GMimOpxCTFG4C30XMGaVt25YwVGFNk4yz7u6fDZZtjzThGvPtqrNGEAaoODlm4lJCOAC
         IUSKs7/XcqXhDby7PYw5XDnKaWvq7ySHh/EfD98sQfI2iSpmPcZle/8MRcgWVTRerJUI
         6nk8DbhDMyqzwt7RmIQga1jr4eAqF/JVJer/uNIhWrXDOkZJbIR6x9zP3Du6SW3Jj1UB
         2UxGRRh4bw6rWbdfSmpAkms1kZjkbJTu41ylY1XgWF7pscJpMGwKFP8Q7SmfT+yNb+vp
         2R5Q==
X-Gm-Message-State: AOAM533IXFwGLML4sulwDFg4sYtEtm9Cyoij883xEQ/tnwlqRbbch+sO
        7SdjL8v9WKy+Abi9i140gArIHttC5Zo=
X-Google-Smtp-Source: ABdhPJwyL6R46WRxWnDIfZEHMgiK0bcZUjuux5QdiBW2epiAYbnHUX5h5wXX6tXlXwwrx+N2jIvS0DNsy54=
X-Received: by 2002:a25:e790:: with SMTP id e138mr11127098ybh.114.1594949734407;
 Thu, 16 Jul 2020 18:35:34 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:35:16 +0000
In-Reply-To: <20200717013518.59219-1-satyat@google.com>
Message-Id: <20200717013518.59219-6-satyat@google.com>
Mime-Version: 1.0
References: <20200717013518.59219-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v2 5/7] f2fs: support direct I/O with fscrypt using blk-crypto
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
2.28.0.rc0.105.gf9edc3c819-goog


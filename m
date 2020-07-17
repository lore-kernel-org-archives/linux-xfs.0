Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-25.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4ACAC43457
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACF2520838
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IuienX4m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgGQBp7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgGQBp4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:45:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236A9C08C5E2
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:45:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u189so9483046ybg.17
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M2BARCIgcttWxNELPw4zNOFpxD9+a8coXLhy2/p7EJA=;
        b=IuienX4mga40GmSRRKzTF+joRBlWaewlilX9kK4DbxKVxKtc0HgNzNmwzCZ1zOSkZS
         /sl4RwiktZzyDIGk22y0rBU4/6to0p2Mb+0sHuOgVc59Of+mmEYUSL/X8GIx7S9N2g7k
         AAsNYq+yOp1P9y/M3dpmzdp+iTmYeg60KNpHeU9Q4DinrRedG6NGSsYmC3G3+ZszcxWF
         iiLyYi1e8fZMhBIQmpfrA1eMen9sCtNU9W9nDP6q6QwGvJa13W8tY3dxZyWvEvjE0cyb
         7vhn6iWIVWyfKhLFtLO/KNWOxq8m9tNiM/Xk00LgFuq+iUFipff48yn3YZCVEhX9KuBH
         cXvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M2BARCIgcttWxNELPw4zNOFpxD9+a8coXLhy2/p7EJA=;
        b=XfrZBpZjUcLXS0zAaxWPB2W2Hgat00vH5TrlSqvhw/EcoRwE41zFhbWGHnawP6Vqnu
         SwDKV78BxkqXtLWi2EynOGigvRXHGx8NGJ9Xu6XQQ7NRxRPZZffTOOZh90hp9lftFZc0
         k/a6tO2i3Frv4aYhVT3PyO2PpqwcvM7CLEXERfCvPDKRYYmHphXIq8Cw4U2P9jWMm228
         0yFiD+sLMtbTx6rNSa6GI312iTcgjnrXJsQ8fgGPc1tnwiCysVQkYucFHV0Ys6xxx/RI
         nK32TKl7oyPUQ5JgQfHTz17+tdGn7pYa/SV8XKEzzZ+hqaqybASD54WsSoJ6VViFNJTJ
         +Zpw==
X-Gm-Message-State: AOAM533GpEDepxeQz7A6sReK8HYzhayxQXvwby/gCt3mZj4ukEiGKzwb
        nVAHG3Up5KjFG6VOXWtPsG560fHxxgU=
X-Google-Smtp-Source: ABdhPJxSclWXD3pWyzJ/EO11UCYSucRKXFbMR9YelueZjjlG1f9W2/r7ez0qwF6s0pIusA0evwMmb2iIxEk=
X-Received: by 2002:a25:3789:: with SMTP id e131mr10722971yba.417.1594950354393;
 Thu, 16 Jul 2020 18:45:54 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:45:39 +0000
In-Reply-To: <20200717014540.71515-1-satyat@google.com>
Message-Id: <20200717014540.71515-7-satyat@google.com>
Mime-Version: 1.0
References: <20200717014540.71515-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v3 6/7] fscrypt: document inline encryption support
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Update the fscrypt documentation file for inline encryption support.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 Documentation/filesystems/fscrypt.rst | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index f5d8b0303ddf..f3d87a1a0a7f 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1204,6 +1204,18 @@ buffer.  Some filesystems, such as UBIFS, already use temporary
 buffers regardless of encryption.  Other filesystems, such as ext4 and
 F2FS, have to allocate bounce pages specially for encryption.
 
+Fscrypt is also able to use inline encryption hardware instead of the
+kernel crypto API for en/decryption of file contents.  When possible, and
+if directed to do so (by specifying the 'inlinecrypt' mount option for
+an ext4/F2FS filesystem), it adds encryption contexts to bios and
+uses blk-crypto to perform the en/decryption instead of making use
+of the above read/write path changes.  Of course, even if directed to make
+use of inline encryption, fscrypt will only be able to do so if either
+hardware inline encryption support is available for the selected encryption
+algorithm or CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK is selected.  If neither
+is the case, fscrypt will fall back to using the above mentioned read/write
+path changes for en/decryption.
+
 Filename hashing and encoding
 -----------------------------
 
@@ -1250,7 +1262,9 @@ Tests
 
 To test fscrypt, use xfstests, which is Linux's de facto standard
 filesystem test suite.  First, run all the tests in the "encrypt"
-group on the relevant filesystem(s).  For example, to test ext4 and
+group on the relevant filesystem(s).  One can also run the tests
+with the 'inlinecrypt' mount option to test the implementation for
+inline encryption support.  For example, to test ext4 and
 f2fs encryption using `kvm-xfstests
 <https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md>`_::
 
-- 
2.28.0.rc0.105.gf9edc3c819-goog


Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-25.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75946C433EB
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 12:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 544632074A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 12:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kiMq1ZWt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgGXMMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 08:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgGXMMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 08:12:01 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD8EC05BD0F
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 05:12:00 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id z16so6120811pfq.7
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 05:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U1mjdiTf1REytCgM0qXLRwHi12+4iLhjMHz6o0dObf4=;
        b=kiMq1ZWtQnJd4reX4VWrcLsQOtCggJ6Lx8/zqeNQSzQ7hT54ehmC/vMQjFsmcj5Bzl
         vfX6LCyxcL40ZX02qaEmRhcqWquQZcpcm14ND8JtsyogdqAL+HsczyPTJ/86YKvMEITC
         a+14IVbSsKlMoJEklV7JAH9lru+zgeEFcHQouasVGEZpC36HAZ0A8fXzWaPHdHwwh531
         3sgi8AC8myUTqxXOiGCGooXwGHlrL4xx7SKojIoIGoqgllfhRf7ZT072nwliYBJnNjsH
         kgVdv5uGrSMRIfdEbgA6jSqsd00RikhGl/OBLE9V+8itOqdO7bSHm0kJnSbdv6a48pA2
         Wz1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U1mjdiTf1REytCgM0qXLRwHi12+4iLhjMHz6o0dObf4=;
        b=t27ciE6To9lcqFiP+J+oZwigM+7q36EgdEzNJSQsegSPBLj6/MSfKkHtdbwP0BRFeg
         QNQoeC2d9PFVcNYz02wn43SpB7awNBcvCRp5XsfQHLhrYCbH7iKshMDUDvaCdMqOqq57
         Yj4jCh0OFfV2H1enZe603Kd+j+U80OE3T+603EzQv6CgUutIyuVGzpYfAmlBn35nyqld
         j2eyAMM1niVV9TZFSWKrdei4Z/us5TjyiNmg5FKzw6LrcTTqWHuAS0SHKLQ87uvkcR0i
         DfzHFVuDYoN+aolFM+2hvik9cTuwU0/NLH9otlAcC4VmYDIuWDmkP9cQt75vP3wJu0JC
         2dQA==
X-Gm-Message-State: AOAM530DsK5ISZVtAW06yNwxrPBBjrYE+kE2u6Jgsd4NEIIs/t4ZoVut
        GN5n3zZQOSZc8uNCWxPrM9bGNksarIQ=
X-Google-Smtp-Source: ABdhPJxJfhv4J/Z8dONpLYUW4MpGcI1VRHtlxbqb93pVNIkZdbpJQqFPedb6S47261MqborqJwQs/SHfE9o=
X-Received: by 2002:a17:902:c389:: with SMTP id g9mr7645772plg.317.1595592719727;
 Fri, 24 Jul 2020 05:11:59 -0700 (PDT)
Date:   Fri, 24 Jul 2020 12:11:42 +0000
In-Reply-To: <20200724121143.1589121-1-satyat@google.com>
Message-Id: <20200724121143.1589121-7-satyat@google.com>
Mime-Version: 1.0
References: <20200724121143.1589121-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v5 6/7] fscrypt: document inline encryption support
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Update the fscrypt documentation file for inline encryption support.

Signed-off-by: Satya Tangirala <satyat@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 Documentation/filesystems/fscrypt.rst | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index f5d8b0303ddf..ec81598477fc 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1204,6 +1204,18 @@ buffer.  Some filesystems, such as UBIFS, already use temporary
 buffers regardless of encryption.  Other filesystems, such as ext4 and
 F2FS, have to allocate bounce pages specially for encryption.
 
+Fscrypt is also able to use inline encryption hardware instead of the
+kernel crypto API for en/decryption of file contents.  When possible,
+and if directed to do so (by specifying the 'inlinecrypt' mount option
+for an ext4/F2FS filesystem), it adds encryption contexts to bios and
+uses blk-crypto to perform the en/decryption instead of making use of
+the above read/write path changes.  Of course, even if directed to
+make use of inline encryption, fscrypt will only be able to do so if
+either hardware inline encryption support is available for the
+selected encryption algorithm or CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK
+is selected.  If neither is the case, fscrypt will fall back to using
+the above mentioned read/write path changes for en/decryption.
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
2.28.0.rc0.142.g3c755180ce-goog


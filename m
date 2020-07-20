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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6B1C4345D
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 23:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCC32207FC
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jul 2020 23:37:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dpz3hRRX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgGTXh7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 19:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbgGTXhz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 19:37:55 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1F7C0619D2
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2020 16:37:55 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z16so14861495pgh.21
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2020 16:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=H043ZGT0tUkHasuQEIGWrSIMw4QdS1VbmKoEccjtzM0=;
        b=dpz3hRRXJhzFYY0/pCX+Y/eePZpWFCADC/kjj4qZk3jOrPT6G6tdSjuyh9Qw+Wrue9
         9f6dhzx0VvfFcrv4a6Firxihch6LbPRbw8QtUFYbwd4f1tEtLpf5bbkhowqe2WfQ2faw
         kB23eVk86fVuNkCwvfPS/vFUeGyQ4ajGNPlCM2T5YJCzs0iVMV+giOYth8pP1IoNiIus
         FwA5zN/b6t+kqlz18awv5ni7cMS7s5ikKECiJK6Jzuibq8sR3hYMa51fZAjxbYwbSer4
         WjNWu50cQeiODtlqpxegUVzn2ulDcCCSBkWeQKnwEj276YUVPDg3kVr0Rfiy1ajwok15
         JZ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=H043ZGT0tUkHasuQEIGWrSIMw4QdS1VbmKoEccjtzM0=;
        b=qCthtCGVDWpifBXXGlDiahGTmNe0Qd7geqxO/1Gr5sDuwuwfMp6GqsAssxul8Hue4t
         588tbDI40l8kL3c8d2QAF6O0AEFX8HliqZg+rZHuVCnl1Ldd0OpvS/XfryF+hEAwn7wa
         OCZGMXqNXIozQOOt1GLWES0Qi3jKiqBFf5TwUlzeGYTm9cPEpK33SDOa8n8k4nrWp2be
         dz5rnlOYvxE9fAIb4cWds9JNSdhSIdwjTz9MHrwsSZLZpqySGpUv4hkChqCrJvykKuo8
         ubeTdO02gwMJqMxnUHDLIk/0A3+Mt11lPOGPOZgYjlaY2a6EZWqGxwH88sct0tmViCDZ
         ZL9g==
X-Gm-Message-State: AOAM532sXyajQnyVMcnxQQ1WtxmEJeS6/ekfkle0EXnNkWgxRc6kd1o9
        JfsILaIsR9ioBuPnUE7x6oHBblS7qwk=
X-Google-Smtp-Source: ABdhPJzD4zyxL6NAWP8CBEO3nWgs3IY5xzymZloYi6QDkienrJ3ha/vZk0REiujEDejgnVubHrJvYSOYoFY=
X-Received: by 2002:a17:90a:bd8b:: with SMTP id z11mr82498pjr.0.1595288274362;
 Mon, 20 Jul 2020 16:37:54 -0700 (PDT)
Date:   Mon, 20 Jul 2020 23:37:39 +0000
In-Reply-To: <20200720233739.824943-1-satyat@google.com>
Message-Id: <20200720233739.824943-8-satyat@google.com>
Mime-Version: 1.0
References: <20200720233739.824943-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v4 7/7] fscrypt: update documentation for direct I/O support
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Update fscrypt documentation to reflect the addition of direct I/O support
and document the necessary conditions for direct I/O on encrypted files.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 Documentation/filesystems/fscrypt.rst | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index ec81598477fc..5367c03b17bb 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1049,8 +1049,10 @@ astute users may notice some differences in behavior:
   may be used to overwrite the source files but isn't guaranteed to be
   effective on all filesystems and storage devices.
 
-- Direct I/O is not supported on encrypted files.  Attempts to use
-  direct I/O on such files will fall back to buffered I/O.
+- Direct I/O is supported on encrypted files only under some
+  circumstances (see `Direct I/O support`_ for details). When these
+  circumstances are not met, attempts to use direct I/O on encrypted
+  files will fall back to buffered I/O.
 
 - The fallocate operations FALLOC_FL_COLLAPSE_RANGE and
   FALLOC_FL_INSERT_RANGE are not supported on encrypted files and will
@@ -1123,6 +1125,20 @@ It is not currently possible to backup and restore encrypted files
 without the encryption key.  This would require special APIs which
 have not yet been implemented.
 
+Direct I/O support
+==================
+
+Direct I/O on encrypted files is supported through blk-crypto. In
+particular, this means the kernel must have CONFIG_BLK_INLINE_ENCRYPTION
+enabled, the filesystem must have had the 'inlinecrypt' mount option
+specified, and either hardware inline encryption must be present, or
+CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK must have been enabled. Further,
+any I/O must be aligned to the filesystem block size (*not* necessarily
+the same as the block device's block size) - in particular, any userspace
+buffer into which data is read/written from must also be aligned to the
+filesystem block size. If any of these conditions isn't met, attempts to do
+direct I/O on an encrypted file will fall back to buffered I/O.
+
 Encryption policy enforcement
 =============================
 
-- 
2.28.0.rc0.105.gf9edc3c819-goog


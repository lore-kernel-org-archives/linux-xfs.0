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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4396CC4345B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E1EC20578
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:35:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tlDHCdVZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgGQBfl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgGQBfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:35:38 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772FEC08C5DD
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:35:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u16so6792114pgj.17
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zr1haxdG39xCeCSCxAtAF/uCJ0PriAfrFWPYdcjKJpg=;
        b=tlDHCdVZLG0m6L9levsiz5n7YIyjIML7yueebl4I+pd4oD2GbC2//CVbku08QwfyVK
         Io6VHBtaFJ92KS1ZOJeZ+gL4I3EE9eCj84H9hWFhQZqN8fQQ85l7TS5gW7erlfNnkmzA
         h57MTGXvkvtREa2Qo1rEyo9lXW31xuTk1ugMXZ6T1CiepMhKbsP1mrjdiKiW3/Rvmu6c
         SZPzhAwx7+ulPeallP3vNIjd8m2ACUMFu9PQZzGNoethIWi21ML/Bzl/g8EenyLMa7F8
         oq0OBvD9rkYG9V07cK0ln918JiY2QNGYAxh/nFT9nNV7Px5YVBoGsAhCgLPzOODa5J1Q
         a24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zr1haxdG39xCeCSCxAtAF/uCJ0PriAfrFWPYdcjKJpg=;
        b=I/YvDwEdMIpVTP9vEjB4dG5E9vdjd/KGUAif4Y3LltTx/ufXR77lzpBzRoyLWSKrQt
         c2Kodwdgd0jJoc5zUp1Q2VswyeCDBp1qTVLsos3AHQYhUSLYEhV64oJDnURhqO3ci64f
         CtRLVjKVdAo18Nfyf667H9cnEDVQvXh5C9icNGGwL8BAcfYBmxhl2qcb7IAOYiR4/t4H
         +SoY2j3UXQmeDBFQmwAoK6hAj8jR7CTfy8VbbiMU19GcsT6o/uPfthADxYpxu4QIvqsP
         LxL8lveP9tG2rbtL8Tc0SFRDSFuvjoffT646lebl+N9SBOaxpgrB1eXvTRmZBga7iTa1
         MzMw==
X-Gm-Message-State: AOAM532zjd8c8RSDNa2680iIPoh9QB6b+UlQBB1LGKnSpwSoUlESbZE4
        lkcXhNgVDsZ6auAlO3V14H34SbvO6ZU=
X-Google-Smtp-Source: ABdhPJzDMFCY+G8Oa8F4K0HKeSD+Xc66nsFn69r8yuQKIuJ5CCaPUQ42wZhUaa7Xlm1W8gsHMjhI0okL6Kg=
X-Received: by 2002:a17:902:b706:: with SMTP id d6mr5918685pls.266.1594949737873;
 Thu, 16 Jul 2020 18:35:37 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:35:18 +0000
In-Reply-To: <20200717013518.59219-1-satyat@google.com>
Message-Id: <20200717013518.59219-8-satyat@google.com>
Mime-Version: 1.0
References: <20200717013518.59219-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v2 7/7] fscrypt: update documentation for direct I/O support
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
index f3d87a1a0a7f..95c76a5f0567 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1049,8 +1049,10 @@ astute users may notice some differences in behavior:
   may be used to overwrite the source files but isn't guaranteed to be
   effective on all filesystems and storage devices.
 
-- Direct I/O is not supported on encrypted files.  Attempts to use
-  direct I/O on such files will fall back to buffered I/O.
+- Direct I/O is supported on encrypted files only under some circumstances
+  (see `Direct I/O support`_ for details). When these circumstances are not
+  met, attempts to use direct I/O on such files will fall back to buffered
+  I/O.
 
 - The fallocate operations FALLOC_FL_COLLAPSE_RANGE and
   FALLOC_FL_INSERT_RANGE are not supported on encrypted files and will
@@ -1257,6 +1259,20 @@ without the key is subject to change in the future.  It is only meant
 as a way to temporarily present valid filenames so that commands like
 ``rm -r`` work as expected on encrypted directories.
 
+Direct I/O support
+------------------
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
 Tests
 =====
 
-- 
2.28.0.rc0.105.gf9edc3c819-goog


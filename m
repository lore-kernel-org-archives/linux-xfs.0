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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5826C4345E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77FF92070E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tEG1tbY0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgGQBp7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgGQBp4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:45:56 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13E8C061755
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:45:56 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id c2so5814252pfj.5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zr1haxdG39xCeCSCxAtAF/uCJ0PriAfrFWPYdcjKJpg=;
        b=tEG1tbY0GS7WlBxSa3Kxt1rFESwI3ui5yUD/cLDZhMOcAswtEsR2gA7+HRG/RM3fom
         kKXQfxEkJ03SNR1VcwABHdAvnSgZUNipTuaqbleOSRI3ly6YGNWQXT0md6xvoxRmgISr
         aj1KioZwAFAZKz6AW2HjIi/fOOThLnth025dI4US/K0SzJSIhF6AN4lrRl8BpYvkr1Lb
         lQR2IJ1LUZ1nzraC9ZyIdcxHojIZhPSRzBFpK0Xtgwy/5Wvxiufo3xtWfUGQ9f6mDhqc
         Jy0npXSloiyPA693awr5gTPYLK5o6O/NYyKBiDV9yOX2QtiUCYUlxyhVr0ZzfowLwJVK
         ez1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zr1haxdG39xCeCSCxAtAF/uCJ0PriAfrFWPYdcjKJpg=;
        b=MnF/MRB3sPGA8wfafA05Bw2A9yIUZjW+xYbc800p9dq/aevmFcQbBToSruHA6mq0JR
         +z4UvHfoDZF/S6NJhm3p8Zqf3ntSmp/rHl5c9pRRlmhL+/fXlk+Q6i5rxGqin1dnnZ3J
         l3DSWCmkhoOyVmgGplbOlMTgDG3LOaW+JWO2MjK3aZdOjrK/Y+f1PqpMsSze8uoJ4OmA
         G7rQ8j6ZgEQeiLhmFyl6YtHcVR2J6ZKNdamico4fw1CBXcooYOhWiNEN77xEsnEWO31x
         pnL7xS1RlEdHd4fCZ4K+uiKokXFNgmBL9v5Xp/5/Ht95doEAvXCIj9riObwchwODgQjC
         89SQ==
X-Gm-Message-State: AOAM532IRlnN424YPLn5n5vDsz+Aa378I98Ossr2szvF7fDNWxhRzs+G
        ABR8fMgb78dmTPZayK1N4fBfAZgXXWI=
X-Google-Smtp-Source: ABdhPJxOhOzjo61R2qPX4OdqO+HjLZ7jHTuuKQDlVMjuRGuop7Hl6oLUSvAWIvqqI67Mktlky6ueFrap26Y=
X-Received: by 2002:a17:90b:283:: with SMTP id az3mr7615052pjb.38.1594950356419;
 Thu, 16 Jul 2020 18:45:56 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:45:40 +0000
In-Reply-To: <20200717014540.71515-1-satyat@google.com>
Message-Id: <20200717014540.71515-8-satyat@google.com>
Mime-Version: 1.0
References: <20200717014540.71515-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v3 7/7] fscrypt: update documentation for direct I/O support
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


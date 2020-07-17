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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D71C433F8
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20F8D20578
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZcYDTvcf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgGQBfg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbgGQBfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:35:33 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D595C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:35:33 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id b69so5777426pfb.14
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=E/vVSGidxRNqfgFvT7W0V9puYBqKI9SZ+5JR8j0m+58=;
        b=ZcYDTvcfLLpu/jhtpmOZTX1yip7PM/LKW+mqaazTmFRD19tgdynOHn3dvFmYrGW/EU
         3OGE6491fFJOHWChT38oVFGgJgqcZ1z9qC05QU8JraayXUwgfZmczmipgbR37elMel8Z
         zNb7TYC+lWvWJJ6SnDNsPiAtosseBQpBY7N1qfVzLHJNWx+JNLHhks/B90rtrKlzTw2Q
         QdJ4Rgwpk7ZYwleZwGq00b+zq66rjpmtFE10TZhsYG25d9JTk8G6JQVQC1rLY+/3pY2o
         8blcSeqgKqhLSzrKduWn3JF/DTEgh0C9d7W/d32ySDrix8TvV4yJXo/ftZgek76k0P/c
         Y1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E/vVSGidxRNqfgFvT7W0V9puYBqKI9SZ+5JR8j0m+58=;
        b=Bq/qxCcbKLyLN0f6AHJGl4x9vQC2NV+UpsFVIM6JAuBJFcrq5g7zcf+rU9f3rocXHZ
         OQg2jKzDHc06DaJnuXhK2b9rp5MLbOBZkj6fgyIIvItMelwY7IMeAanKNoLmTvEVjnpq
         kEPipWaqdcEvAylcaRm38kwwGUhfHaeHskY5uEprnROgXw9d+eoKGouGjDbSC5PD+Du6
         XZ5hUbjBlDV/RMad6YIUjgWosyZmJJskZc4a0JHIo+7xzDiB0KX0ihLCQXKWNk8wnbMy
         8HTfi3O0QJzBVgxcryrbWzRPcF8UohE2Nhh4XF+ttie3d2cBAZdsTK6Eq97/EYRez9g/
         fE3Q==
X-Gm-Message-State: AOAM533Q8pafHmey8/cR1dCMffDU4/8tJn0iRPyvbfK8AHVRQUUIFoPb
        DeO3w8htOyGiEeOKpoyxXHLrgbUkFO4=
X-Google-Smtp-Source: ABdhPJxblkVinfK9/GjEu/MeJLy/xcw1zo2TEXIQwGlWkq0fWav4MrbEVMKPE2WnLaQ1sWXSffDb1SKbb/Q=
X-Received: by 2002:a63:225d:: with SMTP id t29mr6933840pgm.374.1594949732647;
 Thu, 16 Jul 2020 18:35:32 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:35:15 +0000
In-Reply-To: <20200717013518.59219-1-satyat@google.com>
Message-Id: <20200717013518.59219-5-satyat@google.com>
Mime-Version: 1.0
References: <20200717013518.59219-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v2 4/7] ext4: support direct I/O with fscrypt using blk-crypto
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

Wire up ext4 with fscrypt direct I/O support. direct I/O with fscrypt is
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
 fs/ext4/file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 2a01e31a032c..d534f72675d9 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -36,9 +36,11 @@
 #include "acl.h"
 #include "truncate.h"
 
-static bool ext4_dio_supported(struct inode *inode)
+static bool ext4_dio_supported(struct kiocb *iocb, struct iov_iter *iter)
 {
-	if (IS_ENABLED(CONFIG_FS_ENCRYPTION) && IS_ENCRYPTED(inode))
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	if (!fscrypt_dio_supported(iocb, iter))
 		return false;
 	if (fsverity_active(inode))
 		return false;
@@ -61,7 +63,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		inode_lock_shared(inode);
 	}
 
-	if (!ext4_dio_supported(inode)) {
+	if (!ext4_dio_supported(iocb, to)) {
 		inode_unlock_shared(inode);
 		/*
 		 * Fallback to buffered I/O if the operation being performed on
@@ -490,7 +492,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	/* Fallback to buffered I/O if the inode does not support direct I/O. */
-	if (!ext4_dio_supported(inode)) {
+	if (!ext4_dio_supported(iocb, from)) {
 		if (ilock_shared)
 			inode_unlock_shared(inode);
 		else
-- 
2.28.0.rc0.105.gf9edc3c819-goog


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24FEC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7415D2070E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 01:46:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ng8R1/65"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgGQBqC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726782AbgGQBpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 21:45:53 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8BFC08C5DF
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:45:53 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 72so6872585pgb.1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 18:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=ng8R1/65DV2iU+IQ306zEBb/0gZuzKY2wd9E8N5W+UqslArMsttZ5glLKrikl28eKb
         mHq69ANYkDbSrWX4gfqMUWI2ZBqFfFly0rtpiO9z2tckqlbPuAu+WgKmohY8YtajbC7y
         TAkC3td2D69tT+i8RxwKdpD86ImI888MHpVaS3zpZqe2TBh09T3GOUsEhGrYpq7qszO9
         0eL1IJrZbZyK33JvINmsQYzOQns4GWk/EypSIDCE0Bw5rjnxJookR+K0w4fiVIfjkP4l
         48dzxFnzHST1VX+U4ko1hntKzQ14Ezmb2zBJCYDs2eKpTWvdT0fsRQhtyl4OAmHbNGpd
         7XZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=fsVX4Gv2QdCumvsLhkzS+fSnxjtdusWPuWKMSm6QYhhay4iU0/MsV5Dki/Ei7w0UVv
         BmRIpA21jnIo8cFXUwo39k1Vm0w4jLvgrB1xS2YFLwkAB73YCfI1ZThAcYBbfoZRkH9a
         dU3qZHiBE4Ye0ylbOMjI4Q2Fm/ei36J9Ch85OaMKULSOQdhCGuedoL6bqhh2KE4d4sRd
         49GD7RIVvKkhb16RC/dSwLe7aECKnembrSDT5SLqouVqOdZ0QQ4BVDdHSAJ2LkyNDgdk
         HDwq4oZ+E8JFQR68r4ZjbgzQuto1COS5TXu3RNbfvwkieOQPnt1X/C8Owoa/rf7JCczf
         RsDg==
X-Gm-Message-State: AOAM531tgzX0i7bIaKFBdXVZwjQ/9nmV3rCrIJTyuaDYWOkrbKSM+9P2
        z4k+GhJBgMX22kWA7yvPO/uDCGDOwjc=
X-Google-Smtp-Source: ABdhPJypMvXx5XgQi+oxPJJGIhfKX32tGeIjNcFpR4zHf1BJbMQwMi373dkhjOi4KnE/mp1ikT0bXUTweTE=
X-Received: by 2002:a17:90a:2b8f:: with SMTP id u15mr7349194pjd.98.1594950352671;
 Thu, 16 Jul 2020 18:45:52 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:45:38 +0000
In-Reply-To: <20200717014540.71515-1-satyat@google.com>
Message-Id: <20200717014540.71515-6-satyat@google.com>
Mime-Version: 1.0
References: <20200717014540.71515-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v3 5/7] f2fs: support direct I/O with fscrypt using blk-crypto
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


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45402C43445
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 12:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 255A02065E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 12:12:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="slmTUkhi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgGXMMN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 08:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGXMMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 08:12:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7093C08C5DF
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 05:11:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x184so10199964ybx.10
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 05:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oZN8SnIpsU7aOjS5+8MoI/0a82Ym0e3d0O/7K4J6ac4=;
        b=slmTUkhiIwbSQEjfkgmbeV4KCF4u08msiGK6SabnKAiv3CvAYVrGboynyzzbTajxKw
         dZH2xvPQR8jXzK/qntUI9lKlDPtetaRmLCjNT5omgxxhrMizgoRnSC0roIaFgwopHXTv
         IXhLjv+xSOfUUk6gqkYmieytlR1L9nV3xvpbFcQbtEdY9WsWZGStH0uxtSTg0ybo+Yxm
         vNqm/3J1IWd3IHGexMF628lSrVQrvqvd4tFPYBV1UKFjQMZxtGxh9xzY6EDBXANOm8ma
         khmwfHYWnDUYIZDYcO3J3ycu2JUI8GPQwMez8LsY1EOnHkqtMh2j3Mt5z7kSMvf3UCRW
         rFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oZN8SnIpsU7aOjS5+8MoI/0a82Ym0e3d0O/7K4J6ac4=;
        b=FvKMDQ4/EO48PJtMLLihscHvhRXfm0ch5JpmlZtrBl7ROBQKnbb6u+GU2eY+rUY+5N
         xk9Y/cnToaqIKDGQv2/f5tAyN9jMOv80DcDd4zr45YGX8TTqB5cUeU1uuNlc4/KSxTLa
         rmra9GzE9nY0z927Viw3iPhjIh2fkcJbcm6/3SBFh3k8Nu3nQvZq9kaPZ1OPZqhkfP+w
         ULSeaM6zTT4aDXH8UReJPtnrXx1JvA0xDPDTV5s7BHLk5LfyEpIWxqf8IkTarTfGF3Ai
         r0c+/LV9122ZdB4eB06VPNKWtnIYisyDhJ5FvZw8nk2QsecEhvGnspmSUf9hAEFCwHFK
         WP9w==
X-Gm-Message-State: AOAM5324cI0ODyM4OEOkxHNqURXrcJsP5TD3/gUIT7stkhDDTBZB06KM
        uWgcHY+aIiQk5c35nu2sQbwVPmbrQRk=
X-Google-Smtp-Source: ABdhPJyouJ1E2gRcgMN/M3G2tNtXRlKvJhp7ZjedMaUfi7bBr8eQzy4Glr/QlcgRyBhW5mboqWuW4qtyaT8=
X-Received: by 2002:a25:bb07:: with SMTP id z7mr13476612ybg.343.1595592718109;
 Fri, 24 Jul 2020 05:11:58 -0700 (PDT)
Date:   Fri, 24 Jul 2020 12:11:41 +0000
In-Reply-To: <20200724121143.1589121-1-satyat@google.com>
Message-Id: <20200724121143.1589121-6-satyat@google.com>
Mime-Version: 1.0
References: <20200724121143.1589121-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v5 5/7] f2fs: support direct I/O with fscrypt using blk-crypto
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


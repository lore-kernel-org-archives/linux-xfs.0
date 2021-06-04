Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3F4C48BCD
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 21:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 416E061406
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Jun 2021 21:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhFDVMO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 17:12:14 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:39737 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhFDVMM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jun 2021 17:12:12 -0400
Received: by mail-pf1-f202.google.com with SMTP id j206-20020a6280d70000b02902e9e02e1654so5950923pfd.6
        for <linux-xfs@vger.kernel.org>; Fri, 04 Jun 2021 14:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P+DRV+1kr28zVJ/U3wDOfdSPd3HkANrRfuFzxqlC4Pc=;
        b=BD3ZmfBd88tZgrK5VWyAdL43R8ifUsR8x6sFdE82nRuDKynYAWDrzE4ViAPmykHBE4
         iyytiZIYdAESIcvzY6xdWybqTUGCNisGZiXWYfKieKbymZmV/yt7zvjY9NFl3juibb/s
         ikEDpwDO3GTB7QBr/5PZz/yTynDJQ+EVyDbqXYxqVspW4jHjr6GfHmb6aePCiI+9M6Vd
         nAWhQ+RRLTv2OXSWhOZSnRNx4+nvq3NfPSSnycc4sLlhRuBgnNb++2d32IlTONdzLlpM
         5aRbbSRXEHIXxwZ6wYXd6/i1swYlGsa4c2M1WAwUuXtMLF2EffxUpGOmrT0pPALk2QKG
         mb2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P+DRV+1kr28zVJ/U3wDOfdSPd3HkANrRfuFzxqlC4Pc=;
        b=HLhmwDkSSeiU3s7ZjoCabSoGwX0d1nXuK/Wx7hxW1d1G4zdq/8Fi7Jx63IN3YHgcvx
         IF6Lo3b5NI58T3yTofl+NBTIY9sRbkZelX69VMTRnoLWjKRtdktwWtewIbHIGb+4nBCl
         TTNaU695D1yN3CjBqnYqwBS/zr4LVai/NprAu61hya7lY4GN/gqxj5+kN8ytudx9StGy
         6ioZarGVj+9209jRf99dcKVGDhKtmty1cw9zU82BVM6FwYAMQikWpPkUx6bOUIwzwoDk
         mgoTPu9HJaGEIRvT/AnDgIr6tAWaCtX87ShlWkJRUINyD0SyiBHuel3R+m4eKkVdIdOA
         JXZw==
X-Gm-Message-State: AOAM530XV+hwdStAHQbrUGD/fWLRQSVxwfcGjuBKqmfpWsusWm5rMbzV
        ZCMYTMlTI2RvcoEIg/BtGOW4761A9mQ=
X-Google-Smtp-Source: ABdhPJxmL8KM/5Kv0n8tQo795U2DFcdkGRAYUhSqHM6sj42QWQ+C3ACMCn3W2CeCnI48cqnYWj3LpGGCTK0=
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a63:1e55:: with SMTP id p21mr6828807pgm.412.1622840965137;
 Fri, 04 Jun 2021 14:09:25 -0700 (PDT)
Date:   Fri,  4 Jun 2021 21:09:07 +0000
In-Reply-To: <20210604210908.2105870-1-satyat@google.com>
Message-Id: <20210604210908.2105870-9-satyat@google.com>
Mime-Version: 1.0
References: <20210604210908.2105870-1-satyat@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v9 8/9] f2fs: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up f2fs with fscrypt direct I/O support. direct I/O with fscrypt is
only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
have been enabled, the 'inlinecrypt' mount option must have been specified,
and either hardware inline encryption support must be present or
CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
direct I/O on encrypted files is only supported when the *length* of the
I/O is aligned to the filesystem block size (which is *not* necessarily the
same as the block device's block size).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c83d90125ebd..a416ea3a1a04 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4181,7 +4181,11 @@ static inline bool f2fs_force_buffered_io(struct inode *inode,
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
2.32.0.rc1.229.g3e70b5a671-goog


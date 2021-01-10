Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B86C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05D022250E
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbhAJQK6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbhAJQK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 11:10:58 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CD8C0617A4
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:09:48 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id q7so9086094pgm.5
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/aZCROb65rwhTb1g5hjjLpz2rWNIW3lFB2Z6oF/OnN4=;
        b=Uw85kB5XlsSqWjT7gJ/w5Ufz6vcv39mdczYwtT1MPlB39pQPhbZeNLFpKER9qSjLaS
         ywhgBF8CLMpOqdA3PflgyQqmKI7e5RATC4iNe5xbZCCRjpm8j6rIVcGcmX7K/WYdXsjh
         pDwQevI9KDsaaB7dpNqN+f9ZNbzrJbf4ZlwocOT6PMVd18tjcA3vhofVFfBiu2cZCaVt
         JawtFWbw/p0kRP+QzYKvskpV74t5EDogijCY0Xiuj3Xw7tN2ynFHaPZCWOKxBIMqH9uD
         uKd6fsaeyWu1hGZfwdR+YLzG4Z9Gaxxv1/sw0Zl0lRW2+omSMkHH8FC7i+8ap8VR6XvL
         57MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/aZCROb65rwhTb1g5hjjLpz2rWNIW3lFB2Z6oF/OnN4=;
        b=DjgWcWy6eyJPJ0q8yM0MELnL0XNCx/9KMvG87R5qzecCCE0GkA/UjSp91QKNEZyhVj
         1enzYxowYAlIiTRAnFz2rAzkb+c8r8SHfmrbOLIpLEsQYKF0WJKzcio2/sDqUUxbTz/b
         d7kybIB+hEO2hdL+/q2K2tnQREucyFDPIlCKlOCFaW5p19f8wI2RJvl26oNYvEMJdrxi
         J9i+4IEk3OtfA0z20s/YKSbhCO0Leb2ylYKOE94v0NchU0QjSrGtqTi0PiLOBhUNCZ1+
         e2oLIDgTt8d6hkSDG/ZynYW5kPyMGtQVzs7h+BLQ771BUyhz3JajoWqjq8b95YjVoVzc
         nJyg==
X-Gm-Message-State: AOAM533QkkDmdYakolmh2qeUmw8UFtmlqKeeAgzLaHkShxxE0il/Osyy
        y1KWxeCunnaLOHML3GiMhJmkSkb+FPE=
X-Google-Smtp-Source: ABdhPJy3Htf1ebZmFAWI4GkxRSLjWV++/PpzKpxhuL+MGW82DBvtDifN5cI7ZweMqjzEqdR4ec1Fzg==
X-Received: by 2002:a63:b4a:: with SMTP id a10mr15878568pgl.112.1610294987392;
        Sun, 10 Jan 2021 08:09:47 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id d6sm15525896pfo.199.2021.01.10.08.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 08:09:47 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V14 05/16] xfs: Check for extent overflow when removing dir entries
Date:   Sun, 10 Jan 2021 21:37:09 +0530
Message-Id: <20210110160720.3922965-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110160720.3922965-1-chandanrlinux@gmail.com>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Directory entry removal must always succeed; Hence XFS does the
following during low disk space scenario:
1. Data/Free blocks linger until a future remove operation.
2. Dabtree blocks would be swapped with the last block in the leaf space
   and then the new last block will be unmapped.

This facility is reused during low inode extent count scenario i.e. this
commit causes xfs_bmap_del_extent_real() to return -ENOSPC error code so
that the above mentioned behaviour is exercised causing no change to the
directory's extent count.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 32aeacf6f055..6c8f17a0e247 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5151,6 +5151,24 @@ xfs_bmap_del_extent_real(
 		/*
 		 * Deleting the middle of the extent.
 		 */
+
+		/*
+		 * For directories, -ENOSPC is returned since a directory entry
+		 * remove operation must not fail due to low extent count
+		 * availability. -ENOSPC will be handled by higher layers of XFS
+		 * by letting the corresponding empty Data/Free blocks to linger
+		 * until a future remove operation. Dabtree blocks would be
+		 * swapped with the last block in the leaf space and then the
+		 * new last block will be unmapped.
+		 */
+		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
+		if (error) {
+			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
+				whichfork == XFS_DATA_FORK);
+			error = -ENOSPC;
+			goto done;
+		}
+
 		old = got;
 
 		got.br_blockcount = del->br_startoff - got.br_startoff;
-- 
2.29.2


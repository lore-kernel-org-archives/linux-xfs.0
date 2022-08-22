Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39547C32789
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Aug 2022 16:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbiHVQ20 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 12:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbiHVQ2R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 12:28:17 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A18E9A;
        Mon, 22 Aug 2022 09:28:16 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r16so13892507wrm.6;
        Mon, 22 Aug 2022 09:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=q/FI4CYR+WYkVFva7q03Gliz+K3Jnhdatwd2qEAi2Ao=;
        b=G3inXztuNs6ypVb1NVRJ8CdJzgxlJMB2mRdjf/EmS7SLOcBfZZSwgTQZCmJbgTNkaX
         hICVtUk24z0oaPZA5lX694qFK+hczNmto+DIyVyH1FCqVKn58UXG5zOl8yAfGGrEAGbv
         XFpRJXq94KZIq6z5Yg0YLVsuCZXOnn7mK4+s5fxXVzvOBysKXRZuNppg2MTL494NJP3W
         u0yrVjwQV9omEoidB+VkOw+lT/Er7EjPCL3kB2pUZx3mEh9bdrMsxtoMtCt05Wybwq3J
         TADNsUcSu+TTPN10efrEYENviAkiAuRfDGphnZcxgDdhkoaZVhJCGJldQlXogtYA4q5g
         BVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=q/FI4CYR+WYkVFva7q03Gliz+K3Jnhdatwd2qEAi2Ao=;
        b=P84oBuMPl56zVCj1NEsQ5/QIIiB+GzyrHDXKZkpxsEtGBo53k/cOHLCMpLhaI+wh3C
         yukaG0zdJUTwmgeT3AKAgy0ANt6Do1AA4xKSoHTBzMM6QUseokyXs6fbnFqAms8islmi
         P7lR1CwfMRVvQP8TVlLKSHkzFHLgdV8DLpOzuY08FNxHUOtRqBz7VxmuskhEMcdSmrkr
         +5D9ktWCZlhl+PAHoasGOFg7SAdxmAdO5AppSF50ItxVZWl6g6zESGPJqwMDZGOg/lO2
         fBLLujfkll55gA08yCK4YJbFGjrChY8NuPV60aaOTL1kCEJT/6G+rimgtSlDFQOzJv2e
         yrTw==
X-Gm-Message-State: ACgBeo0lD7iGfSJbA3CR3VCLXuk0KLWYc8Im0PC8BfS84dhXZ6XLm3EN
        MG4V34+4rZBRH3Orc4B16/7hwv9yfYc=
X-Google-Smtp-Source: AA6agR71bmi0TjYMckHqvLWSKbz2NnuUh3hXSzUQvPkWeISOW+fgYfweZ0BAeqRWH/n2t/4MMpP+0Q==
X-Received: by 2002:a05:6000:1881:b0:222:c899:cac6 with SMTP id a1-20020a056000188100b00222c899cac6mr10738712wri.283.1661185695155;
        Mon, 22 Aug 2022 09:28:15 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id z13-20020a5d44cd000000b00222ed7ea203sm11749229wrr.100.2022.08.22.09.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 09:28:14 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 CANDIDATE 4/6] vfs: make sync_filesystem return errors from ->sync_fs
Date:   Mon, 22 Aug 2022 19:28:00 +0300
Message-Id: <20220822162802.1661512-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822162802.1661512-1-amir73il@gmail.com>
References: <20220822162802.1661512-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 5679897eb104cec9e99609c3f045a0c20603da4c upstream.

[backport to 5.10 only differs in __sync_blockdev helper]

Strangely, sync_filesystem ignores the return code from the ->sync_fs
call, which means that syscalls like syncfs(2) never see the error.
This doesn't seem right, so fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/sync.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 0d6cdc507cb9..79180e58d862 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -28,7 +28,7 @@
  */
 int sync_filesystem(struct super_block *sb)
 {
-	int ret;
+	int ret = 0;
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -51,15 +51,21 @@ int sync_filesystem(struct super_block *sb)
 	 * at a time.
 	 */
 	writeback_inodes_sb(sb, WB_REASON_SYNC);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 0);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 0);
+		if (ret)
+			return ret;
+	}
 	ret = __sync_blockdev(sb->s_bdev, 0);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	sync_inodes_sb(sb);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 1);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 1);
+		if (ret)
+			return ret;
+	}
 	return __sync_blockdev(sb->s_bdev, 1);
 }
 EXPORT_SYMBOL(sync_filesystem);
-- 
2.25.1


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1760C38142
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Aug 2022 16:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbiHVQ21 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 12:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbiHVQ2Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 12:28:16 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B153BD;
        Mon, 22 Aug 2022 09:28:15 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id z14-20020a7bc7ce000000b003a5db0388a8so5962921wmk.1;
        Mon, 22 Aug 2022 09:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=a+j0v/WuqVSvmnAdOqE+a9Tv3zr3uqGMUrJc5B6a3zo=;
        b=LfdcU9IBxGkjrrjwLSi7lxXGlGltjfU+W7MKJgIPsMbwqZtPamOCPkesFy/nH1tu0N
         j0ry+kx3p07ZZ8Ucv87n3n/hzkBdJTp2dLx4BSSGDJxUj4sVTjcLNiV4VGnoOGU9qZfY
         BnB/GjAz3lb51kKmkv4BL2/lnq4aQlX57MxY9I1zyVq+EOf8yAcpeIaUKt1GH+Wt3bau
         aQn+AWiJ4YbssfsRyPXNG4jmhnmtPTOEykJGhOFSW3i9BkaWf98wqZZiHmP13Va/nLSZ
         AW/7yZJoaBdsHBCkS91MdKUTxkMeAiM1xqcTH56NJjmGiBgCU4d9Jj+i/dNuSG2PiLmY
         IRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=a+j0v/WuqVSvmnAdOqE+a9Tv3zr3uqGMUrJc5B6a3zo=;
        b=uV+z0bTrg/zzbwzFv3DPzH59GP4tsxSUNlNGNKDzCUqvdZEEY4ui2/g8g+HFJQw9yn
         svoH1OJFrHEDDk8D+TnbiTwf2gBLzbFnAJI6kOooHetlptP1bmybrqZg+YeX5X4oCaFG
         S0VBHTgqx+pwfslAIcHBYWxpoby7OCHsfnpF27+SyCYqrsByjA1Sovl8rGOp5Ycf89bO
         31HKpmMUt1NfNJtvB5ILevduvye3rQsFfAQo1Uec0Z3XUGMjVnlzcwINZpsZ9G+EOB90
         bivmkvdbUho6oINGtM27NsMNlSzcXJQE9Bb8/llDBEs/NNpvtwj6BO+k272uTKGBx5Tb
         yqgg==
X-Gm-Message-State: ACgBeo2NMjR6sEWveFTQjdMekUB9G0pl8fBl9oseumAbwBNSmLJS3vgB
        oPC0L/RTuQb/d4YuFgmzEo0=
X-Google-Smtp-Source: AA6agR4Whc6w79g7yLsWxqc4WRqLK3I3an3DkvppBty0t1EBhHndZ/efNRRo6XcGHnY8Uqn2m47n4A==
X-Received: by 2002:a05:600c:4e0f:b0:3a5:e065:9b50 with SMTP id b15-20020a05600c4e0f00b003a5e0659b50mr16045699wmq.35.1661185693785;
        Mon, 22 Aug 2022 09:28:13 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id z13-20020a5d44cd000000b00222ed7ea203sm11749229wrr.100.2022.08.22.09.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 09:28:13 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 CANDIDATE 3/6] fs: remove __sync_filesystem
Date:   Mon, 22 Aug 2022 19:27:59 +0300
Message-Id: <20220822162802.1661512-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822162802.1661512-1-amir73il@gmail.com>
References: <20220822162802.1661512-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 9a208ba5c9afa62c7b1e9c6f5e783066e84e2d3c upstream.

[backported for dependency]

There is no clear benefit in having this helper vs just open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20211019062530.2174626-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/sync.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 1373a610dc78..0d6cdc507cb9 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -21,25 +21,6 @@
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
 			SYNC_FILE_RANGE_WAIT_AFTER)
 
-/*
- * Do the filesystem syncing work. For simple filesystems
- * writeback_inodes_sb(sb) just dirties buffers with inodes so we have to
- * submit IO for these buffers via __sync_blockdev(). This also speeds up the
- * wait == 1 case since in that case write_inode() functions do
- * sync_dirty_buffer() and thus effectively write one block at a time.
- */
-static int __sync_filesystem(struct super_block *sb, int wait)
-{
-	if (wait)
-		sync_inodes_sb(sb);
-	else
-		writeback_inodes_sb(sb, WB_REASON_SYNC);
-
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, wait);
-	return __sync_blockdev(sb->s_bdev, wait);
-}
-
 /*
  * Write out and wait upon all dirty data associated with this
  * superblock.  Filesystem data as well as the underlying block
@@ -61,10 +42,25 @@ int sync_filesystem(struct super_block *sb)
 	if (sb_rdonly(sb))
 		return 0;
 
-	ret = __sync_filesystem(sb, 0);
+	/*
+	 * Do the filesystem syncing work.  For simple filesystems
+	 * writeback_inodes_sb(sb) just dirties buffers with inodes so we have
+	 * to submit I/O for these buffers via __sync_blockdev().  This also
+	 * speeds up the wait == 1 case since in that case write_inode()
+	 * methods call sync_dirty_buffer() and thus effectively write one block
+	 * at a time.
+	 */
+	writeback_inodes_sb(sb, WB_REASON_SYNC);
+	if (sb->s_op->sync_fs)
+		sb->s_op->sync_fs(sb, 0);
+	ret = __sync_blockdev(sb->s_bdev, 0);
 	if (ret < 0)
 		return ret;
-	return __sync_filesystem(sb, 1);
+
+	sync_inodes_sb(sb);
+	if (sb->s_op->sync_fs)
+		sb->s_op->sync_fs(sb, 1);
+	return __sync_blockdev(sb->s_bdev, 1);
 }
 EXPORT_SYMBOL(sync_filesystem);
 
-- 
2.25.1


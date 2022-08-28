Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B55C64991
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Aug 2022 12:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiH1Mqk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Aug 2022 08:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiH1Mqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Aug 2022 08:46:39 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409DB3A490;
        Sun, 28 Aug 2022 05:46:38 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m17-20020a7bce11000000b003a5bedec07bso6814566wmc.0;
        Sun, 28 Aug 2022 05:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ypn/DEQ5yZ3JfSoonTbWK72ruVR6qZV5ozeFWT9uBJY=;
        b=SHdLoNAqSclemXrehclcReC4xaciiy65wcXFRWNArsEjVmAyMV4DUH1TsZdogQYTT+
         ZVyj/ksJwA594uEprXqRtlBH1wa4ULKlZj4XJy73HAZ90lTxMQh1obNRHSbFDLPxqMCy
         RxzQ3p8miN4MEIs6x406f7zzwC+m5vzEv5rqwajHoWtQS1TaAeaxm0eZj9ubRXTNHPLz
         0gSYZNFDZtY+fRYdTOa2pVilRHNiEkdA8o20MVYNwcpjJViqGzr2CC0ZF9+J8GOIHwyY
         An1yYpdG4HgdEpE9sp9cad/GpJ1eht1/o+Gn/AxeyJgCp7wsJDTKDhrYFoUdSsau7UpF
         2diQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ypn/DEQ5yZ3JfSoonTbWK72ruVR6qZV5ozeFWT9uBJY=;
        b=3CIDRpkoh1NZysTxlm+NSKaScBMXgLFJyoTKLOmTiqwPieP4E7iTAD1RZ6eoQ2556B
         BSd7dUFFE+JGS6YzkxrKZAPvlXZbTFJktv5NTj5eXVEIF422irOk9xEcQO3gjfkS1WQY
         4eiFKby/u62Q3RSnwl84/av+If8vVYrj1E1KjG/Emna855v7PGFv2GRFD31NmwR3lvsh
         CuBtYC/iEt7pCJhcFEd0CM3Ho5KhRfRcuwFZLfF6tHa9N99TDsfz/RZ5A8iOgeQxVv3Q
         RZqLIQmWTa6VQoEsbe1DvZchs05KWZB29tEnpTlcgYchTXjSV9SWEZVZzVkUDWoE2S5r
         unEw==
X-Gm-Message-State: ACgBeo0JzLgnlh454QCfFjD69CB8MoYyUBc+C7U36/J1LpmcDbjOCQQV
        kWnF7AeiFT2jQO9715PYMuM=
X-Google-Smtp-Source: AA6agR6viWGC6NN4aUbscG5J28nzTBR6FPI/Ob+KMvyf+GVOSXBWr4ujJnNGqkuKjxAFlDZm2RN7Qg==
X-Received: by 2002:a05:600c:ad4:b0:3a5:50b2:f991 with SMTP id c20-20020a05600c0ad400b003a550b2f991mr4232648wmr.146.1661690797774;
        Sun, 28 Aug 2022 05:46:37 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([2a0d:6fc2:4b00:1500:ecf5:e90e:2ba2:1534])
        by smtp.gmail.com with ESMTPSA id k25-20020adfd239000000b0021e43b4edf0sm4443414wrh.20.2022.08.28.05.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 05:46:37 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 CANDIDATE 7/7] xfs: validate inode fork size against fork format
Date:   Sun, 28 Aug 2022 15:46:14 +0300
Message-Id: <20220828124614.2190592-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220828124614.2190592-1-amir73il@gmail.com>
References: <20220828124614.2190592-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 1eb70f54c445fcbb25817841e774adb3d912f3e8 upstream.

[backport for 5.10.y]

xfs_repair catches fork size/format mismatches, but the in-kernel
verifier doesn't, leading to null pointer failures when attempting
to perform operations on the fork. This can occur in the
xfs_dir_is_empty() where the in-memory fork format does not match
the size and so the fork data pointer is accessed incorrectly.

Note: this causes new failures in xfs/348 which is testing mode vs
ftype mismatches. We now detect a regular file that has been changed
to a directory or symlink mode as being corrupt because the data
fork is for a symlink or directory should be in local form when
there are only 3 bytes of data in the data fork. Hence the inode
verify for the regular file now fires w/ -EFSCORRUPTED because
the inode fork format does not match the format the corrupted mode
says it should be in.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c667c63f2cb0..fa8aefe6b7ec 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -358,19 +358,36 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	mode_t			mode = be16_to_cpu(dip->di_mode);
+	uint32_t		fork_size = XFS_DFORK_SIZE(dip, mp, whichfork);
+	uint32_t		fork_format = XFS_DFORK_FORMAT(dip, whichfork);
 
-	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
+	/*
+	 * For fork types that can contain local data, check that the fork
+	 * format matches the size of local data contained within the fork.
+	 *
+	 * For all types, check that when the size says the should be in extent
+	 * or btree format, the inode isn't claiming it is in local format.
+	 */
+	if (whichfork == XFS_DATA_FORK) {
+		if (S_ISDIR(mode) || S_ISLNK(mode)) {
+			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_LOCAL)
+				return __this_address;
+		}
+
+		if (be64_to_cpu(dip->di_size) > fork_size &&
+		    fork_format == XFS_DINODE_FMT_LOCAL)
+			return __this_address;
+	}
+
+	switch (fork_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
-		 * no local regular files yet
+		 * No local regular files yet.
 		 */
-		if (whichfork == XFS_DATA_FORK) {
-			if (S_ISREG(be16_to_cpu(dip->di_mode)))
-				return __this_address;
-			if (be64_to_cpu(dip->di_size) >
-					XFS_DFORK_SIZE(dip, mp, whichfork))
-				return __this_address;
-		}
+		if (S_ISREG(mode) && whichfork == XFS_DATA_FORK)
+			return __this_address;
 		if (di_nextents)
 			return __this_address;
 		break;
-- 
2.25.1


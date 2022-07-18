Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5122DCCA47F
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbiGRUad (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiGRUaa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:30:30 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007DFE84
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:29 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f65so11618336pgc.12
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B5x1LGuy5pxKZhDdbGsM9v4RKXT84GjS8UQXE4CyxEY=;
        b=dtybAsURIsDVjwCeApShymUeIo85qzOvzs8jfN2Vawm6gtpFBsKdM9YsUuStSn+/pS
         zdUpQw7tBlBuWB/hhx7Zw+RxSE2cZl8cBlMCItR2QO+ZPL4cbKco/7vcLuaFefWtR0ta
         +8/Wks5czfRG8trnxihu6JZnD9q/bDB75LU1QjJ7k7yA6DdGXqYh5KdD19K0jhd/C3ag
         1z5obOMI9+SM8sD64mNnBP7iUqyNUA9894rjxxW3td+FZdlswGZAT0K+uSI4Z9SDggoH
         6B3oYtOgxQAA18VU+vRBWu7N/I2iAWZg4YDNNNUQb9rgFFjxPrEZWDQWp/LnRUYISeQ+
         tThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B5x1LGuy5pxKZhDdbGsM9v4RKXT84GjS8UQXE4CyxEY=;
        b=OIITcmzkknjhYMB2UewZtATD2gMYfXZDPY2Li9EnVzhM1JNMuD+h5q2d/OR9mIWwzU
         DyTZ1xR+AFLOIAYYZUCchPkK9GJyuMToSRG+5yDG7nHz0X3dptigi3RvWIpU65edX0ra
         qnPGEWB6COD05JUZGWTt6moJ3pxRwVueOD65lM9m/0jWUx1S3cGxjoNGdABo6XpoPK2p
         70Kuhs0/ujP30HlbEQYAvCpZe/eNPKkOaYeMCQm8MLiFre07HK9YZX9WFPvbgb2MoSKw
         lB8WI3Lxq1pAcEzV5f6/IwtfIVVMAdRPG044R7QcGrD3YRF2SCC7sIM/UlykETXVUoR+
         cxEA==
X-Gm-Message-State: AJIora9oueiE+Ygp7GjSAxOsc0SAM5mSxiFVDOX6Il9tiD5HkSTzEnl5
        1bYQ4PHci152wQFof41dfWQPc6chZ3yHbQ==
X-Google-Smtp-Source: AGRyM1saOEIC2pjB/bnlaHJh5wIsG95hu7+IjK/Y52wSMLoMsHgtLmgQNqpQKHkGs7C6Ah583peTLA==
X-Received: by 2002:a63:688a:0:b0:412:6728:4bf3 with SMTP id d132-20020a63688a000000b0041267284bf3mr26512076pgc.339.1658176229260;
        Mon, 18 Jul 2022 13:30:29 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cd67:7482:195c:2daf])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0ccb00b001ef7fd7954esm11890148pjt.20.2022.07.18.13.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:30:28 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 8/9] xfs: fix a bug in the online fsck directory leaf1 bestcount check
Date:   Mon, 18 Jul 2022 13:29:58 -0700
Message-Id: <20220718202959.1611129-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220718202959.1611129-1-leah.rumancik@gmail.com>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit e5d1802c70f50e0660ee7f598dc2c40312c9e0af ]

When xfs_scrub encounters a directory with a leaf1 block, it tries to
validate that the leaf1 block's bestcount (aka the best free count of
each directory data block) is the correct size.  Previously, this author
believed that comparing bestcount to the directory isize (since
directory data blocks are under isize, and leaf/bestfree blocks are
above it) was sufficient.

Unfortunately during testing of online repair, it was discovered that it
is possible to create a directory with a hole between the last directory
block and isize.  The directory code seems to handle this situation just
fine and xfs_repair doesn't complain, which effectively makes this quirk
part of the disk format.

Fix the check to work properly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/scrub/dir.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 200a63f58fe7..38897adde7b5 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -497,6 +497,7 @@ STATIC int
 xchk_directory_leaf1_bestfree(
 	struct xfs_scrub		*sc,
 	struct xfs_da_args		*args,
+	xfs_dir2_db_t			last_data_db,
 	xfs_dablk_t			lblk)
 {
 	struct xfs_dir3_icleaf_hdr	leafhdr;
@@ -534,10 +535,14 @@ xchk_directory_leaf1_bestfree(
 	}
 
 	/*
-	 * There should be as many bestfree slots as there are dir data
-	 * blocks that can fit under i_size.
+	 * There must be enough bestfree slots to cover all the directory data
+	 * blocks that we scanned.  It is possible for there to be a hole
+	 * between the last data block and i_disk_size.  This seems like an
+	 * oversight to the scrub author, but as we have been writing out
+	 * directories like this (and xfs_repair doesn't mind them) for years,
+	 * that's what we have to check.
 	 */
-	if (bestcount != xfs_dir2_byte_to_db(geo, sc->ip->i_disk_size)) {
+	if (bestcount != last_data_db + 1) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		goto out;
 	}
@@ -669,6 +674,7 @@ xchk_directory_blocks(
 	xfs_fileoff_t		lblk;
 	struct xfs_iext_cursor	icur;
 	xfs_dablk_t		dabno;
+	xfs_dir2_db_t		last_data_db = 0;
 	bool			found;
 	int			is_block = 0;
 	int			error;
@@ -712,6 +718,7 @@ xchk_directory_blocks(
 				args.geo->fsbcount);
 		     lblk < got.br_startoff + got.br_blockcount;
 		     lblk += args.geo->fsbcount) {
+			last_data_db = xfs_dir2_da_to_db(args.geo, lblk);
 			error = xchk_directory_data_bestfree(sc, lblk,
 					is_block);
 			if (error)
@@ -734,7 +741,7 @@ xchk_directory_blocks(
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out;
 		}
-		error = xchk_directory_leaf1_bestfree(sc, &args,
+		error = xchk_directory_leaf1_bestfree(sc, &args, last_data_db,
 				leaf_lblk);
 		if (error)
 			goto out;
-- 
2.37.0.170.g444d1eabd0-goog


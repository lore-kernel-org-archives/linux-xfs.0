Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C5BDC54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 20:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiITUiN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 16:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiITUiM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 16:38:12 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7807075CCD
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 13:38:11 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t190so3859262pgd.9
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 13:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=FexV5qn2QJAXX8dtS7B6j7EvNU1IcZbwAWb4GEPfu70=;
        b=LKfJ0bmJZbcHQmnjfKCgFeZdnzD88+y7FlC1O0Ev1kXgcBWkFUJUWN9aHydYPZBb65
         fXNa8SKE+l0tgdhqXSDXXAjchbI8Mp/5oTykozPNW6pI4K0anUNOyAPTRpFfMnVggW1c
         4QLP4lh6rRxMsVIpZFkR36fPhnIFyO/sFFBVZr+FKqKEjsQ0oswSreGyqvweVQHePlUn
         HCyRxDsIpdZaBpdsNBxN1seOKS/vFK+3DcQVSoxLRz9dBRwV9twtzfYvcu5VhmnZuOsm
         08CzwbZY6LWBF3PQrDGt5pbdgqYRTzdcyBbfwiZPYmDaUmsnuEAGsZ9ULd98QEZu+yAg
         6NCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=FexV5qn2QJAXX8dtS7B6j7EvNU1IcZbwAWb4GEPfu70=;
        b=DjRRtk40Pz3isRksOk4siSYSENhy5nPgGrzculALg9H/JggN8ZhRkxpknu4tvwEaBK
         0gy6sOc5BNJYvA8e3QGmsniHHfUrbv9YN1/YN3Ix3DQyI7f0dmrvrcbswX84n9KCZ1Xo
         5VXPeqDqobjOfuyqzx3KIs467RQRtYNohoPCR19Lu5qfaKGWFW3iB9hRVKLLVgj6Mp9j
         ld6xGUPMKQJP3RC/6yzNg6ebJDy9fxsqBT4Dsmm8xFBLBgOWL2pg4RtYQaRXJfaf9hR/
         /9O9jMgLJr6tZF0CtLfFhEzofJrvE31tdB4b81DNYvl4+yBvpLGU3xcs2Mj2i5OxLgOJ
         1xKg==
X-Gm-Message-State: ACrzQf3m0hL7cWMStftI47tP0um+lepvn8BssEUhnpxgr2hEG2pzQH/h
        zHFzxN5LN/olwQEjsl7syG3Mt9G6GtzJnQ==
X-Google-Smtp-Source: AMsMyM51SmCJmrlfPxCU1rPkQSrYkMJKhCydhAxnpI5Usn/zwF2dbXIGuLTpF98+GXQ6KNz6aNCEnA==
X-Received: by 2002:a65:464b:0:b0:42c:b0:9643 with SMTP id k11-20020a65464b000000b0042c00b09643mr22392796pgr.232.1663706290143;
        Tue, 20 Sep 2022 13:38:10 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6d85:bae2:555b:c2bf])
        by smtp.gmail.com with ESMTPSA id z9-20020a170903018900b00177c488fea5sm365963plg.12.2022.09.20.13.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 13:38:09 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 3/3] xfs: validate inode fork size against fork format
Date:   Tue, 20 Sep 2022 13:37:50 -0700
Message-Id: <20220920203750.1989625-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
In-Reply-To: <20220920203750.1989625-1-leah.rumancik@gmail.com>
References: <20220920203750.1989625-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 1eb70f54c445fcbb25817841e774adb3d912f3e8 ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3932b4ebf903..f84d3fbb9d3d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -337,19 +337,36 @@ xfs_dinode_verify_fork(
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
2.37.3.968.ga6b4b080e4-goog


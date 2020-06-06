Return-Path: <SRS0=3UjW=7T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598EAC433DF
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Jun 2020 08:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 341C6207D0
	for <linux-xfs@archiver.kernel.org>; Sat,  6 Jun 2020 08:28:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SEr3sNJ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725283AbgFFI2a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 6 Jun 2020 04:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728637AbgFFI21 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jun 2020 04:28:27 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBA6C08C5C4
        for <linux-xfs@vger.kernel.org>; Sat,  6 Jun 2020 01:28:27 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh7so4630941plb.11
        for <linux-xfs@vger.kernel.org>; Sat, 06 Jun 2020 01:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jlFEglChqr2AMUDkDA53KRhdaxEKoTEMphYryBokfGU=;
        b=SEr3sNJ6fEJyv5Rv839NwLGFo2LI/nHJRQzHpGdNZxOo5lAkuBpByujjyzX7HI9vZW
         vFXtd71T5FnwoaIAR8CsW9771yXvJszx1IIVIJGVnE3roLSxDplfYVTNTsjyrLZmdfvZ
         lCcBO5LFZuQwbrZ7Zxhs0ysW6rq7STOpDZDsmGjYqt7wF6+EVazBsLTkDYqu4YkurN26
         mCNAHx0RJQlvibKxmHnX3Cx+sVX/ZnpyVDyLTkovcbpBfPjWBA/FxBgzONEy/Cn3oLzH
         /dVzUG/Pmr3QTgmCFFCRsrabzNkBW1d7dYXXHgaUXrt7jGRpPFWCUPe8lKYnEr5aXj8A
         4IBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jlFEglChqr2AMUDkDA53KRhdaxEKoTEMphYryBokfGU=;
        b=c6M9bv/fGBerhhsXEeOYvUyB1nH8tPHdJv73D89jTWnQq+F1JZIIFE4lW8dG6K2DhN
         Ec0KX1B7x6JfpjBcwbqiXPfY33gCn7Do7vHHhCJt9cxS+4WdW/k9u8lR0e9miL6+P35e
         fucSt0iZlSvE5jzO4JsvgLyiA0lWDlBn21HyA5PStKH2dlmx5gb+obFlwf3tWHlhjZBt
         /w9YCynsxatJZ3YpKbVr6K6Ow7KeLyPDOkHxKo92LT3jX4K6AFHFnSIlp1fzlzXP8Nd3
         OUzRY/ky/2xTrIKHH8oBxSOLtHcU6H8diKRUxPNRMm45CUuFOini3apBbUdagdZCNjFT
         EqbQ==
X-Gm-Message-State: AOAM532hy2xFGxCz+ZBJHti4TZUXjngoBH4pheiDkjoGB3srlVipyBTY
        fl7fkzgSY/2ESMCYvwBNs1f6h/2v
X-Google-Smtp-Source: ABdhPJw5ghUcU3xGkRfQYxv6o6P7F2cufz4OBw7FFX1oiHVH4vFkKNaAVzHRmcVgF92xN4BGlGGtLA==
X-Received: by 2002:a17:90b:949:: with SMTP id dw9mr6422319pjb.101.1591432106813;
        Sat, 06 Jun 2020 01:28:26 -0700 (PDT)
Received: from localhost.localdomain ([122.167.144.243])
        by smtp.gmail.com with ESMTPSA id j3sm1678130pfh.87.2020.06.06.01.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 01:28:26 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com, hch@infradead.org
Subject: [PATCH 5/7] xfs: Use 2^27 as the maximum number of directory extents
Date:   Sat,  6 Jun 2020 13:57:43 +0530
Message-Id: <20200606082745.15174-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200606082745.15174-1-chandanrlinux@gmail.com>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The maximum number of extents that can be used by a directory can be
calculated as shown below. (FS block size is assumed to be 512 bytes
since the smallest allowed block size can create a BMBT of maximum
possible height).

Maximum number of extents in data space =
XFS_DIR2_SPACE_SIZE / 2^9 = 32GiB / 2^9 = 2^26.

Maximum number (theoretically) of extents in leaf space =
32GiB / 2^9 = 2^26.

Maximum number of entries in a free space index block
= (512 - (sizeof struct xfs_dir3_free_hdr)) / (sizeof struct
                                               xfs_dir2_data_off_t)
= (512 - 64) / 2 = 224

Maximum number of extents in free space index =
(Maximum number of extents in data segment) / 224 =
2^26 / 224 = ~2^18

Maximum number of extents in a directory =
Maximum number of extents in data space +
Maximum number of extents in leaf space +
Maximum number of extents in free space index =
2^26 + 2^26 + 2^18 = ~2^27

This commit defines the macro MAXDIREXTNUM to have the value 2^27 and
this in turn is used in calculating the maximum height of a directory
BMBT.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c  | 2 +-
 fs/xfs/libxfs/xfs_types.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8b0029b3cecf..f75b70ae7b1f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -81,7 +81,7 @@ xfs_bmap_compute_maxlevels(
 	if (whichfork == XFS_DATA_FORK) {
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 		if (dir_bmbt)
-			maxleafents = MAXEXTNUM;
+			maxleafents = MAXDIREXTNUM;
 		else
 			maxleafents = MAXEXTNUM;
 	} else {
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 397d94775440..0a3041ad5bec 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -60,6 +60,7 @@ typedef void *		xfs_failaddr_t;
  */
 #define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
 #define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
+#define	MAXDIREXTNUM	((xfs_extnum_t)0x7ffffff)	/* 27 bits */
 #define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
 
 /*
-- 
2.20.1


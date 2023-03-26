Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E33C74A5B
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Mar 2023 17:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCZRGi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Mar 2023 13:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCZRGh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Mar 2023 13:06:37 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2B155AA
        for <linux-xfs@vger.kernel.org>; Sun, 26 Mar 2023 10:06:36 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id h25so8317876lfv.6
        for <linux-xfs@vger.kernel.org>; Sun, 26 Mar 2023 10:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679850394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/7L/5mZXE9n1vowUENWHLi53++vZBT1O3Y6u914/mU=;
        b=UdUUfxR2SiJFBJVab7usBIvRAeFOxGtCgeVwNRn2zMK23JcX1vtzqcBBT0aUwYC5ib
         4+HbiFYg2/1mPphdsSchs2Q2eNNOlPC/IB0SxxeM3VBi6pr6lToBr9lFyTjulJ0F5c+r
         dATnkYCA8PV/HP+qMv4X/ZY/zmQC9FuTk5qoMBT7Xggx5V0H7QiQMLM3iPMfi9k5vaX2
         H1ZkfTlYlSZGQTBvw3A4NeGtCh70TbZjJUjtEyThHiH9DPuDtDXRSf7JShBuapdo8+GI
         RUe6OPMCsNVjxLUZqqUv+CZ+Wo7x0Qt8EKiSHuhavNbdXMguVtlq34S/rkwOfIY9EeUj
         0sIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679850394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/7L/5mZXE9n1vowUENWHLi53++vZBT1O3Y6u914/mU=;
        b=7e0L8sbRmc40NxfN22DN+sVlP5SRocCrNuMea+Q9kwgnO+FmKxg/4nzv8bwMMndJyj
         TeSNc6w03qe0xMXZpXciCCsnRjQkV+Fe3H0OUDGmB1HbrdxLLfsORdd4ExmLV7fS8mfT
         CXea7j6uaFjP/b4W+L1D5266JTI4RRiOQ7H+zSnJLQ+16sKcRFkmOphHdzg0OiBu8MRx
         eS7KOEQ6wsWQcAJ6ddYDeIg2rXdiisnZPwSKzRbwynKQsiKTb4ntBUSHRJs1j3CwQiKn
         Dh0zkRK/Yvd1j92mZoxmmb76812BVSo3PdOtLTJP3NJGldZomNn3AFnH7AJ6mSESRb1r
         Ok5g==
X-Gm-Message-State: AAQBX9ckya6hvb2hR3CLJ2q/PLgdlALf7Hocp5FBwt2/KM/wbsjwRPQy
        X1CV9TYZEwcHS6au3QNyTK8qPpPMqq0=
X-Google-Smtp-Source: AKy350YjI99/4JRKL64AifIR+Kg2+aJTvWV8meCpIOuAgYD1D5X5fRYMS8Ck1MX7sfRhMExrwPDg8w==
X-Received: by 2002:ac2:4e92:0:b0:4d5:a8c8:fb43 with SMTP id o18-20020ac24e92000000b004d5a8c8fb43mr3099816lfr.21.1679850394609;
        Sun, 26 Mar 2023 10:06:34 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id m7-20020ac24ac7000000b004d858fa34ebsm4288720lfp.112.2023.03.26.10.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 10:06:34 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 CANDIDATE 2/2] xfs: don't reuse busy extents on extent trim
Date:   Sun, 26 Mar 2023 20:06:23 +0300
Message-Id: <20230326170623.386288-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230326170623.386288-1-amir73il@gmail.com>
References: <20230326170623.386288-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 06058bc40534530e617e5623775c53bb24f032cb upstream.

Freed extents are marked busy from the point the freeing transaction
commits until the associated CIL context is checkpointed to the log.
This prevents reuse and overwrite of recently freed blocks before
the changes are committed to disk, which can lead to corruption
after a crash. The exception to this rule is that metadata
allocation is allowed to reuse busy extents because metadata changes
are also logged.

As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
has allowed modification or complete invalidation of outstanding
busy extents for metadata allocations. This implementation assumes
that use of the associated extent is imminent, which is not always
the case. For example, the trimmed extent might not satisfy the
minimum length of the allocation request, or the allocation
algorithm might be involved in a search for the optimal result based
on locality.

generic/019 reproduces a corruption caused by this scenario. First,
a metadata block (usually a bmbt or symlink block) is freed from an
inode. A subsequent bmbt split on an unrelated inode attempts a near
mode allocation request that invalidates the busy block during the
search, but does not ultimately allocate it. Due to the busy state
invalidation, the block is no longer considered busy to subsequent
allocation. A direct I/O write request immediately allocates the
block and writes to it. Finally, the filesystem crashes while in a
state where the initial metadata block free had not committed to the
on-disk log. After recovery, the original metadata block is in its
original location as expected, but has been corrupted by the
aforementioned dio.

This demonstrates that it is fundamentally unsafe to modify busy
extent state for extents that are not guaranteed to be allocated.
This applies to pretty much all of the code paths that currently
trim busy extents for one reason or another. Therefore to address
this problem, drop the reuse mechanism from the busy extent trim
path. This code already knows how to return partial non-busy ranges
of the targeted free extent and higher level code tracks the busy
state of the allocation attempt. If a block allocation fails where
one or more candidate extents is busy, we force the log and retry
the allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_extent_busy.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 5c2695a42de1..a4075685d9eb 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -344,7 +344,6 @@ xfs_extent_busy_trim(
 	ASSERT(*len > 0);
 
 	spin_lock(&args->pag->pagb_lock);
-restart:
 	fbno = *bno;
 	flen = *len;
 	rbp = args->pag->pagb_tree.rb_node;
@@ -363,19 +362,6 @@ xfs_extent_busy_trim(
 			continue;
 		}
 
-		/*
-		 * If this is a metadata allocation, try to reuse the busy
-		 * extent instead of trimming the allocation.
-		 */
-		if (!(args->datatype & XFS_ALLOC_USERDATA) &&
-		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
-			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
-							  busyp, fbno, flen,
-							  false))
-				goto restart;
-			continue;
-		}
-
 		if (bbno <= fbno) {
 			/* start overlap */
 
-- 
2.34.1


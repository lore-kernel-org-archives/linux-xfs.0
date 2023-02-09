Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72A1C636D3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjBIW0e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjBIW0d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:33 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E1E6953C
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:23 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id mi9so3418343pjb.4
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y4016YpUEy3I4beR6fqckTQdPnx5F17WIZPjZMkQx5M=;
        b=ZMJPTKA8uDkvANQkztxrkkG0Omvghrry8+F/HR84QnZHYKXk3MyWB3t9iAa1h5yTR5
         ErDPQK5p5ep6TtrHy/3erUG01gxkfQdiFuWfJDb1LQ1CVuvQeyMogswwpcbXP5dDrLUN
         t9za+DkMfHFnwESthcp8bJFyzq4JFOFS7VgB4wytM/cAzL/06Pa8QXhLp4ZZ9Egv3xlv
         HEKj4tJJ2cTSihsYxWvZL+kCb8cw1nDfUoG5GaiGPQa3arum1C+FBg0uBXiiA8qTt5aM
         Q3lio7dxN6mHPVxlPWv4o5s8Zb83CacvXD42zwbc6Uyy+Un03KXlD1bL131tMeI1uzL+
         S9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y4016YpUEy3I4beR6fqckTQdPnx5F17WIZPjZMkQx5M=;
        b=GEtewLX2LnMOKxAk4yBc6z2v2kAa0AbiYteAhnl0fT0DKFPEJw5BhJ43SKOb8UVaFw
         M+spP5mGWad0utND9Dy5/Cw4n4JKF+hpbJ5yzlMYXsRbeqK5dSM9GbuXAkNGNzdnwN5n
         oPqNGDcSOXtCO4HTMsq+tdtWPBioDFu5/ogrUA7H018XGu3pGZ8Trb45DfXKUSBOD0cn
         JrfWGioMh6VfSl+R3EF5ZQlk9jecDp4bkO6Y4YnQKurFu016H6aAFqHFaKoogjRoYW9W
         APpVhgmg9LaFroNIKD6WyQP0MwVl5fl69wXGqDt1syXGvFqOgzk2uFDOcal5cz6YNZFK
         qwZA==
X-Gm-Message-State: AO0yUKWzCFvRmB/P3H3bdjfGpVdsI7veP44n0/k/ug3Z/mwX9f7c3AvW
        NoPG3c5aaVBSWWwynVWfIc7aq+QBOngvKbdg
X-Google-Smtp-Source: AK7set/7a4Av1fNXiQpUszYDUb1irpfNMm87Fji5fPoq5jmoErDUrcjTCMizsVSPYimIBEP8n6+AAg==
X-Received: by 2002:a17:902:e414:b0:199:5593:cdba with SMTP id m20-20020a170902e41400b001995593cdbamr4184709ple.69.1675981583383;
        Thu, 09 Feb 2023 14:26:23 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id z3-20020a170902ee0300b00198a96c6b7csm1991021plb.305.2023.02.09.14.26.22
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:23 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFL-00DOUq-Th
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:27 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFL-00FcM6-2w
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/42] xfs: block reservation too large for minleft allocation
Date:   Fri, 10 Feb 2023 09:17:46 +1100
Message-Id: <20230209221825.3722244-4-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we enter xfs_bmbt_alloc_block() without having first allocated
a data extent (i.e. tp->t_firstblock == NULLFSBLOCK) because we
are doing something like unwritten extent conversion, the transaction
block reservation is used as the minleft value.

This works for operations like unwritten extent conversion, but it
assumes that the block reservation is only for a BMBT split. THis is
not always true, and sometimes results in larger than necessary
minleft values being set. We only actually need enough space for a
btree split, something we already handle correctly in
xfs_bmapi_write() via the xfs_bmapi_minleft() calculation.

We should use xfs_bmapi_minleft() in xfs_bmbt_alloc_block() to
calculate the number of blocks a BMBT split on this inode is going to
require, not use the transaction block reservation that contains the
maximum number of blocks this transaction may consume in it...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c       |  2 +-
 fs/xfs/libxfs/xfs_bmap.h       |  2 ++
 fs/xfs/libxfs/xfs_bmap_btree.c | 19 +++++++++----------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index de6d585c00f1..0930c441159d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4242,7 +4242,7 @@ xfs_bmapi_convert_unwritten(
 	return 0;
 }
 
-static inline xfs_extlen_t
+xfs_extlen_t
 xfs_bmapi_minleft(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 01c2df35c3e3..524912f276f8 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -220,6 +220,8 @@ int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *icur, struct xfs_btree_cur **curp,
 		struct xfs_bmbt_irec *new, int *logflagsp);
+xfs_extlen_t xfs_bmapi_minleft(struct xfs_trans *tp, struct xfs_inode *ip,
+		int fork);
 
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index cfa052d40105..18de4fbfef4e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -213,18 +213,16 @@ xfs_bmbt_alloc_block(
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
 		args.type = XFS_ALLOCTYPE_START_BNO;
+
 		/*
-		 * Make sure there is sufficient room left in the AG to
-		 * complete a full tree split for an extent insert.  If
-		 * we are converting the middle part of an extent then
-		 * we may need space for two tree splits.
-		 *
-		 * We are relying on the caller to make the correct block
-		 * reservation for this operation to succeed.  If the
-		 * reservation amount is insufficient then we may fail a
-		 * block allocation here and corrupt the filesystem.
+		 * If we are coming here from something like unwritten extent
+		 * conversion, there has been no data extent allocation already
+		 * done, so we have to ensure that we attempt to locate the
+		 * entire set of bmbt allocations in the same AG, as
+		 * xfs_bmapi_write() would have reserved.
 		 */
-		args.minleft = args.tp->t_blk_res;
+		args.minleft = xfs_bmapi_minleft(cur->bc_tp, cur->bc_ino.ip,
+						cur->bc_ino.whichfork);
 	} else if (cur->bc_tp->t_flags & XFS_TRANS_LOWMODE) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
 	} else {
@@ -248,6 +246,7 @@ xfs_bmbt_alloc_block(
 		 * successful activate the lowspace algorithm.
 		 */
 		args.fsbno = 0;
+		args.minleft = 0;
 		args.type = XFS_ALLOCTYPE_FIRST_AG;
 		error = xfs_alloc_vextent(&args);
 		if (error)
-- 
2.39.0


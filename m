Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1749C678D6
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 22:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjARWp3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjARWpR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:17 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B5D63E3A
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:15 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v10-20020a17090abb8a00b00229c517a6eeso3992728pjr.5
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ESNl4gcmMvqESi3nyV6w/UdCrWaFMG1IJcQBAioCf04=;
        b=YcLQeofUPNrSxh+tVow59ikNuz3M4fehaOHecVgKm0XRBAcpghP6jF3p8dc3v93fOg
         1WJDl1m8WigyPvfgbMFZi28Bb3OISkqlyWfQZSvZTyJPqzBnagtONZQivX5gFzqjOvMu
         wKepWsS25NqrdqK3LPFIB8OKth8xxe+pXbDF1aa7uGr37AmGTBYM8xmnuHpEvM11HK/5
         MDZdTteMxXvgfwiZewDW6l390wn9K6ssg7dkPZ6mMXrdeheHrT/2hMzhmdk+42rNa4fK
         MgSwKTwWGj8COu/+9dUF/DMz6ElqJ3pnZMpi1JihjvGQDwCV1pCqKrOPloSw9Oqzj5JS
         WRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ESNl4gcmMvqESi3nyV6w/UdCrWaFMG1IJcQBAioCf04=;
        b=s02YjAN4joa5imFZirR23sUlLiggKMZXlBebYuodcP9AAcQeZk9IYGSZbc/HrLIxgI
         2vbRUM9tdJouZyCILoWahPn9aN+MsiKBr8pn0f210kMWUl6xxGpvFSmxKhB8nRRLHVQO
         VqAb8avgKCzk2z69DZRkKCtSUe9XSkoOPAGvZsKNEV2WVLeYxZszmy6D/DtKlvTjYKaZ
         JpbagHMs07Gq9JKjgsigZbWkcKAaXLetYHUiQEP90bNWVkGhHWGKZGqZmaipVxF3xoTc
         akxwjXC4ToXIl0eJsVnnhT1W9cBubH8KK7boVo0/Egztxl4HyiYyPGdB5jY82SFgAR42
         2l0w==
X-Gm-Message-State: AFqh2kqRKyGBHgCBlbfhuv/9suKYruCA3fkFwesUDm1Z9jGnpPvW5Pfk
        4BhvrzV8bOicJtRDquyeu8tg52Igzjd7v8Rk
X-Google-Smtp-Source: AMrXdXvu66FCtqYVOUt05zCVXmIR48GZPjUYo3SqQiWjsuoKBn6sRS9cnGffFeBAz894KrUwEAh6Aw==
X-Received: by 2002:a17:903:2345:b0:193:3155:ebcf with SMTP id c5-20020a170903234500b001933155ebcfmr15858466plh.3.1674081915502;
        Wed, 18 Jan 2023 14:45:15 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902c40600b0017f8094a52asm6611009plk.29.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB8-004iWh-SX
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:10 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB8-008FCj-2q
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/42] xfs: block reservation too large for minleft allocation
Date:   Thu, 19 Jan 2023 09:44:26 +1100
Message-Id: <20230118224505.1964941-4-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
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
---
 fs/xfs/libxfs/xfs_bmap.c       |  2 +-
 fs/xfs/libxfs/xfs_bmap.h       |  2 ++
 fs/xfs/libxfs/xfs_bmap_btree.c | 19 +++++++++----------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 018837bd72c8..9dc33cdc2ab9 100644
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
index 16db95b11589..08c16e4edc0f 100644
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


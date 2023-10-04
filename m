Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A13E8FDBF
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 00:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjJDATw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 20:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjJDATw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 20:19:52 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341BB8E
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 17:19:49 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-578e33b6fb7so1019132a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696378788; x=1696983588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JHWUH9qqCQyz5cFsex0UI5zM6Et5Bd2WzHfcDqhsgPc=;
        b=KKDZsNwgxTfiee/g7R9N8Z8U30ZH5W9M4Ovn052HrUQOl4m95cXw34u8GYXSg+Ky/g
         i2y4ZDbFyv9CnYcMXedCmvlYS7p1cA7NhTSAw4EveP/9K1/WMLfXrusld2M1/CTJPn+u
         SSOV1JJlH/VoxOWy6J9jBb2v4KG4aREaQfRgv37sgDA45eVwEmXafJcuVB2LTcQVFc8S
         1LW4gNEVwz+Dssl2KhBLGHQVyKjx5sOvCMfbld80FRdBZ2Aj2528dOjw3sx3hV3TSlzi
         W+i4VcU3CL4PC8y1xaW7vTS7dZ8pzwan6vSJc1dANqmJhvW348CaDxG2P3V0P0NsGBqI
         QQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378788; x=1696983588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JHWUH9qqCQyz5cFsex0UI5zM6Et5Bd2WzHfcDqhsgPc=;
        b=BYKp2Shhk1YdYo54K5CX/2EA57E+zJD9f1DplEjztucGbknlevQ9EXVWCno4pIzlf+
         X8gKZY+VYf981Xn1xVZ7+X5zOyD9tUbWdUKxLqz1FdmKtJWVKpTolgU95cT21w/MXUmy
         bTV/AkB7IrkOXleLwrSKeMdbgQOYv9nSMZO655OxvYwLWYtdJjsnFMP4rNe1N604TMb4
         qksc3Nr2DRHFtE2hpJhshatgbdLkipxCLueuo771gonshkTrTzuM/lLfPR5h1Y8YS9/g
         Y5jU36bIUmT/eob1r/YZK0mV3atCreEIY3P/DhgOAfGVs8GzLvtAAPnCP2Fkm0Xk75yv
         hHgA==
X-Gm-Message-State: AOJu0Yy13PnE3En0shlZQ2sw4GIOYINZJ7vdxV5Oxw0gWLV6rBre1Uuw
        +XzVvkip5lbCGTXhce3wpGkhlT7B79dueFkY2MM=
X-Google-Smtp-Source: AGHT+IGUMKkjRKCOVFjz9LrhJ0wEzB3DCkuWEJbL00m1Cklb/ChgJC9C0EyqaqKO0yaQTlW1v0Ut0w==
X-Received: by 2002:a05:6a20:3258:b0:15d:bfbb:ab with SMTP id hm24-20020a056a20325800b0015dbfbb00abmr804718pzc.58.1696378788611;
        Tue, 03 Oct 2023 17:19:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id s18-20020a17090330d200b001bdc664ecd3sm2226234plc.307.2023.10.03.17.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 17:19:48 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qnpcA-0097ND-0K;
        Wed, 04 Oct 2023 11:19:45 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qnpc9-00000001TrK-3UEF;
        Wed, 04 Oct 2023 11:19:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     john.g.garry@oracle.com
Subject: [PATCH 5/9] xfs: aligned EOF allocations don't need to scan AGs anymore
Date:   Wed,  4 Oct 2023 11:19:39 +1100
Message-Id: <20231004001943.349265-6-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004001943.349265-1-david@fromorbit.com>
References: <20231004001943.349265-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that contiguous free space selection takes into account stripe
alignment, we no longer need to do an "all AGs" allocation scan in
the case the initial AG doesn't have enough contiguous free space
for a stripe aligned allocation. This cleans up
xfs_bmap_btalloc_aligned() the same for both filestreams and the
normal btree allocation code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3c250c89f42e..c1e2c0707e20 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3538,10 +3538,8 @@ xfs_bmap_btalloc_aligned(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		blen,
-	int			stripe_align,
-	bool			ag_only)
+	int			stripe_align)
 {
-	struct xfs_perag        *caller_pag = args->pag;
 	int			error;
 
 	/*
@@ -3558,14 +3556,7 @@ xfs_bmap_btalloc_aligned(
 	args->alignment = stripe_align;
 	args->minalignslop = 0;
 
-	if (ag_only) {
-		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
-	} else {
-		args->pag = NULL;
-		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
-		ASSERT(args->pag == NULL);
-		args->pag = caller_pag;
-	}
+	error = xfs_alloc_vextent_near_bno(args, ap->blkno);
 	if (error)
 		return error;
 
@@ -3650,8 +3641,7 @@ xfs_bmap_btalloc_filestreams(
 		goto out_low_space;
 
 	if (ap->aeof)
-		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
-				true);
+		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align);
 
 	if (!error && args->fsbno == NULLFSBLOCK)
 		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
@@ -3715,9 +3705,16 @@ xfs_bmap_btalloc_best_length(
 		return error;
 	ASSERT(args->pag);
 
-	if (ap->aeof && ap->offset) {
+	if (ap->aeof && ap->offset)
 		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
-	}
+
+	if (error || args->fsbno != NULLFSBLOCK)
+		goto out_perag_rele;
+
+
+	/* attempt aligned allocation for new EOF extents */
+	if (stripe_align)
+		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align);
 
 	/*
 	 * We are now done with the perag reference for the optimal allocation
@@ -3725,24 +3722,13 @@ xfs_bmap_btalloc_best_length(
 	 * now as we've either succeeded, had a fatal error or we are out of
 	 * space and need to do a full filesystem scan for free space which will
 	 * take it's own references.
-	 *
-	 * XXX: now that xfs_bmap_btalloc_select_lengths() selects an AG with
-	 * enough contiguous free space in it for an aligned allocation, we
-	 * can change the aligned allocation at EOF to just be a single AG
-	 * allocation.
 	 */
+out_perag_rele:
 	xfs_perag_rele(args->pag);
 	args->pag = NULL;
 	if (error || args->fsbno != NULLFSBLOCK)
 		return error;
 
-	/* attempt aligned allocation for new EOF extents */
-	if (stripe_align)
-		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
-				false);
-	if (error || args->fsbno != NULLFSBLOCK)
-		return error;
-
 	/* attempt unaligned allocation */
 	error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error || args->fsbno != NULLFSBLOCK)
-- 
2.40.1


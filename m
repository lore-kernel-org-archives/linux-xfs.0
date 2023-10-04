Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF45E8FDC6
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Oct 2023 00:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjJDATy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 20:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjJDATx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 20:19:53 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A169B
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 17:19:50 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-279013f9875so1128183a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 03 Oct 2023 17:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696378790; x=1696983590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0BzZSZwVE1Gex1qPajd83GLNFTOLvCj80nTxTQpAzs=;
        b=El9EvrAKM6SjfLBmNZNB7XyLBx+qD3OanqDlIBprEn/ZGspmHiZF9b6RAUJJbKJ8Fm
         svsv7UWVPiFo4tVnPkx2cWxt3duPMoRCrFcgNcIVnXDME4qUFknZGZsATWBalV8bn8vR
         W+AvvqWsv3omVfXB2XRs00Krr2N3auCyCvMfm8Oa/LFb71azZZ9dwYhIIm1WB6MH5aC1
         uotZOEBB48udTOLsl46eI/r7NygFU07XmdCwpnw6j4/Qin0VB7Onpc/IhBGC3p9fWW6s
         r7wt6HP/rEsBwyPRhq8rvevewy5q9dTE9ppYVpYwyFYiKoHOaZyP/ktGjqUBkQH/eWW/
         W9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378790; x=1696983590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V0BzZSZwVE1Gex1qPajd83GLNFTOLvCj80nTxTQpAzs=;
        b=qg6dg0H82R9IydjY+29xHJ0cMBfBK9WN41VhRuChmhhLkH6hoUXde5x1N2LYrbK6lw
         J0WLA4ix9A8LPzOBMzCRXTB8LQFQmYIlgOLc2BN3HVloeCLD3T8XRMMnxaJ4mzBhvGhV
         GeSG9wNo5c87Im1niUXfFy8JJv+J9+d3YGoQpJcq+IKjz9SrCG8QWMLcI0aOMwfS569o
         H7d4KD3MAFF0gsof6F1znXaWQ9MOMo9oBmAzzkb+sAugjW8wP0qYOFieYe47lOwPup0W
         cOdKzrbTupdf7iyFxHc5BYAMmEclZSS/ylF6EP5NocF7vT/KwrDy0+iP8XCGRkzuk3IY
         jb0Q==
X-Gm-Message-State: AOJu0YxGqqdO0iQKdV4K5ZaQaEaxqXwPORBPnSUMC6V5qATmXTkx0rr+
        pmy7TUhwgUBMxI52l59VkoEP+iXbcrBLoTxvKbY=
X-Google-Smtp-Source: AGHT+IEwp5rmeuj1qCgIiUzIZHx6Lsbxvy8VQn9fpzK0hCgCkvw3woio3/FQ38MkzVutYQxhM8pd1w==
X-Received: by 2002:a05:6a20:324d:b0:14d:7511:1c2 with SMTP id hm13-20020a056a20324d00b0014d751101c2mr793882pzc.55.1696378790085;
        Tue, 03 Oct 2023 17:19:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id z9-20020aa785c9000000b00692acfc4b3csm1958128pfn.136.2023.10.03.17.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 17:19:49 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qnpc9-0097N2-35;
        Wed, 04 Oct 2023 11:19:45 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qnpc9-00000001Tr5-2x7Y;
        Wed, 04 Oct 2023 11:19:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     john.g.garry@oracle.com
Subject: [PATCH 2/9] xfs: contiguous EOF allocation across AGs
Date:   Wed,  4 Oct 2023 11:19:36 +1100
Message-Id: <20231004001943.349265-3-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004001943.349265-1-david@fromorbit.com>
References: <20231004001943.349265-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently when we allocate at EOF, we set the initial target to the
location of the inode. Then we call xfs_bmap_adjacent(), which sees
that we are doing an EOF extension, so it moves the target to the
last block of the previous extent. This may be in a different AG to
the inode.

When we then go to select the AG with the best free length, the AG
at the target block might not have sufficient free space for the
full allocation, so we may select a different AG. We then do an
exact BNO allocation with the original target (EOF block), which
reverts back to attempting an allocation in an AG that doesn't have
sufficient contiguous free space available.

This generally leads to allocation failure, and then we fall back to
scanning the AGs for one that the allocation will succeed in. This
scan also results in contended AGS being skipped, so we have no idea
what AG we are going to end up allocating in. For sequential writes,
this results in random extents being located in random places in
non-target AGs.

We want to guarantee that we can allocate in the AG that we have
selected as having the "best contiguous free space" efficiently,
so if we select a different AG, we should move the allocation target
and skip the exact EOF allocation as we know it will not succeed.
i.e. we should start with aligned allocation immediately, knowing it
will likely succeed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e14671414afb..e64ba7e2d13d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3252,8 +3252,18 @@ xfs_bmap_btalloc_select_lengths(
 		if (error && error != -EAGAIN)
 			break;
 		error = 0;
-		if (*blen >= args->maxlen)
+		if (*blen >= args->maxlen) {
+			/*
+			 * We are going to target a different AG than the
+			 * incoming target, so we need to reset the target and
+			 * skip exact EOF allocation attempts.
+			 */
+			if (agno != startag) {
+				ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
+				ap->aeof = false;
+			}
 			break;
+		}
 	}
 	if (pag)
 		xfs_perag_rele(pag);
@@ -3514,10 +3524,10 @@ xfs_bmap_btalloc_aligned(
 	int			error;
 
 	/*
-	 * If we failed an exact EOF allocation already, stripe
-	 * alignment will have already been taken into account in
-	 * args->minlen. Hence we only adjust minlen to try to preserve
-	 * alignment if no slop has been reserved for alignment
+	 * If we failed an exact EOF allocation already, stripe alignment will
+	 * have already been taken into account in args->minlen. Hence we only
+	 * adjust minlen to try to preserve alignment if no slop has been
+	 * reserved for alignment
 	 */
 	if (args->minalignslop == 0) {
 		if (blen > stripe_align &&
@@ -3653,6 +3663,16 @@ xfs_bmap_btalloc_best_length(
 	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
 	xfs_bmap_adjacent(ap);
 
+	/*
+	 * We only use stripe alignment for EOF allocations. Hence if it isn't
+	 * an EOF allocation, clear the stripe alignment. This allows us to
+	 * skip exact block EOF allocation yet still do stripe aligned
+	 * allocation if we select a different AG to the
+	 * exact target block due to a lack of contiguous free space.
+	 */
+	if (!ap->aeof)
+		stripe_align = 0;
+
 	/*
 	 * Search for an allocation group with a single extent large enough for
 	 * the request.  If one isn't found, then adjust the minimum allocation
@@ -3675,7 +3695,7 @@ xfs_bmap_btalloc_best_length(
 	}
 
 	/* attempt aligned allocation for new EOF extents */
-	if (ap->aeof)
+	if (stripe_align)
 		error = xfs_bmap_btalloc_aligned(ap, args, blen, stripe_align,
 				false);
 	if (error || args->fsbno != NULLFSBLOCK)
-- 
2.40.1


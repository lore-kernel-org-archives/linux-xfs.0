Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1A0C64E7C
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CCDC24699
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ACqDc2jS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732772AbgKQNpX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732722AbgKQNpW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:45:22 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AE1C0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:22 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id d17so8722902plr.5
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mzo4XKFqwetL4wgqWPphqhx1Obl5kc6g2AJMDkW2Wts=;
        b=ACqDc2jS0I7BW738aDNux8J8oJj9vcERDSwDVn2zd50FyC3TOcF+NTi5ssn1JvqkcA
         U4Umob/SadNFdCTgprtkhOfZY0dcFYQG2+xTXSeGFz2EhcchKlXgBeTFz+tT3na5O/qm
         VwP3iEATBs30CCZvxEaULHB1zLcNj7tyGhP2XjqXSYwBhx5pvHrphUFq08uaH/u5PeET
         8PuZyf12yHUQqVPSHSGXrEo9fNT9OYMogx8lQFxsRVpPv9vyZFYJeW2vJbR73IzcS/4U
         kuCuNIckjYkq39AeD2CNKMGpg0uvNlRYQiT1WjZ1uOSS7ydQ7J35zEOB3z/UKx/dVhXl
         azwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mzo4XKFqwetL4wgqWPphqhx1Obl5kc6g2AJMDkW2Wts=;
        b=PBTSNpORcgCz5X7Iwd0WNb4pkBfx3U3WhtGS8hioCMVki7E0qgGsM2asRyqNJE0sFQ
         6Pip5qZwmEIYLDe3aTBc01gcrjodcmDtABXz55fRe1xFYQnj0ex7Yz76yU2KgbpY1uj6
         UzTnJmXABDaUdqutzyLVn2KbDdEwv0D68l0PWdqLTOpoynLyIjjdBLEX8widC02N0jsk
         hGk+jjiafCaWY9nyIWnNEfskPjyHk3+smmcNI8to3gBHa78adPX+7Oat0FntpU7wjShs
         sh2FHDBl2LKV4BpQ5diL05r9Bbc3aQthNRpS+xEUgkhlWzQX5wVjM6OOiuhn/jzjnAIG
         gWlw==
X-Gm-Message-State: AOAM5329oFuaregFC4IZDJpqBP+K9LIQPdZInPKk96OPbKzsOZtEWGmG
        iCqcHcbAgu+wqa50eIUF4I/wO/YbBso=
X-Google-Smtp-Source: ABdhPJzuIRhdSnUsfZH0XEYyYDRgE+0DBTZKLACuihioQENFSYg1RQanGnc8+kQfRu2UOujYP0OWhw==
X-Received: by 2002:a17:90b:4c92:: with SMTP id my18mr4330120pjb.152.1605620721334;
        Tue, 17 Nov 2020 05:45:21 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:45:20 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH V11 13/14] xfs: Process allocated extent in a separate function
Date:   Tue, 17 Nov 2020 19:14:15 +0530
Message-Id: <20201117134416.207945-14-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves over the code in xfs_bmap_btalloc() which is
responsible for processing an allocated extent to a new function. Apart
from xfs_bmap_btalloc(), the new function will be invoked by another
function introduced in a future commit.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 74 ++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5032539d5e85..f6cd33684571 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3510,6 +3510,48 @@ xfs_bmap_compute_alignments(
 	return stripe_align;
 }
 
+static void
+xfs_bmap_process_allocated_extent(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_fileoff_t		orig_offset,
+	xfs_extlen_t		orig_length)
+{
+	int			nullfb;
+
+	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
+
+	/*
+	 * check the allocation happened at the same or higher AG than
+	 * the first block that was allocated.
+	 */
+	ASSERT(nullfb ||
+		XFS_FSB_TO_AGNO(args->mp, ap->tp->t_firstblock) <=
+		XFS_FSB_TO_AGNO(args->mp, args->fsbno));
+
+	ap->blkno = args->fsbno;
+	if (nullfb)
+		ap->tp->t_firstblock = args->fsbno;
+	ap->length = args->len;
+	/*
+	 * If the extent size hint is active, we tried to round the
+	 * caller's allocation request offset down to extsz and the
+	 * length up to another extsz boundary.  If we found a free
+	 * extent we mapped it in starting at this new offset.  If the
+	 * newly mapped space isn't long enough to cover any of the
+	 * range of offsets that was originally requested, move the
+	 * mapping up so that we can fill as much of the caller's
+	 * original request as possible.  Free space is apparently
+	 * very fragmented so we're unlikely to be able to satisfy the
+	 * hints anyway.
+	 */
+	if (ap->length <= orig_length)
+		ap->offset = orig_offset;
+	else if (ap->offset + ap->length < orig_offset + orig_length)
+		ap->offset = orig_offset + orig_length - ap->length;
+	xfs_bmap_btalloc_accounting(ap, args);
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -3702,36 +3744,10 @@ xfs_bmap_btalloc(
 			return error;
 		ap->tp->t_flags |= XFS_TRANS_LOWMODE;
 	}
+
 	if (args.fsbno != NULLFSBLOCK) {
-		/*
-		 * check the allocation happened at the same or higher AG than
-		 * the first block that was allocated.
-		 */
-		ASSERT(ap->tp->t_firstblock == NULLFSBLOCK ||
-		       XFS_FSB_TO_AGNO(mp, ap->tp->t_firstblock) <=
-		       XFS_FSB_TO_AGNO(mp, args.fsbno));
-
-		ap->blkno = args.fsbno;
-		if (ap->tp->t_firstblock == NULLFSBLOCK)
-			ap->tp->t_firstblock = args.fsbno;
-		ap->length = args.len;
-		/*
-		 * If the extent size hint is active, we tried to round the
-		 * caller's allocation request offset down to extsz and the
-		 * length up to another extsz boundary.  If we found a free
-		 * extent we mapped it in starting at this new offset.  If the
-		 * newly mapped space isn't long enough to cover any of the
-		 * range of offsets that was originally requested, move the
-		 * mapping up so that we can fill as much of the caller's
-		 * original request as possible.  Free space is apparently
-		 * very fragmented so we're unlikely to be able to satisfy the
-		 * hints anyway.
-		 */
-		if (ap->length <= orig_length)
-			ap->offset = orig_offset;
-		else if (ap->offset + ap->length < orig_offset + orig_length)
-			ap->offset = orig_offset + orig_length - ap->length;
-		xfs_bmap_btalloc_accounting(ap, &args);
+		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
+			orig_length);
 	} else {
 		ap->blkno = NULLFSBLOCK;
 		ap->length = 0;
-- 
2.28.0


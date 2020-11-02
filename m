Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB8BC388F9
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA4BC222E8
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rAKmraU6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgKBJvj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 04:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJvj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:39 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4B2C0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:51:39 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 62so3044386pgg.12
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UeDpThAYxs124zwV4PKfLL2jNcC3XH3KhZ5P3V8H6C8=;
        b=rAKmraU60JO2MFtrLE8SCph04onz1WeAsIgK3w0wPll9auH1GyR0eDadHs9K6PBZFr
         cj3bXjPbP5aSnTDOlOM7p+6KAeKDkeGna5hMg6jVybBpNHq36oVLAe0u/bm2ISUqSXOA
         h/Z+Y3OuvGSQKl8xUsc7HNIKNhcqCh5ttkyobDclezlqqlV0b8C4TXdgXeU+rQDkVIwr
         AryuQWxZ6Ugnql+LOL8S5NpC1t+cR8Q5TXbwZETu87zjt4zDSVyjaLD375lqghkqP/W4
         lDEosg1yeCpkFRMiEfF21X5kVhNeqEM69fnywavJNv1yG/68FBtuAKeA2BG+goKFSTlZ
         7Pvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UeDpThAYxs124zwV4PKfLL2jNcC3XH3KhZ5P3V8H6C8=;
        b=ZNxYtnXESLAJzBPF4kcH7JJkwyukLjRZIZjFxwz2D3mdhewJjtAMv9vyxcRQxyhqxF
         Qst7b7i6EusvefSHZgzwhTOIC1r/KgDunEPKPpErE9QPWRHeYI6ypux9xIZggOusKjrR
         hlFL8Nt+q+9xNsAqPfuz+IPIhs6QNOlldMo5h9m3s5glVJmHS0o4OsSU1WhwjsO9ItzX
         C+xTVZi8aFqRJhztF8ZidbhSSU/11kWH+QdbfyhdgU6QBXBEsH8rh0DwybIREtQaVoVK
         M0greGTtrYuO0QQKS4tuc0KbEnEysV/jbeqWl7vvJ6ytFltVKLubixSJRyjghc8b79wJ
         LAPQ==
X-Gm-Message-State: AOAM5300zmREaIrlTDMzXqQMwlJYOOGBK+Yfol8G8jwbUpNz79iPaJYd
        frL+Ng6ED1nTdFnDBqOJGs60TBQiaik=
X-Google-Smtp-Source: ABdhPJwmmGIl3QOZwkUjrlKJO0XkNf+OAvwwENmkPQhXvkDs2g1dB6bvLcSHvVTLBlc5IkkkfS8F2Q==
X-Received: by 2002:a63:6243:: with SMTP id w64mr7402760pgb.430.1604310698380;
        Mon, 02 Nov 2020 01:51:38 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:51:37 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V9 13/14] xfs: Process allocated extent in a separate function
Date:   Mon,  2 Nov 2020 15:20:47 +0530
Message-Id: <20201102095048.100956-14-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102095048.100956-1-chandanrlinux@gmail.com>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
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
index 935f2d506748..88db23afc51c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3509,6 +3509,48 @@ xfs_bmap_compute_alignments(
 	}
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
@@ -3701,36 +3743,10 @@ xfs_bmap_btalloc(
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


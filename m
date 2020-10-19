Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA3BC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C4F22260
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HB0l6rmi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgJSGlu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJSGlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 02:41:49 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0404C061755
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j18so5435223pfa.0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cuw0qYx7vbqAMkfQlHFN5TQrXT6eetenRUTrLL8eCR8=;
        b=HB0l6rmi7dZV5m8pb/sPXIPzeJaTxuAJzRI9KtaIhur6OTN+jWaoXF8WY7Cl3VBDqO
         lonmyD4vnUvdz98ZDVEb/1mCSDFSzBA39W0OjuUyz/RNC/t2HiueM+AunKBvrEOcnVrU
         QOV/d/TPm+ZcnRgAggDyLR8O9oU9jo4LYEAU5YtsDrY8WjErAIFqbxMZIY5pC5WdheeE
         W6Mf7H41OeJ9emhVj5tcn3QxVMfe7JNzZZHZ0Cbe3R+UoDSSmIwi4mJJYqj+vfiwf5xT
         DfREqrimAp7qeOoYulxaJUwiShPRKchIuGVS/0wZEgsxT1fMfeJF6nBkyrnjn9mHMlju
         H66g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cuw0qYx7vbqAMkfQlHFN5TQrXT6eetenRUTrLL8eCR8=;
        b=SgxrFfRmVMIAlRbo+Mr+X4+iv45heeRTtkf3nZnuboOzJ8qcMehYn5F5H5JLlUOtfQ
         alXJdZRyPsJ3Jpv21bBKL3SfkK+JNRCZxsqXnZEltg13y5p7WvYCGH+tf37B1aTNlw7a
         lv/ZkA5x9DYd0IXW6lFyy0K3nBmhSrwCDH2OTCG72pq9NrjmlYMk1YijfrAGIz0a/Xnt
         EkCDZ5iOmvRgzJx8G/4FytwfcSvUPxjTJPwWZYHHcX14Kms3Yzi/rQ0ZnLrapjp/VQh0
         /00ES6lkEYyClg6Nnf1n6Y2sQ8QZi3cGFLOhfjnY6eANw54G73e+o9tx28DLzdchwceg
         5TtA==
X-Gm-Message-State: AOAM5339y0Gjf9FH7+O5PxhZi7YNgfUItad5Q+Qp17EThwDhMUL0Z5q3
        GaftHGQVoD6RJzKN1Yd9WezQUQTqzlY=
X-Google-Smtp-Source: ABdhPJyBz0n8ArDMOP/EJ1qw5YYNUvtCovvSzQm5/I4hZYNwnxHsxXUHx7Nxqa59y0cCLZe+BBU9vA==
X-Received: by 2002:a62:c181:0:b029:152:6ba8:a011 with SMTP id i123-20020a62c1810000b02901526ba8a011mr14903006pfg.2.1603089709096;
        Sun, 18 Oct 2020 23:41:49 -0700 (PDT)
Received: from localhost.localdomain ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id w74sm11164189pff.200.2020.10.18.23.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 23:41:48 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V7 13/14] xfs: Process allocated extent in a separate function
Date:   Mon, 19 Oct 2020 12:10:47 +0530
Message-Id: <20201019064048.6591-14-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019064048.6591-1-chandanrlinux@gmail.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves over the code in xfs_bmap_btalloc() which is
responsible for processing an allocated extent to a new function. Apart
from xfs_bmap_btalloc(), the new function will be invoked by another
function introduced in a future commit.

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


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F222C388F2
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3655E2231B
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpAWRjUo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgKBJvh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 04:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJvh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:37 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386DEC0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:51:36 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 13so10646833pfy.4
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wcibcHg+fGfIy+ERBhxnRgw5AuJuCxxwyu5T4vfwYrc=;
        b=mpAWRjUolU/GYRqOfYqNMJYjNjRG7sYd8Ow6A28yH/YkacK1CGGip2v45/Nr0sAeMT
         zZ1Ii6tFYGg2bq106SWhZ5T1ctDRc7kuFM9m33hbGwatD1xaJyzC37Qvy18gfwK84xVP
         OqUHGafvAyInvtDMKoFA/srC4NrZtpJ8bctWVo/zRqqbzjwT13Qe4898Tu7ELahuC7Ey
         FoeQ7Nh8+0W76Jf1n27X88kdTq1COXn5cZwT2sKtitTuFPX2P+qn7+r3y/QJXVcJ5QSI
         gZ5nDqQA23m+L2nbpc8T1WAQWdEqRS8mKOBB0rnZvlOohDya8yds6RoiujaPDDrvBxI5
         gskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wcibcHg+fGfIy+ERBhxnRgw5AuJuCxxwyu5T4vfwYrc=;
        b=H3A+v2yaXkkBMjeIfZ2cPsnLDWa+hFSnVyMKbMct336AsjISQr4e0z8yNadxF6Fh1P
         6Yri0QyhDUlUE4FHf8Y7xloRt3AaThFpcttsJfkYxOoetlQUwQ/vV8RkgGgm7/duO61N
         ZWOc33YPqnyAJ9YOP5toqbQUG8NyAf6TNNJt/HAPdPO4Ky0xwTbB9FnFrAIjD12pxSMp
         QMX6GmG/32TkLi3wqzTRtNVJmmEOA1tYmBZIWGytq/2OB0DQgDIPOMoRf8sjdn0S8FTA
         ZrUItkrPAdkEk+a7mWvfoDgFd3wTX2wyelzwgC9d3NTta+ezcG1rTFvDWLalDDz8+DnY
         LLjQ==
X-Gm-Message-State: AOAM532RAd1TDTFGxJBZd8Rav2+etJUOebmmixKQNGz0gCpdh4RdZ/DO
        /P01Hz8cPDv5xiZwXIYY2J7H3b3h4vQ=
X-Google-Smtp-Source: ABdhPJy8XUbyGS5m5V1wEjapxwc4JXNiu3bP8Z1pnpozg85rAnGp0CA0hS+BGV4Udb3/ivokEJpSrQ==
X-Received: by 2002:a63:9a41:: with SMTP id e1mr12652468pgo.371.1604310695466;
        Mon, 02 Nov 2020 01:51:35 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:51:34 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V9 12/14] xfs: Compute bmap extent alignments in a separate function
Date:   Mon,  2 Nov 2020 15:20:46 +0530
Message-Id: <20201102095048.100956-13-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102095048.100956-1-chandanrlinux@gmail.com>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves over the code which computes stripe alignment and
extent size hint alignment into a separate function. Apart from
xfs_bmap_btalloc(), the new function will be used by another function
introduced in a future commit.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 88 +++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 64c4d0e384a5..935f2d506748 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3463,13 +3463,58 @@ xfs_bmap_btalloc_accounting(
 		args->len);
 }
 
+static void
+xfs_bmap_compute_alignments(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	int			*stripe_align)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_extlen_t		align = 0; /* minimum allocation alignment */
+	int			error;
+
+	/* stripe alignment for allocation is determined by mount parameters */
+	*stripe_align = 0;
+	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+		*stripe_align = mp->m_swidth;
+	else if (mp->m_dalign)
+		*stripe_align = mp->m_dalign;
+
+	if (ap->flags & XFS_BMAPI_COWFORK)
+		align = xfs_get_cowextsz_hint(ap->ip);
+	else if (ap->datatype & XFS_ALLOC_USERDATA)
+		align = xfs_get_extsz_hint(ap->ip);
+	if (align) {
+		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
+						align, 0, ap->eof, 0, ap->conv,
+						&ap->offset, &ap->length);
+		ASSERT(!error);
+		ASSERT(ap->length);
+	}
+
+	/* apply extent size hints if obtained earlier */
+	if (align) {
+		args->prod = align;
+		div_u64_rem(ap->offset, args->prod, &args->mod);
+		if (args->mod)
+			args->mod = args->prod - args->mod;
+	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
+		args->prod = 1;
+		args->mod = 0;
+	} else {
+		args->prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
+		div_u64_rem(ap->offset, args->prod, &args->mod);
+		if (args->mod)
+			args->mod = args->prod - args->mod;
+	}
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	xfs_mount_t	*mp;		/* mount point structure */
 	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
-	xfs_extlen_t	align = 0;	/* minimum allocation alignment */
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
 	xfs_agnumber_t	ag;
 	xfs_alloc_arg_t	args;
@@ -3489,25 +3534,11 @@ xfs_bmap_btalloc(
 
 	mp = ap->ip->i_mount;
 
-	/* stripe alignment for allocation is determined by mount parameters */
-	stripe_align = 0;
-	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
-		stripe_align = mp->m_swidth;
-	else if (mp->m_dalign)
-		stripe_align = mp->m_dalign;
-
-	if (ap->flags & XFS_BMAPI_COWFORK)
-		align = xfs_get_cowextsz_hint(ap->ip);
-	else if (ap->datatype & XFS_ALLOC_USERDATA)
-		align = xfs_get_extsz_hint(ap->ip);
-	if (align) {
-		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
-						align, 0, ap->eof, 0, ap->conv,
-						&ap->offset, &ap->length);
-		ASSERT(!error);
-		ASSERT(ap->length);
-	}
+	memset(&args, 0, sizeof(args));
+	args.tp = ap->tp;
+	args.mp = mp;
 
+	xfs_bmap_compute_alignments(ap, &args, &stripe_align);
 
 	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
@@ -3538,9 +3569,6 @@ xfs_bmap_btalloc(
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
-	memset(&args, 0, sizeof(args));
-	args.tp = ap->tp;
-	args.mp = mp;
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 
@@ -3571,21 +3599,7 @@ xfs_bmap_btalloc(
 		args.total = ap->total;
 		args.minlen = ap->minlen;
 	}
-	/* apply extent size hints if obtained earlier */
-	if (align) {
-		args.prod = align;
-		div_u64_rem(ap->offset, args.prod, &args.mod);
-		if (args.mod)
-			args.mod = args.prod - args.mod;
-	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
-		args.prod = 1;
-		args.mod = 0;
-	} else {
-		args.prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
-		div_u64_rem(ap->offset, args.prod, &args.mod);
-		if (args.mod)
-			args.mod = args.prod - args.mod;
-	}
+
 	/*
 	 * If we are not low on available data blocks, and the underlying
 	 * logical volume manager is a stripe, and the file offset is zero then
-- 
2.28.0


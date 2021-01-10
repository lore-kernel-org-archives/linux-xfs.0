Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1755C43331
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCE2622B2A
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbhAJQLI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbhAJQLG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 11:11:06 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4B8C0617B9
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:10:09 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id x18so8209419pln.6
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jw0B2g9g3rbrg1IyEQa89IWyyj4zbNdIUqbVg9wx8z8=;
        b=BqnNuH5A2Scq2gM+MJpNcDo/camKwQJoytqBoFHZwk3KqLNoxiN73WIuAVo84Cj9gq
         NspOuIiemfbYpWeK+KRmiwhvcmeVLicG+dyhqzxTr55dXmgXdWT0j/M4Eys4XvdyCz56
         +pVriObj/mVkuiMXrkaDMGOS+TSjjIlPwDQ38JdrBsAby8Ap9QCl72G/MRYzhBADPEjC
         rkg5LPl+IqAVv9CAj+RG2D02w9bJIj075v+SiS1w3OtCzApXegJSkAPdWnGmgYyiDHuh
         Pz5DCkc+pmDC+o1IYAvNOLIIHzjAbHJ7SEA49dF2v2NzBRw1i1etN8FTtfAdeuuOZ5b6
         r7gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jw0B2g9g3rbrg1IyEQa89IWyyj4zbNdIUqbVg9wx8z8=;
        b=pY5Lh9uyCZp4HhpRCq3VOsfLeB6r0BFCQr7rNKRcX2sJZINYw6/4dirceF/x3eeArN
         gg67ynVN41al/rm7UfDCLaqdOez7k/ua6F3uaQObkrooYDbNRPW7RR9hWTvM0x6aGWeV
         ZciPg3Lo3AZAzfGcx198Cgj/OhNc3hWJZGNacqH/+cTSIJcXlJSx+ayD6Ru279eHI/wn
         bSbtLam5C+abYq+pAvrOh8fxHefZdM8R1kXYZme1yRx0BhXfrC+uhJ1jH64X/makcAHO
         sZt4HsNYl/ebi9KIi0s91Oh+aisQ0/KPQuvVM1dsME3UPqnMP5TznkVugsgQ3fet2Svd
         Rb4w==
X-Gm-Message-State: AOAM533ODnf8Lqco1W97VE64GGfC9rVaXAEd4ApaaXuNMceINvrnIBU4
        +pMLc7cN+1nBLwIzuUWR/57u8EAPwRQ=
X-Google-Smtp-Source: ABdhPJw6jraLZqNII1iKQVZjM8c4QIGKz8TneMEk3IBk2HXa8KWx+4NKllZ+Amh5n47cnIrK7+b3EQ==
X-Received: by 2002:a17:902:7e85:b029:da:726a:3a4f with SMTP id z5-20020a1709027e85b02900da726a3a4fmr15915201pla.65.1610295009276;
        Sun, 10 Jan 2021 08:10:09 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id d6sm15525896pfo.199.2021.01.10.08.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 08:10:08 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V14 14/16] xfs: Compute bmap extent alignments in a separate function
Date:   Sun, 10 Jan 2021 21:37:18 +0530
Message-Id: <20210110160720.3922965-15-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110160720.3922965-1-chandanrlinux@gmail.com>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves over the code which computes stripe alignment and
extent size hint alignment into a separate function. Apart from
xfs_bmap_btalloc(), the new function will be used by another function
introduced in a future commit.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 89 +++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0b15b1ff4bdd..8955a0a938d5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3463,13 +3463,59 @@ xfs_bmap_btalloc_accounting(
 		args->len);
 }
 
+static int
+xfs_bmap_compute_alignments(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_extlen_t		align = 0; /* minimum allocation alignment */
+	int			stripe_align = 0;
+	int			error;
+
+	/* stripe alignment for allocation is determined by mount parameters */
+	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+		stripe_align = mp->m_swidth;
+	else if (mp->m_dalign)
+		stripe_align = mp->m_dalign;
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
+
+	return stripe_align;
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
@@ -3489,25 +3535,11 @@ xfs_bmap_btalloc(
 
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
 
+	stripe_align = xfs_bmap_compute_alignments(ap, &args);
 
 	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
@@ -3538,9 +3570,6 @@ xfs_bmap_btalloc(
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
-	memset(&args, 0, sizeof(args));
-	args.tp = ap->tp;
-	args.mp = mp;
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 
@@ -3571,21 +3600,7 @@ xfs_bmap_btalloc(
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
2.29.2


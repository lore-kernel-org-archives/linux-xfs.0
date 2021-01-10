Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77148C433E6
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B6E22A99
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAJDbM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbhAJDbM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:31:12 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6753BC0617BA
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:30:15 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e2so7707456plt.12
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w5kbC0J5zG4QEoJGS8pq+48lwW5EdhSbHeM6VkT9c1A=;
        b=buM2+LSDVyCAOvN9qmqXpIB5h2XKSAJ8w4TFiZjxev0rBbsZ8jm6fMwxRUDi45J2xc
         v/+Oq9o1Khl1W73A79l+qCHMXwLaBg/83za3A8proWdx0CBsrryuchU0Gs/1JrOQ3zW7
         M4H3psJBVqa8ppTnBowmWazAlEMVfeA+vfG1bW48V/iu8eRF+FWYRLk+63dm9iL/d5gV
         E5OtRrjdXzvx3jwU9ASbRaafeMil71dAglAFNNPk/OUq6h+6hPBfsnyByQaoaTiccKU3
         GmxWxY41zgqIo23sv96q+AhQyqEuhNnNQ06scSD7d//L0mHmuuQViIX50UHM9lVTJ++E
         GaZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w5kbC0J5zG4QEoJGS8pq+48lwW5EdhSbHeM6VkT9c1A=;
        b=M8cxbL8GFoHaEQt6If2oqZeo4gW/5uzBqDuniQ+x/rUPccq5/n34sbdsH/zMfJX8Mq
         PAKdslhYZSyPQoFVZQHK8FsKVuMyyA8NKt9KYC67hrCq7kJmFRXs7UuEnXHM4uGNcz1f
         Q+ioqUFZngp/uwiCGOxy3dy+hcqL3rTwEfWsOJzeuzegj7GZBq4E50omclVRmXPvq1ny
         1tL5cVNcGJh2ee1sSNw7AhB1LR7WSjhULczAVepTiEkjZ5PzLopz8/Eafb2gs3Tb/q9Y
         6tbiPf87+VZloehhGKfHnlUzmYkhwQAVbyOYtVj8+N3qjmP1Nnz5HLPc5KM8zM9lV2Mz
         SESw==
X-Gm-Message-State: AOAM532uFqSYZwqAlb5mAg/0/29PHZagyRp7cUKYxEcx0VQcbpcbYBDu
        ODTfpljmxYBXJc7T1FQuRdBL2b2D33krPw==
X-Google-Smtp-Source: ABdhPJw1MzEK9kmKMXp7VNS3aKA7VUqY9IfQx7LEN4nxQ+mq0E0TPZSWWFPacOQRsZdndCI9rDg3ng==
X-Received: by 2002:a17:90a:c8d:: with SMTP id v13mr11358054pja.75.1610249414814;
        Sat, 09 Jan 2021 19:30:14 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:30:14 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 14/16] xfs: Compute bmap extent alignments in a separate function
Date:   Sun, 10 Jan 2021 08:59:26 +0530
Message-Id: <20210110032928.3120861-15-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
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
index 0102aefcf4a6..ff4ca6c456c3 100644
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


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6DDC64E7A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED932468E
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WqO60eJb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732472AbgKQNpV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733209AbgKQNpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:45:19 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0B7C0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:19 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w6so17328410pfu.1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QiHkQlus2qgqmYvIyhwPk8dKwWaSPHNiqdeEZjmv2gQ=;
        b=WqO60eJbXErxXFtw5XNKxV5ML46antVrVuKvaItNwPD28yP/mTOBeTqSzyW7DVhuDe
         7Tvo/As4hfhTniMmF36+f+xegOLeN8AlSYMNxoauxqmC9lMnc9TPfbo4EIDobtDPtoVR
         hETxw1bb8aqGtFo0iXLeh4BBfq5NxeR2YYr+Z2260xhs6SD6kQDZI2THzlw8rQbB4MJw
         Z0Y06vYtkpEZrskY2hzrHw+mC8O7fjNadWOQU/yeYkEi+xItEcP2FmzpAP2Q6m0o8zen
         Hj65AC3txK3AlD32rM77B7rpljRdDUKy4WCWMracy/8P5hZYGOWZ2wNN/VidepnjWQ2X
         sCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QiHkQlus2qgqmYvIyhwPk8dKwWaSPHNiqdeEZjmv2gQ=;
        b=FLYOHG1K5CvRekSvcmCgMfVTtCT0FlbSPYTyy9sYa7DKxdW1110W+gDpcvF4ZgyynK
         bPvbSddKJ61xiV7CU5xgkrw2hpVmTScQ81U4i7xRieT5F1+O3yj+Dkq1mODnhXRJWxYy
         dmILuqQ+kMJe2xOJ6SeCTcxuZUYZIcbbaf/KXqEQHXA0GaVTzvNlkSHac9UsGtUvxMSE
         3DLlX0k8wL2tedJrENCUkbGO/nGnJA8NCL1KASqaqb7yrP3a0TFWkCwInJuLjNUVkmIp
         xkwUw8adFq1Uf6jKPw5TU5if5IW6BmRHp8ymWws9MhtcAiK/oeIbZjg6LjiPY+07ks3B
         bbEg==
X-Gm-Message-State: AOAM531zcIM8XH6t4PdrApXHWexcQo/Ut75REtiOS27QxMbxAkp9QovK
        umAl38/taAMKuHJGEPVwiV8JgwcRjqo=
X-Google-Smtp-Source: ABdhPJy/KHUhijCLzdsI88SyAZHxXiEGs+q1+0nAiQS9wbemmKUUzYQXGtGLJXLfMbdCfL5smP/m2Q==
X-Received: by 2002:a62:2c16:0:b029:15d:8d2:2e6d with SMTP id s22-20020a622c160000b029015d08d22e6dmr18541949pfs.52.1605620718827;
        Tue, 17 Nov 2020 05:45:18 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:45:18 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com
Subject: [PATCH V11 12/14] xfs: Compute bmap extent alignments in a separate function
Date:   Tue, 17 Nov 2020 19:14:14 +0530
Message-Id: <20201117134416.207945-13-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
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
index 64c4d0e384a5..5032539d5e85 100644
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
2.28.0


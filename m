Return-Path: <SRS0=fxM9=DK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BFCC4363D
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 023EC206F8
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eflDt7FA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJCF5P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF5P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Oct 2020 01:57:15 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6088FC0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 22:57:15 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d9so2948664pfd.3
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 22:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tXr55mjl3UmO57eYfVCWv0w8/2eCgxaYhZvrPvTy4lM=;
        b=eflDt7FAvgy/Btb2DiN/b/Y/lg16RZsySm5ZK46LOrS70imOzfBrG8LRQTCIhOA7jy
         S01Jj4p58Fbyx7t3VBKbgLTm9GimyJb+vWt/sUw92Oj7KHjB6kCNMD+IPgglWJX9rrm9
         0N/qHmVlU+9DSg/urWBwcnxlD6l9abP7bgVwhG+fh/qTpstAhShfjRKEOvlPsyFfnc0l
         jMCeJu2T9WccW4C/kFqzkPvds2DdQl1AuOegucGr3L9bJ3UW3e2kf6sZEQjPXqKO6FIH
         m4N7Ym3ORjZn8rpJNJU9C6ELH7qibKxWnArpRbICSgwRZYazGXz0+oT69TW5VVr32B+A
         IzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tXr55mjl3UmO57eYfVCWv0w8/2eCgxaYhZvrPvTy4lM=;
        b=UAbl37es8Kws4CP2oCXAUx2DC6AaiJpuxFTfYj4fnEMG+gj3A/llR/tKex7MUUL6Ky
         087v1mcWvSMBeeO5IxpMC8OL2P8HbjRpR49HzYeggPKWlYuAOT0XvI8+jwZFJF+6W6iI
         A2a5YKAoZZ/jDXeMhbxXKjeQl7ZadVtRe/PKXXrb6cgqpVsblCjz7wYHcySOjI1pHvhe
         GJr3qxPRZZ2okVC5/eDITZ3VfnhJM8watpd6YdWuf3rdQFCym1rP3x8mPMtrismdf912
         Ix3PUvUwPRNxz5FJfLeq+qgPnEkgdLxGVk33LaG+tjoOECBzM9J3iv7887SyepOUsKu7
         +Kaw==
X-Gm-Message-State: AOAM533Y7KU/lmrfToe5OJAAts/QAB3vtwz0cfx+VdQHXdAZECtdYCOR
        W+Gw0wXrW6+p2RaHLQOQFVrCP42ZWLpyHQ==
X-Google-Smtp-Source: ABdhPJwh6dCXjowmQJlfMRSsXeD5XJ9E+gDbpLroRSNsxv+msCcfv4wU3/6vTmeqhVR1hRq0zNL/nw==
X-Received: by 2002:a62:b40c:0:b029:142:6a8f:c2f8 with SMTP id h12-20020a62b40c0000b02901426a8fc2f8mr6325987pfn.32.1601704634437;
        Fri, 02 Oct 2020 22:57:14 -0700 (PDT)
Received: from localhost.localdomain ([122.171.168.96])
        by smtp.gmail.com with ESMTPSA id 125sm4106664pff.59.2020.10.02.22.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:57:13 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V5 12/12] xfs: Introduce error injection to allocate only minlen size extents for files
Date:   Sat,  3 Oct 2020 11:26:33 +0530
Message-Id: <20201003055633.9379-13-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201003055633.9379-1-chandanrlinux@gmail.com>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
helps userspace test programs to get xfs_bmap_btalloc() to always
allocate minlen sized extents.

This is required for test programs which need a guarantee that minlen
extents allocated for a file do not get merged with their existing
neighbours in the inode's BMBT. "Inode fork extent overflow check" for
Directories, Xattrs and extension of realtime inodes need this since the
file offset at which the extents are being allocated cannot be
explicitly controlled from userspace.

One way to use this error tag is to,
1. Consume all of the free space by sequentially writing to a file.
2. Punch alternate blocks of the file. This causes CNTBT to contain
   sufficient number of one block sized extent records.
3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
After step 3, xfs_bmap_btalloc() will issue space allocation
requests for minlen sized extents only.

ENOSPC error code is returned to userspace when there aren't any "one
block sized" extents left in any of the AGs.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_alloc.c    | 46 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h    |  1 +
 fs/xfs/libxfs/xfs_bmap.c     | 26 ++++++++++++++------
 fs/xfs/libxfs/xfs_errortag.h |  4 +++-
 fs/xfs/xfs_error.c           |  3 +++
 5 files changed, 72 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 852b536551b5..d8d8ab1478db 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2473,6 +2473,45 @@ xfs_defer_agfl_block(
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
 }
 
+STATIC int
+minlen_freespace_available(
+	struct xfs_alloc_arg	*args,
+	struct xfs_buf		*agbp,
+	int			*stat)
+{
+	xfs_btree_cur_t		*cnt_cur;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			btree_error = XFS_BTREE_NOERROR;
+	int			error = 0;
+
+	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
+			args->agno, XFS_BTNUM_CNT);
+	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
+	if (error) {
+		btree_error = XFS_BTREE_ERROR;
+		goto out;
+	}
+
+	ASSERT(*stat == 1);
+
+	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
+	if (error) {
+		btree_error = XFS_BTREE_ERROR;
+		goto out;
+	}
+
+	if (flen == args->minlen)
+		*stat = 1;
+	else
+		*stat = 0;
+
+out:
+	xfs_btree_del_cursor(cnt_cur, btree_error);
+
+	return error;
+}
+
 /*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
@@ -2490,6 +2529,7 @@ xfs_alloc_fix_freelist(
 	struct xfs_alloc_arg	targs;	/* local allocation arguments */
 	xfs_agblock_t		bno;	/* freelist block */
 	xfs_extlen_t		need;	/* total blocks needed in freelist */
+	int			i;
 	int			error = 0;
 
 	/* deferred ops (AGFL block frees) require permanent transactions */
@@ -2544,6 +2584,12 @@ xfs_alloc_fix_freelist(
 	if (!xfs_alloc_space_available(args, need, flags))
 		goto out_agbp_relse;
 
+	if (args->alloc_minlen_only) {
+		error = minlen_freespace_available(args, agbp, &i);
+		if (error || !i)
+			goto out_agbp_relse;
+	}
+
 	/*
 	 * Make the freelist shorter if it's too long.
 	 *
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 6c22b12176b8..1d04089b7fb4 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -75,6 +75,7 @@ typedef struct xfs_alloc_arg {
 	char		wasfromfl;	/* set if allocation is from freelist */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
+	bool		alloc_minlen_only;
 } xfs_alloc_arg_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5156cbd476f2..fab4097e7492 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3510,12 +3510,19 @@ xfs_bmap_btalloc(
 		ASSERT(ap->length);
 	}
 
+	memset(&args, 0, sizeof(args));
+
+	args.alloc_minlen_only = XFS_TEST_ERROR(false, mp,
+					XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 
 	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
 							ap->tp->t_firstblock);
 	if (nullfb) {
-		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+		if (args.alloc_minlen_only) {
+			ag = 0;
+			ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
+		} else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
 		    xfs_inode_is_filestream(ap->ip)) {
 			ag = xfs_filestream_lookup_ag(ap->ip);
 			ag = (ag != NULLAGNUMBER) ? ag : 0;
@@ -3523,10 +3530,12 @@ xfs_bmap_btalloc(
 		} else {
 			ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
 		}
-	} else
+	} else {
 		ap->blkno = ap->tp->t_firstblock;
+	}
 
-	xfs_bmap_adjacent(ap);
+	if (!args.alloc_minlen_only)
+		xfs_bmap_adjacent(ap);
 
 	/*
 	 * If allowed, use ap->blkno; otherwise must use firstblock since
@@ -3540,7 +3549,6 @@ xfs_bmap_btalloc(
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
-	memset(&args, 0, sizeof(args));
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->blkno;
@@ -3549,7 +3557,10 @@ xfs_bmap_btalloc(
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
 	blen = 0;
-	if (nullfb) {
+	if (args.alloc_minlen_only) {
+		args.type = XFS_ALLOCTYPE_START_AG;
+		args.total = args.minlen = args.maxlen = ap->minlen;
+	} else if (nullfb) {
 		/*
 		 * Search for an allocation group with a single extent large
 		 * enough for the request.  If one isn't found, then adjust
@@ -3595,7 +3606,8 @@ xfs_bmap_btalloc(
 	 * is only set if the allocation length is >= the stripe unit and the
 	 * allocation offset is at the end of file.
 	 */
-	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof) {
+	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof &&
+		!args.alloc_minlen_only) {
 		if (!ap->offset) {
 			args.alignment = stripe_align;
 			atype = args.type;
@@ -3681,7 +3693,7 @@ xfs_bmap_btalloc(
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
-	if (args.fsbno == NULLFSBLOCK && nullfb) {
+	if (args.fsbno == NULLFSBLOCK && nullfb && !args.alloc_minlen_only) {
 		args.fsbno = 0;
 		args.type = XFS_ALLOCTYPE_FIRST_AG;
 		args.total = ap->minlen;
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 1c56fcceeea6..6ca9084b6934 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -57,7 +57,8 @@
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
 #define XFS_ERRTAG_BUF_IOERROR				35
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
-#define XFS_ERRTAG_MAX					37
+#define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
+#define XFS_ERRTAG_MAX					38
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -99,5 +100,6 @@
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
+#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 3780b118cc47..028560bb596a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -55,6 +55,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_IUNLINK_FALLBACK,
 	XFS_RANDOM_BUF_IOERROR,
 	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
+	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 };
 
 struct xfs_errortag_attr {
@@ -166,6 +167,7 @@ XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
 XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
 XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
+XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent, XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -205,6 +207,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
 	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
 	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
+	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	NULL,
 };
 
-- 
2.28.0


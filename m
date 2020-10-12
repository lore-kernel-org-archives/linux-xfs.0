Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D3AC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 060B9208B6
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JvuoR37j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgJLJad (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 05:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729370AbgJLJad (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 05:30:33 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCFBC0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g29so13705502pgl.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j9Rw1cVTT1bMHjvLd0mv4CVViNSKLnoOYj4Pz/Seph8=;
        b=JvuoR37jX/zddQOzdKKLBm6RxI+b7VHrRInfdiFq0Tp6Icq8PyJJ231ObUfEdTefIo
         U5srh+EesHNalLpV4CepZlPxy2nMHl2bp+2FIlKmYJiQiMR6jTcwDW5D1n0EBo2pHlx2
         yHl1ap8h+H5aMDBBbmIAuP4xTt5jtD+ajLjPOLvOlF9XGx1TLRPEjC5heB33Zk+FN5ej
         4XrcRxur3sv58mW3qsg9EL6Lhev8Cxo7e6OO1xfmMSKnX056KXu7PhKtJnKssFGCgW3d
         U9lHnzSNEHcFEnQW9OmFs+76eUCOp0gIz2bBJ96AYd6UhWRVuISfbzL2X9Xllz9dLw28
         RI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j9Rw1cVTT1bMHjvLd0mv4CVViNSKLnoOYj4Pz/Seph8=;
        b=DuLI85dEfkLFhi/DWslsEylfIo0mtWJatA0ddyAQYr6/VuGzJulqzlWtnLaXbIbTv9
         xQOR0iHrqm5EZwSkdWozWmnIbHBPVlXyQJwoq+8hmcyhkatWAR9evB8r6ZlNMCGoOEWt
         ErY5XgnbWHjCxa2XXd92lwngGm7Lqtnt+Dq2GAXe+Hos7oqEQyxm3xtNSt+luF52j1qG
         nFuAwvMIPsJ9lFqMWJbB1ChGiDAyWgVdb+PHlPqh7N5T9Jno+4bifek/ondfYzyIZiTd
         +ZhJ72ls/AlnjAexcqiPG10kngMKIoLX5ekZK5NnwFC3vDQIKZLx6SozmVQm1oKhkbeg
         EuLw==
X-Gm-Message-State: AOAM532hJTczVKXTnHn96oCv8SlkiebGblmNt/5wxISsxstTOGjQx8W/
        PEGMSE+7fZR060nOgVtv0sZEfM9zfT4=
X-Google-Smtp-Source: ABdhPJxuc9pCcS67A6BeIoqO4lNQEQN3JnsgqRz8bTIhhzIHq+cd/64TavTMdXXUppk+POGpSUJo6A==
X-Received: by 2002:a17:90a:c90d:: with SMTP id v13mr18051004pjt.166.1602495032263;
        Mon, 12 Oct 2020 02:30:32 -0700 (PDT)
Received: from localhost.localdomain ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id z142sm19451985pfc.179.2020.10.12.02.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 02:30:31 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V6 11/11] xfs: Introduce error injection to allocate only minlen size extents for files
Date:   Mon, 12 Oct 2020 14:59:38 +0530
Message-Id: <20201012092938.50946-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012092938.50946-1-chandanrlinux@gmail.com>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
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
 fs/xfs/libxfs/xfs_bmap.c     | 34 ++++++++++++++++++++------
 fs/xfs/libxfs/xfs_errortag.h |  4 +++-
 fs/xfs/xfs_error.c           |  3 +++
 5 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 852b536551b5..42b776f93ff9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2473,6 +2473,45 @@ xfs_defer_agfl_block(
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
 }
 
+/*
+ * Check if an AGF has a free extent record whose length is equal to
+ * args->minlen.
+ */
+STATIC int
+xfs_exact_minlen_extent_available(
+	struct xfs_alloc_arg	*args,
+	struct xfs_buf		*agbp,
+	int			*stat)
+{
+	struct xfs_btree_cur	*cnt_cur;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			error = 0;
+
+	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
+			args->agno, XFS_BTNUM_CNT);
+	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
+	if (error)
+		goto out;
+
+	if (*stat == 0) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
+	if (error)
+		goto out;
+
+	if (*stat == 1 && flen != args->minlen)
+		*stat = 0;
+
+out:
+	xfs_btree_del_cursor(cnt_cur, error);
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
+		error = xfs_exact_minlen_extent_available(args, agbp, &i);
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
index 505358839d2f..981ab4cbf7ba 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3508,12 +3508,27 @@ xfs_bmap_btalloc(
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
+			/*
+			 * Unlike the longest extent available in an AG, we
+			 * don't track the length of an AG's shortest extent.
+			 * XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is a debug only
+			 * knob and hence we can afford to start traversing from
+			 * the 0th AG since we need not worry about a drop in
+			 * performance in "debug only" code paths.
+			 */
+			ag = 0;
+			ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
+		} else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
 		    xfs_inode_is_filestream(ap->ip)) {
 			ag = xfs_filestream_lookup_ag(ap->ip);
 			ag = (ag != NULLAGNUMBER) ? ag : 0;
@@ -3521,10 +3536,12 @@ xfs_bmap_btalloc(
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
@@ -3538,7 +3555,6 @@ xfs_bmap_btalloc(
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
-	memset(&args, 0, sizeof(args));
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->blkno;
@@ -3547,7 +3563,10 @@ xfs_bmap_btalloc(
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
 	blen = 0;
-	if (nullfb) {
+	if (args.alloc_minlen_only) {
+		args.type = XFS_ALLOCTYPE_FIRST_AG;
+		args.total = args.minlen = args.maxlen = ap->minlen;
+	} else if (nullfb) {
 		/*
 		 * Search for an allocation group with a single extent large
 		 * enough for the request.  If one isn't found, then adjust
@@ -3593,7 +3612,8 @@ xfs_bmap_btalloc(
 	 * is only set if the allocation length is >= the stripe unit and the
 	 * allocation offset is at the end of file.
 	 */
-	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof) {
+	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof &&
+	    !args.alloc_minlen_only) {
 		if (!ap->offset) {
 			args.alignment = stripe_align;
 			atype = args.type;
@@ -3679,7 +3699,7 @@ xfs_bmap_btalloc(
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
index 3780b118cc47..185b4915b7bf 100644
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
+XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 
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


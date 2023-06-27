Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9496CEB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 22:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjF0Wo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 18:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjF0Wo2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 18:44:28 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B51F2945
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:22 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-3a0423ea749so4126043b6e.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687905861; x=1690497861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HQFgV6ssEPI/mbuynXLID8AB1DFeefdovCY9d+I6BuQ=;
        b=QClWJY1CdrPrdWcb5pjZWkFt47ZfzXO6KAVf3efpVcz0hTmTmEB4kFALdPAEMjRal8
         lPkimnNmD/eKZK3jGmVuOoafB+vJCvEUeKpGC0887DfIPHAi95tJb5wYB/TdIoyZe0lY
         f2/bXcuCPKsbfSawx89zF8xUKNg1dBq8lnZ/UmfMbe6isWyHPkXLkhT4LA4i2NGm9QYI
         /ec7EfJpPqZ0N4nV8jaXhXSS8nT6aYq1Rw6lUyLu3Xgg4c2xRxMb2FAKjTelr7RdDmfO
         J0nqkrTub/7/6bfStYdDPZ5pxthkC6XA1pZdqh1JNYgGXP/oFiiVvaoPDPd4sicpW2Kd
         9Ygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687905861; x=1690497861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HQFgV6ssEPI/mbuynXLID8AB1DFeefdovCY9d+I6BuQ=;
        b=Tk8X5XAj853vTgLtCZjYzDm8yHH3u2o/MjqzJVRECPeKQ/DCNPw+nuMsnZOL6j4lDZ
         75R9MbVsFfwjtQKmsc0qtts2Fqj5EMSL6QHLSL42wQmrpOFC97+Qxzu3c0GTYKNpTDmB
         CI71jFaw596OkJAbQ+MtVxnyIvoUcjLg+GRnVeIvgPbmmDwILzFVu7YWC6SfJLsFyJLG
         rJy7sESyIYcTrLbYkHYfv4dViSQFEQB3Gk2qm250XbLO0RURRjxNQEl3jyYGWFLqh/pg
         WGHj+ErOKGbZ1wZGFur0l4oWo3ueCKb2lWNgYg/AlyIVirm0BdyS8ug81jix1pevDiJ8
         YcZA==
X-Gm-Message-State: AC+VfDxyb1BejIYWFxSeqRd8lp+sAc0J7u5Iu038um+xiWS6yHutu2on
        ApnHE/QrNBKj/Ou2S1M/Dbx9r5oVxfB9ziCUk7w=
X-Google-Smtp-Source: ACHHUZ6d4ehbGkUOlK4xHgqtEh9YG6Z1t9rHGr6CbaVatR/Woe8u/fii0I+NxjmB1tZ1G2cGOpQzeg==
X-Received: by 2002:a05:6808:1983:b0:3a1:e222:97db with SMTP id bj3-20020a056808198300b003a1e22297dbmr6994023oib.30.1687905861650;
        Tue, 27 Jun 2023 15:44:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id 29-20020a17090a199d00b0026334010a4fsm520032pji.35.2023.06.27.15.44.18
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 15:44:20 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qEHPz-00GzwV-1C
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qEHPz-009ZmB-01
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: use deferred frees for btree block freeing
Date:   Wed, 28 Jun 2023 08:44:06 +1000
Message-Id: <20230627224412.2242198-3-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230627224412.2242198-1-david@fromorbit.com>
References: <20230627224412.2242198-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Btrees that aren't freespace management trees use the normal extent
allocation and freeing routines for their blocks. Hence when a btree
block is freed, a direct call to xfs_free_extent() is made and the
extent is immediately freed. This puts the entire free space
management btrees under this path, so we are stacking btrees on
btrees in the call stack. The inobt, finobt and refcount btrees
all do this.

However, the bmap btree does not do this - it calls
xfs_free_extent_later() to defer the extent free operation via an
XEFI and hence it gets processed in deferred operation processing
during the commit of the primary transaction (i.e. via intent
chaining).

We need to change xfs_free_extent() to behave in a non-blocking
manner so that we can avoid deadlocks with busy extents near ENOSPC
in transactions that free multiple extents. Inserting or removing a
record from a btree can cause a multi-level tree merge operation and
that will free multiple blocks from the btree in a single
transaction. i.e. we can call xfs_free_extent() multiple times, and
hence the btree manipulation transaction is vulnerable to this busy
extent deadlock vector.

To fix this, convert all the remaining callers of xfs_free_extent()
to use xfs_free_extent_later() to queue XEFIs and hence defer
processing of the extent frees to a context that can be safely
restarted if a deadlock condition is detected.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c             | 2 +-
 fs/xfs/libxfs/xfs_alloc.c          | 4 ++++
 fs/xfs/libxfs/xfs_alloc.h          | 8 +++++---
 fs/xfs/libxfs/xfs_bmap.c           | 8 +++++---
 fs/xfs/libxfs/xfs_bmap_btree.c     | 3 ++-
 fs/xfs/libxfs/xfs_ialloc.c         | 8 ++++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   | 3 +--
 fs/xfs/libxfs/xfs_refcount.c       | 9 ++++++---
 fs/xfs/libxfs/xfs_refcount_btree.c | 8 +-------
 fs/xfs/xfs_extfree_item.c          | 3 ++-
 fs/xfs/xfs_reflink.c               | 3 ++-
 11 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index ee84835ebc66..e9cc481b4ddf 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -985,7 +985,7 @@ xfs_ag_shrink_space(
 			goto resv_err;
 
 		err2 = __xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
-				true);
+				XFS_AG_RESV_NONE, true);
 		if (err2)
 			goto resv_err;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c20fe99405d8..cc3f7b905ea1 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2449,6 +2449,7 @@ xfs_defer_agfl_block(
 	xefi->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
 	xefi->xefi_blockcount = 1;
 	xefi->xefi_owner = oinfo->oi_owner;
+	xefi->xefi_type = XFS_AG_RESV_AGFL;
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, xefi->xefi_startblock)))
 		return -EFSCORRUPTED;
@@ -2470,6 +2471,7 @@ __xfs_free_extent_later(
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo,
+	enum xfs_ag_resv_type		type,
 	bool				skip_discard)
 {
 	struct xfs_extent_free_item	*xefi;
@@ -2490,6 +2492,7 @@ __xfs_free_extent_later(
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
 	ASSERT(xfs_extfree_item_cache != NULL);
+	ASSERT(type != XFS_AG_RESV_AGFL);
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
 		return -EFSCORRUPTED;
@@ -2498,6 +2501,7 @@ __xfs_free_extent_later(
 			       GFP_KERNEL | __GFP_NOFAIL);
 	xefi->xefi_startblock = bno;
 	xefi->xefi_blockcount = (xfs_extlen_t)len;
+	xefi->xefi_type = type;
 	if (skip_discard)
 		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
 	if (oinfo) {
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 85ac470be0da..121faf1e11ad 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -232,7 +232,7 @@ xfs_buf_to_agfl_bno(
 
 int __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
 		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
-		bool skip_discard);
+		enum xfs_ag_resv_type type, bool skip_discard);
 
 /*
  * List of extents to be free "later".
@@ -245,6 +245,7 @@ struct xfs_extent_free_item {
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
 	struct xfs_perag	*xefi_pag;
 	unsigned int		xefi_flags;
+	enum xfs_ag_resv_type	xefi_type;
 };
 
 void xfs_extent_free_get_group(struct xfs_mount *mp,
@@ -259,9 +260,10 @@ xfs_free_extent_later(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
-	const struct xfs_owner_info	*oinfo)
+	const struct xfs_owner_info	*oinfo,
+	enum xfs_ag_resv_type		type)
 {
-	return __xfs_free_extent_later(tp, bno, len, oinfo, false);
+	return __xfs_free_extent_later(tp, bno, len, oinfo, type, false);
 }
 
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fef35696adb7..30c931b38853 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -574,7 +574,8 @@ xfs_bmap_btree_to_extents(
 		return error;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
-	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
+	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo,
+			XFS_AG_RESV_NONE);
 	if (error)
 		return error;
 
@@ -5236,8 +5237,9 @@ xfs_bmap_del_extent_real(
 		} else {
 			error = __xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
-					(bflags & XFS_BMAPI_NODISCARD) ||
-					del->br_state == XFS_EXT_UNWRITTEN);
+					XFS_AG_RESV_NONE,
+					((bflags & XFS_BMAPI_NODISCARD) ||
+					del->br_state == XFS_EXT_UNWRITTEN));
 			if (error)
 				goto done;
 		}
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 36564ae3084f..bf3f1b36fdd2 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -271,7 +271,8 @@ xfs_bmbt_free_block(
 	int			error;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
-	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
+	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo,
+			XFS_AG_RESV_NONE);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 34600f94c2f4..1e5fafbc0cdb 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1853,8 +1853,8 @@ xfs_difree_inode_chunk(
 		/* not sparse, calculate extent info directly */
 		return xfs_free_extent_later(tp,
 				XFS_AGB_TO_FSB(mp, agno, sagbno),
-				M_IGEO(mp)->ialloc_blks,
-				&XFS_RMAP_OINFO_INODES);
+				M_IGEO(mp)->ialloc_blks, &XFS_RMAP_OINFO_INODES,
+				XFS_AG_RESV_NONE);
 	}
 
 	/* holemask is only 16-bits (fits in an unsigned long) */
@@ -1899,8 +1899,8 @@ xfs_difree_inode_chunk(
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		error = xfs_free_extent_later(tp,
-				XFS_AGB_TO_FSB(mp, agno, agbno),
-				contigblk, &XFS_RMAP_OINFO_INODES);
+				XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
+				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 5a945ae21b5d..9258f01c0015 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -160,8 +160,7 @@ __xfs_inobt_free_block(
 
 	xfs_inobt_mod_blockcount(cur, -1);
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
-	return xfs_free_extent(cur->bc_tp, cur->bc_ag.pag,
-			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1,
+	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
 			&XFS_RMAP_OINFO_INOBT, resv);
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index b6e21433925c..70ab113c9cea 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1152,7 +1152,8 @@ xfs_refcount_adjust_extents(
 						cur->bc_ag.pag->pag_agno,
 						tmp.rc_startblock);
 				error = xfs_free_extent_later(cur->bc_tp, fsbno,
-						  tmp.rc_blockcount, NULL);
+						  tmp.rc_blockcount, NULL,
+						  XFS_AG_RESV_NONE);
 				if (error)
 					goto out_error;
 			}
@@ -1213,7 +1214,8 @@ xfs_refcount_adjust_extents(
 					cur->bc_ag.pag->pag_agno,
 					ext.rc_startblock);
 			error = xfs_free_extent_later(cur->bc_tp, fsbno,
-					ext.rc_blockcount, NULL);
+					ext.rc_blockcount, NULL,
+					XFS_AG_RESV_NONE);
 			if (error)
 				goto out_error;
 		}
@@ -1981,7 +1983,8 @@ xfs_refcount_recover_cow_leftovers(
 
 		/* Free the block. */
 		error = xfs_free_extent_later(tp, fsb,
-				rr->rr_rrec.rc_blockcount, NULL);
+				rr->rr_rrec.rc_blockcount, NULL,
+				XFS_AG_RESV_NONE);
 		if (error)
 			goto out_trans;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index d4afc5f4e6a5..5c3987d8dc24 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -106,19 +106,13 @@ xfs_refcountbt_free_block(
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
-	int			error;
 
 	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
 			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
-	error = xfs_free_extent(cur->bc_tp, cur->bc_ag.pag,
-			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1,
+	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
 			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA);
-	if (error)
-		return error;
-
-	return error;
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f9e36b810663..79e65bb6b0a2 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -365,7 +365,7 @@ xfs_trans_free_extent(
 			agbno, xefi->xefi_blockcount);
 
 	error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
-			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
+			xefi->xefi_blockcount, &oinfo, xefi->xefi_type,
 			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
 
 	/*
@@ -644,6 +644,7 @@ xfs_efi_item_recover(
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		struct xfs_extent_free_item	fake = {
 			.xefi_owner		= XFS_RMAP_OWN_UNKNOWN,
+			.xefi_type		= XFS_AG_RESV_NONE,
 		};
 		struct xfs_extent		*extp;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index abcc559f3c64..eb9102453aff 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -617,7 +617,8 @@ xfs_reflink_cancel_cow_blocks(
 					del.br_blockcount);
 
 			error = xfs_free_extent_later(*tpp, del.br_startblock,
-					  del.br_blockcount, NULL);
+					del.br_blockcount, NULL,
+					XFS_AG_RESV_NONE);
 			if (error)
 				break;
 
-- 
2.40.1


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC60BC7EE2F
	for <linux-xfs@archiver.kernel.org>; Mon, 29 May 2023 00:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjE2AIg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 May 2023 20:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjE2AIf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 May 2023 20:08:35 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F45BE
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 17:08:33 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b011cffef2so24085325ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 28 May 2023 17:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685318913; x=1687910913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=56fvRqW/uaU/oX36wfYzyJdFriabNBFT3+nLS451iG8=;
        b=YSpo1tkVjRw0/1Ab53tMloXfdK8wWFob0dULoMmrz98SgYTtB+orLsq6p7KCEnpqkt
         ynARTOBPoBmn9rJHaAZt6Eb5/CXOdgICL+s0Yz5kPQ7MI2GxoKsEja9MERadaacRzjM+
         b6HBjdPpiWcmddhJAv5Gi820ycVDQC4X7yygK403/1GbnPLDct4QbRqfP33g68DOL1sJ
         ZzCSaFVtqcVtdq69ui8N8ydjeIqkRp4zQgmxMOhuZADNcQt9p/k7/8TABRdbh5/hXlw/
         OkGYWP72S564KNvBWvXOgO7geqiA4rjpzNecxEKrk4Skt+IDd4qFwp6SGiA9lDwkxNQY
         WMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685318913; x=1687910913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=56fvRqW/uaU/oX36wfYzyJdFriabNBFT3+nLS451iG8=;
        b=e8Ugn/2fSrI2UXkrdv0sJAJu2JMOdEG5wRMtpBfeE8d0fxw2RjDI5zxcruMoFL8ut4
         YC+h00Pkg3B16cv8mGA+kNCe6PHQZuJc2e0HWxGzsqnrtgaLwvWWg72PIoxi9DnBlANS
         3kpp3f7DMPfCmId1L0vrBBUqdgdDq4Afr/+pxu3eRBvemE/0r/3YOy91m6A853w4mnjZ
         Un03MU/Xe9LMyxVlRmFlImcnaYa7DOprwnNs8X8XBf9lTmMUXmby5811CI+CRLFnMFTi
         GoZhvC02r29DLEjgemiUPrWnURSqfoI41CR9KoB2cXihmvRk5moTD6F+Js1wDm3dTNGr
         bfPA==
X-Gm-Message-State: AC+VfDwoCwGQ//CPPhjcmYApF/2wBFBo3sbhf5/Y7z5v6HBHghpFJbXE
        HObxD/EfPbf6tHK+P0RRMSvbmxxewh7vfXWyDN4=
X-Google-Smtp-Source: ACHHUZ5P8Y4ZaIlS2WGlmoKlm0/JfuLMU9t9f6cP5xBhLZitm5vYqOOM7NwRLYmoS0OoxXeYaxHPvA==
X-Received: by 2002:a17:903:182:b0:1af:d812:d16 with SMTP id z2-20020a170903018200b001afd8120d16mr11078966plg.21.1685318912696;
        Sun, 28 May 2023 17:08:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id e3-20020a170902744300b001b02df0ddbbsm2591344plt.275.2023.05.28.17.08.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 17:08:31 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1q3QR2-005764-2x
        for linux-xfs@vger.kernel.org;
        Mon, 29 May 2023 10:08:28 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1q3QR2-00A6Va-1n
        for linux-xfs@vger.kernel.org;
        Mon, 29 May 2023 10:08:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: validate block number being freed before adding to xefi
Date:   Mon, 29 May 2023 10:08:25 +1000
Message-Id: <20230529000825.2325477-4-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529000825.2325477-1-david@fromorbit.com>
References: <20230529000825.2325477-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Bad things happen in defered extent freeing operations if it is
passed a bad block number in the xefi. This can come from a bogus
agno/agbno pair from deferred agfl freeing, or just a bad fsbno
being passed to __xfs_free_extent_later(). Either way, it's very
difficult to diagnose where a null perag oops in EFI creation
is coming from when the operation that queued the xefi has already
been completed and there's no longer any trace of it around....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c         |  5 ++++-
 fs/xfs/libxfs/xfs_alloc.c      | 16 +++++++++++++---
 fs/xfs/libxfs/xfs_alloc.h      |  6 +++---
 fs/xfs/libxfs/xfs_bmap.c       | 10 ++++++++--
 fs/xfs/libxfs/xfs_bmap_btree.c |  7 +++++--
 fs/xfs/libxfs/xfs_ialloc.c     | 24 ++++++++++++++++--------
 fs/xfs/libxfs/xfs_refcount.c   | 13 ++++++++++---
 fs/xfs/xfs_reflink.c           |  4 +++-
 8 files changed, 62 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9b373a0c7aaf..ee84835ebc66 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -984,7 +984,10 @@ xfs_ag_shrink_space(
 		if (err2 != -ENOSPC)
 			goto resv_err;
 
-		__xfs_free_extent_later(*tpp, args.fsbno, delta, NULL, true);
+		err2 = __xfs_free_extent_later(*tpp, args.fsbno, delta, NULL,
+				true);
+		if (err2)
+			goto resv_err;
 
 		/*
 		 * Roll the transaction before trying to re-init the per-ag
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 643d17877832..c20fe99405d8 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2431,7 +2431,7 @@ xfs_agfl_reset(
  * the real allocation can proceed. Deferring the free disconnects freeing up
  * the AGFL slot from freeing the block.
  */
-STATIC void
+static int
 xfs_defer_agfl_block(
 	struct xfs_trans		*tp,
 	xfs_agnumber_t			agno,
@@ -2450,17 +2450,21 @@ xfs_defer_agfl_block(
 	xefi->xefi_blockcount = 1;
 	xefi->xefi_owner = oinfo->oi_owner;
 
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, xefi->xefi_startblock)))
+		return -EFSCORRUPTED;
+
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
 	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &xefi->xefi_list);
+	return 0;
 }
 
 /*
  * Add the extent to the list of extents to be free at transaction end.
  * The list is maintained sorted (by block number).
  */
-void
+int
 __xfs_free_extent_later(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
@@ -2487,6 +2491,9 @@ __xfs_free_extent_later(
 #endif
 	ASSERT(xfs_extfree_item_cache != NULL);
 
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
+		return -EFSCORRUPTED;
+
 	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
 	xefi->xefi_startblock = bno;
@@ -2510,6 +2517,7 @@ __xfs_free_extent_later(
 
 	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
+	return 0;
 }
 
 #ifdef DEBUG
@@ -2670,7 +2678,9 @@ xfs_alloc_fix_freelist(
 			goto out_agbp_relse;
 
 		/* defer agfl frees */
-		xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
+		error = xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
+		if (error)
+			goto out_agbp_relse;
 	}
 
 	targs.tp = tp;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 5dbb25546d0b..85ac470be0da 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -230,7 +230,7 @@ xfs_buf_to_agfl_bno(
 	return bp->b_addr;
 }
 
-void __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
+int __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
 		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
 		bool skip_discard);
 
@@ -254,14 +254,14 @@ void xfs_extent_free_get_group(struct xfs_mount *mp,
 #define XFS_EFI_ATTR_FORK	(1U << 1) /* freeing attr fork block */
 #define XFS_EFI_BMBT_BLOCK	(1U << 2) /* freeing bmap btree block */
 
-static inline void
+static inline int
 xfs_free_extent_later(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
 	const struct xfs_owner_info	*oinfo)
 {
-	__xfs_free_extent_later(tp, bno, len, oinfo, false);
+	return __xfs_free_extent_later(tp, bno, len, oinfo, false);
 }
 
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cd8870a16fd1..fef35696adb7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -572,8 +572,12 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
+
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
-	xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
+	error = xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
+	if (error)
+		return error;
+
 	ip->i_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -5230,10 +5234,12 @@ xfs_bmap_del_extent_real(
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else {
-			__xfs_free_extent_later(tp, del->br_startblock,
+			error = __xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL,
 					(bflags & XFS_BMAPI_NODISCARD) ||
 					del->br_state == XFS_EXT_UNWRITTEN);
+			if (error)
+				goto done;
 		}
 	}
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 1b40e5f8b1ec..36564ae3084f 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -268,11 +268,14 @@ xfs_bmbt_free_block(
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 	struct xfs_owner_info	oinfo;
+	int			error;
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
-	xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
+	error = xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
+	if (error)
+		return error;
+
 	ip->i_nblocks--;
-
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a16d5de16933..34600f94c2f4 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1834,7 +1834,7 @@ xfs_dialloc(
  * might be sparse and only free the regions that are allocated as part of the
  * chunk.
  */
-STATIC void
+static int
 xfs_difree_inode_chunk(
 	struct xfs_trans		*tp,
 	xfs_agnumber_t			agno,
@@ -1851,10 +1851,10 @@ xfs_difree_inode_chunk(
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
-		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
-				  M_IGEO(mp)->ialloc_blks,
-				  &XFS_RMAP_OINFO_INODES);
-		return;
+		return xfs_free_extent_later(tp,
+				XFS_AGB_TO_FSB(mp, agno, sagbno),
+				M_IGEO(mp)->ialloc_blks,
+				&XFS_RMAP_OINFO_INODES);
 	}
 
 	/* holemask is only 16-bits (fits in an unsigned long) */
@@ -1871,6 +1871,8 @@ xfs_difree_inode_chunk(
 						XFS_INOBT_HOLEMASK_BITS);
 	nextbit = startidx + 1;
 	while (startidx < XFS_INOBT_HOLEMASK_BITS) {
+		int error;
+
 		nextbit = find_next_zero_bit(holemask, XFS_INOBT_HOLEMASK_BITS,
 					     nextbit);
 		/*
@@ -1896,8 +1898,11 @@ xfs_difree_inode_chunk(
 
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
-		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
-				  contigblk, &XFS_RMAP_OINFO_INODES);
+		error = xfs_free_extent_later(tp,
+				XFS_AGB_TO_FSB(mp, agno, agbno),
+				contigblk, &XFS_RMAP_OINFO_INODES);
+		if (error)
+			return error;
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;
@@ -1905,6 +1910,7 @@ xfs_difree_inode_chunk(
 next:
 		nextbit++;
 	}
+	return 0;
 }
 
 STATIC int
@@ -2003,7 +2009,9 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		xfs_difree_inode_chunk(tp, pag->pag_agno, &rec);
+		error = xfs_difree_inode_chunk(tp, pag->pag_agno, &rec);
+		if (error)
+			goto error0;
 	} else {
 		xic->deleted = false;
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index c1c65774dcc2..b6e21433925c 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1151,8 +1151,10 @@ xfs_refcount_adjust_extents(
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 						cur->bc_ag.pag->pag_agno,
 						tmp.rc_startblock);
-				xfs_free_extent_later(cur->bc_tp, fsbno,
+				error = xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, NULL);
+				if (error)
+					goto out_error;
 			}
 
 			(*agbno) += tmp.rc_blockcount;
@@ -1210,8 +1212,10 @@ xfs_refcount_adjust_extents(
 			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
 					cur->bc_ag.pag->pag_agno,
 					ext.rc_startblock);
-			xfs_free_extent_later(cur->bc_tp, fsbno,
+			error = xfs_free_extent_later(cur->bc_tp, fsbno,
 					ext.rc_blockcount, NULL);
+			if (error)
+				goto out_error;
 		}
 
 skip:
@@ -1976,7 +1980,10 @@ xfs_refcount_recover_cow_leftovers(
 				rr->rr_rrec.rc_blockcount);
 
 		/* Free the block. */
-		xfs_free_extent_later(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
+		error = xfs_free_extent_later(tp, fsb,
+				rr->rr_rrec.rc_blockcount, NULL);
+		if (error)
+			goto out_trans;
 
 		error = xfs_trans_commit(tp);
 		if (error)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index f5dc46ce9803..abcc559f3c64 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -616,8 +616,10 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_refcount_free_cow_extent(*tpp, del.br_startblock,
 					del.br_blockcount);
 
-			xfs_free_extent_later(*tpp, del.br_startblock,
+			error = xfs_free_extent_later(*tpp, del.br_startblock,
 					  del.br_blockcount, NULL);
+			if (error)
+				break;
 
 			/* Roll the transaction */
 			error = xfs_defer_finish(tpp);
-- 
2.40.1


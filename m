Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3260CCA482
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 16:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241510AbiFFQFw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 12:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241491AbiFFQFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 12:05:51 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FFE188E63;
        Mon,  6 Jun 2022 09:05:49 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l2-20020a05600c4f0200b0039c55c50482so240054wmq.0;
        Mon, 06 Jun 2022 09:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cI/QuW66ym5PzfqEi96jpvK+GY/6pjcHFsCHEDRkUFQ=;
        b=O17/BPbigX34v+0ysF3t2fD/1uv7eMjOkl7mFqyB6KoA0qYrXJX6S1rUDpvgKQTzNX
         LhThFTXxClujAH09HqzxxlAZnodZiz6sUm5ISSHA68ARTh7+5yinp0zRyK9cq5sgcTZb
         /LulxFBEPPIn4RoxajBE8k9qiMEByj5bpvBxRi/hGQXtuYqLAkDHepr2NZdMxscUijsR
         OgQ4S49szvJNYNs8I4Tkmeeh657F2rRsNr6BZ+2Ht/hfVwg/cDB9417iq15saEzaE2YG
         X1rtxKhtCHhcReJxEAc7GvOZAVIbBSwaSPHvM+VSW0eWSDwVfC2wUAO6Q/mLDF70ehnY
         xQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cI/QuW66ym5PzfqEi96jpvK+GY/6pjcHFsCHEDRkUFQ=;
        b=Z8rlpVcdIrOEcXqQZbCvgojkkopMo+55umWiWlXzA5uHNcqHgIV0LqXh5Mh871BoJb
         MRl6JkD7F8ONGirFv6Ag1FYRszoh7Fl3jbHjsuLhMXXHyuwoHYFtNbG7fa53gWXxQI48
         UnAzId41pTXA7z8A6xYYjV542sA2Kx2FVGzpelRl+0GUlbe4hs/KiXlt+3x93W27ek09
         XQOvVhxD/4sdLGD+KsClZGb/KrZ8tje7Ggg7mu3Yx1O0+T5NB9PV+SUEsOzQFXeuABik
         adzBWSrif3EZfQnVknL5kQ0LWqopTQ3Grcl8ukiVpe0Y0FZvF+yAsOSX23f+K5NHBCqS
         bS/Q==
X-Gm-Message-State: AOAM532jGEM3LNm3qnhqI1xicDSjdFhHvfpmBORe4J+v7bdsGjRulY3v
        4u7o8o0Zztk/isRThD8D+GeFYj4eopGlsQ==
X-Google-Smtp-Source: ABdhPJx/1XKO/iwTbcSOiabdMcchwCbB0VFn3XFrHKjAYDIEww0Sxv712WI/g5/2aLomNC+sWBnRwQ==
X-Received: by 2002:a1c:4d0d:0:b0:397:30f6:b62b with SMTP id o13-20020a1c4d0d000000b0039730f6b62bmr52571028wmh.155.1654531548260;
        Mon, 06 Jun 2022 09:05:48 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c3b9600b00397342e3830sm25681327wms.0.2022.06.06.09.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 09:05:47 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 1/7] xfs: use current->journal_info for detecting transaction recursion
Date:   Mon,  6 Jun 2022 19:05:31 +0300
Message-Id: <20220606160537.689915-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606160537.689915-1-amir73il@gmail.com>
References: <20220606160537.689915-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 756b1c343333a5aefcc26b0409f3fd16f72281bf upstream.

Because the iomap code using PF_MEMALLOC_NOFS to detect transaction
recursion in XFS is just wrong. Remove it from the iomap code and
replace it with XFS specific internal checks using
current->journal_info instead.

[djwong: This change also realigns the lifetime of NOFS flag changes to
match the incore transaction, instead of the inconsistent scheme we have
now.]

Fixes: 9070733b4efa ("xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/iomap/buffered-io.c    |  7 -------
 fs/xfs/libxfs/xfs_btree.c | 12 ++++++++++--
 fs/xfs/xfs_aops.c         | 17 +++++++++++++++--
 fs/xfs/xfs_trans.c        | 20 +++++---------------
 fs/xfs/xfs_trans.h        | 30 ++++++++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 26 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index cd9f7baa5bb7..47279fe00b1a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1459,13 +1459,6 @@ iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
 			PF_MEMALLOC))
 		goto redirty;
 
-	/*
-	 * Given that we do not allow direct reclaim to call us, we should
-	 * never be called in a recursive filesystem reclaim context.
-	 */
-	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
-		goto redirty;
-
 	/*
 	 * Is this page beyond the end of the file?
 	 *
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 98c82f4935e1..24c7d30e41df 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2811,7 +2811,7 @@ xfs_btree_split_worker(
 	struct xfs_btree_split_args	*args = container_of(work,
 						struct xfs_btree_split_args, work);
 	unsigned long		pflags;
-	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
+	unsigned long		new_pflags = 0;
 
 	/*
 	 * we are in a transaction context here, but may also be doing work
@@ -2823,12 +2823,20 @@ xfs_btree_split_worker(
 		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 
 	current_set_flags_nested(&pflags, new_pflags);
+	xfs_trans_set_context(args->cur->bc_tp);
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
-	complete(args->done);
 
+	xfs_trans_clear_context(args->cur->bc_tp);
 	current_restore_flags_nested(&pflags, new_pflags);
+
+	/*
+	 * Do not access args after complete() has run here. We don't own args
+	 * and the owner may run and free args before we return here.
+	 */
+	complete(args->done);
+
 }
 
 /*
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4304c6416fbb..b4186d666157 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -62,7 +62,7 @@ xfs_setfilesize_trans_alloc(
 	 * We hand off the transaction to the completion thread now, so
 	 * clear the flag here.
 	 */
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	xfs_trans_clear_context(tp);
 	return 0;
 }
 
@@ -125,7 +125,7 @@ xfs_setfilesize_ioend(
 	 * thus we need to mark ourselves as being in a transaction manually.
 	 * Similarly for freeze protection.
 	 */
-	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	xfs_trans_set_context(tp);
 	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
 
 	/* we abort the update if there was an IO error */
@@ -568,6 +568,12 @@ xfs_vm_writepage(
 {
 	struct xfs_writepage_ctx wpc = { };
 
+	if (WARN_ON_ONCE(current->journal_info)) {
+		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
+		return 0;
+	}
+
 	return iomap_writepage(page, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
 
@@ -578,6 +584,13 @@ xfs_vm_writepages(
 {
 	struct xfs_writepage_ctx wpc = { };
 
+	/*
+	 * Writing back data in a transaction context can result in recursive
+	 * transactions. This is bad, so issue a warning and get out of here.
+	 */
+	if (WARN_ON_ONCE(current->journal_info))
+		return 0;
+
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c94e71f741b6..2d7deacea2cf 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -68,6 +68,7 @@ xfs_trans_free(
 	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
 	trace_xfs_trans_free(tp, _RET_IP_);
+	xfs_trans_clear_context(tp);
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_end_intwrite(tp->t_mountp->m_super);
 	xfs_trans_free_dqinfo(tp);
@@ -119,7 +120,8 @@ xfs_trans_dup(
 
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
-	ntp->t_pflags = tp->t_pflags;
+
+	xfs_trans_switch_context(tp, ntp);
 
 	/* move deferred ops over to the new tp */
 	xfs_defer_move(ntp, tp);
@@ -153,9 +155,6 @@ xfs_trans_reserve(
 	int			error = 0;
 	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
-	/* Mark this thread as being in a transaction */
-	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	/*
 	 * Attempt to reserve the needed disk blocks by decrementing
 	 * the number needed from the number available.  This will
@@ -163,10 +162,8 @@ xfs_trans_reserve(
 	 */
 	if (blocks > 0) {
 		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
-		if (error != 0) {
-			current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+		if (error != 0)
 			return -ENOSPC;
-		}
 		tp->t_blk_res += blocks;
 	}
 
@@ -240,9 +237,6 @@ xfs_trans_reserve(
 		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
-
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	return error;
 }
 
@@ -266,6 +260,7 @@ xfs_trans_alloc(
 	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
+	xfs_trans_set_context(tp);
 
 	/*
 	 * Zero-reservation ("empty") transactions can't modify anything, so
@@ -878,7 +873,6 @@ __xfs_trans_commit(
 
 	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
 
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free(tp);
 
 	/*
@@ -910,7 +904,6 @@ __xfs_trans_commit(
 			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
 		tp->t_ticket = NULL;
 	}
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free_items(tp, !!error);
 	xfs_trans_free(tp);
 
@@ -970,9 +963,6 @@ xfs_trans_cancel(
 		tp->t_ticket = NULL;
 	}
 
-	/* mark this thread as no longer being in a transaction */
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	xfs_trans_free_items(tp, dirty);
 	xfs_trans_free(tp);
 }
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 084658946cc8..075eeade4f7d 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -268,4 +268,34 @@ xfs_trans_item_relog(
 	return lip->li_ops->iop_relog(lip, tp);
 }
 
+static inline void
+xfs_trans_set_context(
+	struct xfs_trans	*tp)
+{
+	ASSERT(current->journal_info == NULL);
+	tp->t_pflags = memalloc_nofs_save();
+	current->journal_info = tp;
+}
+
+static inline void
+xfs_trans_clear_context(
+	struct xfs_trans	*tp)
+{
+	if (current->journal_info == tp) {
+		memalloc_nofs_restore(tp->t_pflags);
+		current->journal_info = NULL;
+	}
+}
+
+static inline void
+xfs_trans_switch_context(
+	struct xfs_trans	*old_tp,
+	struct xfs_trans	*new_tp)
+{
+	ASSERT(current->journal_info == old_tp);
+	new_tp->t_pflags = old_tp->t_pflags;
+	old_tp->t_pflags = 0;
+	current->journal_info = new_tp;
+}
+
 #endif	/* __XFS_TRANS_H__ */
-- 
2.25.1


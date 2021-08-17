Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA5CC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 134DA6102A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbhHQXng (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236443AbhHQXnf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:43:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEC9D61008;
        Tue, 17 Aug 2021 23:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243781;
        bh=KBy/lZ/+Fx5U8LLc4bRo6Kw1lqTzXuDBHmTO8tkVOhs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NAtCnZes7ekdOzET5cENq89pFIdQpH+zUxbSzOsGhju6SxU6wnYQe61LUXRe845Uc
         /sBdB5BJ3t45/bQIzqaS6e/l9Bg0rN+ZCKHFETekp4NqIJ0nmDCHcohN7bTrdBFBU1
         H/5ovU79OdPZAl6+/+ihQvPXFfiLI797bz4Rec5QDXsBXG2XX9TiZ+mOCA9+1sH8xt
         sR7Ya20nAWQ96fxHIgnmPDgnGYVjRGCh8WzcVajPhGjDBEcqMmWQRFZfmkfpzcFUt8
         NsrICifp2rA1AZNP+1NXkpsxKWIH4lKJHIDGmrUep+8QifkfGdfvniFKpW36zvTIEV
         UxH6AGdE3k2Cw==
Subject: [PATCH 09/15] xfs: disambiguate units for ftrace fields tagged "len"
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:43:01 -0700
Message-ID: <162924378154.761813.12918362378497157448.stgit@magnolia>
In-Reply-To: <162924373176.761813.10896002154570305865.stgit@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Some of our tracepoints have a field known as "len".  That name doesn't
describe any units, which makes the fields not very useful.  Rename the
fields to capture units and ensure the format is hexadecimal.

"blockcount" are in units of fs blocks
"daddrcount" are in units of 512b blocks

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    8 ++++---
 fs/xfs/xfs_trace.h   |   54 +++++++++++++++++++++++++-------------------------
 2 files changed, 31 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5a57fea014f9..cb5a74028b63 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -572,7 +572,7 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
 		__entry->holemask = holemask;
 		__entry->cluster_ino = cluster_ino;
 	),
-	TP_printk("dev %d:%d agno 0x%x startino 0x%x daddr 0x%llx len %d chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
+	TP_printk("dev %d:%d agno 0x%x startino 0x%x daddr 0x%llx daddrcount 0x%x chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startino,
@@ -662,7 +662,7 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -699,7 +699,7 @@ DECLARE_EVENT_CLASS(xrep_rmap_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -737,7 +737,7 @@ TRACE_EVENT(xrep_refcount_extent_fn,
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9748412ef3d3..7ae654f7ae82 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1573,7 +1573,7 @@ TRACE_EVENT(xfs_bunmap,
 		__entry->caller_ip = caller_ip;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx fileoff 0x%llx len 0x%llx"
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx fileoff 0x%llx blockcount 0x%llx"
 		  "flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
@@ -1601,7 +1601,7 @@ DECLARE_EVENT_CLASS(xfs_extent_busy_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1639,7 +1639,7 @@ TRACE_EVENT(xfs_extent_busy_trim,
 		__entry->tbno = tbno;
 		__entry->tlen = tlen;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u found_agbno 0x%x tlen %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x found_agbno 0x%x found_blockcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1735,7 +1735,7 @@ TRACE_EVENT(xfs_free_extent,
 		__entry->haveleft = haveleft;
 		__entry->haveright = haveright;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u resv %d %s",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x resv %d %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1870,7 +1870,7 @@ TRACE_EVENT(xfs_alloc_cur_check,
 		__entry->diff = diff;
 		__entry->new = new;
 	),
-	TP_printk("dev %d:%d btree %s agbno 0x%x len 0x%x diff 0x%x new %d",
+	TP_printk("dev %d:%d btree %s agbno 0x%x blockcount 0x%x diff 0x%x new %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->bno, __entry->len, __entry->diff, __entry->new)
@@ -2271,7 +2271,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_buf_item_class,
 		__entry->size = buf_f->blf_size;
 		__entry->map_size = buf_f->blf_map_size;
 	),
-	TP_printk("dev %d:%d daddr 0x%llx, len %u, flags 0x%x, size %d, "
+	TP_printk("dev %d:%d daddr 0x%llx, daddrcount 0x%x, flags 0x%x, size %d, "
 			"map_size %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->blkno,
@@ -2322,7 +2322,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_ino_item_class,
 		__entry->boffset = in_f->ilf_boffset;
 	),
 	TP_printk("dev %d:%d ino 0x%llx, size %u, fields 0x%x, asize %d, "
-			"dsize %d, daddr 0x%llx, len %d, boffset %d",
+			"dsize %d, daddr 0x%llx, daddrcount 0x%x, boffset %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -2363,7 +2363,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_icreate_item_class,
 		__entry->length = be32_to_cpu(in_f->icl_length);
 		__entry->gen = be32_to_cpu(in_f->icl_gen);
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u length %u "
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u blockcount 0x%x "
 		  "gen %u", MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno, __entry->agbno, __entry->count, __entry->isize,
 		  __entry->length, __entry->gen)
@@ -2392,7 +2392,7 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2551,7 +2551,7 @@ DECLARE_EVENT_CLASS(xfs_phys_extent_deferred_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x len %u",
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x blockcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -2598,7 +2598,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
 		__entry->l_state = state;
 		__entry->op = op;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx len %llu state %d",
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx blockcount 0x%llx state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->op,
 		  __entry->agno,
@@ -2668,7 +2668,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		if (unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%lx",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2748,7 +2748,7 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2903,7 +2903,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
@@ -2938,7 +2938,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 		__entry->refcount = irec->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x refcount %u @ agbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
@@ -2978,8 +2978,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
-		  "agbno 0x%x len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x refcount %u -- "
+		  "agbno 0x%x blockcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->i1_startblock,
@@ -3024,8 +3024,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 		__entry->i2_refcount = i2->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
-		  "agbno 0x%x len %u refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x refcount %u -- "
+		  "agbno 0x%x blockcount 0x%x refcount %u @ agbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->i1_startblock,
@@ -3076,9 +3076,9 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 		__entry->i3_blockcount = i3->rc_blockcount;
 		__entry->i3_refcount = i3->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
-		  "agbno 0x%x len %u refcount %u -- "
-		  "agbno 0x%x len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x blockcount 0x%x refcount %u -- "
+		  "agbno 0x%x blockcount 0x%x refcount %u -- "
+		  "agbno 0x%x blockcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->i1_startblock,
@@ -3165,7 +3165,7 @@ TRACE_EVENT(xfs_refcount_finish_one_leftover,
 		__entry->new_agbno = new_agbno;
 		__entry->new_len = new_len;
 	),
-	TP_printk("dev %d:%d type %d agno 0x%x agbno 0x%x len %u new_agbno 0x%x new_len %u",
+	TP_printk("dev %d:%d type %d agno 0x%x agbno 0x%x blockcount 0x%x new_agbno 0x%x new_blockcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -3276,7 +3276,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
 		__entry->pblk = irec->br_startblock;
 		__entry->state = irec->br_state;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fileoff 0x%llx len 0x%x startblock 0x%llx st %d",
+	TP_printk("dev %d:%d ino 0x%llx fileoff 0x%llx blockcount 0x%x startblock 0x%llx st %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->lblk,
@@ -3316,7 +3316,7 @@ TRACE_EVENT(xfs_reflink_remap_blocks,
 		__entry->dest_ino = dest->i_ino;
 		__entry->dest_lblk = doffset;
 	),
-	TP_printk("dev %d:%d len 0x%llx "
+	TP_printk("dev %d:%d blockcount 0x%llx "
 		  "ino 0x%llx fileoff 0x%llx -> ino 0x%llx fileoff 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->len,
@@ -3416,7 +3416,7 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
 		__entry->offset = rmap->rm_offset;
 		__entry->flags = rmap->rm_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%llx len %llu owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%llx blockcount 0x%llx owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->agno,
@@ -3456,7 +3456,7 @@ DECLARE_EVENT_CLASS(xfs_getfsmap_class,
 		__entry->offset = fsmap->fmr_offset;
 		__entry->flags = fsmap->fmr_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d daddr 0x%llx len %llu owner 0x%llx fileoff_daddr 0x%llx flags 0x%llx",
+	TP_printk("dev %d:%d keydev %d:%d daddr 0x%llx daddrcount 0x%llx owner 0x%llx fileoff_daddr 0x%llx flags 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->block,


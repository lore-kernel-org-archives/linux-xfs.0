Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E024C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1582C6103A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbhHQXnD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhHQXnC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:43:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9DFB61008;
        Tue, 17 Aug 2021 23:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243748;
        bh=ugpg7cZ37WxYfAL/JU5+9D0HgDqmYCp7bBBb0+U8ogg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tU08Ko+5D0hHImGvY0xQ31RCVAE3c+8GBceOv4C+dyXye2yLe+XLlxXYZejcocGGh
         HOopOR5wUw4T/WcHqqfdU1wn4p3Z85cRu4BcxKhctH8rghweJpGxPTHJWUqY3YE3D2
         wbHwxJUXIay6mR9tC81bQJDG50XC40pTRngONGjYWE0VeY2Sip7pOoFhYqJq31vBx8
         S54Y3HrUQSh+MTl2/zVsS6w7V3Dq2QV2tJUE+mbQDxMr/7lrFKLq/bJoInKpro3SzH
         NgRTRu0oTBJAY4FhV1tyuKtTMI0yR1i54WAhJGLwXGvTMkHv1PrNmgb6WBevTjr533
         rsArWeoTURMdA==
Subject: [PATCH 03/15] xfs: standardize AG number formatting in ftrace output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:42:28 -0700
Message-ID: <162924374855.761813.3505702511699510019.stgit@magnolia>
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

Always print allocation group numbers in hexadecimal and preceded with
the unit "agno".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |   34 ++++++++++++------------
 fs/xfs/xfs_trace.h   |   72 +++++++++++++++++++++++++-------------------------
 2 files changed, 53 insertions(+), 53 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e6e70d5870a2..3676b1736bab 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -103,7 +103,7 @@ DECLARE_EVENT_CLASS(xchk_class,
 		__entry->flags = sm->sm_flags;
 		__entry->error = error;
 	),
-	TP_printk("dev %d:%d ino 0x%llx type %s agno %u inum 0x%llx gen %u flags 0x%x error %d",
+	TP_printk("dev %d:%d ino 0x%llx type %s agno 0x%x inum 0x%llx gen %u flags 0x%x error %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
@@ -145,7 +145,7 @@ TRACE_EVENT(xchk_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %s agno %u agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d type %s agno 0x%x agbno %u error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->agno,
@@ -203,7 +203,7 @@ DECLARE_EVENT_CLASS(xchk_block_error_class,
 		__entry->agbno = xfs_daddr_to_agbno(sc->mp, daddr);
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %s agno %u agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d type %s agno 0x%x agbno %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->agno,
@@ -338,7 +338,7 @@ TRACE_EVENT(xchk_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno %u error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
@@ -381,7 +381,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno %u agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno %u error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -420,7 +420,7 @@ TRACE_EVENT(xchk_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno %u agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
@@ -460,7 +460,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno %u agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno %u ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -499,7 +499,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 		__entry->nlevels = cur->bc_nlevels;
 		__entry->ptr = cur->bc_ptrs[level];
 	),
-	TP_printk("dev %d:%d type %s btree %s agno %u agbno %u level %d nlevels %d ptr %d",
+	TP_printk("dev %d:%d type %s btree %s agno 0x%x agbno %u level %d nlevels %d ptr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
@@ -572,7 +572,7 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
 		__entry->holemask = holemask;
 		__entry->cluster_ino = cluster_ino;
 	),
-	TP_printk("dev %d:%d agno %d startino 0x%x daddr 0x%llx len %d chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
+	TP_printk("dev %d:%d agno 0x%x startino 0x%x daddr 0x%llx len %d chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startino,
@@ -662,7 +662,7 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -699,7 +699,7 @@ DECLARE_EVENT_CLASS(xrep_rmap_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset %llu flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u owner %lld offset %llu flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -737,7 +737,7 @@ TRACE_EVENT(xrep_refcount_extent_fn,
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
@@ -761,7 +761,7 @@ TRACE_EVENT(xrep_init_btblock,
 		__entry->agbno = agbno;
 		__entry->btnum = btnum;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u btree %s",
+	TP_printk("dev %d:%d agno 0x%x agbno %u btree %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -785,7 +785,7 @@ TRACE_EVENT(xrep_findroot_block,
 		__entry->magic = magic;
 		__entry->level = level;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u magic 0x%x level %u",
+	TP_printk("dev %d:%d agno 0x%x agbno %u magic 0x%x level %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -813,7 +813,7 @@ TRACE_EVENT(xrep_calc_ag_resblks,
 		__entry->freelen = freelen;
 		__entry->usedlen = usedlen;
 	),
-	TP_printk("dev %d:%d agno %d icount %u aglen %u freelen %u usedlen %u",
+	TP_printk("dev %d:%d agno 0x%x icount %u aglen %u freelen %u usedlen %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->icount,
@@ -842,7 +842,7 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
 		__entry->rmapbt_sz = rmapbt_sz;
 		__entry->refcbt_sz = refcbt_sz;
 	),
-	TP_printk("dev %d:%d agno %d bnobt %u inobt %u rmapbt %u refcountbt %u",
+	TP_printk("dev %d:%d agno 0x%x bnobt %u inobt %u rmapbt %u refcountbt %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->bnobt_sz,
@@ -886,7 +886,7 @@ TRACE_EVENT(xrep_ialloc_insert,
 		__entry->freecount = freecount;
 		__entry->freemask = freemask;
 	),
-	TP_printk("dev %d:%d agno %d startino 0x%x holemask 0x%x count %u freecount %u freemask 0x%llx",
+	TP_printk("dev %d:%d agno 0x%x startino 0x%x holemask 0x%x count %u freecount %u freemask 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startino,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6b2d4c5205d8..9ddc710c1be9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -139,7 +139,7 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
 		__entry->refcount = refcount;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u refcount %d caller %pS",
+	TP_printk("dev %d:%d agno 0x%x refcount %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->refcount,
@@ -246,7 +246,7 @@ DECLARE_EVENT_CLASS(xfs_ag_class,
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
 	),
-	TP_printk("dev %d:%d agno %u",
+	TP_printk("dev %d:%d agno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno)
 );
@@ -612,7 +612,7 @@ DECLARE_EVENT_CLASS(xfs_filestream_class,
 		__entry->agno = agno;
 		__entry->streams = xfs_filestream_peek_ag(mp, agno);
 	),
-	TP_printk("dev %d:%d ino 0x%llx agno %u streams %d",
+	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->agno,
@@ -646,7 +646,7 @@ TRACE_EVENT(xfs_filestream_pick,
 		__entry->free = free;
 		__entry->nscan = nscan;
 	),
-	TP_printk("dev %d:%d ino 0x%llx agno %u streams %d free %d nscan %d",
+	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d free %d nscan %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->agno,
@@ -858,7 +858,7 @@ TRACE_EVENT(xfs_irec_merge_pre,
 		__entry->nagino = nagino;
 		__entry->nholemask = holemask;
 	),
-	TP_printk("dev %d:%d agno %d inobt (%u:0x%x) new (%u:0x%x)",
+	TP_printk("dev %d:%d agno 0x%x inobt (%u:0x%x) new (%u:0x%x)",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
 		  __entry->agino, __entry->holemask, __entry->nagino,
 		  __entry->nholemask)
@@ -880,7 +880,7 @@ TRACE_EVENT(xfs_irec_merge_post,
 		__entry->agino = agino;
 		__entry->holemask = holemask;
 	),
-	TP_printk("dev %d:%d agno %d inobt (%u:0x%x)", MAJOR(__entry->dev),
+	TP_printk("dev %d:%d agno 0x%x inobt (%u:0x%x)", MAJOR(__entry->dev),
 		  MINOR(__entry->dev), __entry->agno, __entry->agino,
 		  __entry->holemask)
 )
@@ -1601,7 +1601,7 @@ DECLARE_EVENT_CLASS(xfs_extent_busy_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1639,7 +1639,7 @@ TRACE_EVENT(xfs_extent_busy_trim,
 		__entry->tbno = tbno;
 		__entry->tlen = tlen;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u tbno %u tlen %u",
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u tbno %u tlen %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1686,7 +1686,7 @@ DECLARE_EVENT_CLASS(xfs_agf_class,
 		__entry->longest = be32_to_cpu(agf->agf_longest);
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u flags %s length %u roots b %u c %u "
+	TP_printk("dev %d:%d agno 0x%x flags %s length %u roots b %u c %u "
 		  "levels b %u c %u flfirst %u fllast %u flcount %u "
 		  "freeblks %u longest %u caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -1735,7 +1735,7 @@ TRACE_EVENT(xfs_free_extent,
 		__entry->haveleft = haveleft;
 		__entry->haveright = haveright;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u resv %d %s",
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u resv %d %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1792,7 +1792,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__entry->datatype = args->datatype;
 		__entry->firstblock = args->tp->t_firstblock;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u minlen %u maxlen %u mod %u "
+	TP_printk("dev %d:%d agno 0x%x agbno %u minlen %u maxlen %u mod %u "
 		  "prod %u minleft %u total %u alignment %u minalignslop %u "
 		  "len %u type %s otype %s wasdel %d wasfromfl %d resv %d "
 		  "datatype 0x%x firstblock 0x%llx",
@@ -2363,7 +2363,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_icreate_item_class,
 		__entry->length = be32_to_cpu(in_f->icl_length);
 		__entry->gen = be32_to_cpu(in_f->icl_gen);
 	),
-	TP_printk("dev %d:%d agno %u agbno %u count %u isize %u length %u "
+	TP_printk("dev %d:%d agno 0x%x agbno %u count %u isize %u length %u "
 		  "gen %u", MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno, __entry->agbno, __entry->count, __entry->isize,
 		  __entry->length, __entry->gen)
@@ -2392,7 +2392,7 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2551,7 +2551,7 @@ DECLARE_EVENT_CLASS(xfs_phys_extent_deferred_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d op %d agno %u agbno %u len %u",
+	TP_printk("dev %d:%d op %d agno 0x%x agbno %u len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -2598,7 +2598,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
 		__entry->l_state = state;
 		__entry->op = op;
 	),
-	TP_printk("dev %d:%d op %d agno %u agbno %u owner %lld %s offset %llu len %llu state %d",
+	TP_printk("dev %d:%d op %d agno 0x%x agbno %u owner %lld %s offset %llu len %llu state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->op,
 		  __entry->agno,
@@ -2668,7 +2668,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		if (unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset %llu flags 0x%lx",
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u owner %lld offset %llu flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2701,7 +2701,7 @@ DECLARE_EVENT_CLASS(xfs_ag_error_class,
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno %u error %d caller %pS",
+	TP_printk("dev %d:%d agno 0x%x error %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->error,
@@ -2748,7 +2748,7 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset %llu flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u owner %lld offset %llu flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2817,7 +2817,7 @@ DECLARE_EVENT_CLASS(xfs_ag_resv_class,
 		__entry->asked = r ? r->ar_asked : 0;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno %u resv %d freeblks %u flcount %u "
+	TP_printk("dev %d:%d agno 0x%x resv %d freeblks %u flcount %u "
 		  "resv %u ask %u len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
@@ -2870,7 +2870,7 @@ DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
 		__entry->agbno = agbno;
 		__entry->dir = dir;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u cmp %s(%d)",
+	TP_printk("dev %d:%d agno 0x%x agbno %u cmp %s(%d)",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2903,7 +2903,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
@@ -2938,7 +2938,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 		__entry->refcount = irec->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u @ agbno %u",
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u @ agbno %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
@@ -2978,7 +2978,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u -- "
 		  "agbno %u len %u refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
@@ -3024,7 +3024,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 		__entry->i2_refcount = i2->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u -- "
 		  "agbno %u len %u refcount %u @ agbno %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
@@ -3076,7 +3076,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 		__entry->i3_blockcount = i3->rc_blockcount;
 		__entry->i3_refcount = i3->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u -- "
+	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u -- "
 		  "agbno %u len %u refcount %u -- "
 		  "agbno %u len %u refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -3165,7 +3165,7 @@ TRACE_EVENT(xfs_refcount_finish_one_leftover,
 		__entry->new_agbno = new_agbno;
 		__entry->new_len = new_len;
 	),
-	TP_printk("dev %d:%d type %d agno %u agbno %u len %u new_agbno %u new_len %u",
+	TP_printk("dev %d:%d type %d agno 0x%x agbno %u len %u new_agbno %u new_len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -3417,7 +3417,7 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
 		__entry->offset = rmap->rm_offset;
 		__entry->flags = rmap->rm_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d agno %u bno %llu len %llu owner %lld offset %llu flags 0x%x",
+	TP_printk("dev %d:%d keydev %d:%d agno 0x%x bno %llu len %llu owner %lld offset %llu flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->agno,
@@ -3556,7 +3556,7 @@ TRACE_EVENT(xfs_iunlink_update_bucket,
 		__entry->old_ptr = old_ptr;
 		__entry->new_ptr = new_ptr;
 	),
-	TP_printk("dev %d:%d agno %u bucket %u old 0x%x new 0x%x",
+	TP_printk("dev %d:%d agno 0x%x bucket %u old 0x%x new 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->bucket,
@@ -3582,7 +3582,7 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
 		__entry->old_ptr = old_ptr;
 		__entry->new_ptr = new_ptr;
 	),
-	TP_printk("dev %d:%d agno %u agino 0x%x old 0x%x new 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x old 0x%x new 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agino,
@@ -3603,7 +3603,7 @@ DECLARE_EVENT_CLASS(xfs_ag_inode_class,
 		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
 		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
 	),
-	TP_printk("dev %d:%d agno %u agino 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agino 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno, __entry->agino)
 )
@@ -3655,7 +3655,7 @@ DECLARE_EVENT_CLASS(xfs_ag_corrupt_class,
 		__entry->agno = agno;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno %u flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno, __entry->flags)
 );
@@ -3706,7 +3706,7 @@ TRACE_EVENT(xfs_iwalk_ag,
 		__entry->agno = agno;
 		__entry->startino = startino;
 	),
-	TP_printk("dev %d:%d agno %d startino 0x%x",
+	TP_printk("dev %d:%d agno 0x%x startino 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
 		  __entry->startino)
 )
@@ -3727,7 +3727,7 @@ TRACE_EVENT(xfs_iwalk_ag_rec,
 		__entry->startino = irec->ir_startino;
 		__entry->freemask = irec->ir_free;
 	),
-	TP_printk("dev %d:%d agno %d startino 0x%x freemask 0x%llx",
+	TP_printk("dev %d:%d agno 0x%x startino 0x%x freemask 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
 		  __entry->startino, __entry->freemask)
 )
@@ -3815,7 +3815,7 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
 		__entry->levels = cur->bc_ag.afake->af_levels;
 		__entry->blocks = cur->bc_ag.afake->af_blocks;
 	),
-	TP_printk("dev %d:%d btree %s ag %u levels %u blocks %u root %u",
+	TP_printk("dev %d:%d btree %s agno 0x%x levels %u blocks %u root %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->agno,
@@ -3847,7 +3847,7 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
 		__entry->blocks = cur->bc_ino.ifake->if_blocks;
 		__entry->whichfork = cur->bc_ino.whichfork;
 	),
-	TP_printk("dev %d:%d btree %s ag %u agino 0x%x whichfork %s levels %u blocks %u",
+	TP_printk("dev %d:%d btree %s agno 0x%x agino 0x%x whichfork %s levels %u blocks %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->agno,
@@ -3930,7 +3930,7 @@ TRACE_EVENT(xfs_btree_bload_block,
 		}
 		__entry->nr_records = nr_records;
 	),
-	TP_printk("dev %d:%d btree %s level %u block %llu/%llu fsb (%u/%u) recs %u",
+	TP_printk("dev %d:%d btree %s level %u block %llu/%llu agno 0x%x agbno %u recs %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->level,


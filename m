Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C32FC4320A
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2043E606A5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhHSDp3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236426AbhHSDp2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Aug 2021 23:45:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A537C606A5;
        Thu, 19 Aug 2021 03:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629344692;
        bh=xqNTamCHZP6iix59iJwDRe6a9/Xz3fI5WpGvH1XZ/Kk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qwYS2Ug2efGZ3FH97gUoHCIYyv9KDEf8G2OwKisCrkcQu3Fs68MqVgdcR0ZTKSlsq
         W4B2K0xGRSuBZGH5dQiCHSZPsl2nWiyzrT9EFBwZKE2m2R958J4xF40nlgMmqLNf5v
         e9/FcWqzk/AzzpVZGW0YWOoH1G0kdWV7sZqqz/q3GedgGx9c0KtRMSvGs1KE7O1nq6
         XdFjC2tkg/00BLf6x0pxYyG7PxTHqOKgRDMR6+gjRRZ3ROV90RUKZi4lqi+PdimqVt
         UT2rsXtWT/px/XjwFIqrxGi/xYQ0YeLrYz1ITvFzHWF8QaoxnNjghnURcA/tXxesjS
         hn5ydktBbZEtA==
Date:   Wed, 18 Aug 2021 20:44:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 09/15] xfs: disambiguate units for ftrace fields tagged
 "len"
Message-ID: <20210819034452.GP12640@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924378154.761813.12918362378497157448.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924378154.761813.12918362378497157448.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Some of our tracepoints have a field known as "len".  That name doesn't
describe any units, which makes the fields not very useful.  Rename the
fields to capture units and ensure the format is hexadecimal.

"fsbcount" are in units of fs blocks
"bbcount" are in units of 512b blocks
"ireccount" are in units of inodes

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: change the prefixes of the unit counts
---
 fs/xfs/scrub/trace.h |    8 +++---
 fs/xfs/xfs_trace.h   |   66 +++++++++++++++++++++++++++-----------------------
 2 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5a57fea014f9..eb29f56dc9f1 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -572,7 +572,7 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
 		__entry->holemask = holemask;
 		__entry->cluster_ino = cluster_ino;
 	),
-	TP_printk("dev %d:%d agno 0x%x startino 0x%x daddr 0x%llx len %d chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
+	TP_printk("dev %d:%d agno 0x%x startino 0x%x daddr 0x%llx bbcount 0x%x chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startino,
@@ -662,7 +662,7 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -699,7 +699,7 @@ DECLARE_EVENT_CLASS(xrep_rmap_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -737,7 +737,7 @@ TRACE_EVENT(xrep_refcount_extent_fn,
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 60837ff297bc..4169dc6cb5b9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1440,7 +1440,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 		__entry->blockcount = irec ? irec->br_blockcount : 0;
 	),
 	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx count %zd "
-		  "fork %s startoff 0x%llx startblock 0x%llx blockcount 0x%llx",
+		  "fork %s startoff 0x%llx startblock 0x%llx fsbcount 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -1579,7 +1579,7 @@ TRACE_EVENT(xfs_bunmap,
 		__entry->caller_ip = caller_ip;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx fileoff 0x%llx len 0x%llx"
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx fileoff 0x%llx fsbcount 0x%llx"
 		  "flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
@@ -1607,7 +1607,7 @@ DECLARE_EVENT_CLASS(xfs_extent_busy_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1645,7 +1645,7 @@ TRACE_EVENT(xfs_extent_busy_trim,
 		__entry->tbno = tbno;
 		__entry->tlen = tlen;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u found_agbno 0x%x tlen %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x found_agbno 0x%x found_fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1741,7 +1741,7 @@ TRACE_EVENT(xfs_free_extent,
 		__entry->haveleft = haveleft;
 		__entry->haveright = haveright;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u resv %d %s",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x resv %d %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1876,7 +1876,7 @@ TRACE_EVENT(xfs_alloc_cur_check,
 		__entry->diff = diff;
 		__entry->new = new;
 	),
-	TP_printk("dev %d:%d btree %s agbno 0x%x len 0x%x diff 0x%x new %d",
+	TP_printk("dev %d:%d btree %s agbno 0x%x fsbcount 0x%x diff 0x%x new %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->bno, __entry->len, __entry->diff, __entry->new)
@@ -2277,7 +2277,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_buf_item_class,
 		__entry->size = buf_f->blf_size;
 		__entry->map_size = buf_f->blf_map_size;
 	),
-	TP_printk("dev %d:%d daddr 0x%llx, len %u, flags 0x%x, size %d, "
+	TP_printk("dev %d:%d daddr 0x%llx, bbcount 0x%x, flags 0x%x, size %d, "
 			"map_size %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->blkno,
@@ -2328,7 +2328,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_ino_item_class,
 		__entry->boffset = in_f->ilf_boffset;
 	),
 	TP_printk("dev %d:%d ino 0x%llx, size %u, fields 0x%x, asize %d, "
-			"dsize %d, daddr 0x%llx, len %d, boffset %d",
+			"dsize %d, daddr 0x%llx, bbcount 0x%x, boffset %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -2369,10 +2369,14 @@ DECLARE_EVENT_CLASS(xfs_log_recover_icreate_item_class,
 		__entry->length = be32_to_cpu(in_f->icl_length);
 		__entry->gen = be32_to_cpu(in_f->icl_gen);
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u length %u "
-		  "gen %u", MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno, __entry->agbno, __entry->count, __entry->isize,
-		  __entry->length, __entry->gen)
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x ireccount 0x%x isize %u gen %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->length,
+		  __entry->count,
+		  __entry->isize,
+		  __entry->gen)
 )
 #define DEFINE_LOG_RECOVER_ICREATE_ITEM(name) \
 DEFINE_EVENT(xfs_log_recover_icreate_item_class, name, \
@@ -2398,7 +2402,7 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2557,7 +2561,7 @@ DECLARE_EVENT_CLASS(xfs_phys_extent_deferred_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x len %u",
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -2604,7 +2608,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
 		__entry->l_state = state;
 		__entry->op = op;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx len %llu state %d",
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->op,
 		  __entry->agno,
@@ -2674,7 +2678,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		if (unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%lx",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2754,7 +2758,7 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2909,7 +2913,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
@@ -2944,7 +2948,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 		__entry->refcount = irec->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
@@ -2984,8 +2988,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
-		  "agbno 0x%x len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "agbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->i1_startblock,
@@ -3030,8 +3034,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 		__entry->i2_refcount = i2->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
-		  "agbno 0x%x len %u refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->i1_startblock,
@@ -3082,9 +3086,9 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 		__entry->i3_blockcount = i3->rc_blockcount;
 		__entry->i3_refcount = i3->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
-		  "agbno 0x%x len %u refcount %u -- "
-		  "agbno 0x%x len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "agbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->i1_startblock,
@@ -3171,7 +3175,7 @@ TRACE_EVENT(xfs_refcount_finish_one_leftover,
 		__entry->new_agbno = new_agbno;
 		__entry->new_len = new_len;
 	),
-	TP_printk("dev %d:%d type %d agno 0x%x agbno 0x%x len %u new_agbno 0x%x new_len %u",
+	TP_printk("dev %d:%d type %d agno 0x%x agbno 0x%x fsbcount 0x%x new_agbno 0x%x new_fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -3282,7 +3286,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
 		__entry->pblk = irec->br_startblock;
 		__entry->state = irec->br_state;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fileoff 0x%llx len 0x%x startblock 0x%llx st %d",
+	TP_printk("dev %d:%d ino 0x%llx fileoff 0x%llx fsbcount 0x%x startblock 0x%llx st %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->lblk,
@@ -3322,7 +3326,7 @@ TRACE_EVENT(xfs_reflink_remap_blocks,
 		__entry->dest_ino = dest->i_ino;
 		__entry->dest_lblk = doffset;
 	),
-	TP_printk("dev %d:%d len 0x%llx "
+	TP_printk("dev %d:%d fsbcount 0x%llx "
 		  "ino 0x%llx fileoff 0x%llx -> ino 0x%llx fileoff 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->len,
@@ -3422,7 +3426,7 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
 		__entry->offset = rmap->rm_offset;
 		__entry->flags = rmap->rm_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%llx len %llu owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%llx fsbcount 0x%llx owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->agno,
@@ -3462,7 +3466,7 @@ DECLARE_EVENT_CLASS(xfs_getfsmap_class,
 		__entry->offset = fsmap->fmr_offset;
 		__entry->flags = fsmap->fmr_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d daddr 0x%llx len %llu owner 0x%llx fileoff_daddr 0x%llx flags 0x%llx",
+	TP_printk("dev %d:%d keydev %d:%d daddr 0x%llx bbcount 0x%llx owner 0x%llx fileoff_daddr 0x%llx flags 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->block,

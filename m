Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83068C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6706C6103A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbhHQXna (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236456AbhHQXna (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:43:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EDF5604AC;
        Tue, 17 Aug 2021 23:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243776;
        bh=sOaeBGwBPSNsjKP8zmV/iIo2oNUIElqWaSnvYxALPXQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fnPl8JL+NrMPsgkojhiDVPwSuP0l3noJt+GbJJ0VGubj1KfAbb+z75DrKqIykb+Sl
         hYF67pap/itgurV9vVD/eaQ3mbGsVYquSrG0+6PQS2p9f06w34wtili0lLAlTmxzk4
         GAn2C3avbscktWvWspgAZNhPJXfyH09tfHwHUwQ1EJcIurDjcD61wkeChIlvPFaFPW
         chObv/e7kYGZt/JWOVmGQsVDfP9wLHjM3osj/ofYdKsgDVcsqVHQWQ5bakmoIzl5HX
         t7aUwfSQrD+T31TOskExlfRWCMtwiFedcCtk0iVp50VXukkWSEzV3kw441QmNnh7nu
         KJIV5z6/T62Gg==
Subject: [PATCH 08/15] xfs: disambiguate units for ftrace fields tagged
 "offset"
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:42:56 -0700
Message-ID: <162924377603.761813.4113528501236797725.stgit@magnolia>
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

Some of our tracepoints describe fields as "offset".  That name doesn't
describe any units, which makes the fields not very useful.  Rename the
fields to capture units and ensure the format is hexadecimal.

"fileoff" means file offset, in units of fs blocks
"pos" means file offset, in bytes
"forkoff" means inode fork offset, in bytes

The one remaining "offset" value is for iclogs, since that's the byte
offset of the end of where we've written into the current iclog.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    6 +++---
 fs/xfs/xfs_trace.h   |   29 ++++++++++++++---------------
 2 files changed, 17 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 486e6f3c0ea2..5a57fea014f9 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -176,7 +176,7 @@ TRACE_EVENT(xchk_file_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %s offset %llu error %d ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %s fileoff 0x%llx error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -273,7 +273,7 @@ DECLARE_EVENT_CLASS(xchk_fblock_error_class,
 		__entry->offset = offset;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %s offset %llu ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %s fileoff 0x%llx ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -699,7 +699,7 @@ DECLARE_EVENT_CLASS(xrep_rmap_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx offset %llu flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d725bc4bd1e7..9748412ef3d3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -346,7 +346,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
-		  "offset %lld startblock 0x%llx count %lld flag %d caller %pS",
+		  "fileoff 0x%llx startblock 0x%llx count %lld flag %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
@@ -1386,7 +1386,7 @@ DECLARE_EVENT_CLASS(xfs_file_class,
 		__entry->offset = iocb->ki_pos;
 		__entry->count = iov_iter_count(iter);
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx offset 0x%llx count 0x%zx",
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx count 0x%zx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -1433,7 +1433,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 		__entry->startblock = irec ? irec->br_startblock : 0;
 		__entry->blockcount = irec ? irec->br_blockcount : 0;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx offset 0x%llx count %zd "
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx count %zd "
 		  "fork %s startoff 0x%llx startblock 0x%llx blockcount 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
@@ -1476,7 +1476,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__entry->count = count;
 	),
 	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx "
-		  "offset 0x%llx count %zd",
+		  "pos 0x%llx count %zd",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->isize,
@@ -2145,7 +2145,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
 	),
 	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
-		  "broot size %d, fork offset %d",
+		  "broot size %d, forkoff %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_symbolic(__entry->which, XFS_SWAPEXT_INODES),
@@ -2598,7 +2598,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
 		__entry->l_state = state;
 		__entry->op = op;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s offset %llu len %llu state %d",
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx len %llu state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->op,
 		  __entry->agno,
@@ -2668,7 +2668,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		if (unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx offset %llu flags 0x%lx",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2748,7 +2748,7 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx offset %llu flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -3236,8 +3236,8 @@ DECLARE_EVENT_CLASS(xfs_double_io_class,
 		__entry->dest_offset = doffset;
 	),
 	TP_printk("dev %d:%d count %zd "
-		  "ino 0x%llx isize 0x%llx disize 0x%llx offset 0x%llx -> "
-		  "ino 0x%llx isize 0x%llx disize 0x%llx offset 0x%llx",
+		  "ino 0x%llx isize 0x%llx disize 0x%llx pos 0x%llx -> "
+		  "ino 0x%llx isize 0x%llx disize 0x%llx pos 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->len,
 		  __entry->src_ino,
@@ -3276,7 +3276,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
 		__entry->pblk = irec->br_startblock;
 		__entry->state = irec->br_state;
 	),
-	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x startblock 0x%llx st %d",
+	TP_printk("dev %d:%d ino 0x%llx fileoff 0x%llx len 0x%x startblock 0x%llx st %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->lblk,
@@ -3317,8 +3317,7 @@ TRACE_EVENT(xfs_reflink_remap_blocks,
 		__entry->dest_lblk = doffset;
 	),
 	TP_printk("dev %d:%d len 0x%llx "
-		  "ino 0x%llx offset 0x%llx blocks -> "
-		  "ino 0x%llx offset 0x%llx blocks",
+		  "ino 0x%llx fileoff 0x%llx -> ino 0x%llx fileoff 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->len,
 		  __entry->src_ino,
@@ -3417,7 +3416,7 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
 		__entry->offset = rmap->rm_offset;
 		__entry->flags = rmap->rm_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%llx len %llu owner 0x%llx offset %llu flags 0x%x",
+	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%llx len %llu owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->agno,
@@ -3457,7 +3456,7 @@ DECLARE_EVENT_CLASS(xfs_getfsmap_class,
 		__entry->offset = fsmap->fmr_offset;
 		__entry->flags = fsmap->fmr_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d daddr 0x%llx len %llu owner 0x%llx offset %llu flags 0x%llx",
+	TP_printk("dev %d:%d keydev %d:%d daddr 0x%llx len %llu owner 0x%llx fileoff_daddr 0x%llx flags 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->block,


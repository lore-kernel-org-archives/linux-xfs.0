Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9C6C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15A6661008
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbhHQXnZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236443AbhHQXnY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:43:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC35261008;
        Tue, 17 Aug 2021 23:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243770;
        bh=FCjbwzfModpr2zh6FIwxOwLeVmcEM4jGooPaAN2u1o4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oo9Cl94MhF9Z4io/LW5SclwM/EDCKWOQoih48D4MYEmHRpD8in3XauYL38wIZJ/sI
         /dClPagEjLTzfGFnSjva3nnDzYVhRGANpEfig7pGly3XYsqQSqoDwDVRa7coBgPQAi
         JDH6RYyHhGEbFp35jBWBvQ0lkv+Q6gwtuCmoFTxsoeuFZO9j1D3BJTENGd4eTW+D3S
         ceQSgHPygdz6Cp1EJmDPnkmlEGR8TsaYHOb+sqid3cwoJddiXgG51uD96RVhpGrAqs
         vC/ZA8F9rZkxP1ftkMPiBsH7BmDoKLYCO3phlDoCeZ+fzmhI9mK7r6a0tpPqp76NLN
         4lnKeOZuQ/ybA==
Subject: [PATCH 07/15] xfs: disambiguate units for ftrace fields tagged
 "blkno", "block", or "bno"
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:42:50 -0700
Message-ID: <162924377054.761813.15725895998141087832.stgit@magnolia>
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

Some of our tracepoints describe fields as "blkno", "block", or "bno".
That name doesn't describe any units, which makes the fields not very
useful.  Rename the fields to capture units and ensure the format is
hexadecimal.

"startblock" is the startblock field from the bmap structure, which is a
segmented fsblock on the data device, or an rfsblock on the realtime
device.
"fileoff" is a file offset, in units of filesystem blocks
"daddr" is a raw device offset, in 512b blocks

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.h |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3944373ad2f6..d725bc4bd1e7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -346,7 +346,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
-		  "offset %lld block %lld count %lld flag %d caller %pS",
+		  "offset %lld startblock 0x%llx count %lld flag %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
@@ -1434,7 +1434,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 		__entry->blockcount = irec ? irec->br_blockcount : 0;
 	),
 	TP_printk("dev %d:%d ino 0x%llx size 0x%llx offset 0x%llx count %zd "
-		  "fork %s startoff 0x%llx startblock %lld blockcount 0x%llx",
+		  "fork %s startoff 0x%llx startblock 0x%llx blockcount 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -1552,14 +1552,14 @@ TRACE_EVENT(xfs_pagecache_inval,
 );
 
 TRACE_EVENT(xfs_bunmap,
-	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t bno, xfs_filblks_t len,
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t fileoff, xfs_filblks_t len,
 		 int flags, unsigned long caller_ip),
-	TP_ARGS(ip, bno, len, flags, caller_ip),
+	TP_ARGS(ip, fileoff, len, flags, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(xfs_fsize_t, size)
-		__field(xfs_fileoff_t, bno)
+		__field(xfs_fileoff_t, fileoff)
 		__field(xfs_filblks_t, len)
 		__field(unsigned long, caller_ip)
 		__field(int, flags)
@@ -1568,17 +1568,17 @@ TRACE_EVENT(xfs_bunmap,
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->size = ip->i_disk_size;
-		__entry->bno = bno;
+		__entry->fileoff = fileoff;
 		__entry->len = len;
 		__entry->caller_ip = caller_ip;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx bno 0x%llx len 0x%llx"
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx fileoff 0x%llx len 0x%llx"
 		  "flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
-		  __entry->bno,
+		  __entry->fileoff,
 		  __entry->len,
 		  __print_flags(__entry->flags, "|", XFS_BMAPI_FLAGS),
 		  (void *)__entry->caller_ip)
@@ -2271,7 +2271,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_buf_item_class,
 		__entry->size = buf_f->blf_size;
 		__entry->map_size = buf_f->blf_map_size;
 	),
-	TP_printk("dev %d:%d blkno 0x%llx, len %u, flags 0x%x, size %d, "
+	TP_printk("dev %d:%d daddr 0x%llx, len %u, flags 0x%x, size %d, "
 			"map_size %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->blkno,
@@ -2322,7 +2322,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_ino_item_class,
 		__entry->boffset = in_f->ilf_boffset;
 	),
 	TP_printk("dev %d:%d ino 0x%llx, size %u, fields 0x%x, asize %d, "
-			"dsize %d, blkno 0x%llx, len %d, boffset %d",
+			"dsize %d, daddr 0x%llx, len %d, boffset %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -3276,7 +3276,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
 		__entry->pblk = irec->br_startblock;
 		__entry->state = irec->br_state;
 	),
-	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x pblk %llu st %d",
+	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x startblock 0x%llx st %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->lblk,
@@ -3417,7 +3417,7 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
 		__entry->offset = rmap->rm_offset;
 		__entry->flags = rmap->rm_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d agno 0x%x bno %llu len %llu owner 0x%llx offset %llu flags 0x%x",
+	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%llx len %llu owner 0x%llx offset %llu flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->agno,
@@ -3457,7 +3457,7 @@ DECLARE_EVENT_CLASS(xfs_getfsmap_class,
 		__entry->offset = fsmap->fmr_offset;
 		__entry->flags = fsmap->fmr_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d block %llu len %llu owner 0x%llx offset %llu flags 0x%llx",
+	TP_printk("dev %d:%d keydev %d:%d daddr 0x%llx len %llu owner 0x%llx offset %llu flags 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->block,


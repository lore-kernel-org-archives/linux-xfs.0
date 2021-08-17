Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41765C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 252176102A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbhHQXm7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhHQXm5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:42:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 556CA604AC;
        Tue, 17 Aug 2021 23:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243743;
        bh=bqHCri0UB7Q+QIQPrhzHJg88SnrYH7BO11sL+XbsgJk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K/gidJeQ35B0yZsZ74QAsSh5CdNjMDWBgsO4GdzIEfTZeBIy9oHnYF84jPYDB01A6
         OCujV0w3lNjD+QYGpeumgoR2/Rt92HgYP90QDFRSdUbAqGXfVieHxhkOhhzcITqwli
         boA1UmGgBqtoIPgiyCaR3fZVpjWe6qHbRhxIKMzfCCI3Hsbutxv+nYq8d2h4nlETzR
         d1Y1qA6esijHf/mr9mM185P8IRfT6gaaXfZ7/eP5YzCqU8dJ5ECxIvqFPfnIjlyoxX
         Wot44U8+xO4WSfACwPniCv4M6FX7WsQQlaDvdwT66ivt/ct5nvIKLLEpehSQ1xVvvB
         wO2OCpLB10/bA==
Subject: [PATCH 02/15] xfs: standardize inode number formatting in ftrace
 output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:42:23 -0700
Message-ID: <162924374307.761813.7272815473497235066.stgit@magnolia>
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

Always print inode numbers in hexadecimal and preceded with the unit
"ino" or "agino", as apropriate.  Fix one tracepoint that used "ino %u"
for an inode btree block count to reduce confusion.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    8 ++++----
 fs/xfs/xfs_trace.h   |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 29f1d0ac7ec5..e6e70d5870a2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -103,7 +103,7 @@ DECLARE_EVENT_CLASS(xchk_class,
 		__entry->flags = sm->sm_flags;
 		__entry->error = error;
 	),
-	TP_printk("dev %d:%d ino 0x%llx type %s agno %u inum %llu gen %u flags 0x%x error %d",
+	TP_printk("dev %d:%d ino 0x%llx type %s agno %u inum 0x%llx gen %u flags 0x%x error %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
@@ -572,7 +572,7 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
 		__entry->holemask = holemask;
 		__entry->cluster_ino = cluster_ino;
 	),
-	TP_printk("dev %d:%d agno %d startino %u daddr 0x%llx len %d chunkino %u nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino %u",
+	TP_printk("dev %d:%d agno %d startino 0x%x daddr 0x%llx len %d chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startino,
@@ -842,7 +842,7 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
 		__entry->rmapbt_sz = rmapbt_sz;
 		__entry->refcbt_sz = refcbt_sz;
 	),
-	TP_printk("dev %d:%d agno %d bno %u ino %u rmap %u refcount %u",
+	TP_printk("dev %d:%d agno %d bnobt %u inobt %u rmapbt %u refcountbt %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->bnobt_sz,
@@ -886,7 +886,7 @@ TRACE_EVENT(xrep_ialloc_insert,
 		__entry->freecount = freecount;
 		__entry->freemask = freemask;
 	),
-	TP_printk("dev %d:%d agno %d startino %u holemask 0x%x count %u freecount %u freemask 0x%llx",
+	TP_printk("dev %d:%d agno %d startino 0x%x holemask 0x%x count %u freecount %u freemask 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startino,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7e04a6adb349..6b2d4c5205d8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3191,7 +3191,7 @@ DECLARE_EVENT_CLASS(xfs_inode_error_class,
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d ino %llx error %d caller %pS",
+	TP_printk("dev %d:%d ino 0x%llx error %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->error,
@@ -3603,7 +3603,7 @@ DECLARE_EVENT_CLASS(xfs_ag_inode_class,
 		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
 		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
 	),
-	TP_printk("dev %d:%d agno %u agino %u",
+	TP_printk("dev %d:%d agno %u agino 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno, __entry->agino)
 )
@@ -3706,7 +3706,7 @@ TRACE_EVENT(xfs_iwalk_ag,
 		__entry->agno = agno;
 		__entry->startino = startino;
 	),
-	TP_printk("dev %d:%d agno %d startino %u",
+	TP_printk("dev %d:%d agno %d startino 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
 		  __entry->startino)
 )
@@ -3727,7 +3727,7 @@ TRACE_EVENT(xfs_iwalk_ag_rec,
 		__entry->startino = irec->ir_startino;
 		__entry->freemask = irec->ir_free;
 	),
-	TP_printk("dev %d:%d agno %d startino %u freemask 0x%llx",
+	TP_printk("dev %d:%d agno %d startino 0x%x freemask 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
 		  __entry->startino, __entry->freemask)
 )
@@ -3790,7 +3790,7 @@ TRACE_EVENT(xfs_check_new_dalign,
 		__entry->sb_rootino = mp->m_sb.sb_rootino;
 		__entry->calc_rootino = calc_rootino;
 	),
-	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
+	TP_printk("dev %d:%d new_dalign %d sb_rootino 0x%llx calc_rootino 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->new_dalign, __entry->sb_rootino,
 		  __entry->calc_rootino)
@@ -3847,7 +3847,7 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
 		__entry->blocks = cur->bc_ino.ifake->if_blocks;
 		__entry->whichfork = cur->bc_ino.whichfork;
 	),
-	TP_printk("dev %d:%d btree %s ag %u agino %u whichfork %s levels %u blocks %u",
+	TP_printk("dev %d:%d btree %s ag %u agino 0x%x whichfork %s levels %u blocks %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->agno,


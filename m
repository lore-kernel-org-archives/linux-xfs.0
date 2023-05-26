Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F41C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbjEZBNC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbjEZBM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:12:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5086AD8
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:12:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFCF864C27
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295A1C433AF;
        Fri, 26 May 2023 01:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063575;
        bh=0n1Zo6tnSnuPtvmwCDTyGOa8x838sX7NmbKIQ6WXQxU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rv1a886bpxZoLs16wXpFlvO6lr72yDfHG53ZDWZlP88Rl3wj5yhuiIMeClZP7d21V
         dFULL95bvIvHeSuDb7SF8pBR44u1f3Mtm/J8vCaPFt1lcF7wT3DkWPhXRHx9BfOU97
         dIZs7aOtNv27DVcC/PUwxVzX67aKt2t1SaMMG/9sOpHqHRBWaIKp0y7xoL9a5YSumU
         zv/cdq4uSw2NRkeKhRvR1F4ytCgdBW3ldODfXeJcbvp1XTkdfUz52m4Gz8dNjC0eYG
         OJmg2caApJJZH34xSqLFUyu1R2GCsyNKnc9XIa5UD5lC/MzXfQL0AFCbENW6R5/4eI
         jZRvgTYBIv6Pg==
Date:   Thu, 25 May 2023 18:12:54 -0700
Subject: [PATCH 3/4] xfs: add a realtime flag to the bmap update log redo
 items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063894.3734058.3752885596387164565.stgit@frogsfrogsfrogs>
In-Reply-To: <168506063846.3734058.6853885983674617900.stgit@frogsfrogsfrogs>
References: <168506063846.3734058.6853885983674617900.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Extend the bmap update (BUI) log items with a new realtime flag that
indicates that the updates apply against a realtime file's data fork.
We'll wire up the actual code later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |    4 +++-
 fs/xfs/xfs_bmap_item.c         |    2 ++
 fs/xfs/xfs_trace.h             |   23 ++++++++++++++++++-----
 3 files changed, 23 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index f13e0809dc63..367f536d9881 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -831,10 +831,12 @@ struct xfs_cud_log_format {
 
 #define XFS_BMAP_EXTENT_ATTR_FORK	(1U << 31)
 #define XFS_BMAP_EXTENT_UNWRITTEN	(1U << 30)
+#define XFS_BMAP_EXTENT_REALTIME	(1U << 29)
 
 #define XFS_BMAP_EXTENT_FLAGS		(XFS_BMAP_EXTENT_TYPE_MASK | \
 					 XFS_BMAP_EXTENT_ATTR_FORK | \
-					 XFS_BMAP_EXTENT_UNWRITTEN)
+					 XFS_BMAP_EXTENT_UNWRITTEN | \
+					 XFS_BMAP_EXTENT_REALTIME)
 
 /*
  * This is the structure used to lay out an bui log item in the
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 803127a16904..3668817a344b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -319,6 +319,8 @@ xfs_bmap_update_log_item(
 		map->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
 	if (bi->bi_whichfork == XFS_ATTR_FORK)
 		map->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		map->me_flags |= XFS_BMAP_EXTENT_REALTIME;
 }
 
 static struct xfs_log_item *
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 27a7901e2973..faecf54080a8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2979,9 +2979,11 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 	TP_ARGS(bi),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_ino_t, ino)
 		__field(xfs_agblock_t, agbno)
+		__field(xfs_fsblock_t, rtbno)
 		__field(int, whichfork)
 		__field(xfs_fileoff_t, l_loff)
 		__field(xfs_filblks_t, l_len)
@@ -2992,23 +2994,34 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 		struct xfs_inode	*ip = bi->bi_owner;
 
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->agno = XFS_FSB_TO_AGNO(ip->i_mount,
-					bi->bi_bmap.br_startblock);
+		if (xfs_ifork_is_realtime(ip, bi->bi_whichfork)) {
+			__entry->agno = 0;
+			__entry->agbno = 0;
+			__entry->rtbno = bi->bi_bmap.br_startblock;
+			__entry->opdev = ip->i_mount->m_rtdev_targp->bt_dev;
+		} else {
+			__entry->agno = XFS_FSB_TO_AGNO(ip->i_mount,
+						bi->bi_bmap.br_startblock);
+			__entry->agbno = XFS_FSB_TO_AGBNO(ip->i_mount,
+						bi->bi_bmap.br_startblock);
+			__entry->rtbno = 0;
+			__entry->opdev = __entry->dev;
+		}
 		__entry->ino = ip->i_ino;
-		__entry->agbno = XFS_FSB_TO_AGBNO(ip->i_mount,
-					bi->bi_bmap.br_startblock);
 		__entry->whichfork = bi->bi_whichfork;
 		__entry->l_loff = bi->bi_bmap.br_startoff;
 		__entry->l_len = bi->bi_bmap.br_blockcount;
 		__entry->l_state = bi->bi_bmap.br_state;
 		__entry->op = bi->bi_type;
 	),
-	TP_printk("dev %d:%d op %s ino 0x%llx agno 0x%x agbno 0x%x %s fileoff 0x%llx fsbcount 0x%llx state %d",
+	TP_printk("dev %d:%d op %s opdev %d:%d ino 0x%llx agno 0x%x agbno 0x%x rtbno 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->op, XFS_BMAP_INTENT_STRINGS),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->ino,
 		  __entry->agno,
 		  __entry->agbno,
+		  __entry->rtbno,
 		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __entry->l_loff,
 		  __entry->l_len,


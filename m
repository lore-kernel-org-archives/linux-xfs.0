Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A988FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbiL3Xsk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiL3Xsk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:48:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FACD64FA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:48:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00E3EB81DCA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9A9C433EF;
        Fri, 30 Dec 2022 23:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444115;
        bh=xQqgiYAyKDNOCs6/M+XZX4f+MKhtODOpVSLocSped+w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uvckip2oYA5/npqWAr46dZEHflNclB1iN6usoPQ6uGtjBp2QgEr2pCRawU+2P1TN8
         0tWyzkna7HlJEVU7PPQsvk3V6NbvpHzpIV3hHz0OMZl12t8ztPsgX3RXHJRK7rUyQV
         5noDDyz2YzH7ft4VOLJhQ1493GIBTsIxW03JqAdBflQjXlhW8AcxmFyZ/LBhnNbKyl
         DSpFK/hAXt7AJLUbkzfdPGuczBWlptvBfbrhB7kgMpy6p+uhgE+IKRvoBdktIIpDq4
         BHr69YVEucCCtBqjp0iWiWMeUGofdOR0EdqV8IT8+uHONOAJoGA7ymqCvi/waKhH4f
         rZiVBMaQlmFUw==
Subject: [PATCH 3/4] xfs: add a realtime flag to the bmap update log redo
 items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:45 -0800
Message-ID: <167243842506.699102.9766066283836624402.stgit@magnolia>
In-Reply-To: <167243842459.699102.4471319762222972730.stgit@magnolia>
References: <167243842459.699102.4471319762222972730.stgit@magnolia>
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
index b4ecba7c7663..82970413cb85 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -319,6 +319,8 @@ xfs_bmap_update_log_item(
 		map->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
 	if (bi->bi_whichfork == XFS_ATTR_FORK)
 		map->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
+	if (xfs_ifork_is_realtime(bmap->bi_owner, bmap->bi_whichfork))
+		map->me_flags |= XFS_BMAP_EXTENT_REALTIME;
 }
 
 static struct xfs_log_item *
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b65b7969a1d3..15bd6b86b514 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2971,9 +2971,11 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
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
@@ -2984,23 +2986,34 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
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


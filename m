Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364D9C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1984661038
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbhHQXnw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236443AbhHQXnw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:43:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C42B61008;
        Tue, 17 Aug 2021 23:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243798;
        bh=nEsz1Cm28Sby3uCj9LGKX5b1gh+V4C1MSPp5D5SfyaY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GgQbyYoZiMsh0RNHwI7BhlIaz7Umt6ZTRXNCgjAj1148roHUOTHdnGImzj34DxK/m
         o8PoHZn07er0SY0FRq3Gpwe6kYpkBX17s9aVeIHf5QfCwflH9ghRV3B/YZeMD172ga
         vkWiX11isSygi5OyNsLTzZ1gHzJJccnlP7mGBzihL/z/AbBCXyJksrzbCi5HiTISSn
         EqQeVHYr1X3zPicOMzLvJ8IF14XkIcZVgXb9vERc0MenUzRcy247bjE0YDC88M2NBK
         R1hFGB8dSKX/3m19D/dJAbHFmFDcZtyh+47isqmScFtO9u5sE8DP0d4T+iveWsq3n/
         z898HeUeJ3M7w==
Subject: [PATCH 12/15] xfs: resolve fork names in trace output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:43:18 -0700
Message-ID: <162924379815.761813.4507794744090240998.stgit@magnolia>
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

Emit whichfork values as text strings in the ftrace output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_types.h |    5 +++++
 fs/xfs/scrub/trace.h      |   16 ++++++++--------
 fs/xfs/xfs_trace.h        |    6 +++---
 3 files changed, 16 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 0870ef6f933d..b6da06b40989 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -87,6 +87,11 @@ typedef void *		xfs_failaddr_t;
 #define	XFS_ATTR_FORK	1
 #define	XFS_COW_FORK	2
 
+#define XFS_WHICHFORK_STRINGS \
+	{ XFS_DATA_FORK, 	"data" }, \
+	{ XFS_ATTR_FORK,	"attr" }, \
+	{ XFS_COW_FORK,		"cow" }
+
 /*
  * Min numbers of data/attr fork btree root pointers.
  */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cb5a74028b63..36f86b1497f4 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -176,10 +176,10 @@ TRACE_EVENT(xchk_file_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %s fileoff 0x%llx error %d ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %s type %s fileoff 0x%llx error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __entry->whichfork,
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->offset,
 		  __entry->error,
@@ -273,10 +273,10 @@ DECLARE_EVENT_CLASS(xchk_fblock_error_class,
 		__entry->offset = offset;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %s fileoff 0x%llx ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %s type %s fileoff 0x%llx ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __entry->whichfork,
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->offset,
 		  __entry->ret_ip)
@@ -381,10 +381,10 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %s type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __entry->whichfork,
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->level,
@@ -460,10 +460,10 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %s type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __entry->whichfork,
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->level,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 29bf5fbfa71b..474fdaffdccf 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1440,7 +1440,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 		  __entry->size,
 		  __entry->offset,
 		  __entry->count,
-		  __entry->whichfork == XFS_COW_FORK ? "cow" : "data",
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __entry->startoff,
 		  (int64_t)__entry->startblock,
 		  __entry->blockcount)
@@ -2604,7 +2604,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->ino,
-		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __entry->l_loff,
 		  __entry->l_len,
 		  __entry->l_state)
@@ -3851,7 +3851,7 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->agno,
 		  __entry->agino,
-		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __entry->levels,
 		  __entry->blocks)
 )


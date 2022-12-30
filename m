Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B91CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbiLaBhJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbiLaBhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:37:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C19A13DD9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:37:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B5EE61CC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF19C433D2;
        Sat, 31 Dec 2022 01:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450625;
        bh=9eJ8luAf8V+tPxcfvgulkbSSn9xRm1Hb6hxCjMbXIUU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LrLv75OXgFlTm9NiEahZrz3Qj91/+EOn7TxwbuCvXx9rUA9LiCl54mARRcyDdySKV
         6evcVCG9CFGibkmC9kwXJSybOw5P1Ga6AFMKh5e6Mmn+AfeHc9wvFf6Y1SSr4fVPl3
         +3dsEsHXmWhMIBjM/jRQ9xLra3opdSRnyHM5A3L9W3aK+nySocS24l0ZgGLLSzSVaU
         qXqvpDF+3ivHQ4Qow8qSr5DcvPamrSZsU5kxJ4G4Z20K2lH7pOA4lOBq57vHfsWDoe
         kCRCA4UvbALjEVEMc7ApOQCAR+phcUN0MVVXx58x/j6/2xE2YA65dYUpFNHQRLoGzp
         QtVfyOnWzdsaw==
Subject: [PATCH 01/38] xfs: prepare rmap btree cursor tracepoints for realtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:16 -0800
Message-ID: <167243869615.715303.9064037493733102205.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rework the rmap btree cursor tracepoints in preparation to handle the
realtime rmap btree cursor.  Mostly this involves renaming the field to
"rmapbno" and extracting the group number from the cursor when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.c |   18 ++++++++++++++++
 fs/xfs/xfs_trace.h |   58 +++++++++++++++++++++++++++-------------------------
 2 files changed, 48 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index d7ede15110e8..ae35868e0638 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -45,6 +45,24 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rmap.h"
 
+static inline void
+xfs_rmapbt_crack_agno_opdev(
+	struct xfs_btree_cur	*cur,
+	xfs_agnumber_t		*agno,
+	dev_t			*opdev)
+{
+	if (cur->bc_flags & XFS_BTREE_IN_MEMORY) {
+		*agno = 0;
+		*opdev = xfbtree_target(cur->bc_mem.xfbtree)->bt_dev;
+	} else if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		*agno = cur->bc_ino.rtg->rtg_rgno;
+		*opdev = cur->bc_mp->m_rtdev_targp->bt_dev;
+	} else {
+		*agno = cur->bc_ag.pag->pag_agno;
+		*opdev = cur->bc_mp->m_super->s_dev;
+	}
+}
+
 /*
  * We include this last to have the helpers above available for the trace
  * event implementations.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fd067e1e28db..6bf7c2aa8e9d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -14,11 +14,15 @@
  * ino: filesystem inode number
  *
  * agbno: per-AG block number in fs blocks
+ * rgbno: per-rtgroup block number in fs blocks
  * startblock: physical block number for file mappings.  This is either a
  *             segmented fsblock for data device mappings, or a rfsblock
  *             for realtime device mappings
  * fsbcount: number of blocks in an extent, in fs blocks
  *
+ * rmapbno: physical block number for a reverse mapping.  This is an agbno for
+ *          per-AG rmap btrees or a rgbno for realtime rmap btrees.
+ *
  * daddr: physical block number in 512b blocks
  * bbcount: number of blocks in a physical extent, in 512b blocks
  *
@@ -2836,13 +2840,14 @@ DEFINE_DEFER_PENDING_ITEM_EVENT(xfs_defer_finish_item);
 /* rmap tracepoints */
 DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_PROTO(struct xfs_btree_cur *cur,
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten,
+		 xfs_agblock_t rmapbno, xfs_extlen_t len, bool unwritten,
 		 const struct xfs_owner_info *oinfo),
-	TP_ARGS(cur, agbno, len, unwritten, oinfo),
+	TP_ARGS(cur, rmapbno, len, unwritten, oinfo),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, rmapbno)
 		__field(xfs_extlen_t, len)
 		__field(uint64_t, owner)
 		__field(uint64_t, offset)
@@ -2850,8 +2855,8 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
-		__entry->agbno = agbno;
+		xfs_rmapbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
+		__entry->rmapbno = rmapbno;
 		__entry->len = len;
 		__entry->owner = oinfo->oi_owner;
 		__entry->offset = oinfo->oi_offset;
@@ -2859,10 +2864,11 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		if (unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%lx",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x rmapbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->rmapbno,
 		  __entry->len,
 		  __entry->owner,
 		  __entry->offset,
@@ -2871,9 +2877,9 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 #define DEFINE_RMAP_EVENT(name) \
 DEFINE_EVENT(xfs_rmap_class, name, \
 	TP_PROTO(struct xfs_btree_cur *cur, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten, \
+		 xfs_agblock_t rmapbno, xfs_extlen_t len, bool unwritten, \
 		 const struct xfs_owner_info *oinfo), \
-	TP_ARGS(cur, agbno, len, unwritten, oinfo))
+	TP_ARGS(cur, rmapbno, len, unwritten, oinfo))
 
 /* btree cursor error/%ip tracepoint class */
 DECLARE_EVENT_CLASS(xfs_btree_error_class,
@@ -2932,40 +2938,35 @@ TRACE_EVENT(xfs_rmap_convert_state,
 	TP_ARGS(cur, state, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_ino_t, ino)
 		__field(int, state)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
-			__entry->agno = 0;
-			__entry->ino = cur->bc_ino.ip->i_ino;
-		} else {
-			__entry->agno = cur->bc_ag.pag->pag_agno;
-			__entry->ino = 0;
-		}
+		xfs_rmapbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
 		__entry->state = state;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno 0x%x ino 0x%llx state %d caller %pS",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x state %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
-		  __entry->ino,
 		  __entry->state,
 		  (char *)__entry->caller_ip)
 );
 
 DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	TP_PROTO(struct xfs_btree_cur *cur,
-		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 xfs_agblock_t rmapbno, xfs_extlen_t len,
 		 uint64_t owner, uint64_t offset, unsigned int flags),
-	TP_ARGS(cur, agbno, len, owner, offset, flags),
+	TP_ARGS(cur, rmapbno, len, owner, offset, flags),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, rmapbno)
 		__field(xfs_extlen_t, len)
 		__field(uint64_t, owner)
 		__field(uint64_t, offset)
@@ -2973,17 +2974,18 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
-		__entry->agbno = agbno;
+		xfs_rmapbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
+		__entry->rmapbno = rmapbno;
 		__entry->len = len;
 		__entry->owner = owner;
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x rmapbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->rmapbno,
 		  __entry->len,
 		  __entry->owner,
 		  __entry->offset,
@@ -2992,9 +2994,9 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 #define DEFINE_RMAPBT_EVENT(name) \
 DEFINE_EVENT(xfs_rmapbt_class, name, \
 	TP_PROTO(struct xfs_btree_cur *cur, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 xfs_agblock_t rmapbno, xfs_extlen_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
-	TP_ARGS(cur, agbno, len, owner, offset, flags))
+	TP_ARGS(cur, rmapbno, len, owner, offset, flags))
 
 TRACE_DEFINE_ENUM(XFS_RMAP_MAP);
 TRACE_DEFINE_ENUM(XFS_RMAP_MAP_SHARED);


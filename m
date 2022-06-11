Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CA4C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348466AbiFKB1o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242840AbiFKB1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:23 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3230D3FB128
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0831610E721F
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005AQK-IM
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELOL-Gs
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 47/50] xfs: pass perag to filestreams tracing
Date:   Sat, 11 Jun 2022 11:26:56 +1000
Message-Id: <20220611012659.3418072-48-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a3ef6a
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=9QBWbjWuI8rPk8iwX7gA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Pass perags instead of raw ag numbers, avoiding the need for the
special peek function for the tracing code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_filestream.c | 29 +++++------------------------
 fs/xfs/xfs_filestream.h |  1 -
 fs/xfs/xfs_trace.h      | 37 ++++++++++++++++++++-----------------
 3 files changed, 25 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 7b540898062e..6212e8adb7a9 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -31,25 +31,6 @@ enum xfs_fstrm_alloc {
 	XFS_PICK_LOWSPACE = 2,
 };
 
-/*
- * Allocation group filestream associations are tracked with per-ag atomic
- * counters.  These counters allow xfs_filestream_pick_ag() to tell whether a
- * particular AG already has active filestreams associated with it.
- */
-int
-xfs_filestream_peek_ag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno)
-{
-	struct xfs_perag *pag;
-	int		ret;
-
-	pag = xfs_perag_get(mp, agno);
-	ret = atomic_read(&pag->pagf_fstrms);
-	xfs_perag_put(pag);
-	return ret;
-}
-
 static void
 xfs_fstrm_free_func(
 	void			*data,
@@ -59,7 +40,7 @@ xfs_fstrm_free_func(
 		container_of(mru, struct xfs_fstrm_item, mru);
 	struct xfs_perag	*pag = item->pag;
 
-	trace_xfs_filestream_free(pag->pag_mount, mru->key, pag->pag_agno);
+	trace_xfs_filestream_free(pag, mru->key);
 	atomic_dec(&pag->pagf_fstrms);
 	xfs_perag_rele(pag);
 
@@ -99,7 +80,7 @@ xfs_filestream_pick_ag(
 
 restart:
 	for_each_perag_wrap(mp, start_agno, agno, pag) {
-		trace_xfs_filestream_scan(mp, ip->i_ino, agno);
+		trace_xfs_filestream_scan(pag, ip->i_ino);
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
@@ -169,7 +150,7 @@ xfs_filestream_pick_ag(
 		 */
 		if (!max_pag) {
 			*agp = NULLAGNUMBER;
-			trace_xfs_filestream_pick(ip, *agp, free, 0);
+			trace_xfs_filestream_pick(ip, NULL, free);
 			return 0;
 		}
 		pag = max_pag;
@@ -179,7 +160,7 @@ xfs_filestream_pick_ag(
 		xfs_perag_rele(max_pag);
 	}
 
-	trace_xfs_filestream_pick(ip, pag->pag_agno, free, 0);
+	trace_xfs_filestream_pick(ip, pag, free);
 
 	err = -ENOMEM;
 	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
@@ -259,7 +240,7 @@ xfs_filestream_select_ag_mru(
 	pag = container_of(mru, struct xfs_fstrm_item, mru)->pag;
 	xfs_mru_cache_done(mp->m_filestream);
 
-	trace_xfs_filestream_lookup(mp, ap->ip->i_ino, pag->pag_agno);
+	trace_xfs_filestream_lookup(pag, ap->ip->i_ino);
 
 	ap->blkno = XFS_AGB_TO_FSB(args->mp, pag->pag_agno, 0);
 	xfs_bmap_adjacent(ap);
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index df9f7553e106..84149ed0e340 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -14,7 +14,6 @@ struct xfs_alloc_arg;
 int xfs_filestream_mount(struct xfs_mount *mp);
 void xfs_filestream_unmount(struct xfs_mount *mp);
 void xfs_filestream_deassociate(struct xfs_inode *ip);
-int xfs_filestream_peek_ag(struct xfs_mount *mp, xfs_agnumber_t agno);
 int xfs_filestream_select_ag(struct xfs_bmalloca *ap,
 		struct xfs_alloc_arg *args, xfs_extlen_t *blen);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 686d6078e936..95d5bc7d9030 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -74,6 +74,7 @@ struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
 struct xfs_dqtrx;
 struct xfs_icwalk;
+struct xfs_perag;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -637,8 +638,8 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
 
 DECLARE_EVENT_CLASS(xfs_filestream_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino, xfs_agnumber_t agno),
-	TP_ARGS(mp, ino, agno),
+	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino),
+	TP_ARGS(pag, ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
@@ -646,10 +647,10 @@ DECLARE_EVENT_CLASS(xfs_filestream_class,
 		__field(int, streams)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
 		__entry->ino = ino;
-		__entry->agno = agno;
-		__entry->streams = xfs_filestream_peek_ag(mp, agno);
+		__entry->agno = pag->pag_agno;
+		__entry->streams = atomic_read(&pag->pagf_fstrms);
 	),
 	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -659,39 +660,41 @@ DECLARE_EVENT_CLASS(xfs_filestream_class,
 )
 #define DEFINE_FILESTREAM_EVENT(name) \
 DEFINE_EVENT(xfs_filestream_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino, xfs_agnumber_t agno), \
-	TP_ARGS(mp, ino, agno))
+	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino), \
+	TP_ARGS(pag, ino))
 DEFINE_FILESTREAM_EVENT(xfs_filestream_free);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
 
 TRACE_EVENT(xfs_filestream_pick,
-	TP_PROTO(struct xfs_inode *ip, xfs_agnumber_t agno,
-		 xfs_extlen_t free, int nscan),
-	TP_ARGS(ip, agno, free, nscan),
+	TP_PROTO(struct xfs_inode *ip, struct xfs_perag *pag,
+		 xfs_extlen_t free),
+	TP_ARGS(ip, pag, free),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(xfs_agnumber_t, agno)
 		__field(int, streams)
 		__field(xfs_extlen_t, free)
-		__field(int, nscan)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->agno = agno;
-		__entry->streams = xfs_filestream_peek_ag(ip->i_mount, agno);
+		if (pag) {
+			__entry->agno = pag->pag_agno;
+			__entry->streams = atomic_read(&pag->pagf_fstrms);
+		} else {
+			__entry->agno = NULLAGNUMBER;
+			__entry->streams = 0;
+		}
 		__entry->free = free;
-		__entry->nscan = nscan;
 	),
-	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d free %d nscan %d",
+	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d free %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->agno,
 		  __entry->streams,
-		  __entry->free,
-		  __entry->nscan)
+		  __entry->free)
 );
 
 DECLARE_EVENT_CLASS(xfs_lock_class,
-- 
2.35.1


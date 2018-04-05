Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751195AbeDEMLt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Apr 2018 08:11:49 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4426D7F7C0
        for <linux-xfs@vger.kernel.org>; Thu,  5 Apr 2018 12:11:49 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 131B18BE10
        for <linux-xfs@vger.kernel.org>; Thu,  5 Apr 2018 12:11:49 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] xfs: replace filestream item xfs_inode reference with xfs_mount
Date: Thu,  5 Apr 2018 08:11:47 -0400
Message-Id: <20180405121147.60897-2-bfoster@redhat.com>
In-Reply-To: <20180405121147.60897-1-bfoster@redhat.com>
References: <20180405121147.60897-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The filestreams allocator stores an xfs_fstrm_item structure in the
MRU to cache inode number to agno mappings for a particular length
of time. Each xfs_fstrm_item contains the internal MRU structure, an
inode pointer and agno value.

The inode pointer stored in the xfs_fstrm_item is not referenced,
however, which means the inode itself can be removed and reclaimed
before the MRU item is freed. If this occurs, xfs_fstrm_free_func()
can access freed or unrelated memory through xfs_fstrm_item->ip and
crash.

The obvious solution is to grab an inode reference for
xfs_fstrm_item. The filestream mechanism only actually uses the
inode pointer as a means to access the xfs_mount, however. Rather
than add unnecessary complexity, simplify the implementation to
store an xfs_mount pointer instead of the inode. This also requires
updates to the tracepoint class to provide the associated data via
parameters rather than the inode and a minor hack to peek at the MRU
key to establish the inode number at free time.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_filestream.c | 12 ++++++------
 fs/xfs/xfs_trace.h      | 14 +++++++-------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 043ca3808ea2..585f4f25fbe5 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -34,7 +34,7 @@
 
 struct xfs_fstrm_item {
 	struct xfs_mru_cache_elem	mru;
-	struct xfs_inode		*ip;
+	struct xfs_mount		*mp;
 	xfs_agnumber_t			ag; /* AG in use for this directory */
 };
 
@@ -127,9 +127,9 @@ xfs_fstrm_free_func(
 	struct xfs_fstrm_item	*item =
 		container_of(mru, struct xfs_fstrm_item, mru);
 
-	xfs_filestream_put_ag(item->ip->i_mount, item->ag);
+	xfs_filestream_put_ag(item->mp, item->ag);
 
-	trace_xfs_filestream_free(item->ip, item->ag);
+	trace_xfs_filestream_free(item->mp, mru->key, item->ag);
 
 	kmem_free(item);
 }
@@ -165,7 +165,7 @@ xfs_filestream_pick_ag(
 	trylock = XFS_ALLOC_FLAG_TRYLOCK;
 
 	for (nscan = 0; 1; nscan++) {
-		trace_xfs_filestream_scan(ip, ag);
+		trace_xfs_filestream_scan(mp, ip->i_ino, ag);
 
 		pag = xfs_perag_get(mp, ag);
 
@@ -265,7 +265,7 @@ xfs_filestream_pick_ag(
 		goto out_put_ag;
 
 	item->ag = *agp;
-	item->ip = ip;
+	item->mp = mp;
 
 	err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, &item->mru);
 	if (err) {
@@ -333,7 +333,7 @@ xfs_filestream_lookup_ag(
 		ag = container_of(mru, struct xfs_fstrm_item, mru)->ag;
 		xfs_mru_cache_done(mp->m_filestream);
 
-		trace_xfs_filestream_lookup(ip, ag);
+		trace_xfs_filestream_lookup(mp, ip->i_ino, ag);
 		goto out;
 	}
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a982c0b623d0..8955254b900e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -506,8 +506,8 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
 
 DECLARE_EVENT_CLASS(xfs_filestream_class,
-	TP_PROTO(struct xfs_inode *ip, xfs_agnumber_t agno),
-	TP_ARGS(ip, agno),
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino, xfs_agnumber_t agno),
+	TP_ARGS(mp, ino, agno),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
@@ -515,10 +515,10 @@ DECLARE_EVENT_CLASS(xfs_filestream_class,
 		__field(int, streams)
 	),
 	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ino = ino;
 		__entry->agno = agno;
-		__entry->streams = xfs_filestream_peek_ag(ip->i_mount, agno);
+		__entry->streams = xfs_filestream_peek_ag(mp, agno);
 	),
 	TP_printk("dev %d:%d ino 0x%llx agno %u streams %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -528,8 +528,8 @@ DECLARE_EVENT_CLASS(xfs_filestream_class,
 )
 #define DEFINE_FILESTREAM_EVENT(name) \
 DEFINE_EVENT(xfs_filestream_class, name, \
-	TP_PROTO(struct xfs_inode *ip, xfs_agnumber_t agno), \
-	TP_ARGS(ip, agno))
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino, xfs_agnumber_t agno), \
+	TP_ARGS(mp, ino, agno))
 DEFINE_FILESTREAM_EVENT(xfs_filestream_free);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
-- 
2.13.6


Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BBpMSU137851 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 05:51:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDAC61358289
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 03:52:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	lxOWtAASXjBwIyqw for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 03:52:15 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11243208-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:22:14 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUIof-0003f6-5I
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:52:13 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUIkT-0006GE-0J
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 22:47:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/10] XFS: Kill filestreams cache flush
Date: Mon, 11 Jan 2010 22:47:47 +1100
Message-Id: <1263210469-22171-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1263210469-22171-1-git-send-email-david@fromorbit.com>
References: <1263210469-22171-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The filestreams cache flush is not needed in the sync code as it
does not affect data writeback, and it is now not used by the
growfs code, either, so kill it.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    3 ---
 fs/xfs/xfs_filestream.c     |   14 --------------
 fs/xfs/xfs_filestream.h     |    1 -
 fs/xfs/xfs_mru_cache.c      |    2 +-
 fs/xfs/xfs_mru_cache.h      |    1 -
 5 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 2de7876..2eca601 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -451,9 +451,6 @@ xfs_quiesce_data(
 	xfs_sync_data(mp, SYNC_WAIT);
 	xfs_qm_sync(mp, SYNC_WAIT);
 
-	/* drop inode references pinned by filestreams */
-	xfs_filestream_flush(mp);
-
 	/* write superblock and hoover up shutdown errors */
 	error = xfs_sync_fsdata(mp, SYNC_WAIT);
 
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 914d00d..390850e 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -455,20 +455,6 @@ xfs_filestream_unmount(
 }
 
 /*
- * If the mount point's m_perag tree is going to be modified, all
- * outstanding cache entries must be flushed to avoid accessing reference count
- * addresses that have been freed.  The call to xfs_filestream_flush() must be
- * made inside the block that holds the m_perag_lock in write mode to do the
- * reallocation.
- */
-void
-xfs_filestream_flush(
-	xfs_mount_t	*mp)
-{
-	xfs_mru_cache_flush(mp->m_filestream);
-}
-
-/*
  * Return the AG of the filestream the file or directory belongs to, or
  * NULLAGNUMBER otherwise.
  */
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 58378b2..260f757 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -135,7 +135,6 @@ int xfs_filestream_init(void);
 void xfs_filestream_uninit(void);
 int xfs_filestream_mount(struct xfs_mount *mp);
 void xfs_filestream_unmount(struct xfs_mount *mp);
-void xfs_filestream_flush(struct xfs_mount *mp);
 xfs_agnumber_t xfs_filestream_lookup_ag(struct xfs_inode *ip);
 int xfs_filestream_associate(struct xfs_inode *dip, struct xfs_inode *ip);
 void xfs_filestream_deassociate(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 4b0613d..45ce15d 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -398,7 +398,7 @@ exit:
  * guaranteed that all the free functions for all the elements have finished
  * executing and the reaper is not running.
  */
-void
+static void
 xfs_mru_cache_flush(
 	xfs_mru_cache_t		*mru)
 {
diff --git a/fs/xfs/xfs_mru_cache.h b/fs/xfs/xfs_mru_cache.h
index 5d439f3..36dd3ec 100644
--- a/fs/xfs/xfs_mru_cache.h
+++ b/fs/xfs/xfs_mru_cache.h
@@ -42,7 +42,6 @@ void xfs_mru_cache_uninit(void);
 int xfs_mru_cache_create(struct xfs_mru_cache **mrup, unsigned int lifetime_ms,
 			     unsigned int grp_count,
 			     xfs_mru_cache_free_func_t free_func);
-void xfs_mru_cache_flush(xfs_mru_cache_t *mru);
 void xfs_mru_cache_destroy(struct xfs_mru_cache *mru);
 int xfs_mru_cache_insert(struct xfs_mru_cache *mru, unsigned long key,
 				void *value);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

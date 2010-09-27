Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8R1lLn2150656 for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 20:47:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EF469FE62
	for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 18:48:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	L0Xv9917c9966NJd for <xfs@oss.sgi.com>;
	Sun, 26 Sep 2010 18:48:17 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40635751-1927428
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 11:18:16 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1P02pC-0002su-5p
	for xfs@oss.sgi.com; Mon, 27 Sep 2010 11:48:14 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1P02p5-0003ps-Ds
	for xfs@oss.sgi.com; Mon, 27 Sep 2010 11:48:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/18] xfs: kill XBF_FS_MANAGED buffers
Date: Mon, 27 Sep 2010 11:47:44 +1000
Message-Id: <1285552073-14663-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1285552073-14663-1-git-send-email-david@fromorbit.com>
References: <1285552073-14663-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Filesystem level managed buffers are buffers that have their
lifecycle controlled by the filesystem layer, not the buffer cache.
We currently cache these buffers, which makes cleanup and cache
walking somewhat troublesome. Convert the fs managed buffers to
uncached buffers obtained by via xfs_buf_get_uncached(), and remove
the XBF_FS_MANAGED special cases from the buffer cache.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   20 +++------------
 fs/xfs/linux-2.6/xfs_buf.h |    4 ---
 fs/xfs/xfs_mount.c         |   57 +++++++++++++------------------------------
 3 files changed, 21 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index d692897..975d658 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -826,8 +826,6 @@ xfs_buf_rele(
 			atomic_inc(&bp->b_hold);
 			spin_unlock(&hash->bh_lock);
 			(*(bp->b_relse)) (bp);
-		} else if (bp->b_flags & XBF_FS_MANAGED) {
-			spin_unlock(&hash->bh_lock);
 		} else {
 			ASSERT(!(bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)));
 			list_del_init(&bp->b_hash_list);
@@ -1433,26 +1431,16 @@ void
 xfs_wait_buftarg(
 	xfs_buftarg_t	*btp)
 {
-	xfs_buf_t	*bp, *n;
 	xfs_bufhash_t	*hash;
 	uint		i;
 
 	for (i = 0; i < (1 << btp->bt_hashshift); i++) {
 		hash = &btp->bt_hash[i];
-again:
 		spin_lock(&hash->bh_lock);
-		list_for_each_entry_safe(bp, n, &hash->bh_list, b_hash_list) {
-			ASSERT(btp == bp->b_target);
-			if (!(bp->b_flags & XBF_FS_MANAGED)) {
-				spin_unlock(&hash->bh_lock);
-				/*
-				 * Catch superblock reference count leaks
-				 * immediately
-				 */
-				BUG_ON(bp->b_bn == 0);
-				delay(100);
-				goto again;
-			}
+		while (!list_empty(&hash->bh_list)) {
+			spin_unlock(&hash->bh_lock);
+			delay(100);
+			spin_lock(&hash->bh_lock);
 		}
 		spin_unlock(&hash->bh_lock);
 	}
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index def2cea..1f109ce 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -51,7 +51,6 @@ typedef enum {
 #define XBF_DONE	(1 << 5) /* all pages in the buffer uptodate */
 #define XBF_DELWRI	(1 << 6) /* buffer has dirty pages */
 #define XBF_STALE	(1 << 7) /* buffer has been staled, do not find it */
-#define XBF_FS_MANAGED	(1 << 8) /* filesystem controls freeing memory */
 #define XBF_ORDERED	(1 << 11)/* use ordered writes */
 #define XBF_READ_AHEAD	(1 << 12)/* asynchronous read-ahead */
 #define XBF_LOG_BUFFER	(1 << 13)/* this is a buffer used for the log */
@@ -104,7 +103,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_DELWRI,		"DELWRI" }, \
 	{ XBF_STALE,		"STALE" }, \
-	{ XBF_FS_MANAGED,	"FS_MANAGED" }, \
 	{ XBF_ORDERED,		"ORDERED" }, \
 	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
 	{ XBF_LOCK,		"LOCK" },  	/* should never be set */\
@@ -279,8 +277,6 @@ extern void xfs_buf_terminate(void);
 					XFS_BUF_DONE(bp);	\
 				} while (0)
 
-#define XFS_BUF_UNMANAGE(bp)	((bp)->b_flags &= ~XBF_FS_MANAGED)
-
 #define XFS_BUF_DELAYWRITE(bp)		((bp)->b_flags |= XBF_DELWRI)
 #define XFS_BUF_UNDELAYWRITE(bp)	xfs_buf_delwri_dequeue(bp)
 #define XFS_BUF_ISDELAYWRITE(bp)	((bp)->b_flags & XBF_DELWRI)
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 14fc6e9..fbca293 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -646,7 +646,6 @@ int
 xfs_readsb(xfs_mount_t *mp, int flags)
 {
 	unsigned int	sector_size;
-	unsigned int	extra_flags;
 	xfs_buf_t	*bp;
 	int		error;
 
@@ -659,28 +658,24 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	 * access to the superblock.
 	 */
 	sector_size = xfs_getsize_buftarg(mp->m_ddev_targp);
-	extra_flags = XBF_LOCK | XBF_FS_MANAGED | XBF_MAPPED;
 
-	bp = xfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR, BTOBB(sector_size),
-			  extra_flags);
-	if (!bp || XFS_BUF_ISERROR(bp)) {
-		xfs_fs_mount_cmn_err(flags, "SB read failed");
-		error = bp ? XFS_BUF_GETERROR(bp) : ENOMEM;
-		goto fail;
+reread:
+	bp = xfs_buf_read_uncached(mp, mp->m_ddev_targp,
+					XFS_SB_DADDR, sector_size, 0);
+	if (!bp) {
+		xfs_fs_mount_cmn_err(flags, "SB buffer read failed");
+		return EIO;
 	}
-	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 
 	/*
 	 * Initialize the mount structure from the superblock.
 	 * But first do some basic consistency checking.
 	 */
 	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
-
 	error = xfs_mount_validate_sb(mp, &(mp->m_sb), flags);
 	if (error) {
 		xfs_fs_mount_cmn_err(flags, "SB validate failed");
-		goto fail;
+		goto release_buf;
 	}
 
 	/*
@@ -691,7 +686,7 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 			"device supports only %u byte sectors (not %u)",
 			sector_size, mp->m_sb.sb_sectsize);
 		error = ENOSYS;
-		goto fail;
+		goto release_buf;
 	}
 
 	/*
@@ -699,33 +694,20 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 	 * re-read the superblock so the buffer is correctly sized.
 	 */
 	if (sector_size < mp->m_sb.sb_sectsize) {
-		XFS_BUF_UNMANAGE(bp);
 		xfs_buf_relse(bp);
 		sector_size = mp->m_sb.sb_sectsize;
-		bp = xfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR,
-				  BTOBB(sector_size), extra_flags);
-		if (!bp || XFS_BUF_ISERROR(bp)) {
-			xfs_fs_mount_cmn_err(flags, "SB re-read failed");
-			error = bp ? XFS_BUF_GETERROR(bp) : ENOMEM;
-			goto fail;
-		}
-		ASSERT(XFS_BUF_ISBUSY(bp));
-		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
+		goto reread;
 	}
 
 	/* Initialize per-cpu counters */
 	xfs_icsb_reinit_counters(mp);
 
 	mp->m_sb_bp = bp;
-	xfs_buf_relse(bp);
-	ASSERT(XFS_BUF_VALUSEMA(bp) > 0);
+	xfs_buf_unlock(bp);
 	return 0;
 
- fail:
-	if (bp) {
-		XFS_BUF_UNMANAGE(bp);
-		xfs_buf_relse(bp);
-	}
+release_buf:
+	xfs_buf_relse(bp);
 	return error;
 }
 
@@ -2005,18 +1987,13 @@ xfs_getsb(
  */
 void
 xfs_freesb(
-	xfs_mount_t	*mp)
+	struct xfs_mount	*mp)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf		*bp = mp->m_sb_bp;
 
-	/*
-	 * Use xfs_getsb() so that the buffer will be locked
-	 * when we call xfs_buf_relse().
-	 */
-	bp = xfs_getsb(mp, 0);
-	XFS_BUF_UNMANAGE(bp);
-	xfs_buf_relse(bp);
+	xfs_buf_lock(bp);
 	mp->m_sb_bp = NULL;
+	xfs_buf_relse(bp);
 }
 
 /*
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

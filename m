Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BFEAD7F37
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 17:58:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 40763AC002
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 15:58:48 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HuWcED76uly13G5y for <xfs@oss.sgi.com>;
	Sun, 23 Aug 2015 15:58:43 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZTeDp-0006zC-Ar
	for xfs@oss.sgi.com; Mon, 24 Aug 2015 08:58:41 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZTeDp-0006Ee-9i
	for xfs@oss.sgi.com; Mon, 24 Aug 2015 08:58:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix non-debug build warnings
Date: Mon, 24 Aug 2015 08:58:41 +1000
Message-Id: <1440370721-23931-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

There seem to be a couple of new set-but-unused build warnings
that gcc 4.9.3 is now warning about. These are not regressions, just
hte compiler being more picky.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c      |  4 +---
 fs/xfs/xfs_buf_item.c | 20 +++++++++++++-------
 fs/xfs/xfs_buf_item.h |  2 +-
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d7dbd81..c46166b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -438,7 +438,6 @@ _xfs_buf_find(
 	xfs_buf_flags_t		flags,
 	xfs_buf_t		*new_bp)
 {
-	size_t			numbytes;
 	struct xfs_perag	*pag;
 	struct rb_node		**rbp;
 	struct rb_node		*parent;
@@ -450,10 +449,9 @@ _xfs_buf_find(
 
 	for (i = 0; i < nmaps; i++)
 		numblks += map[i].bm_len;
-	numbytes = BBTOB(numblks);
 
 	/* Check for IOs smaller than the sector size / not sector aligned */
-	ASSERT(!(numbytes < btp->bt_meta_sectorsize));
+	ASSERT(!(BBTOB(numblks) < btp->bt_meta_sectorsize));
 	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_meta_sectormask));
 
 	/*
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 919057e..7e986da 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -746,13 +746,13 @@ xfs_buf_item_free_format(
  * buffer (see xfs_buf_attach_iodone() below), then put the
  * buf log item at the front.
  */
-void
+int
 xfs_buf_item_init(
-	xfs_buf_t	*bp,
-	xfs_mount_t	*mp)
+	struct xfs_buf	*bp,
+	struct xfs_mount *mp)
 {
-	xfs_log_item_t		*lip = bp->b_fspriv;
-	xfs_buf_log_item_t	*bip;
+	struct xfs_log_item	*lip = bp->b_fspriv;
+	struct xfs_buf_log_item	*bip;
 	int			chunks;
 	int			map_size;
 	int			error;
@@ -766,12 +766,11 @@ xfs_buf_item_init(
 	 */
 	ASSERT(bp->b_target->bt_mount == mp);
 	if (lip != NULL && lip->li_type == XFS_LI_BUF)
-		return;
+		return 0;
 
 	bip = kmem_zone_zalloc(xfs_buf_item_zone, KM_SLEEP);
 	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
 	bip->bli_buf = bp;
-	xfs_buf_hold(bp);
 
 	/*
 	 * chunks is the number of XFS_BLF_CHUNK size pieces the buffer
@@ -784,6 +783,11 @@ xfs_buf_item_init(
 	 */
 	error = xfs_buf_item_get_format(bip, bp->b_map_count);
 	ASSERT(error == 0);
+	if (error) {	/* to stop gcc throwing set-but-unused warnings */
+		kmem_zone_free(xfs_buf_item_zone, bip);
+		return error;
+	}
+
 
 	for (i = 0; i < bip->bli_format_count; i++) {
 		chunks = DIV_ROUND_UP(BBTOB(bp->b_maps[i].bm_len),
@@ -803,6 +807,8 @@ xfs_buf_item_init(
 	if (bp->b_fspriv)
 		bip->bli_item.li_bio_list = bp->b_fspriv;
 	bp->b_fspriv = bip;
+	xfs_buf_hold(bp);
+	return 0;
 }
 
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 3f3455a..f7eba99 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -61,7 +61,7 @@ typedef struct xfs_buf_log_item {
 	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
 } xfs_buf_log_item_t;
 
-void	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
+int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_relse(struct xfs_buf *);
 void	xfs_buf_item_log(xfs_buf_log_item_t *, uint, uint);
 uint	xfs_buf_item_dirty(xfs_buf_log_item_t *);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

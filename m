Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8475C7F99
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0EBA5AC016
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XvA4DzCc5lowaVxl for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:08 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/19] xfs: remove unused blocksize arg from
	xfs_setsize_buftarg()
Date: Mon,  7 Apr 2014 14:58:53 -0500
Message-Id: <1396900746-22201-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_buf.c   |    4 +---
 fs/xfs/xfs_buf.h   |    2 +-
 fs/xfs/xfs_super.c |    5 +----
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9c061ef..03742ea 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1596,7 +1596,6 @@ xfs_free_buftarg(
 int
 xfs_setsize_buftarg(
 	xfs_buftarg_t		*btp,
-	unsigned int		blocksize,
 	unsigned int		sectorsize)
 {
 	/* Set up metadata sector size info */
@@ -1631,8 +1630,7 @@ xfs_setsize_buftarg_early(
 	xfs_buftarg_t		*btp,
 	struct block_device	*bdev)
 {
-	return xfs_setsize_buftarg(btp, PAGE_SIZE,
-				   bdev_logical_block_size(bdev));
+	return xfs_setsize_buftarg(btp, bdev_logical_block_size(bdev));
 }
 
 xfs_buftarg_t *
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 9953395..0aee9b8 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -376,7 +376,7 @@ extern xfs_buftarg_t *xfs_alloc_buftarg(struct xfs_mount *,
 			struct block_device *, int, const char *);
 extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
-extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
+extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
 
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d971f49..c10197e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -811,8 +811,7 @@ xfs_setup_devices(
 {
 	int			error;
 
-	error = xfs_setsize_buftarg(mp->m_ddev_targp, mp->m_sb.sb_blocksize,
-				    mp->m_sb.sb_sectsize);
+	error = xfs_setsize_buftarg(mp->m_ddev_targp, mp->m_sb.sb_sectsize);
 	if (error)
 		return error;
 
@@ -822,14 +821,12 @@ xfs_setup_devices(
 		if (xfs_sb_version_hassector(&mp->m_sb))
 			log_sector_size = mp->m_sb.sb_logsectsize;
 		error = xfs_setsize_buftarg(mp->m_logdev_targp,
-					    mp->m_sb.sb_blocksize,
 					    log_sector_size);
 		if (error)
 			return error;
 	}
 	if (mp->m_rtdev_targp) {
 		error = xfs_setsize_buftarg(mp->m_rtdev_targp,
-					    mp->m_sb.sb_blocksize,
 					    mp->m_sb.sb_sectsize);
 		if (error)
 			return error;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

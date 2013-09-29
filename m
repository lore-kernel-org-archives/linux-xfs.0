Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 395CB7F56
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 05:55:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27990304039
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 03:55:18 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id LSAx5XDSeYI2zwhZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 03:55:17 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r8TAtFQB030965
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 10:55:16 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r8TAtEW1023220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 10:55:15 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r8TAtESt015281 for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 10:55:14 GMT
Message-ID: <52480744.10606@oracle.com>
Date: Sun, 29 Sep 2013 18:56:04 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: get rid of count from xfs_iomap_write_allocate()
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Get rid of function variable count from xfs_iomap_write_allocate() as
it is unused.

Additionally, checkpatch warn me of the following for this change:
WARNING: extern prototypes should be avoided in .h files
+extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,

So this patch also remove all extern function prototypes at xfs_iomap.h
to suppress it to make this code style in consistent manner in this file.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_aops.c  |    2 +-
 fs/xfs/xfs_iomap.c |    1 -
 fs/xfs/xfs_iomap.h |    8 ++++----
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e51e581..f3f95f0 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -333,7 +333,7 @@ xfs_map_blocks(
 
 	if (type == XFS_IO_DELALLOC &&
 	    (!nimaps || isnullstartblock(imap->br_startblock))) {
-		error = xfs_iomap_write_allocate(ip, offset, count, imap);
+		error = xfs_iomap_write_allocate(ip, offset, imap);
 		if (!error)
 			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
 		return -XFS_ERROR(error);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8d4d49b..521fdf2 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -655,7 +655,6 @@ int
 xfs_iomap_write_allocate(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
-	size_t		count,
 	xfs_bmbt_irec_t *imap)
 {
 	xfs_mount_t	*mp = ip->i_mount;
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 8061576..411fbb8 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -21,12 +21,12 @@
 struct xfs_inode;
 struct xfs_bmbt_irec;
 
-extern int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
+int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *, int);
-extern int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
+int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *);
-extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t, size_t,
+int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
 			struct xfs_bmbt_irec *);
-extern int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, size_t);
+int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, size_t);
 
 #endif /* __XFS_IOMAP_H__*/
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

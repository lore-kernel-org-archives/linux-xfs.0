Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CA2187F58
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 11:52:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C0CA8F8035
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:52:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MFmAIXuu2BNQwlkZ for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:52:12 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rADHqCsZ004598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 12:52:12 -0500
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rADHqBMJ016891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 12:52:12 -0500
Message-ID: <5283BC4B.9090204@redhat.com>
Date: Wed, 13 Nov 2013 11:52:11 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: remove unused "verbose" argument from xfs_setsize_buftarg
	path
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
To: xfs-oss <xfs@oss.sgi.com>

The "verbose" argument has been unused since 
ffe37436 xfs: stop using the page cache to back the buffer cache

Remove it, and then give the function a better (?) name since
no flags are involved.

Fix inconsistent comment spacing while we're at it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2634700..85d916a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1602,11 +1602,10 @@ xfs_free_buftarg(
 }
 
 STATIC int
-xfs_setsize_buftarg_flags(
+__xfs_setsize_buftarg(
 	xfs_buftarg_t		*btp,
 	unsigned int		blocksize,
-	unsigned int		sectorsize,
-	int			verbose)
+	unsigned int		sectorsize)
 {
 	btp->bt_bsize = blocksize;
 	btp->bt_sshift = ffs(sectorsize) - 1;
@@ -1627,17 +1626,17 @@ xfs_setsize_buftarg_flags(
 }
 
 /*
- *	When allocating the initial buffer target we have not yet
- *	read in the superblock, so don't know what sized sectors
- *	are being used at this early stage.  Play safe.
+ * When allocating the initial buffer target we have not yet
+ * read in the superblock, so don't know what sized sectors
+ * are being used at this early stage.  Play safe.
  */
 STATIC int
 xfs_setsize_buftarg_early(
 	xfs_buftarg_t		*btp,
 	struct block_device	*bdev)
 {
-	return xfs_setsize_buftarg_flags(btp,
-			PAGE_SIZE, bdev_logical_block_size(bdev), 0);
+	return __xfs_setsize_buftarg(btp,
+			PAGE_SIZE, bdev_logical_block_size(bdev));
 }
 
 int
@@ -1646,7 +1645,7 @@ xfs_setsize_buftarg(
 	unsigned int		blocksize,
 	unsigned int		sectorsize)
 {
-	return xfs_setsize_buftarg_flags(btp, blocksize, sectorsize, 1);
+	return __xfs_setsize_buftarg(btp, blocksize, sectorsize);
 }
 
 xfs_buftarg_t *

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2Hljlk092697 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 11:47:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 134CA984866
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 09:47:43 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7VEU5zvANBJfE7AW for <xfs@oss.sgi.com>;
	Fri, 02 Dec 2011 09:47:43 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RWXD4-0000mU-VC
	for xfs@oss.sgi.com; Fri, 02 Dec 2011 17:47:43 +0000
Message-Id: <20111202174742.901901836@bombadil.infradead.org>
Date: Fri, 02 Dec 2011 12:46:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/12] repair: kill check_inode_block
References: <20111202174619.179530033@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-kill-check_inode_block
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

It's a wrapper around check_aginode_block, but given that the only caller
already has the agno and agbno at hand it isn't overly useful.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/dino_chunks.c
===================================================================
--- xfsprogs-dev.orig/repair/dino_chunks.c	2011-11-14 20:04:08.847867904 +0100
+++ xfsprogs-dev/repair/dino_chunks.c	2011-11-14 20:04:59.487867601 +0100
@@ -72,14 +72,6 @@ check_aginode_block(xfs_mount_t	*mp,
 	return(cnt);
 }
 
-int
-check_inode_block(xfs_mount_t		*mp,
-			xfs_ino_t	ino)
-{
-	return(check_aginode_block(mp, XFS_INO_TO_AGNO(mp, ino),
-					XFS_INO_TO_AGBNO(mp, ino)));
-}
-
 /*
  * tries to establish if the inode really exists in a valid
  * inode chunk.  returns number of new inodes if things are good
@@ -145,10 +137,9 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	 */
 	if (XFS_IALLOC_BLOCKS(mp) == 1)  {
 		if (agbno > max_agbno)
-			return(0);
-
-		if (check_inode_block(mp, ino) == 0)
-			return(0);
+			return 0;
+		if (check_aginode_block(mp, agno, agino) == 0)
+			return 0;
 
 		pthread_mutex_lock(&ag_locks[agno]);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

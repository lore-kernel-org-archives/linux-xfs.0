Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47B727F37
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 10:18:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D52C8F8037
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 08:18:07 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id hJUimfwCIhAepAR3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 08:18:05 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WgbhT-0003iB-WB
	for xfs@oss.sgi.com; Sat, 03 May 2014 15:18:04 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] xfs: pass struct da_args to xfs_attr_calc_size
Date: Sat,  3 May 2014 17:20:15 +0200
Message-Id: <1399130415-5382-6-git-send-email-hch@lst.de>
In-Reply-To: <1399130415-5382-1-git-send-email-hch@lst.de>
References: <1399130415-5382-1-git-send-email-hch@lst.de>
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

And remove a very confused comment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 1208621..86f482e 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -162,12 +162,10 @@ xfs_attr_get(
  */
 STATIC int
 xfs_attr_calc_size(
-	struct xfs_inode 	*ip,
-	int			namelen,
-	int			valuelen,
+	struct xfs_da_args	*args,
 	int			*local)
 {
-	struct xfs_mount 	*mp = ip->i_mount;
+	struct xfs_mount	*mp = args->dp->i_mount;
 	int			size;
 	int			nblks;
 
@@ -175,7 +173,7 @@ xfs_attr_calc_size(
 	 * Determine space new attribute will use, and if it would be
 	 * "local" or "remote" (note: local != inline).
 	 */
-	size = xfs_attr_leaf_newentsize(namelen, valuelen,
+	size = xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
 					mp->m_sb.sb_blocksize, local);
 
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
@@ -189,7 +187,7 @@ xfs_attr_calc_size(
 		 * Out of line attribute, cannot double split, but
 		 * make room for the attribute value itself.
 		 */
-		uint	dblocks = XFS_B_TO_FSB(mp, valuelen);
+		uint	dblocks = XFS_B_TO_FSB(mp, args->valuelen);
 		nblks += dblocks;
 		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
 	}
@@ -227,9 +225,7 @@ xfs_attr_set(
 	args.firstblock = &firstblock;
 	args.flist = &flist;
 	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
-
-	/* Size is now blocks for attribute data */
-	args.total = xfs_attr_calc_size(dp, args.namelen, valuelen, &local);
+	args.total = xfs_attr_calc_size(&args, &local);
 
 	error = xfs_qm_dqattach(dp, 0);
 	if (error)
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

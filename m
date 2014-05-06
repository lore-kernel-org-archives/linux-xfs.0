Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6FE9D7FC9
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:07:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E97A6AC006
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:07:01 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id Bd6eDGSvYD8PL919 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:07:00 -0700 (PDT)
Date: Tue, 6 May 2014 10:06:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5 v2] xfs: pass struct da_args to xfs_attr_calc_size
Message-ID: <20140506080658.GA12085@lst.de>
References: <1399130415-5382-1-git-send-email-hch@lst.de>
	<1399130415-5382-6-git-send-email-hch@lst.de>
	<20140505202149.GF12448@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140505202149.GF12448@laptop.bfoster>
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
To: xfs@oss.sgi.com
Cc: Brian Foster <bfoster@redhat.com>

And remove a very confused comment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_attr.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

[updated for a minor conflict in for-next]

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index d5c03ed..1fc1f06 100644
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
-		uint	dblocks = xfs_attr3_rmt_blocks(mp, valuelen);
+		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->valuelen);
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

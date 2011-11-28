Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAS8JRrS225227 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 02:19:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2602327AD4D
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 00:19:25 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VDRdCGTEYrIAxQ1U for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 00:19:25 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RUwQv-000776-GH
	for xfs@oss.sgi.com; Mon, 28 Nov 2011 08:19:25 +0000
Message-Id: <20111128081925.458494771@bombadil.infradead.org>
Date: Mon, 28 Nov 2011 03:17:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] xfs: fix attr2 vs large data fork assert
References: <20111128081732.350228200@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-attr-oops
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

With Dmitrys fsstress updates I've seen very reproducible crashes in
xfs_attr_shortform_remove because xfs_attr_shortform_bytesfit claims that
the attributes would not fit inline into the inode after removing an
attribute.  It turns out that we were operating on an inode with lots
of delalloc extents, and thus an if_bytes values for the data fork that
is larger than biggest possible on-disk storage for it which utterly
confuses the code near the end of xfs_attr_shortform_bytesfit.

Fix this by always allowing the current attribute fork, like we already
do for the attr1 format, given that delalloc conversion will take care
for moving either the data or attribute area out of line if it doesn't
fit at that point - or making the point moot by merging extents at this
point.

Also document the function better, and clean up some lose bits.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c	2011-11-04 16:31:32.244656675 +0100
+++ xfs/fs/xfs/xfs_attr_leaf.c	2011-11-05 09:01:32.613995075 +0100
@@ -110,6 +110,7 @@ xfs_attr_namesp_match(int arg_flags, int
 /*
  * Query whether the requested number of additional bytes of extended
  * attribute space will be able to fit inline.
+ *
  * Returns zero if not, else the di_forkoff fork offset to be used in the
  * literal area for attribute data once the new bytes have been added.
  *
@@ -136,11 +137,26 @@ xfs_attr_shortform_bytesfit(xfs_inode_t
 		return (offset >= minforkoff) ? minforkoff : 0;
 	}
 
-	if (!(mp->m_flags & XFS_MOUNT_ATTR2)) {
-		if (bytes <= XFS_IFORK_ASIZE(dp))
-			return dp->i_d.di_forkoff;
+	/*
+	 * If the requested numbers of bytes is smaller or equal to the
+	 * current attribute fork size we can always proceed.
+	 *
+	 * Note that if_bytes in the data fork might actually be larger than
+	 * the current data fork size is due to delalloc extents. In that
+	 * case either the extent count will go down when they are converted
+	 * to ral extents, or the delalloc conversion will take care of the
+	 * literal area rebalancing.
+	 */
+	if (bytes <= XFS_IFORK_ASIZE(dp))
+		return dp->i_d.di_forkoff;
+
+	/*
+	 * For attr2 we can try to move the forkoff if there is space in the
+	 * literal area, but for the old format we are done if there is no
+	 * space in the fixes attribute fork.
+	 */
+	if (!(mp->m_flags & XFS_MOUNT_ATTR2))
 		return 0;
-	}
 
 	dsize = dp->i_df.if_bytes;
 	
@@ -157,10 +173,9 @@ xfs_attr_shortform_bytesfit(xfs_inode_t
 		    xfs_default_attroffset(dp))
 			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 		break;
-		
 	case XFS_DINODE_FMT_BTREE:
 		/*
-		 * If have data btree then keep forkoff if we have one,
+		 * If have a data btree then keep forkoff if we have one,
 		 * otherwise we are adding a new attr, so then we set 
 		 * minforkoff to where the btree root can finish so we have 
 		 * plenty of room for attrs
@@ -168,10 +183,9 @@ xfs_attr_shortform_bytesfit(xfs_inode_t
 		if (dp->i_d.di_forkoff) {
 			if (offset < dp->i_d.di_forkoff) 
 				return 0;
-			else 
-				return dp->i_d.di_forkoff;
-		} else
-			dsize = XFS_BMAP_BROOT_SPACE(dp->i_df.if_broot);
+			return dp->i_d.di_forkoff;
+		}
+		dsize = XFS_BMAP_BROOT_SPACE(dp->i_df.if_broot);
 		break;
 	}
 	
@@ -186,10 +200,10 @@ xfs_attr_shortform_bytesfit(xfs_inode_t
 	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
-	if (offset >= minforkoff && offset < maxforkoff)
-		return offset;
 	if (offset >= maxforkoff)
 		return maxforkoff;
+	if (offset >= minforkoff)
+		return offset;
 	return 0;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

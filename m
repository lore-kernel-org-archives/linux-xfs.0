Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCMMmhQ125300 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 16:22:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64B841EABA54
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 14:22:47 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ejAISALkTQorr05T for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 14:22:47 -0800 (PST)
Date: Mon, 12 Dec 2011 17:22:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: avoid synchronous transactions when deleting attr
	blocks
Message-ID: <20111212222246.GC16123@infradead.org>
References: <20111212222214.GA16123@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212222214.GA16123@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stable@vger.kernel.org, xfs@oss.sgi.com

commit 859f57ca00805e6c482eef1a7ab073097d02c8ca upstream.

[slightly different from the upstream version because of a previous cleanup]

Currently xfs_attr_inactive causes a synchronous transactions if we are
removing a file that has any extents allocated to the attribute fork, and
thus makes XFS extremely slow at removing files with out of line extended
attributes. The code looks a like a relict from the days before the busy
extent list, but with the busy extent list we avoid reusing data and attr
extents that have been freed but not commited yet, so this code is just
as superflous as the synchronous transactions for data blocks.
    
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 01d2072..99d4011 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -822,17 +822,9 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	error = xfs_attr_root_inactive(&trans, dp);
 	if (error)
 		goto out;
-	/*
-	 * signal synchronous inactive transactions unless this
-	 * is a synchronous mount filesystem in which case we
-	 * know that we're here because we've been called out of
-	 * xfs_inactive which means that the last reference is gone
-	 * and the unlink transaction has already hit the disk so
-	 * async inactive transactions are safe.
-	 */
-	if ((error = xfs_itruncate_finish(&trans, dp, 0LL, XFS_ATTR_FORK,
-				(!(mp->m_flags & XFS_MOUNT_WSYNC)
-				 ? 1 : 0))))
+
+	error = xfs_itruncate_finish(&trans, dp, 0LL, XFS_ATTR_FORK, 0);
+	if (error)
 		goto out;
 
 	/*
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index e546a33..a175933 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3785,19 +3785,11 @@ xfs_bmap_compute_maxlevels(
  * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
  * caller.  Frees all the extents that need freeing, which must be done
  * last due to locking considerations.  We never free any extents in
- * the first transaction.  This is to allow the caller to make the first
- * transaction a synchronous one so that the pointers to the data being
- * broken in this transaction will be permanent before the data is actually
- * freed.  This is necessary to prevent blocks from being reallocated
- * and written to before the free and reallocation are actually permanent.
- * We do not just make the first transaction synchronous here, because
- * there are more efficient ways to gain the same protection in some cases
- * (see the file truncation code).
+ * the first transaction.
  *
  * Return 1 if the given transaction was committed and a new one
  * started, and 0 otherwise in the committed parameter.
  */
-/*ARGSUSED*/
 int						/* error */
 xfs_bmap_finish(
 	xfs_trans_t		**tp,		/* transaction pointer addr */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c6888a4..5715279 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1528,15 +1528,7 @@ xfs_itruncate_finish(
 				xfs_trans_log_inode(ntp, ip, XFS_ILOG_CORE);
 			}
 		}
-	} else if (sync) {
-		ASSERT(!(mp->m_flags & XFS_MOUNT_WSYNC));
-		if (ip->i_d.di_anextents > 0)
-			xfs_trans_set_sync(ntp);
 	}
-	ASSERT(fork == XFS_DATA_FORK ||
-		(fork == XFS_ATTR_FORK &&
-			((sync && !(mp->m_flags & XFS_MOUNT_WSYNC)) ||
-			 (sync == 0 && (mp->m_flags & XFS_MOUNT_WSYNC)))));
 
 	/*
 	 * Since it is possible for space to become allocated beyond

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6LLH9E001030 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 15:21:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36EBD162F5A7
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 13:21:15 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	jRHNKFUHLENmaVov for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 13:21:15 -0800 (PST)
Date: Tue, 6 Dec 2011 16:21:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: force buffer writeback before blocking on the ilock
	in inode reclaim
Message-ID: <20111206212115.GB28459@infradead.org>
References: <20111206212056.GA24640@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206212056.GA24640@infradead.org>
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

commit 4dd2cb4a28b7ab1f37163a4eba280926a13a8749 upstream.

If we are doing synchronous inode reclaim we block the VM from making
progress in memory reclaim.  So if we encouter a flush locked inode
promote it in the delwri list and wake up xfsbufd to write it out now.
Without this we can get hangs of up to 30 seconds during workloads hitting
synchronous inode reclaim.

The scheme is copied from what we do for dquot reclaims.

Reported-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   11 +++++++++++
 fs/xfs/xfs_inode.c          |   21 +++++++++++++++++++++
 fs/xfs/xfs_inode.h          |    1 +
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 8ecad5f..b69688d 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -772,6 +772,17 @@ restart:
 	if (!xfs_iflock_nowait(ip)) {
 		if (!(sync_mode & SYNC_WAIT))
 			goto out;
+
+		/*
+		 * If we only have a single dirty inode in a cluster there is
+		 * a fair chance that the AIL push may have pushed it into
+		 * the buffer, but xfsbufd won't touch it until 30 seconds
+		 * from now, and thus we will lock up here.
+		 *
+		 * Promote the inode buffer to the front of the delwri list
+		 * and wake up xfsbufd now.
+		 */
+		xfs_promote_inode(ip);
 		xfs_iflock(ip);
 	}
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a098a20..c6888a4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3099,6 +3099,27 @@ corrupt_out:
 	return XFS_ERROR(EFSCORRUPTED);
 }
 
+void
+xfs_promote_inode(
+	struct xfs_inode	*ip)
+{
+	struct xfs_buf		*bp;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+
+	bp = xfs_incore(ip->i_mount->m_ddev_targp, ip->i_imap.im_blkno,
+			ip->i_imap.im_len, XBF_TRYLOCK);
+	if (!bp)
+		return;
+
+	if (XFS_BUF_ISDELAYWRITE(bp)) {
+		xfs_buf_delwri_promote(bp);
+		wake_up_process(ip->i_mount->m_ddev_targp->bt_task);
+	}
+
+	xfs_buf_relse(bp);
+}
+
 /*
  * Return a pointer to the extent record at file index idx.
  */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 964cfea..28b3596 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -509,6 +509,7 @@ int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 void		xfs_iunpin_wait(xfs_inode_t *);
 int		xfs_iflush(xfs_inode_t *, uint);
+void		xfs_promote_inode(struct xfs_inode *);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
-- 
1.7.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

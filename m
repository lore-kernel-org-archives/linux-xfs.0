Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAKFWh2r163469 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 09:32:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 015121D14512
	for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 07:32:42 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	54LDBkiGeEecmEx8 for <xfs@oss.sgi.com>;
	Sun, 20 Nov 2011 07:32:42 -0800 (PST)
Date: Sun, 20 Nov 2011 10:32:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111120153241.GA23511@infradead.org>
References: <20111020224214.GC22772@hostway.ca>
	<20111021132240.GA24136@infradead.org>
	<20111021202857.GB30100@hostway.ca>
	<20111024082219.GA19941@infradead.org>
	<20111025200748.GA25043@hostway.ca>
	<20111026112521.GA10432@infradead.org>
	<20111104210324.GB14983@infradead.org>
	<20111116195643.GF24411@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111116195643.GF24411@hostway.ca>
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
To: Simon Kirby <sim@hostway.ca>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Nov 16, 2011 at 11:56:43AM -0800, Simon Kirby wrote:
> Sorry for the delay in testing.
> 
> Yes, everything looks fine even with the xfs_log_force line from your
> patch commented out. So, the changes in xfs_reclaim_inode() are just the
> set_bit(XBT_FORCE_FLUSH) and wake_up_process(), relative to 3.1.

Dave pointed out that we can do better than the big hammer, and the
patch below should fix your issue, too.  Can you test it?

---
From: Christoph Hellwig <hch@lst.de>
Subject: xfs: force buffer writeback before blocking on the ilock in inode reclaim

If we are doing synchronous inode reclaim we block the VM from making
progress in memory reclaim.  So if we encouter a flush locked inode
promote it in the delwri list and wake up xfsbufd to write it out now.
Without this we can get hangs of up to 30 seconds during workloads hitting
synchronous inode reclaim.

The scheme is copied from what we do for dquot reclaims.

Reported-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2011-11-20 12:48:36.664765032 +0100
+++ xfs/fs/xfs/xfs_sync.c	2011-11-20 13:51:55.594184465 +0100
@@ -770,6 +770,17 @@ restart:
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
 
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-11-20 13:50:51.457865253 +0100
+++ xfs/fs/xfs/xfs_inode.c	2011-11-20 13:52:30.420662460 +0100
@@ -2835,6 +2835,27 @@ corrupt_out:
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
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-11-20 13:50:51.487865091 +0100
+++ xfs/fs/xfs/xfs_inode.h	2011-11-20 13:51:39.224273148 +0100
@@ -498,6 +498,7 @@ int		xfs_iunlink(struct xfs_trans *, xfs
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 void		xfs_iunpin_wait(xfs_inode_t *);
 int		xfs_iflush(xfs_inode_t *, uint);
+void		xfs_promote_inode(struct xfs_inode *);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

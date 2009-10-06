Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96KZIvV091123 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 15:35:18 -0500
Message-Id: <20091006203642.877846388@bombadil.infradead.org>
Date: Tue, 06 Oct 2009 16:29:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] [PATCH 5/5] xfs: fix xfs_quiesce_data 
References: <20091006202925.459164320@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-xfs_quiesce_data
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
To: aelder@sgi.com, xfs@oss.sgi.com, akpm@linux-foundation.org, sfr@canb.auug.org.au
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <david@fromorbit.com>

We need to do a synchronous xfs_sync_fsdata to make sure the superblock
actually is on disk when we return.

Also remove SYNC_BDFLUSH flag to xfs_sync_inodes because that particular
flag is never checked.

Move xfs_filestream_flush call later to only release inodes after they
have been written out.


Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-08-27 20:06:39.889355294 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2009-08-27 20:08:01.169357854 -0300
@@ -426,14 +426,16 @@ xfs_quiesce_data(
 	/* push non-blocking */
 	xfs_sync_data(mp, 0);
 	xfs_qm_sync(mp, SYNC_TRYLOCK);
-	xfs_filestream_flush(mp);
 
-	/* push and block */
+	/* push and block till complete */
 	xfs_sync_data(mp, SYNC_WAIT);
 	xfs_qm_sync(mp, SYNC_WAIT);
 
+	/* drop inode references pinned by filestreams */
+	xfs_filestream_flush(mp);
+
 	/* write superblock and hoover up shutdown errors */
-	error = xfs_sync_fsdata(mp, 0);
+	error = xfs_sync_fsdata(mp, SYNC_WAIT);
 
 	/* flush data-only devices */
 	if (mp->m_rtdev_targp)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAN0gOrO183014 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:42:24 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2850F162EC5C
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:42:22 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 6BwXBUPP3ecaAuwq for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 16:42:22 -0800 (PST)
Message-Id: <20111123002409.095325764@clark.kroah.org>
Date: Tue, 22 Nov 2011 16:23:55 -0800
From: Greg KH <gregkh@suse.de>
Subject: [48/53] xfs: fix buffer flushing during unmount
In-Reply-To: <20111123002419.GA8531@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, Christoph Hellwig <hch@lst.de>, alan@lxorguk.ukuu.org.uk

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit 87c7bec7fc3377b3873eb3a0f4b603981ea16ebb upstream.

The code to flush buffers in the umount code is a bit iffy: we first
flush all delwri buffers out, but then might be able to queue up a
new one when logging the sb counts.  On a normal shutdown that one
would get flushed out when doing the synchronous superblock write in
xfs_unmountfs_writesb, but we skip that one if the filesystem has
been shut down.

Fix this by moving the delwri list flushing until just before unmounting
the log, and while we're at it also remove the superflous delwri list
and buffer lru flusing for the rt and log device that can never have
cached or delwri buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Tested-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_mount.c         |   29 ++++++++++-------------------
 2 files changed, 10 insertions(+), 20 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -346,7 +346,6 @@ extern struct list_head *xfs_get_buftarg
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
-#define xfs_binval(buftarg)		xfs_flush_buftarg(buftarg, 1)
 #define XFS_bflush(buftarg)		xfs_flush_buftarg(buftarg, 1)
 
 #endif	/* __XFS_BUF_H__ */
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -44,9 +44,6 @@
 #include "xfs_trace.h"
 
 
-STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
-
-
 #ifdef HAVE_PERCPU_SB
 STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t,
 						int);
@@ -1507,11 +1504,6 @@ xfs_unmountfs(
 	 */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-	xfs_binval(mp->m_ddev_targp);
-	if (mp->m_rtdev_targp) {
-		xfs_binval(mp->m_rtdev_targp);
-	}
-
 	/*
 	 * Unreserve any blocks we have so that when we unmount we don't account
 	 * the reserved free space as used. This is really only necessary for
@@ -1537,7 +1529,16 @@ xfs_unmountfs(
 		xfs_warn(mp, "Unable to update superblock counters. "
 				"Freespace may not be correct on next mount.");
 	xfs_unmountfs_writesb(mp);
-	xfs_unmountfs_wait(mp); 		/* wait for async bufs */
+
+	/*
+	 * Make sure all buffers have been flushed and completed before
+	 * unmounting the log.
+	 */
+	error = xfs_flush_buftarg(mp->m_ddev_targp, 1);
+	if (error)
+		xfs_warn(mp, "%d busy buffers during unmount.", error);
+	xfs_wait_buftarg(mp->m_ddev_targp);
+
 	xfs_log_unmount_write(mp);
 	xfs_log_unmount(mp);
 	xfs_uuid_unmount(mp);
@@ -1548,16 +1549,6 @@ xfs_unmountfs(
 	xfs_free_perag(mp);
 }
 
-STATIC void
-xfs_unmountfs_wait(xfs_mount_t *mp)
-{
-	if (mp->m_logdev_targp != mp->m_ddev_targp)
-		xfs_wait_buftarg(mp->m_logdev_targp);
-	if (mp->m_rtdev_targp)
-		xfs_wait_buftarg(mp->m_rtdev_targp);
-	xfs_wait_buftarg(mp->m_ddev_targp);
-}
-
 int
 xfs_fs_writable(xfs_mount_t *mp)
 {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

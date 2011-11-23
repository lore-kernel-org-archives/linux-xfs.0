Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAN0gDHj182947 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:42:13 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B88B826FB73
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:42:12 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 0OeBDE0F2WGb8Zto for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 16:42:12 -0800 (PST)
Message-Id: <20111123002408.819236764@clark.kroah.org>
Date: Tue, 22 Nov 2011 16:23:52 -0800
From: Greg KH <gregkh@suse.de>
Subject: [45/53] xfs: dont serialise direct IO reads on page cache
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 0c38a2512df272b14ef4238b476a2e4f70da1479 upstream.

There is no need to grab the i_mutex of the IO lock in exclusive
mode if we don't need to invalidate the page cache. Taking these
locks on every direct IO effective serialises them as taking the IO
lock in exclusive mode has to wait for all shared holders to drop
the lock. That only happens when IO is complete, so effective it
prevents dispatch of concurrent direct IO reads to the same inode.

Fix this by taking the IO lock shared to check the page cache state,
and only then drop it and take the IO lock exclusively if there is
work to be done. Hence for the normal direct IO case, no exclusive
locking will occur.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Joern Engel <joern@logfs.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_file.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -309,7 +309,19 @@ xfs_file_aio_read(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if (unlikely(ioflags & IO_ISDIRECT)) {
+	/*
+	 * Locking is a bit tricky here. If we take an exclusive lock
+	 * for direct IO, we effectively serialise all new concurrent
+	 * read IO to this file and block it behind IO that is currently in
+	 * progress because IO in progress holds the IO lock shared. We only
+	 * need to hold the lock exclusive to blow away the page cache, so
+	 * only take lock exclusively if the page cache needs invalidation.
+	 * This allows the normal direct IO case of no page cache pages to
+	 * proceeed concurrently without serialisation.
+	 */
+	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	if ((ioflags & IO_ISDIRECT) && inode->i_mapping->nrpages) {
+		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 
 		if (inode->i_mapping->nrpages) {
@@ -322,8 +334,7 @@ xfs_file_aio_read(
 			}
 		}
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
-	} else
-		xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	}
 
 	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

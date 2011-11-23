Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAN0gGEv182977 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 18:42:17 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 176791D2B4FA
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:42:15 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ZnLoWGmdaLDOEjeK for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 16:42:15 -0800 (PST)
Message-Id: <20111123002408.908319178@clark.kroah.org>
Date: Tue, 22 Nov 2011 16:23:53 -0800
From: Greg KH <gregkh@suse.de>
Subject: [46/53] xfs: avoid direct I/O write vs buffered I/O race
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

commit c58cb165bd44de8aaee9755a144136ae743be116 upstream.

Currently a buffered reader or writer can add pages to the pagecache
while we are waiting for the iolock in xfs_file_dio_aio_write.  Prevent
this by re-checking mapping->nrpages after we got the iolock, and if
nessecary upgrade the lock to exclusive mode.  To simplify this a bit
only take the ilock inside of xfs_file_aio_write_checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_file.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -669,6 +669,7 @@ xfs_file_aio_write_checks(
 	xfs_fsize_t		new_size;
 	int			error = 0;
 
+	xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
 	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
 	if (error) {
 		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
@@ -760,14 +761,24 @@ xfs_file_dio_aio_write(
 		*iolock = XFS_IOLOCK_EXCL;
 	else
 		*iolock = XFS_IOLOCK_SHARED;
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+	xfs_rw_ilock(ip, *iolock);
 
 	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
 	if (ret)
 		return ret;
 
+	/*
+	 * Recheck if there are cached pages that need invalidate after we got
+	 * the iolock to protect against other threads adding new pages while
+	 * we were waiting for the iolock.
+	 */
+	if (mapping->nrpages && *iolock == XFS_IOLOCK_SHARED) {
+		xfs_rw_iunlock(ip, *iolock);
+		*iolock = XFS_IOLOCK_EXCL;
+		xfs_rw_ilock(ip, *iolock);
+	}
+
 	if (mapping->nrpages) {
-		WARN_ON(*iolock != XFS_IOLOCK_EXCL);
 		ret = -xfs_flushinval_pages(ip, (pos & PAGE_CACHE_MASK), -1,
 							FI_REMAPF_LOCKED);
 		if (ret)
@@ -812,7 +823,7 @@ xfs_file_buffered_aio_write(
 	size_t			count = ocount;
 
 	*iolock = XFS_IOLOCK_EXCL;
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+	xfs_rw_ilock(ip, *iolock);
 
 	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
 	if (ret)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

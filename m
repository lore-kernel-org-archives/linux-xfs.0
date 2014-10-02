Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4EF777F6B
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 12:33:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE19EAC012
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 10:33:51 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id uSSVspGgoGwkrqK6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 10:33:50 -0700 (PDT)
Date: Thu, 2 Oct 2014 19:33:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3 v2] xfs: add RWF_NONBLOCK support
Message-ID: <20141002173347.GA28846@lst.de>
References: <1412197494-7655-1-git-send-email-hch@lst.de>
	<1412197494-7655-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1412197494-7655-2-git-send-email-hch@lst.de>
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
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Add support for non-blocking reads.  The guts are handled by the generic
code, the only addition is a non-blocking variant of xfs_rw_ilock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index cf61271..6981b10 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -61,6 +61,25 @@ xfs_rw_ilock(
 	xfs_ilock(ip, type);
 }
 
+static inline bool
+xfs_rw_ilock_nowait(
+	struct xfs_inode	*ip,
+	int			type)
+{
+	if (type & XFS_IOLOCK_EXCL) {
+		if (!mutex_trylock(&VFS_I(ip)->i_mutex))
+			return false;
+		if (!xfs_ilock_nowait(ip, type)) {
+			mutex_unlock(&VFS_I(ip)->i_mutex);
+			return false;
+		}
+	} else {
+		if (!xfs_ilock_nowait(ip, type))
+			return false;
+	}
+	return true;
+}
+
 static inline void
 xfs_rw_iunlock(
 	struct xfs_inode	*ip,
@@ -246,10 +265,6 @@ xfs_file_read_iter(
 
 	XFS_STATS_INC(xs_read_calls);
 
-	/* XXX: need a non-blocking iolock helper, shouldn't be too hard */
-	if (iocb->ki_rwflags & RWF_NONBLOCK)
-		return -EAGAIN;
-
 	if (unlikely(file->f_flags & O_DIRECT))
 		ioflags |= XFS_IO_ISDIRECT;
 	if (file->f_mode & FMODE_NOCMTIME)
@@ -287,7 +302,14 @@ xfs_file_read_iter(
 	 * This allows the normal direct IO case of no page cache pages to
 	 * proceeed concurrently without serialisation.
 	 */
-	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	if (iocb->ki_rwflags & RWF_NONBLOCK) {
+		if (ioflags & XFS_IO_ISDIRECT)
+			return -EAGAIN;
+		if (!xfs_rw_ilock_nowait(ip, XFS_IOLOCK_SHARED))
+			return -EAGAIN;
+	} else {
+		xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	}
 	if ((ioflags & XFS_IO_ISDIRECT) && inode->i_mapping->nrpages) {
 		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

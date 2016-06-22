Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 849A07CB5
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 10:27:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CBDB8F8059
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 08:27:42 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id R6uOXHgAaWKoA5nZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2016 08:27:40 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/8] xfs: fix locking for DAX writes
Date: Wed, 22 Jun 2016 17:27:16 +0200
Message-Id: <1466609236-23801-9-git-send-email-hch@lst.de>
In-Reply-To: <1466609236-23801-1-git-send-email-hch@lst.de>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

So far DAX writes inherited the locking from direct I/O writes, but the direct
I/O model of using shared locks for writes is actually wrong for DAX.  For
direct I/O we're out of any standards and don't have to provide the Posix
required exclusion between writers, but for DAX which gets transparently
enable on applications without any knowledge of it we can't simply drop the
requirement.  Even worse this only happens for aligned writes and thus
doesn't show up for many typical use cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0e74325..413c9e0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -714,24 +714,11 @@ xfs_file_dax_write(
 	struct address_space	*mapping = iocb->ki_filp->f_mapping;
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
-	int			unaligned_io = 0;
-	int			iolock;
+	int			iolock = XFS_IOLOCK_EXCL;
 	struct iov_iter		data;
 
-	/* "unaligned" here means not aligned to a filesystem block */
-	if ((iocb->ki_pos & mp->m_blockmask) ||
-	    ((iocb->ki_pos + iov_iter_count(from)) & mp->m_blockmask)) {
-		unaligned_io = 1;
-		iolock = XFS_IOLOCK_EXCL;
-	} else if (mapping->nrpages) {
-		iolock = XFS_IOLOCK_EXCL;
-	} else {
-		iolock = XFS_IOLOCK_SHARED;
-	}
 	xfs_rw_ilock(ip, iolock);
-
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
 		goto out;
@@ -747,11 +734,6 @@ xfs_file_dax_write(
 		WARN_ON_ONCE(ret);
 	}
 
-	if (iolock == XFS_IOLOCK_EXCL && !unaligned_io) {
-		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
-		iolock = XFS_IOLOCK_SHARED;
-	}
-
 	trace_xfs_file_dax_write(ip, iov_iter_count(from), iocb->ki_pos);
 
 	data = *from;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

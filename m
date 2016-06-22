Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A2C887CB1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 10:27:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 73CB98F8059
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 08:27:35 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id PBSa1jlfKcxDviFT (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2016 08:27:33 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/8] xfs: stop using generic_file_read_iter for direct I/O
Date: Wed, 22 Jun 2016 17:27:13 +0200
Message-Id: <1466609236-23801-6-git-send-email-hch@lst.de>
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

XFS already implement it's own flushing of the pagecache because it
implements proper synchronization for direct I/O reads.  This means
calling generic_file_read_iter for direct I/O is rather useless,
as it doesn't do much but updating the atime and iocb position for
us.  This also gets rid of the buffered I/O fallback that isn't used
for XFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e584333..f761f49 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -246,12 +246,17 @@ xfs_file_dio_aio_read(
 	struct address_space	*mapping = iocb->ki_filp->f_mapping;
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
+	loff_t			isize = i_size_read(inode);
 	size_t			count = iov_iter_count(to);
+	struct iov_iter		data;
 	struct xfs_buftarg	*target;
 	ssize_t			ret = 0;
 
 	trace_xfs_file_direct_read(ip, count, iocb->ki_pos);
 
+	if (!count)
+		return 0; /* skip atime */
+
 	if (XFS_IS_REALTIME_INODE(ip))
 		target = ip->i_mount->m_rtdev_targp;
 	else
@@ -260,7 +265,7 @@ xfs_file_dio_aio_read(
 	if (!IS_DAX(inode)) {
 		/* DIO must be aligned to device logical sector size */
 		if ((iocb->ki_pos | count) & target->bt_logical_sectormask) {
-			if (iocb->ki_pos == i_size_read(inode))
+			if (iocb->ki_pos == isize)
 				return 0;
 			return -EINVAL;
 		}
@@ -311,9 +316,15 @@ xfs_file_dio_aio_read(
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 	}
 
-	ret = generic_file_read_iter(iocb, to);
+	data = *to;
+	ret = mapping->a_ops->direct_IO(iocb, &data);
+	if (ret > 0) {
+		iocb->ki_pos += ret;
+		iov_iter_advance(to, ret);
+	}
 	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 
+	file_accessed(iocb->ki_filp);
 	return ret;
 }
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

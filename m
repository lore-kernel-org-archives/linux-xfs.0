Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8uHlZ003246 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:56:17 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id uN2GpWrG1D41fEMq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:56:16 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q6Q8uEOc016016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 08:56:15 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q6Q8uEI7007074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 08:56:14 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q6Q8uETl015484 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:56:14 -0500
Message-ID: <50110607.2000905@oracle.com>
Date: Thu, 26 Jul 2012 16:55:35 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v5 1/4] xfs: Remove type argument from xfs_seek_data() and
	xfs_seek_hole().
Reply-To: jeff.liu@oracle.com
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
To: xfs@oss.sgi.com

The type is already indicated by the function naming explicitly, so this argument
can be omitted from those calls.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_file.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9f7ec15..98642cf 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -969,8 +969,7 @@ xfs_vm_page_mkwrite(
 STATIC loff_t
 xfs_seek_data(
 	struct file		*file,
-	loff_t			start,
-	u32			type)
+	loff_t			start)
 {
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -1036,8 +1035,7 @@ out_unlock:
 STATIC loff_t
 xfs_seek_hole(
 	struct file		*file,
-	loff_t			start,
-	u32			type)
+	loff_t			start)
 {
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -1099,9 +1097,9 @@ xfs_file_llseek(
 	case SEEK_SET:
 		return generic_file_llseek(file, offset, origin);
 	case SEEK_DATA:
-		return xfs_seek_data(file, offset, origin);
+		return xfs_seek_data(file, offset);
 	case SEEK_HOLE:
-		return xfs_seek_hole(file, offset, origin);
+		return xfs_seek_hole(file, offset);
 	default:
 		return -EINVAL;
 	}
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QFXMQD048702 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:33:22 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id ym9WP3P6xBRcErrx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 08:33:20 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q6QFXH8Z017346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 15:33:18 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q6QFXGEV014716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 15:33:17 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q6QFXGg0014497 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:33:16 -0500
Message-ID: <50116315.6000505@oracle.com>
Date: Thu, 26 Jul 2012 23:32:37 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v5 1/4] xfs: Remove type argument from xfs_seek_data() and
	xfs_seek_hole().
References: <50110607.2000905@oracle.com>
In-Reply-To: <50110607.2000905@oracle.com>
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

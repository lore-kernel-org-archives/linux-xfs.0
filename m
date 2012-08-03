Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q736BS1B044797 for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 01:11:29 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id rqAQtTDi12giH3eA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Aug 2012 23:11:28 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q736BQBa006213
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 06:11:27 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q736BP3F029351
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 06:11:26 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q736BP3l019175 for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 01:11:25 -0500
Message-ID: <501B6B62.7040303@oracle.com>
Date: Fri, 03 Aug 2012 14:10:42 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v6 1/4] xfs: Remove type argument from
	xfs_seek_data()/xfs_seek_hole()
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

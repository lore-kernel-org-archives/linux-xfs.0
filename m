Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3G6o1da179247 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 01:50:01 -0500
Received: from mx2.fusionio.com (mx2.fusionio.com [66.114.96.31]) by
	cuda.sgi.com with ESMTP id 7bjLdKyHRkuiXrO8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Apr 2012 23:49:59 -0700 (PDT)
Message-ID: <4F8BC112.9090508@fusionio.com>
Date: Mon, 16 Apr 2012 14:49:54 +0800
From: Shaohua Li <shli@fusionio.com>
MIME-Version: 1.0
Subject: [RFC]xfs: using GFP_NOFS for blkdev_issue_flush
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org


flush request is issued in transaction commit code path usually, so 
looks using
GFP_KERNEL to allocate memory for flush request bio falls into the classic
deadlock issue (memory reclaim recursion). Use GFP_NOFS to avoid recursion
from reclaim context. Per Dave Chinner, there is only blkdev_issue_flush 
might
be buggy here. But using GFP_NOFS by default for all calls should not 
matter.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
  fs/xfs/xfs_super.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/fs/xfs/xfs_super.c
===================================================================
--- linux.orig/fs/xfs/xfs_super.c    2012-04-13 10:08:26.095496072 +0800
+++ linux/fs/xfs/xfs_super.c    2012-04-13 10:08:42.555496865 +0800
@@ -622,7 +622,7 @@ void
  xfs_blkdev_issue_flush(
      xfs_buftarg_t        *buftarg)
  {
-    blkdev_issue_flush(buftarg->bt_bdev, GFP_KERNEL, NULL);
+    blkdev_issue_flush(buftarg->bt_bdev, GFP_NOFS, NULL);
  }

  STATIC void


This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.  Email addresses that end with a ?-c? identify the sender as a Fusion-io contractor.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

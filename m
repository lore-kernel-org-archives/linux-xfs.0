Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94FC47CD9
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 09:02:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 69E458F8033
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 07:02:12 -0700 (PDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id NNoMo59ogHsRC1hF
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2016 07:02:09 -0700 (PDT)
Received: by mail-wm0-f53.google.com with SMTP id v188so130833955wme.1
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 07:02:09 -0700 (PDT)
From: Shyam Kaushik <shyam@zadarastorage.com>
MIME-Version: 1.0
Date: Tue, 26 Apr 2016 19:31:59 +0530
Message-ID: <a71e1aed74b2922e8ed6fb40404899e7@mail.gmail.com>
Subject: [PATCH] xfs_buf_iodone_callbacks to force shutdown & resubmit buf in
	case of permanent failure
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
To: xfs@oss.sgi.com
Cc: Alex Lyakas <alex@zadarastorage.com>

When XFS underlying disk fails, it could take several milliseconds for the
FS to be marked
shutdown. xfs_buf_iodone_callbacks() retries buf upon first failure by
submitting it once
again. But if the buf fails 2nd time before FS is marked for shutdown, it
just releases the
buf with xfs_buf_relse(). This is flawed that nobody is releasing the
XFS_IFLOCK on the inode.
Because of this AIL tasks repeated effort to xfs_inode_item_push() will
see that xfs_iflock()
cannot be acquired. This blocks XFS from being unmounted as
xfs_ail_push_all_sync() will keep
looping without progress.

Fix this by marking the FS for shutdown if we have a permanent failure &
resubmit the buf.
xfs_buf_submit() will see FS marked for shutdown & invoke the callback
which releases
XFS_IFLOCK.

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1a6c9b9..6f73ee0 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1100,7 +1100,12 @@ xfs_buf_iodone_callbacks(
                                       XBF_DONE | XBF_WRITE_FAIL;
                        xfs_buf_submit(bp);
                } else {
-                       xfs_buf_relse(bp);
+                       /*
+                       * if we have the buf fail 2nd time, force a FS
shutdown & resubmit
+                       * the buf for it to be failed back immediately
+                       */
+                       xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
+                       xfs_buf_submit(bp);
                }

                return;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

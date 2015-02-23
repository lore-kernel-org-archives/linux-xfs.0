Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 23B1F7F54
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 13:00:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9885AAC007
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 11:00:45 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4KwFAx4HAuw2WRPq for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 11:00:28 -0800 (PST)
Message-ID: <54EB78CB.6050709@sandeen.net>
Date: Mon, 23 Feb 2015 13:00:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs: cancel failed transaction in xfs_fs_commit_blocks()
References: <54EB782F.8020201@redhat.com>
In-Reply-To: <54EB782F.8020201@redhat.com>
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@lst.de>

If xfs_trans_reserve fails we don't cancel the transaction,
and we'll leak the allocated transaction pointer.

Spotted by Coverity.

Signed-off-by: Eric Sandeen <ssandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 4b33ef1..365dd57 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -300,8 +300,10 @@ xfs_fs_commit_blocks(
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
-	if (error)
+	if (error) {
+		xfs_trans_cancel(tp, 0);
 		goto out_drop_iolock;
+	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

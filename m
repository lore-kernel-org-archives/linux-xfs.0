Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47660 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbfCAX3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:29:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NT4VI126636
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:29:07 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qtwkut93w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:29:07 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x21NT51h009684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:29:06 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21NT5DE008183
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:29:05 GMT
Subject: [PATCH 21/23] libxfs: free buffer log item in libxfs_trans_brelse
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:29:04 -0800
Message-ID: <155148294438.16677.1930910751833400782.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we're going to putbuf a buffer at the bottom of libxfs_trans_brelse,
that means that the buffer is clean and not held, and therefore we need
to detach the buffer from the transaction prior to releasing the buffer.
For whatever reason, we forget to free the buffer's b_log_item (though
we set b_transp to NULL), which means that if the buffer is immediately
freed or picked back up to write an inode core (which changes
b_log_item), we'll leak the buf item.

Therefore, free the buffer log item like the kernel does, which stops
the leak.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index 46ff8b4a..b0a04ecd 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -570,6 +570,8 @@ libxfs_trans_brelse(
 	xfs_trans_del_item(&bip->bli_item);
 	if (bip->bli_flags & XFS_BLI_HOLD)
 		bip->bli_flags &= ~XFS_BLI_HOLD;
+	kmem_zone_free(xfs_buf_item_zone, bip);
+	bp->b_log_item = NULL;
 	bp->b_transp = NULL;
 	libxfs_putbuf(bp);
 }
@@ -856,6 +858,7 @@ inode_item_done(
 		return;
 	}
 
+	ASSERT(bp->b_log_item == NULL);
 	bp->b_log_item = iip;
 	error = libxfs_iflush_int(ip, bp);
 	if (error) {

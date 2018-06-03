Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeFCXXa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:23:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w53NNJuS115627
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:30 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2jbvyp1fds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018 23:23:30 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w53NNTor021745
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:29 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w53NNTDr016904
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:29 GMT
Subject: [PATCH 10/10] xfs: don't return garbage buffers in xfs_da3_node_read
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 03 Jun 2018 16:23:27 -0700
Message-ID: <152806820783.18187.7435549978381764983.stgit@magnolia>
In-Reply-To: <152806814253.18187.4009340462930782844.stgit@magnolia>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we're reading a node in a dir/attr btree and the buffer comes off the
disk with a magic number we don't recognize, don't ASSERT and don't set
a garbage buffer type (0 also triggers ASSERTs).  Instead, report the
corruption, release the buffer, and return -EFSCORRUPTED because that's
what the dabtree is -- corrupt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index ea187b4a7991..39c1013358ed 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -305,9 +305,11 @@ xfs_da3_node_read(
 			type = XFS_BLFT_DIR_LEAFN_BUF;
 			break;
 		default:
-			type = 0;
-			ASSERT(0);
-			break;
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
+					tp->t_mountp, info);
+			xfs_trans_brelse(tp, *bpp);
+			*bpp = NULL;
+			return -EFSCORRUPTED;
 		}
 		xfs_trans_buf_set_type(tp, *bpp, type);
 	}


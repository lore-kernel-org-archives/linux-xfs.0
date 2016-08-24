Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C41E77CA0
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 21:20:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86197304051
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:20:52 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4vMzWzqJfN27NwEv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:20:51 -0700 (PDT)
Subject: [PATCH 3/5] xfs: fix some key handling problems in
	_btree_simple_query_range
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Aug 2016 19:20:47 -0700
Message-ID: <147200524743.14738.15760103598513525911.stgit@birch.djwong.org>
In-Reply-To: <147200522764.14738.15186015137934319456.stgit@birch.djwong.org>
References: <147200522764.14738.15186015137934319456.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

We only need the record's high key for the first record that we look
at; for all records, we /definitely/ need the regular record key.
Therefore, fix how the simple range query function gets its keys.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 33f1406..b70d9f9 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4563,10 +4563,10 @@ xfs_btree_simple_query_range(
 		error = xfs_btree_get_rec(cur, &recp, &stat);
 		if (error || !stat)
 			break;
-		cur->bc_ops->init_high_key_from_rec(&rec_key, recp);
 
 		/* Skip if high_key(rec) < low_key. */
 		if (firstrec) {
+			cur->bc_ops->init_high_key_from_rec(&rec_key, recp);
 			firstrec = false;
 			diff = cur->bc_ops->diff_two_keys(cur, low_key,
 					&rec_key);
@@ -4575,6 +4575,7 @@ xfs_btree_simple_query_range(
 		}
 
 		/* Stop if high_key < low_key(rec). */
+		cur->bc_ops->init_key_from_rec(&rec_key, recp);
 		diff = cur->bc_ops->diff_two_keys(cur, &rec_key, high_key);
 		if (diff > 0)
 			break;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

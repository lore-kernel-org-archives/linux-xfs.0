Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF6297CB5
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 21:20:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B543A304051
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:20:58 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zZuxS7jDeGr0egzN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:20:57 -0700 (PDT)
Subject: [PATCH 4/5] xfs: simple btree query range should look right if LE
	lookup fails
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Aug 2016 19:20:53 -0700
Message-ID: <147200525360.14738.17074008566594507843.stgit@birch.djwong.org>
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

If the initial LOOKUP_LE in the simple query range fails to find
anything, we should attempt to increment the btree cursor to see
if there actually /are/ records for what we're trying to find.
Without this patch, a bnobt range query of (0, $agsize) returns
no results because the leftmost record never has a startblock
of zero.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index b70d9f9..0856979 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4558,6 +4558,13 @@ xfs_btree_simple_query_range(
 	if (error)
 		goto out;
 
+	/* Nothing?  See if there's anything to the right. */
+	if (!stat) {
+		error = xfs_btree_increment(cur, 0, &stat);
+		if (error)
+			goto out;
+	}
+
 	while (stat) {
 		/* Find the record. */
 		error = xfs_btree_get_rec(cur, &recp, &stat);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

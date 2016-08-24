Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 312F57CA1
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 21:24:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 990F2AC005
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:24:49 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Q9RTlJSlGMzUEWVP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:24:48 -0700 (PDT)
Subject: [PATCH 3/7] xfs: simple btree query range should look right if LE
	lookup fails
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Aug 2016 19:24:43 -0700
Message-ID: <147200548364.15538.8448801693088924431.stgit@birch.djwong.org>
In-Reply-To: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
References: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
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
 libxfs/xfs_btree.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index b69c8d2..8e928ea 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
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

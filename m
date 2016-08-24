Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2F3397CA0
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 21:20:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 027AC8F8033
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:20:48 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id RqX2ssrEcuRtXy5I (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:20:47 -0700 (PDT)
Subject: [PATCH 2/5] xfs: don't perform lookups on zero-height btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Aug 2016 19:20:41 -0700
Message-ID: <147200524120.14738.16686498030898663475.stgit@birch.djwong.org>
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

If the caller passes in a cursor to a zero-height btree (which is
impossible), we never set block to anything but NULL, which causes the
later dereference of it to crash.  Instead, just return -EFSCORRUPTED.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index b5c213a..33f1406 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1814,6 +1814,10 @@ xfs_btree_lookup(
 
 	XFS_BTREE_STATS_INC(cur, lookup);
 
+	/* No such thing as a zero-level tree. */
+	if (cur->bc_nlevels == 0)
+		return -EFSCORRUPTED;
+
 	block = NULL;
 	keyno = 0;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

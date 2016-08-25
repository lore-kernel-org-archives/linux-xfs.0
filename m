Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D1B3842B
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:00:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 34AF58F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:05 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id RrGbZvAIqCkBkudD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:03 -0700 (PDT)
Subject: [PATCH 13/29] xfs: don't assume a left rmap when allocating a new rmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:59:59 -0700
Message-ID: <147216959911.7022.5271004764125497550.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
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

The original rmap code assumed that there would always be at least
one rmap in the rmapbt (the AG sb/agf/agi) and so errored out if
it didn't find one.  This assumption isn't true for rtrmapbt, so
remove the check and just deal with the situation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_rmap.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index dc1e3a7..4ed2f2e 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -706,19 +706,19 @@ xfs_rmap_map(
 			&have_lt);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
-
-	error = xfs_rmap_get_rec(cur, &ltrec, &have_lt);
-	if (error)
-		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
-	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			xfs_rmap_cur_agno(cur), ltrec.rm_startblock,
-			ltrec.rm_blockcount, ltrec.rm_owner,
-			ltrec.rm_offset, ltrec.rm_flags);
+	if (have_lt) {
+		error = xfs_rmap_get_rec(cur, &ltrec, &have_lt);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
+		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
+				xfs_rmap_cur_agno(cur), ltrec.rm_startblock,
+				ltrec.rm_blockcount, ltrec.rm_owner,
+				ltrec.rm_offset, ltrec.rm_flags);
 
-	if (!xfs_rmap_is_mergeable(&ltrec, owner, flags))
-		have_lt = 0;
+		if (!xfs_rmap_is_mergeable(&ltrec, owner, flags))
+			have_lt = 0;
+	}
 
 	XFS_WANT_CORRUPTED_GOTO(mp,
 		have_lt == 0 ||

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

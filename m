Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57328 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752063AbeFXTXj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:23:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJJCCi117036
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:38 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2jt7mp8hne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:38 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJNbsh019091
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:37 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJNbBX012934
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:37 GMT
Subject: [PATCH 01/21] xfs: don't assume a left rmap when allocating a new
 rmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:23:36 -0700
Message-ID: <152986821631.3155.13981921703707802906.stgit@magnolia>
In-Reply-To: <152986820984.3155.16417868536016544528.stgit@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The original rmap code assumed that there would always be at least one
rmap in the rmapbt (the AG sb/agf/agi) and so errored out if it didn't
find one.  This assumption isn't true for the rmapbt repair function
(and it won't be true for realtime rmap either), so remove the check and
just deal with the situation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index d4460b0d2d81..8b2a2f81d110 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -753,19 +753,19 @@ xfs_rmap_map(
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
-			cur->bc_private.a.agno, ltrec.rm_startblock,
-			ltrec.rm_blockcount, ltrec.rm_owner,
-			ltrec.rm_offset, ltrec.rm_flags);
+	if (have_lt) {
+		error = xfs_rmap_get_rec(cur, &ltrec, &have_lt);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
+		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
+				cur->bc_private.a.agno, ltrec.rm_startblock,
+				ltrec.rm_blockcount, ltrec.rm_owner,
+				ltrec.rm_offset, ltrec.rm_flags);
 
-	if (!xfs_rmap_is_mergeable(&ltrec, owner, flags))
-		have_lt = 0;
+		if (!xfs_rmap_is_mergeable(&ltrec, owner, flags))
+			have_lt = 0;
+	}
 
 	XFS_WANT_CORRUPTED_GOTO(mp,
 		have_lt == 0 ||


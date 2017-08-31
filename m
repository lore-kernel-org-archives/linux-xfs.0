Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36078 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbdHaUet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:34:49 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKYmDo022866
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKYml7022266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:48 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7VKYm9F029533
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:34:48 GMT
Subject: [PATCH 13/19] xfs: don't assume a left rmap when allocating a new
 rmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:34:44 -0700
Message-ID: <150421168458.17458.8262524267485288486.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The original rmap code assumed that there would always be at least
one rmap in the rmapbt (the AG sb/agf/agi) and so errored out if
it didn't find one.  This assumption isn't true for rtrmapbt, so
remove the check and just deal with the situation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index efcd63d..2ce9bf55 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -708,19 +708,19 @@ xfs_rmap_map(
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


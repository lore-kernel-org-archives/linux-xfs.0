Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31263 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdGRSYY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2017 14:24:24 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6IIOOHm029272
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 18:24:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6IIOOxZ017063
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 18:24:24 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6IION1O022069
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 18:24:23 GMT
Subject: [PATCH 2/3] xfs: set firstfsb to NULLFSBLOCK before feeding it to
 _bmapi_write
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Jul 2017 11:24:22 -0700
Message-ID: <150040226271.1216.6697100927248768726.stgit@magnolia>
In-Reply-To: <150040225662.1216.16823172616535217786.stgit@magnolia>
References: <150040225662.1216.16823172616535217786.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We must initialize the firstfsb parameter to _bmapi_write so that it
doesn't incorrectly treat stack garbage as a restriction on which AGs
it can search for free space.

Fixes-coverity-id: 1402025
Fixes-coverity-id: 1415167
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 fs/xfs/xfs_reflink.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 935adde..8c4ee60 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6508,7 +6508,7 @@ xfs_bmap_finish_one(
 	xfs_filblks_t			*blockcount,
 	xfs_exntst_t			state)
 {
-	xfs_fsblock_t			firstfsb;
+	xfs_fsblock_t			firstfsb = NULLFSBLOCK;
 	int				error = 0;
 
 	trace_xfs_bmap_deferred(tp->t_mountp,
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index ab2270a..d9b3d57 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -329,7 +329,7 @@ xfs_reflink_convert_cow_extent(
 	xfs_filblks_t			count_fsb,
 	struct xfs_defer_ops		*dfops)
 {
-	xfs_fsblock_t			first_block;
+	xfs_fsblock_t			first_block = NULLFSBLOCK;
 	int				nimaps = 1;
 
 	if (imap->br_state == XFS_EXT_NORM)


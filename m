Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17048 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbdGRSYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2017 14:24:31 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6IIOUWK013176
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 18:24:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6IIOUT7028430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 18:24:30 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6IIOTka022179
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 18:24:29 GMT
Subject: [PATCH 3/3] xfs: check _alloc_read_agf buffer pointer before using
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 18 Jul 2017 11:24:28 -0700
Message-ID: <150040226878.1216.15454073908001325566.stgit@magnolia>
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

In some circumstances, _alloc_read_agf can return an error code of zero
but also a null AGF buffer pointer.  Check for this and jump out.

Fixes-coverity-id: 1415250
Fixes-coverity-id: 1415320
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount.c |    4 ++++
 fs/xfs/xfs_reflink.c         |    2 ++
 2 files changed, 6 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 900ea23..45b1c3b 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1638,6 +1638,10 @@ xfs_refcount_recover_cow_leftovers(
 	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (error)
 		goto out_trans;
+	if (!agbp) {
+		error = -ENOMEM;
+		goto out_trans;
+	}
 	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
 
 	/* Find all the leftover CoW staging extents. */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d9b3d57..f45fbf0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -170,6 +170,8 @@ xfs_reflink_find_shared(
 	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (error)
 		return error;
+	if (!agbp)
+		return -ENOMEM;
 
 	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
 


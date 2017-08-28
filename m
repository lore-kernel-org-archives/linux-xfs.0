Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24110 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751270AbdH1SRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 14:17:41 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7SIHecv019844
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7SIHe3k029201
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:40 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7SIHeGK019476
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:40 GMT
Subject: [PATCH 11/12] xfs: fail out of xfs_attr3_leaf_lookup_int if it
 looks corrupt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 28 Aug 2017 11:17:38 -0700
Message-ID: <150394425879.24826.2197584659415095788.stgit@magnolia>
In-Reply-To: <150394418979.24826.12970283067445908653.stgit@magnolia>
References: <150394418979.24826.12970283067445908653.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

If the xattr leaf block looks corrupt, return -EFSCORRUPTED to userspace
instead of ASSERTing on debug kernels or running off the end of the
buffer on regular kernels.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 742e8a3..bde5269 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2246,7 +2246,8 @@ xfs_attr3_leaf_lookup_int(
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
-	ASSERT(ichdr.count < args->geo->blksize / 8);
+	if (ichdr.count >= args->geo->blksize / 8)
+		return -EFSCORRUPTED;
 
 	/*
 	 * Binary search.  (note: small blocks will skip this loop)
@@ -2262,8 +2263,10 @@ xfs_attr3_leaf_lookup_int(
 		else
 			break;
 	}
-	ASSERT(probe >= 0 && (!ichdr.count || probe < ichdr.count));
-	ASSERT(span <= 4 || be32_to_cpu(entry->hashval) == hashval);
+	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count)))
+		return -EFSCORRUPTED;
+	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval))
+		return -EFSCORRUPTED;
 
 	/*
 	 * Since we may have duplicate hashval's, find the first matching


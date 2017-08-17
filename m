Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48973 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753775AbdHQXcm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 19:32:42 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7HNWfL2027625
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7HNWfm9024977
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:41 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7HNWfZj008132
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 23:32:41 GMT
Subject: [PATCH 11/12] xfs: fail out of xfs_attr3_leaf_lookup_int if it
 looks corrupt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 17 Aug 2017 16:32:39 -0700
Message-ID: <150301275986.5851.1737833775089959985.stgit@magnolia>
In-Reply-To: <150301268960.5851.2513223883233763065.stgit@magnolia>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
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


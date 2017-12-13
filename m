Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45121 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdLMX7Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:59:24 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNlJbx100059
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:24 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2eue5b01q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:23 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNxNZi003570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:23 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNxMpe012076
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:22 GMT
Subject: [PATCH 11/13] xfs: fail out of xfs_attr3_leaf_lookup_int if it
 looks corrupt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:59:19 -0800
Message-ID: <151320955989.30654.3751933390923840893.stgit@magnolia>
In-Reply-To: <151320949282.30654.14805160700975182459.stgit@magnolia>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the xattr leaf block looks corrupt, return -EFSCORRUPTED to userspace
instead of ASSERTing on debug kernels or running off the end of the
buffer on regular kernels.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index a5033f0..e130952 100644
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


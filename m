Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39428 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757150AbdLWBNg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:13:36 -0500
Subject: [PATCH 14/20] xfs: fail out of xfs_attr3_leaf_lookup_int if it
 looks corrupt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:08:31 -0800
Message-ID: <151399131176.23543.17232259320483863747.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

If the xattr leaf block looks corrupt, return -EFSCORRUPTED to userspace
instead of ASSERTing on debug kernels or running off the end of the
buffer on regular kernels.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index ae3bccb..7168827 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2249,7 +2249,8 @@ xfs_attr3_leaf_lookup_int(
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
-	ASSERT(ichdr.count < args->geo->blksize / 8);
+	if (ichdr.count >= args->geo->blksize / 8)
+		return -EFSCORRUPTED;
 
 	/*
 	 * Binary search.  (note: small blocks will skip this loop)
@@ -2265,8 +2266,10 @@ xfs_attr3_leaf_lookup_int(
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


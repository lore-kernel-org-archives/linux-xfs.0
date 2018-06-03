Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48422 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeFCXXF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:23:05 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w53NMkDN052563
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:05 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2jbvynsfhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018 23:23:05 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w53NN4fZ030006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:04 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w53NN3tc016775
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:03 GMT
Subject: [PATCH 06/10] xfs: remove redundant ASSERT on insufficient bestfree
 length in _leaf_addname
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 03 Jun 2018 16:23:02 -0700
Message-ID: <152806818271.18187.6990427991156565889.stgit@magnolia>
In-Reply-To: <152806814253.18187.4009340462930782844.stgit@magnolia>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_dir2_leaf_addname we ASSERT if the length of the unused space
described by bestfree[0] is less the amount of space we wish to consume.
Immediately after it is a call to xfs_dir2_data_use_free where the
offset parameter is offset of the unused space and the length parameter
is the amount of space we wish to consume.  Both values (and the unused
space pointer) are passed into xfs_dir2_data_check_free, which also
validates that the region of unused space is big enough to cover the
space we wish to consume.  This is effectively the same check that the
ASSERT covers, and since a check failure results in a corruption message
being logged we can remove the ASSERT.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 50fc9c0c5e2b..9367f2a41b35 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -872,7 +872,6 @@ xfs_dir2_leaf_addname(
 	 */
 	dup = (xfs_dir2_data_unused_t *)
 	      ((char *)hdr + be16_to_cpu(bf[0].offset));
-	ASSERT(be16_to_cpu(dup->length) >= length);
 	needscan = needlog = 0;
 	/*
 	 * Mark the initial part of our freespace in use for the new entry.


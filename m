Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59476 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:44:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fT7J010307
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:55 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2hdrxnrjyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:54 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2ismh019504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:54 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2isnD026992
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:54 GMT
Subject: [PATCH 5/9] xfs: remove redundant ASSERT on insufficient bestfree
 length in _leaf_addname
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:44:53 -0700
Message-ID: <152401949323.12719.8437084534440484031.stgit@magnolia>
In-Reply-To: <152401946245.12719.18338955003321437040.stgit@magnolia>
References: <152401946245.12719.18338955003321437040.stgit@magnolia>
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
index 50fc9c0..9367f2a 100644
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


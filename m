Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32179 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753514AbdEJQDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 12:03:37 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4AG3ZCq004576
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2017 16:03:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v4AG3ZVG002571
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2017 16:03:35 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v4AG3ZbC022421
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2017 16:03:35 GMT
Date: Wed, 10 May 2017 09:03:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: bmap shouldn't barf on inline-format directories
Message-ID: <20170510160329.GS5973@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

When we're fulfilling a BMAPX request, check that the fork is still in
extents or btree format just prior to calling bmapi.  This prevents us
from hitting a debugging check in bmapi_read and barfing errors back
to userspace.  The on-disk extent count check later isn't sufficient for
IF_DELALLOC mode because da extents are in memory and not on disk.

To reproduce, run "xfs_io -c 'bmap -e'" on any inline directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7ac80a1..378f142 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -614,6 +614,11 @@ xfs_getbmap(
 		return -EINVAL;
 	bmvend = bmv->bmv_offset + bmv->bmv_length;
 
+	/* Local format inodes don't have any extents to report. */
+	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+		bmv->bmv_entries = 0;
+		return 0;
+	}
 
 	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
 		return -ENOMEM;

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47952 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbeAZCPV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 21:15:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0Q2F4iD152761
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:15:21 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2fqucqr035-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:15:20 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0Q25K7D015078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:20 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0Q25KjR010707
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2018 02:05:20 GMT
Subject: [PATCH 5/6] xfs: skip CoW writes past EOF when writeback races with
 truncate
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jan 2018 18:05:18 -0800
Message-ID: <151693231885.7395.533058591055949677.stgit@magnolia>
In-Reply-To: <151693228803.7395.12526880865470882359.stgit@magnolia>
References: <151693228803.7395.12526880865470882359.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Every so often we blow the ASSERT(type != XFS_IO_COW) in xfs_map_blocks
when running fsstress, as we do in generic/269.  The cause of this is
writeback racing with truncate -- writeback doesn't take the iolock, so
truncate can sneak in to decrease i_size and truncate page cache while
writeback is gathering buffer heads to schedule writeout.

If we hit this race on a block that has a CoW mapping, we'll get a valid
imap from the CoW fork but the reduced i_size trims the mapping to zero
length (which makes it invalid), so we call xfs_map_blocks to try again.
This doesn't do much anyway, since any mapping we get out of that will
also be invalid, so we might as well skip the assert and just stop.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2e094c7..2ebc42e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -390,6 +390,19 @@ xfs_map_blocks(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	/*
+	 * Apparently truncate can race with writeback since writeback doesn't
+	 * take the iolock and truncate decreases the file size before it
+	 * starts truncating the pages between new_size and old_size.
+	 * Therefore, we can end up in the situation where writeback gets a
+	 * CoW fork mapping but the truncate makes the mapping invalid and we
+	 * end up in here trying to get a new mapping.  Bail out here so that
+	 * we simply never get a valid mapping and so we drop the write
+	 * altogether.  The page truncation will kill the contents anyway.
+	 */
+	if (type == XFS_IO_COW && offset > i_size_read(inode))
+		return 0;
+
 	ASSERT(type != XFS_IO_COW);
 	if (type == XFS_IO_UNWRITTEN)
 		bmapi_flags |= XFS_BMAPI_IGSTATE;


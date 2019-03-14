Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48080 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfCNV3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:29:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2ELSsZE118148
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:29:01 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2r44wukj95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:29:01 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2ELT0ld018664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:29:00 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2ELT0E4023039
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:29:00 GMT
Subject: [PATCH 1/4] xfs: only free posteof blocks on first close
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:29:00 -0700
Message-ID: <155259894034.30230.7188877605950498518.stgit@magnolia>
In-Reply-To: <155259893433.30230.6566995969675098053.stgit@magnolia>
References: <155259893433.30230.6566995969675098053.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Certain workloads fragment files on XFS very badly, such as a software
package that creates a number of threads, each of which repeatedly run
the sequence: open a file, perform a synchronous write, and close the
file, which defeats the speculative preallocation mechanism.  We work
around this problem by only deleting posteof blocks the /first/ time a
file is closed to preserve the behavior that unpacking a tarball lays
out files one after the other with no gaps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 665fb2518a66..981c34bdec25 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1262,9 +1262,7 @@ xfs_release(
 				return error;
 		}
 
-		/* delalloc blocks after truncation means it really is dirty */
-		if (ip->i_delayed_blks)
-			xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
+		xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
 	}
 	return 0;
 }

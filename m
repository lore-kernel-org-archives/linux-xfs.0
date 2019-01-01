Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49512 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfAACLZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:11:25 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0129vHo166084
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:11:23 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2pnxedxajm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:11:23 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012BIeN021060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:11:18 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012BHPT003869
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:11:17 GMT
Subject: [PATCH 11/17] xfs: convert xfs_itruncate_extents_flags to use
 __xfs_bunmapi
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:11:08 -0800
Message-ID: <154630866829.15625.7130537465110165585.stgit@magnolia>
In-Reply-To: <154630859850.15625.17640302184521917854.stgit@magnolia>
References: <154630859850.15625.17640302184521917854.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There's no reason why we can't consume unmap_len, just use the raw
version.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8341031711b2..73511b003650 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1527,7 +1527,6 @@ xfs_itruncate_extents_flags(
 	xfs_fileoff_t		last_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
-	int			done = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
@@ -1558,10 +1557,10 @@ xfs_itruncate_extents_flags(
 
 	ASSERT(first_unmap_block < last_block);
 	unmap_len = last_block - first_unmap_block + 1;
-	while (!done) {
+	while (unmap_len > 0) {
 		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
-				    XFS_ITRUNC_MAX_EXTENTS, &done);
+		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
+				flags, XFS_ITRUNC_MAX_EXTENTS);
 		if (error)
 			goto out;
 

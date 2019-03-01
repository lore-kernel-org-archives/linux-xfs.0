Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfCAQRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 11:17:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21GEAq6180969
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 16:17:34 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qtwkur9y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 16:17:34 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x21GHSKj011995
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 16:17:28 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x21GHS1k010127
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 16:17:28 GMT
Date: Fri, 1 Mar 2019 08:17:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: set attributes_mask in xfs_vn_getattr
Message-ID: <20190301161727.GP21626@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

According to the statx documentation we're supposed to set a bit in
attributes_mask for every inode flag that the filesystem can support.
We don't, so fix this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iops.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1efef69a7f1c..74047bd0c1ae 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -531,6 +531,10 @@ xfs_vn_getattr(
 		}
 	}
 
+	/*
+	 * Note: If you add another clause to set an attribute flag, please
+	 * update attributes_mask below.
+	 */
 	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
@@ -538,6 +542,10 @@ xfs_vn_getattr(
 	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
 
+	stat->attributes_mask |= (STATX_ATTR_IMMUTABLE |
+				  STATX_ATTR_APPEND |
+				  STATX_ATTR_NODUMP);
+
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFBLK:
 	case S_IFCHR:

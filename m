Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbeAUFeM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Jan 2018 00:34:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0L5WjV3076740
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:34:12 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2fmkcy02tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:34:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0L5YBOq021362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:34:11 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0L5YAfO005084
        for <linux-xfs@vger.kernel.org>; Sun, 21 Jan 2018 05:34:10 GMT
Subject: [PATCH 3/6] xfs: call xfs_qm_dqattach before performing reflink
 operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 20 Jan 2018 21:34:10 -0800
Message-ID: <151651284994.28390.7445163994259507169.stgit@magnolia>
In-Reply-To: <151651282961.28390.17944517354130397779.stgit@magnolia>
References: <151651282961.28390.17944517354130397779.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Ensure that we've attached all the necessary dquots before performing
reflink operations so that quota accounting is accurate.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5d1ff5a..947d0637 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -54,6 +54,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_sb.h"
 #include "xfs_ag_resv.h"
+#include "xfs_qm.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -282,6 +283,10 @@ xfs_reflink_reserve_cow(
 	 * tree.
 	 */
 
+	error = xfs_qm_dqattach_locked(ip, 0);
+	if (error)
+		return error;
+
 	if (!xfs_iext_lookup_extent(ip, ifp, imap->br_startoff, &icur, &got))
 		eof = true;
 	if (!eof && got.br_startoff <= imap->br_startoff) {
@@ -396,6 +401,10 @@ xfs_reflink_allocate_cow(
 	ASSERT(xfs_is_reflink_inode(ip));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
 
+	error = xfs_qm_dqattach_locked(ip, 0);
+	if (error)
+		return error;
+
 	/*
 	 * Even if the extent is not shared we might have a preallocation for
 	 * it in the COW fork.  If so use it.
@@ -1356,6 +1365,14 @@ xfs_reflink_remap_range(
 	if (IS_DAX(inode_in) || IS_DAX(inode_out))
 		goto out_unlock;
 
+	/* Attach dquots to both inodes */
+	ret = xfs_qm_dqattach(src, 0);
+	if (ret)
+		goto out_unlock;
+	ret = xfs_qm_dqattach(dest, 0);
+	if (ret)
+		goto out_unlock;
+
 	ret = vfs_clone_file_prep_inodes(inode_in, pos_in, inode_out, pos_out,
 			&len, is_dedupe);
 	if (ret <= 0)


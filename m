Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755406AbdLORL2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 12:11:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBFH7Ba1167640
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:27 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2evje0r1eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:27 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBFHBRmR001244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:27 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBFHBQ5J016753
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2017 17:11:26 GMT
Subject: [PATCH 2/4] xfs: don't be so eager to clear the cowblocks tag on
 truncate
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 15 Dec 2017 09:11:25 -0800
Message-ID: <151335788573.26575.10453091656387965703.stgit@magnolia>
In-Reply-To: <151335786780.26575.15542999972223359181.stgit@magnolia>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Currently, xfs_itruncate_extents clears the cowblocks tag if i_cnextents
is zero.  This is wrong, since i_cnextents only tracks real extents in
the CoW fork, which means that we could have some delayed CoW
reservations still in there that will now never get cleaned.

Fix a further bug where we /don't/ clear the reflink iflag if there are
any attribute blocks -- really, it's only safe to clear the reflink flag
if there are no data fork extents and no cow fork extents.

Found by adding clonerange to fsstress in xfs/017.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b41952a..6f95bdb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1487,6 +1487,24 @@ xfs_link(
 	return error;
 }
 
+/* Clear the reflink flag and the cowblocks tag if possible. */
+static void
+xfs_itruncate_clear_reflink_flags(
+	struct xfs_inode	*ip)
+{
+	struct xfs_ifork	*dfork;
+	struct xfs_ifork	*cfork;
+
+	if (!xfs_is_reflink_inode(ip))
+		return;
+	dfork = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	cfork = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	if (dfork->if_bytes == 0 && cfork->if_bytes == 0)
+		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+	if (cfork->if_bytes == 0)
+		xfs_inode_clear_cowblocks_tag(ip);
+}
+
 /*
  * Free up the underlying blocks past new_size.  The new size must be smaller
  * than the current size.  This routine can be used both for the attribute and
@@ -1583,15 +1601,7 @@ xfs_itruncate_extents(
 	if (error)
 		goto out;
 
-	/*
-	 * Clear the reflink flag if there are no data fork blocks and
-	 * there are no extents staged in the cow fork.
-	 */
-	if (xfs_is_reflink_inode(ip) && ip->i_cnextents == 0) {
-		if (ip->i_d.di_nblocks == 0)
-			ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
-		xfs_inode_clear_cowblocks_tag(ip);
-	}
+	xfs_itruncate_clear_reflink_flags(ip);
 
 	/*
 	 * Always re-log the inode so that our permanent transaction can keep


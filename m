Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35652 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbeFDQKn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 12:10:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w54G5rkm010739
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:42 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2jbvypc914-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jun 2018 16:10:42 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w54GAfxW031544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:41 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w54GAfpo025829
        for <linux-xfs@vger.kernel.org>; Mon, 4 Jun 2018 16:10:41 GMT
Subject: [PATCH 3/4] xfs: don't assert when on-disk btree pointers are
 garbage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Jun 2018 09:10:40 -0700
Message-ID: <152812864040.2736.215537024334765916.stgit@magnolia>
In-Reply-To: <152812862079.2736.15381483104759513267.stgit@magnolia>
References: <152812862079.2736.15381483104759513267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't ASSERT when we encounter bad on-disk btree pointers in the debug
check functions.  Log the error to leave breadcrumbs and let the upper
layers deal with it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index ef93721c0d49..5d5fe6b96e09 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -246,16 +246,25 @@ xfs_btree_check_ptr(
 	int			level)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
-				xfs_btree_check_lptr(cur,
-					be64_to_cpu((&ptr->l)[index]), level));
+		if (xfs_btree_check_lptr(cur, be64_to_cpu((&ptr->l)[index]),
+				level))
+			return 0;
+		xfs_err(cur->bc_mp,
+"Inode %llu fork %d: Corrupt btree %d pointer at level %d index %d.",
+				cur->bc_private.b.ip->i_ino,
+				cur->bc_private.b.whichfork, cur->bc_btnum,
+				level, index);
 	} else {
-		XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
-				xfs_btree_check_sptr(cur,
-					be32_to_cpu((&ptr->s)[index]), level));
+		if (xfs_btree_check_sptr(cur, be32_to_cpu((&ptr->s)[index]),
+				level))
+			return 0;
+		xfs_err(cur->bc_mp,
+"AG %u: Corrupt btree %d pointer at level %d index %d.",
+				cur->bc_private.a.agno, cur->bc_btnum,
+				level, index);
 	}
 
-	return 0;
+	return -EFSCORRUPTED;
 }
 
 #ifdef DEBUG


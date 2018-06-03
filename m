Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48192 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeFCXWq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:22:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w53NMkDL052563
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:46 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2jbvynsfh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018 23:22:46 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w53NMjpX029718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:45 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w53NMiiv016672
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:22:44 GMT
Subject: [PATCH 03/10] xfs: don't assert when on-disk btree pointers are
 garbage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 03 Jun 2018 16:22:41 -0700
Message-ID: <152806816098.18187.494409176600320204.stgit@magnolia>
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

Don't ASSERT when we encounter bad on-disk btree pointers in the debug
check functions.  Log the error to leave breadcrumbs and let the upper
layers deal with it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2ddf47f3be52..6101ad685019 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -247,16 +247,25 @@ xfs_btree_check_ptr(
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
 #endif
 


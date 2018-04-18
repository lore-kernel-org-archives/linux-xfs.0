Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCoh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:44:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fnBZ100939
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:37 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8k0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:37 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2iaXg014760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:36 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3I2ia7v028233
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:36 GMT
Subject: [PATCH 2/9] xfs: don't assert when on-disk btree pointers are
 garbage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:44:34 -0700
Message-ID: <152401947482.12719.12573042641278124294.stgit@magnolia>
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

Don't ASSERT when we encounter bad on-disk btree pointers in the debug
check functions.  Log the error to leave breadcrumbs and let the upper
layers deal with it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2ddf47f..6101ad6 100644
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
 


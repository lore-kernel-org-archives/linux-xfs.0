Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47924 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeFCXXY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:23:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w53NMIOg139669
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:24 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2jbvyp9fxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018 23:23:23 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w53NNNoV021638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:23 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w53NNMM8016901
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:22 GMT
Subject: [PATCH 09/10] xfs: don't ASSERT on short form btree root pointer of
 zero
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 03 Jun 2018 16:23:21 -0700
Message-ID: <152806820166.18187.3892893338496519833.stgit@magnolia>
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

Don't ASSERT if the short form btree root pointer is zero.  Now that we
use xfs_verify_agbno to check all short form btree pointers, we'll let
that log the error and pass it to the upper layers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    1 -
 fs/xfs/libxfs/xfs_refcount_btree.c |    1 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |    1 -
 3 files changed, 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 18aec7a0e599..a4a001f2e130 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -242,7 +242,6 @@ xfs_allocbt_init_ptr_from_cur(
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
-	ASSERT(agf->agf_roots[cur->bc_btnum] != 0);
 
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 375abfeb6267..f652b48128c3 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -192,7 +192,6 @@ xfs_refcountbt_init_ptr_from_cur(
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
-	ASSERT(agf->agf_refcount_root != 0);
 
 	ptr->s = agf->agf_refcount_root;
 }
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index d756e0b84abf..78ab00beee93 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -234,7 +234,6 @@ xfs_rmapbt_init_ptr_from_cur(
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
-	ASSERT(agf->agf_roots[cur->bc_btnum] != 0);
 
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }


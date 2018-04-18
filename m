Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47222 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:45:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fpsi100948
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:13 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8k1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:13 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2jCFU016368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:12 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2jCuf032615
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:12 GMT
Subject: [PATCH 8/9] xfs: don't ASSERT on short form btree root pointer of
 zero
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:45:11 -0700
Message-ID: <152401951163.12719.7441194507384177453.stgit@magnolia>
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
index 18aec7a..a4a001f 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -242,7 +242,6 @@ xfs_allocbt_init_ptr_from_cur(
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
-	ASSERT(agf->agf_roots[cur->bc_btnum] != 0);
 
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 375abfe..f652b48 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -192,7 +192,6 @@ xfs_refcountbt_init_ptr_from_cur(
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
-	ASSERT(agf->agf_refcount_root != 0);
 
 	ptr->s = agf->agf_refcount_root;
 }
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index d756e0b..78ab00b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -234,7 +234,6 @@ xfs_rmapbt_init_ptr_from_cur(
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
 
 	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
-	ASSERT(agf->agf_roots[cur->bc_btnum] != 0);
 
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }


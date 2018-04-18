Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45200 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCk3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:40:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2a2vt097385
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:28 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8js7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:28 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2eRDw014262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:27 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2eRFU030548
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:27 GMT
Subject: [PATCH 08/11] xfs: clean up scrub usage of KM_NOFS
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:40:26 -0700
Message-ID: <152401922624.11465.11624202753005507925.stgit@magnolia>
In-Reply-To: <152401916729.11465.4212188839231900136.stgit@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

All scrub code runs in transaction context, which means that memory
allocations are automatically run in PF_MEMALLOC_NOFS context.  It's
therefore unnecessary to pass in KM_NOFS to allocation routines, so
clean them all out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c |    3 ++-
 fs/xfs/scrub/btree.c    |    2 +-
 fs/xfs/scrub/refcount.c |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index aacbc3f..6c6e4d8 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -798,7 +798,8 @@ xfs_scrub_agfl(
 	}
 	memset(&sai, 0, sizeof(sai));
 	sai.sz_entries = agflcount;
-	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount, KM_NOFS);
+	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount,
+			KM_MAYFAIL);
 	if (!sai.entries) {
 		error = -ENOMEM;
 		goto out;
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 5421816..ea972da 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -442,7 +442,7 @@ xfs_scrub_btree_check_owner(
 	 */
 	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
 		co = kmem_alloc(sizeof(struct check_owner),
-				KM_MAYFAIL | KM_NOFS);
+				KM_MAYFAIL);
 		if (!co)
 			return -ENOMEM;
 		co->level = level;
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 823bda3..5fff94d 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -150,7 +150,7 @@ xfs_scrub_refcountbt_rmap_check(
 		 * so we don't need insertion sort here.
 		 */
 		frag = kmem_alloc(sizeof(struct xfs_scrub_refcnt_frag),
-				KM_MAYFAIL | KM_NOFS);
+				KM_MAYFAIL);
 		if (!frag)
 			return -ENOMEM;
 		memcpy(&frag->rm, rec, sizeof(frag->rm));


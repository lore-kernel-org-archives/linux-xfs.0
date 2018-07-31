Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33214 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbeGaFg0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 01:36:26 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6V3t3HY010646
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:58:14 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2kge0cy7pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:58:14 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6V3wDXl013943
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:58:13 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6V3wDZ1001832
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 03:58:13 GMT
Date: Mon, 30 Jul 2018 20:58:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: move extent busy tree initialization to
 xfs_initialize_perag
Message-ID: <20180731035812.GU30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the per-AG busy extent tree initialization to the per-ag structure
initialization since we don't want online repair to leak the old tree.
We only deconstruct the tree at unmount time, so this should be safe.
This also enables us to eliminate the commented out initialization in
the xfsprogs libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    3 ---
 fs/xfs/xfs_mount.c        |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3c3f2d5119ea..9847c1632712 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2755,9 +2755,6 @@ xfs_alloc_read_agf(
 		pag->pagf_levels[XFS_BTNUM_RMAPi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
-		spin_lock_init(&pag->pagb_lock);
-		pag->pagb_count = 0;
-		pag->pagb_tree = RB_ROOT;
 		pag->pagf_init = 1;
 		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
 	}
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8f739e4d0d1c..99db27d6ac8a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -207,6 +207,9 @@ xfs_initialize_perag(
 		if (xfs_buf_hash_init(pag))
 			goto out_free_pag;
 		init_waitqueue_head(&pag->pagb_wait);
+		spin_lock_init(&pag->pagb_lock);
+		pag->pagb_count = 0;
+		pag->pagb_tree = RB_ROOT;
 
 		if (radix_tree_preload(GFP_NOFS))
 			goto out_hash_destroy;

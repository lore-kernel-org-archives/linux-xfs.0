Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34989 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753218AbdKHU4j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 15:56:39 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA8KucUP003998
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 8 Nov 2017 20:56:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA8KucnP000689
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 8 Nov 2017 20:56:38 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA8Kuc4a017235
        for <linux-xfs@vger.kernel.org>; Wed, 8 Nov 2017 20:56:38 GMT
Date: Wed, 8 Nov 2017 12:56:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/5] xfs: only check da node header padding on v5 filesystems
Message-ID: <20171108205636.GG26910@magnolia>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151001660179.26786.15701876786383794673.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

It turns out that we only started zeroing a new da btree node's block
header on v5 filesystems.  Prior to that, we just wouldn't set anything
at all, which means that the pad field never got set and would retain
whatever happened to be in memory.

Therefore, we can only check the pad for zeroness on v5 filesystems.
shared/006 on a v4 filesystem exposes this scrub bug.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dabtree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 4c9839c..d94edd9 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -378,7 +378,8 @@ xfs_scrub_da_btree_block(
 	blk->magic = be16_to_cpu(hdr3->hdr.magic);
 	pmaxrecs = &ds->maxrecs[level];
 
-	if (hdr3->hdr.pad != cpu_to_be16(0))
+	/* We only started zeroing the header on v5 filesystems. */
+	if (xfs_sb_version_hascrc(&ds->sc->mp->m_sb) && hdr3->hdr.pad)
 		xfs_scrub_da_set_corrupt(ds, level);
 
 	/* Check the owner. */

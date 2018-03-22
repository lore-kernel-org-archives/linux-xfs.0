Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50016 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbeCVGTT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 02:19:19 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2M6Cwko140405
        for <linux-xfs@vger.kernel.org>; Thu, 22 Mar 2018 06:19:19 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2gv71100s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Mar 2018 06:19:19 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2M6JHc4015069
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Mar 2018 06:19:18 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2M6JHoE011240
        for <linux-xfs@vger.kernel.org>; Thu, 22 Mar 2018 06:19:17 GMT
Date: Wed, 21 Mar 2018 23:19:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/9] xfs: xfs_scrub_iallocbt_xref_rmap_inodes should use
 xref_set_corrupt
Message-ID: <20180322061916.GT4818@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152107377037.19571.8618901963505842632.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_scrub_iallocbt_xref_rmap_inodes we're checking inodes against
rmap records, so we should use xfs_scrub_btree_xref_set_corrupt if we
encounter discrepancies here so that we know that it's a cross
referencing error, not necessarily a corruption in the inobt itself.

The userspace xfs_scrub program will try to repair outright corruptions
in the agi/inobt prior to phase 3 so that the inode scan will proceed.
If only a cross-referencing error is noted, the repair program defers
the repair attempt until it can check the other space metadata at least
once.

It is therefore essential that the inobt scrubber can correctly
distinguish between corruptions and "unable to cross-reference something
else with this inobt".  The same reasoning applies to "xfs: record inode
buf errors as a xref error in inobt scrubber".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 32e0d1a..106ca4b 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -434,7 +434,7 @@ xfs_scrub_iallocbt_xref_rmap_inodes(
 	if (!xfs_scrub_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
 	if (blocks != inode_blocks)
-		xfs_scrub_btree_set_corrupt(sc, sc->sa.ino_cur, 0);
+		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 }
 
 /* Scrub the inode btrees for some AG. */

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58327 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756065AbdLWApE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:45:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0ivQE196383
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:45:03 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2f1cvf000b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:45:03 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0j2da009637
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:45:03 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0j2hc028621
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:45:02 GMT
Subject: [PATCH 21/21] xfs: cross-reference the block mappings when possible
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:45:01 -0800
Message-ID: <151398990147.18741.17837826861246689519.stgit@magnolia>
In-Reply-To: <151398977028.18741.12031215574014508438.stgit@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use an inode's block mappings to cross-reference inode block counters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/inode.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index b32a01d..d21866f 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -37,6 +37,8 @@
 #include "xfs_da_format.h"
 #include "xfs_reflink.h"
 #include "xfs_rmap.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -578,6 +580,37 @@ xfs_scrub_inode_map_raw(
 	return error;
 }
 
+/* Cross reference the inode fields with the forks. */
+STATIC void
+xfs_scrub_inode_xref_bmap(
+	struct xfs_scrub_context	*sc,
+	struct xfs_dinode		*dip)
+{
+	xfs_extnum_t			nextents;
+	xfs_filblks_t			count;
+	xfs_filblks_t			acount;
+	int				error;
+
+	/* Walk all the extents to check nextents/naextents/nblocks. */
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (!xfs_scrub_should_xref(sc, &error, NULL))
+		return;
+	if (nextents < be32_to_cpu(dip->di_nextents))
+		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino, NULL);
+
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+			&nextents, &acount);
+	if (!xfs_scrub_should_xref(sc, &error, NULL))
+		return;
+	if (nextents != be16_to_cpu(dip->di_anextents))
+		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino, NULL);
+
+	/* Check nblocks against the inode. */
+	if (count + acount != be64_to_cpu(dip->di_nblocks))
+		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino, NULL);
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xfs_scrub_inode_xref(
@@ -604,6 +637,7 @@ xfs_scrub_inode_xref(
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 	xfs_scrub_xref_owned_by(sc, &sc->sa.rmap_cur, agbno, 1, &oinfo);
 	xfs_scrub_xref_not_shared(sc, &sc->sa.refc_cur, agbno, 1);
+	xfs_scrub_inode_xref_bmap(sc, dip);
 
 	xfs_scrub_ag_free(sc, &sa);
 }


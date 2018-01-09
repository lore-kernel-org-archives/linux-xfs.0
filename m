Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59052 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752305AbeAIV2a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 16:28:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09LQVWY088913
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:28:30 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fd5fv825f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jan 2018 21:28:29 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09LQZfE002118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:26:35 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w09LQYbC013254
        for <linux-xfs@vger.kernel.org>; Tue, 9 Jan 2018 21:26:34 GMT
Date: Tue, 9 Jan 2018 13:26:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 21/21] xfs: cross-reference the block mappings when
 possible
Message-ID: <20180109212633.GP5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398990147.18741.17837826861246689519.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398990147.18741.17837826861246689519.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use an inode's block mappings to cross-reference inode block counters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: streamline scrubber arguments, remove stack allocated objects
---
 fs/xfs/scrub/inode.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index f12586c..b2fc3ac 100644
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
@@ -626,6 +628,37 @@ xfs_scrub_inode_xref_finobt(
 		xfs_scrub_btree_xref_set_corrupt(sc, sc->sa.fino_cur, 0);
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
+	if (!xfs_scrub_should_check_xref(sc, &error, NULL))
+		return;
+	if (nextents < be32_to_cpu(dip->di_nextents))
+		xfs_scrub_ino_xref_set_corrupt(sc, sc->ip->i_ino, NULL);
+
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+			&nextents, &acount);
+	if (!xfs_scrub_should_check_xref(sc, &error, NULL))
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
@@ -653,6 +686,7 @@ xfs_scrub_inode_xref(
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
 	xfs_scrub_xref_owned_by(sc, agbno, 1, &oinfo);
 	xfs_scrub_xref_not_shared(sc, agbno, 1);
+	xfs_scrub_inode_xref_bmap(sc, dip);
 
 	xfs_scrub_ag_free(sc, &sc->sa);
 }

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37702 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbdLMX57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:57:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNl9W8024430
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:58 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2eudq605dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:58 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNvvbT024569
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:57 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBDNvupj026462
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:57:57 GMT
Subject: [PATCH 15/15] xfs: cross-reference the block mappings when possible
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:57:54 -0800
Message-ID: <151320947398.30154.1126939598300413289.stgit@magnolia>
In-Reply-To: <151320938254.30154.1046660005648421683.stgit@magnolia>
References: <151320938254.30154.1046660005648421683.stgit@magnolia>
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
index 6ea2c96..18588fb 100644
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


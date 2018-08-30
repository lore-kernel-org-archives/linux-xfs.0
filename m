Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51786 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbeH3Wg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Aug 2018 18:36:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7UISec4133725
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:30 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2m2yrqpb28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:30 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7UIXUm6016231
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:30 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7UIXTWd020127
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:33:29 GMT
Subject: [PATCH 17/18] xfs: cross-reference realtime bitmap to realtime
 rmapbt scrubber
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 30 Aug 2018 11:33:28 -0700
Message-ID: <153565400876.32612.8730648788010963281.stgit@magnolia>
In-Reply-To: <153565389576.32612.11057291402738397706.stgit@magnolia>
References: <153565389576.32612.11057291402738397706.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're checking the realtime rmapbt, cross-reference the entries
with the realtime bitmap too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/rtrmap.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 6dde3c026918..0685a647d373 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -56,6 +56,16 @@ xchk_setup_rtrmapbt(
 
 /* Realtime reverse mapping. */
 
+/* Cross-reference with other metadata. */
+STATIC void
+xchk_rtrmapbt_xref(
+	struct xfs_scrub	*sc,
+	struct xfs_rmap_irec	*irec)
+{
+	xchk_xref_is_used_rt_space(sc, irec->rm_startblock,
+			irec->rm_blockcount);
+}
+
 /* Scrub a realtime rmapbt record. */
 STATIC int
 xchk_rtrmapbt_helper(
@@ -86,6 +96,10 @@ xchk_rtrmapbt_helper(
 	if (is_bmbt || non_inode || is_attr)
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
+	xchk_rtrmapbt_xref(bs->sc, &irec);
 out:
 	return error;
 }

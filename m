Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39958 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfCRQmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Mar 2019 12:42:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2IGYcKj167101
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2019 16:42:17 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2r8rjufsu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2019 16:42:17 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2IGgGP0002579
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2019 16:42:16 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2IGgGS8015070
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2019 16:42:16 GMT
Date: Mon, 18 Mar 2019 09:42:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: dabtree scrub needs to range-check level
Message-ID: <20190318164215.GN4929@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure scrub's dabtree iterator function checks that we're not
going deeper in the stack than our cursor permits.  Found by sparse.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dabtree.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index c6ab123b6051..5c6175d074e0 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -604,6 +604,11 @@ xchk_da_btree(
 		/* Drill another level deeper. */
 		blkno = be32_to_cpu(key->before);
 		level++;
+		if (level >= XFS_DA_NODE_MAXDEPTH) {
+			/* Too deep! */
+			xchk_da_set_corrupt(&ds, level - 1);
+			break;
+		}
 		ds.tree_level--;
 		error = xchk_da_btree_block(&ds, level, blkno);
 		if (error)

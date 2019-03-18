Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33648 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfCRQnk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Mar 2019 12:43:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2IGYSMK173144
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2019 16:43:39 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2r8ssr7n5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2019 16:43:39 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2IGhb66020151
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2019 16:43:38 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2IGhbAL006096
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2019 16:43:37 GMT
Date: Mon, 18 Mar 2019 09:43:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix btree scrub checking with regards to root-in-inode
Message-ID: <20190318164336.GO4929@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In xchk_btree_check_owner, we can be passed a null buffer pointer.  This
should only happen for the root of a root-in-inode btree type, but we
should program defensively in case the btree cursor state ever gets
screwed up and we get a null buffer anyway.

Coverity-id: 1438713
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/btree.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 6271a277eabe..cf4046c9e250 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -481,8 +481,17 @@ xchk_btree_check_owner(
 	struct xfs_btree_cur	*cur = bs->cur;
 	struct check_owner	*co;
 
-	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) && bp == NULL)
+	/*
+	 * In theory, xfs_btree_get_block should only give us a null buffer
+	 * pointer for the root of a root-in-inode btree type, but we need
+	 * to check defensively here in case the cursor state is also screwed
+	 * up.
+	 */
+	if (bp == NULL) {
+		if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
+			xchk_btree_set_corrupt(bs->sc, bs->cur, level);
 		return 0;
+	}
 
 	/*
 	 * We want to cross-reference each btree block with the bnobt

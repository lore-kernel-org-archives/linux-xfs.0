Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34725 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935002AbdKGBEK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 20:04:10 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA7149UM030697
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:04:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA714864007359
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:04:09 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA7148S0017845
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2017 01:04:08 GMT
Subject: [PATCH 5/5] xfs: fix btree scrub deref check
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 06 Nov 2017 17:03:52 -0800
Message-ID: <151001663224.26786.16638321559848220870.stgit@magnolia>
In-Reply-To: <151001660179.26786.15701876786383794673.stgit@magnolia>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The btree scrubber has some custom code to retrieve and check a btree
block via xfs_btree_lookup_get_block.  This function will either return
an error code (verifiers failed) or a *pblock will be untouched (bad
pointer).  Since we previously set *pblock to NULL, we need to check
*pblock, not pblock, to trigger the early bailout.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index a814404..df07661 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -335,7 +335,7 @@ xfs_scrub_btree_get_block(
 
 	error = xfs_btree_lookup_get_block(bs->cur, level, pp, pblock);
 	if (!xfs_scrub_btree_process_error(bs->sc, bs->cur, level, &error) ||
-	    !pblock)
+	    !*pblock)
 		return error;
 
 	xfs_btree_get_block(bs->cur, level, pbp);


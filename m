Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42012 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbfAORI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 12:08:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0FH4PVd012403
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jan 2019 17:08:27 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pybjs54yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jan 2019 17:08:27 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0FH8MC9032298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jan 2019 17:08:22 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0FH8Lqx026876
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jan 2019 17:08:22 GMT
Date: Tue, 15 Jan 2019 09:08:20 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't crash when read verifier reports errors with null
 b_ops
Message-ID: <20190115170820.GB12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In xrep_findroot_block, we work out the btree type and correctness of a
given block by calling different btree verifiers on root block
candidates.  However, we leave the NULL b_ops while ->verify_read
validates the block, which means that if the verifier calls
xfs_buf_verifier_error it'll crash on the null b_ops.  Fix it to avoid
this crash.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
FWIW I also thought about stuffing in a fake b_ops while xrep_findroot
is calling a candidate read verifier, but thought that might just
confuse things more?
---
 fs/xfs/xfs_error.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 9866f542e77b..2a02be280769 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -359,7 +359,7 @@ xfs_buf_verifier_error(
 
 	xfs_alert(mp, "Metadata %s detected at %pS, %s block 0x%llx %s",
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
-		  fa, bp->b_ops->name, bp->b_bn, name);
+		  fa, bp->b_ops ? bp->b_ops->name : "unknown", bp->b_bn, name);
 
 	xfs_alert(mp, "Unmount and run xfs_repair");
 

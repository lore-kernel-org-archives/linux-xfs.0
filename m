Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25590 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdIUARj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 20:17:39 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8L0HcNE004767
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:17:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0HcSu003673
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:17:38 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0HcZC005279
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 00:17:38 GMT
Subject: [PATCH 01/27] xfs: return a distinct error code value for
 IGET_INCORE cache misses
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Sep 2017 17:17:37 -0700
Message-ID: <150595305764.18473.14307181577961479811.stgit@magnolia>
In-Reply-To: <150595305131.18473.16572195821331601191.stgit@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For an XFS_IGET_INCORE iget operation, if the inode isn't in the cache,
return ENODATA so that we don't confuse it with the pre-existing ENOENT
cases (inode is in cache, but freed).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3422711..43005fb 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -610,7 +610,7 @@ xfs_iget(
 	} else {
 		rcu_read_unlock();
 		if (flags & XFS_IGET_INCORE) {
-			error = -ENOENT;
+			error = -ENODATA;
 			goto out_error_or_again;
 		}
 		XFS_STATS_INC(mp, xs_ig_missed);


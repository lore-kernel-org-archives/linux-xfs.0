Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33846 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967622AbeEXPzz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 May 2018 11:55:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4OFtZvE026937
        for <linux-xfs@vger.kernel.org>; Thu, 24 May 2018 15:55:54 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2j4nh7h2hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 24 May 2018 15:55:54 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4OFtssw024773
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 24 May 2018 15:55:54 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4OFtrc8022839
        for <linux-xfs@vger.kernel.org>; Thu, 24 May 2018 15:55:54 GMT
Date: Thu, 24 May 2018 08:55:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix inobt magic number check
Message-ID: <20180524155553.GO14384@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit a6a781a58befcbd467c ("xfs: have buffer verifier functions
report failing address") the bad magic number return was ported
incorrectly.

Fixes: a6a781a58befcbd467ce843af4eaca3906aa1f08
Reported-by: syzbot+08ab33be0178b76851c8@syzkaller.appspotmail.com
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index ba053a4c124f..b04c55512159 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -296,7 +296,7 @@ xfs_inobt_verify(
 	case cpu_to_be32(XFS_FIBT_MAGIC):
 		break;
 	default:
-		return NULL;
+		return __this_address;
 	}
 
 	/* level verification */

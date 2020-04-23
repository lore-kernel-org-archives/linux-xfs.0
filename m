Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1590C54FD0
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 17:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BB6121556
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 17:25:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EVYXs30Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgDWRZd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 13:25:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbgDWRZc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 13:25:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NHMYEe138176
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 17:25:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=rNBxKwWv/F9CpQafpZ0RHkvojz5d1GSrRkAF1xHh++0=;
 b=EVYXs30YegjJPsRT8FcJfqBiiSKy3zt6x04Q60MZke7mO5RA2bFjZ5Tr8H997sD3uz4r
 RgwXpDm7pja7LzANIo73tfaLkBfIXvwZdJomDRp8bk99f2atPTbt19v4P3owvgzwpzyN
 EpzXVlCanjVHnnysMwubOV1Wi9XJ18bWxxbgjknlGat25G3cSg4CwP3BRDV+UlWLvk+b
 mPyE/w9YqsjUhc1jQ7PNCIgaJqafK8wP35JprK5VSDJyhuB0fG6yunCOWfV+Sq1i3hze
 Sd8NlYhuz0c/+eQzu7IUytsCtRxdoUtPTvQ+CEXp5CIFxnU3gtRtzLxNQ5ERZTrrmAnF DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30ketdg70h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 17:25:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NHMeZn088544
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 17:23:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30gbbmmbyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 17:23:30 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03NHNU8s002603
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 17:23:30 GMT
Received: from oracle.com (/10.211.45.245)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 10:23:29 -0700
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     wen.gang.wang@oracle.com
Subject: [PATCH] xfs: don't change to infinate lock to avoid dead lock
Date:   Thu, 23 Apr 2020 10:23:25 -0700
Message-Id: <20200423172325.8595-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=972 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1011 suspectscore=1 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_reclaim_inodes_ag() do infinate locking on pag_ici_reclaim_lock at the
2nd round of walking of all AGs when SYNC_TRYLOCK is set (conditionally).
That causes dead lock in a special situation:

1) In a heavy memory load environment, process A is doing direct memory
reclaiming waiting for xfs_inode.i_pincount to be cleared while holding
mutex lock pag_ici_reclaim_lock.

2) i_pincount is increased by adding the xfs_inode to journal transection,
and it's expected to be decreased when the transection related IO is done.
Step 1) happens after i_pincount is increased and before truansection IO is
issued.

3) Now the transection IO is issued by process B. In the IO path (IO could
be more complex than you think), memory allocation and memory direct
reclaiming happened too. It is blocked, during the 2nd walking of AGs, at
locking pag_ici_reclaim_lock which is now held by process A.

Thus Process A waiting for IO done holding pag_ici_reclaim_lock, process B
tries to issue the IO but blocked at pag_ici_reclaim_lock. -- That forms
dead lock.

The fix is: don't change to infinate wait when SYNC_TRYLOCK is set. To
avoid long time spining, just walk each AG only once.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_icache.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8dc2e5414276..e2a6ab04db3d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1245,11 +1245,8 @@ xfs_reclaim_inodes_ag(
 	int			last_error = 0;
 	xfs_agnumber_t		ag;
 	int			trylock = flags & SYNC_TRYLOCK;
-	int			skipped;
 
-restart:
 	ag = 0;
-	skipped = 0;
 	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
 		unsigned long	first_index = 0;
 		int		done = 0;
@@ -1259,7 +1256,6 @@ xfs_reclaim_inodes_ag(
 
 		if (trylock) {
 			if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
-				skipped++;
 				xfs_perag_put(pag);
 				continue;
 			}
@@ -1340,17 +1336,6 @@ xfs_reclaim_inodes_ag(
 		xfs_perag_put(pag);
 	}
 
-	/*
-	 * if we skipped any AG, and we still have scan count remaining, do
-	 * another pass this time using blocking reclaim semantics (i.e
-	 * waiting on the reclaim locks and ignoring the reclaim cursors). This
-	 * ensure that when we get more reclaimers than AGs we block rather
-	 * than spin trying to execute reclaim.
-	 */
-	if (skipped && (flags & SYNC_WAIT) && *nr_to_scan > 0) {
-		trylock = 0;
-		goto restart;
-	}
 	return last_error;
 }
 
-- 
2.21.0


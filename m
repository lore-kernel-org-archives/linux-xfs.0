Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49778 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753725AbeFUSbZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 14:31:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5LITFxd082983
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:24 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2jmr2muapd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:24 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5LIVOXh027296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:24 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5LIVNXM030811
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:23 GMT
Subject: [PATCH 3/8] xfs: don't trip over negative free space in
 xfs_reserve_blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jun 2018 11:31:22 -0700
Message-ID: <152960588253.26246.18220681679037001885.stgit@magnolia>
In-Reply-To: <152960586416.26246.8634761888260524091.stgit@magnolia>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we somehow end up with a filesystem that has fewer free blocks than
the blocks set aside to avoid ENOSPC deadlocks, it's possible that the
free space calculation in xfs_reserve_blocks will spit out a negative
number (because percpu_counter_sum returns s64).  We fail to notice
this negative number and set fdblks_delta to it.  Now we increment
fdblocks(!) and the unsigned type of m_resblks means that we end up
setting a ridiculously huge m_resblks reservation.

Avoid this comedy of errors by detecting the negative free space and
returning -ENOSPC.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a7afcad6b711..3f2bd6032cf8 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -387,7 +387,7 @@ xfs_reserve_blocks(
 	do {
 		free = percpu_counter_sum(&mp->m_fdblocks) -
 						mp->m_alloc_set_aside;
-		if (!free)
+		if (free <= 0)
 			break;
 
 		delta = request - mp->m_resblks;


Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46160 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbeFIC05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jun 2018 22:26:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w592QUpb190056
        for <linux-xfs@vger.kernel.org>; Sat, 9 Jun 2018 02:26:56 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2jbvypye3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jun 2018 02:26:56 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w592Qsgc018895
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 9 Jun 2018 02:26:55 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w592QshQ020919
        for <linux-xfs@vger.kernel.org>; Sat, 9 Jun 2018 02:26:54 GMT
Date: Fri, 8 Jun 2018 19:26:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: update incore per-AG inode count
Message-ID: <20180609022653.GS25007@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

For whatever reason we never actually update pagi_count (the in-core
perag inode count) when we allocate or free inode chunks.  Online scrub
is going to use it, so we need to fix the accounting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 3f551eb29157..a64f71b614cc 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -897,6 +897,7 @@ xfs_ialloc_ag_alloc(
 	be32_add_cpu(&agi->agi_freecount, newlen);
 	pag = xfs_perag_get(args.mp, agno);
 	pag->pagi_freecount += newlen;
+	pag->pagi_count += newlen;
 	xfs_perag_put(pag);
 	agi->agi_newino = cpu_to_be32(newino);
 
@@ -1991,6 +1992,7 @@ xfs_difree_inobt(
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
 		pag = xfs_perag_get(mp, agno);
 		pag->pagi_freecount -= ilen - 1;
+		pag->pagi_count -= ilen;
 		xfs_perag_put(pag);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));

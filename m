Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33726 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933158AbeCGJFT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Mar 2018 04:05:19 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 672EC40201A9
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 09:05:18 +0000 (UTC)
Received: from odin.brq.redhat.com (unknown [10.43.17.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C9AE10B0F49
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 09:05:17 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 4/4] Get rid of XFS_BUF_SET_COUNT() macro
Date: Wed,  7 Mar 2018 10:05:06 +0100
Message-Id: <20180307090506.30199-5-cmaiolino@redhat.com>
In-Reply-To: <20180307090506.30199-1-cmaiolino@redhat.com>
References: <20180307090506.30199-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	Fix indentation

 libxfs/libxfs_io.h        | 3 +--
 libxlog/xfs_log_recover.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index f429d667..78c29445 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -102,11 +102,10 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 #define XFS_BUF_SIZE(bp)		((bp)->b_bcount)
 #define XFS_BUF_SET_PTR(bp,p,cnt)	({	\
 	(bp)->b_addr = (char *)(p);		\
-	XFS_BUF_SET_COUNT(bp,cnt);		\
+	(bp)->b_bcount = (cnt);			\
 })
 
 #define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_bn = (blk))
-#define XFS_BUF_SET_COUNT(bp,cnt)	((bp)->b_bcount = (cnt))
 
 #define XFS_BUF_SET_PRIORITY(bp,pri)	cache_node_set_priority( \
 						libxfs_bcache, \
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 6bd000c0..68989930 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -131,7 +131,7 @@ xlog_bread_noalign(
 	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
+	bp->b_bcount = BBTOB(nbblks);
 	bp->b_error = 0;
 
 	return libxfs_readbufr(log->l_dev, XFS_BUF_ADDR(bp), bp, nbblks, 0);
-- 
2.14.3


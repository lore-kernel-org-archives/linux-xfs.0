Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39096 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbeH1XSJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 19:18:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7SJJDmP125076
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:04 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2m2y2pdwkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:04 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJP2vE013368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:03 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJP20e003545
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:25:02 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v8 26/28] xfs: Increase  XFS_DEFER_OPS_NR_INODES to 4
Date: Tue, 28 Aug 2018 12:22:39 -0700
Message-Id: <1535484161-11059-27-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Renames that generate parent pointer updates will
need to 2 extra defer operations.  One for the rmap
update and another for the parent pointer update

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_trans.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index cc38d45..7e86892 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -95,7 +95,7 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+#define XFS_DEFER_OPS_NR_INODES	4	/* join up to four inodes */
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /*
-- 
2.7.4

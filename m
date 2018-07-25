Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39554 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727757AbeGYDZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 23:25:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6P29VZE015300
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 02:16:16 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2kbtbcum07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 02:16:16 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6P2GFu8005381
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 02:16:15 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6P2GEoF029773
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 02:16:14 GMT
Subject: [PATCH 1/2] xfs: kill IHOLD
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 24 Jul 2018 18:14:52 -0700
Message-ID: <153248129226.28208.17839960103899087670.stgit@magnolia>
In-Reply-To: <153248128617.28208.11803349732053454018.stgit@magnolia>
References: <153248128617.28208.11803349732053454018.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Nobody uses this macro, get rid of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.h |    7 -------
 1 file changed, 7 deletions(-)


diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2ed63a49e890..8e18bc0fedd0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -484,13 +484,6 @@ static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
 	xfs_finish_inode_setup(ip);
 }
 
-#define IHOLD(ip) \
-do { \
-	ASSERT(atomic_read(&VFS_I(ip)->i_count) > 0) ; \
-	ihold(VFS_I(ip)); \
-	trace_xfs_ihold(ip, _THIS_IP_); \
-} while (0)
-
 #define IRELE(ip) \
 do { \
 	trace_xfs_irele(ip, _THIS_IP_); \


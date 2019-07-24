Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39966 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfGXPft (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 11:35:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFUJwS132701
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:35:48 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tx61bx9k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:35:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFMaff145920
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:35:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tx60y27hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:35:47 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6OFZkf5014778
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:35:47 GMT
Date: Wed, 24 Jul 2019 08:35:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix stack contents leakage in the v1 bulkstat/inumbers
 ioctls
Message-ID: <20190724153545.GC1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Explicitly initialize the onstack structures to zero so we don't leak
kernel memory into userspace when converting the in-core structure to
the v1 ioctl structure.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f193f7b288ca..44e1a290f053 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -719,7 +719,7 @@ xfs_fsbulkstat_one_fmt(
 	struct xfs_ibulk		*breq,
 	const struct xfs_bulkstat	*bstat)
 {
-	struct xfs_bstat		bs1;
+	struct xfs_bstat		bs1 = { 0 };
 
 	xfs_bulkstat_to_bstat(breq->mp, &bs1, bstat);
 	if (copy_to_user(breq->ubuffer, &bs1, sizeof(bs1)))
@@ -732,7 +732,7 @@ xfs_fsinumbers_fmt(
 	struct xfs_ibulk		*breq,
 	const struct xfs_inumbers	*igrp)
 {
-	struct xfs_inogrp		ig1;
+	struct xfs_inogrp		ig1 = { 0 };
 
 	xfs_inumbers_to_inogrp(&ig1, igrp);
 	if (copy_to_user(breq->ubuffer, &ig1, sizeof(struct xfs_inogrp)))

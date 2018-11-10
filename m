Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49640 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbeKJK2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 05:28:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAA0hlqu088253
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:42 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2nh3mq9tr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:42 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAA0jfYo017667
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:41 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAA0jfXP029348
        for <linux-xfs@vger.kernel.org>; Sat, 10 Nov 2018 00:45:41 GMT
Subject: [PATCH 4/6] xfs_scrub: handle totally empty inode chunks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 09 Nov 2018 16:45:39 -0800
Message-ID: <154181073901.3727.3960278646297663354.stgit@magnolia>
In-Reply-To: <154181071499.3727.3910572718199592407.stgit@magnolia>
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We try to load a single inobt record with each FSINUMBERS call.  If the
chunk is totally empty (which can happen when there are more than one
inobt record per block) we should skip to the next INUMBERS call since
there are no inodes to bulkstat.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/inodes.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 693f21ec..442a5978 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -139,6 +139,12 @@ xfs_iterate_inodes_range(
 		/* Load the inodes. */
 		ino = inogrp.xi_startino - 1;
 		bulkreq.icount = inogrp.xi_alloccount;
+		/*
+		 * We can have totally empty inode chunks on filesystems where
+		 * there are more than 64 inodes per block.  Skip these.
+		 */
+		if (inogrp.xi_alloccount == 0)
+			goto igrp_retry;
 		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT, &bulkreq);
 		if (error)
 			str_info(ctx, descr, "%s", strerror_r(errno,

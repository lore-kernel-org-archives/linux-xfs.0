Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3364EC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 120FC21924
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JOwn3prr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgGNBea (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:34:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39500 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNBea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:34:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1Wdkf096294;
        Tue, 14 Jul 2020 01:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1qsbR10apGkwWIs9C7PmGh/zsFcVggdWHACNsXJX0LY=;
 b=JOwn3prrjZsoFnZAkxuKYIXzatNpOaSkJ9qmPvX7tzvvDiX4rMiy9U2di/smf1Rzfn9m
 9w3bbe4unwKiKaxx1hWRbZHW87n1o6cCaRlzM+Lb6uIsMtPdGlF0LS+b6MKLN5TZUyGu
 iKkLAOlF9a9s6GYrCLtGyjmmiry9naTjFZzg0cTEMRmPQw70irREJBI7ac/vZ+o7En6b
 Bgf37czG/zzixJjQCMCGcBb1jLhyTRqyQz3jMgcJbLDqtvahHVP0YT5mj0a0mPaPJE6q
 SQILQJXmkJFy18MNr1mR05xuwjmq9H0eGQeFbNlTDRcAo99INS3Kyj3iaIaD5zJpydNG EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274ur2f3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 01:34:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1RXkQ164495;
        Tue, 14 Jul 2020 01:32:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 327q0n6kkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 01:32:26 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06E1WP6F010218;
        Tue, 14 Jul 2020 01:32:26 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:32:25 -0700
Subject: [PATCH 09/26] xfs: make XFS_DQUOT_CLUSTER_SIZE_FSB part of the ondisk
 format
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:32:25 -0700
Message-ID: <159469034551.2914673.4835752141162338250.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the dquot cluster size #define to xfs_format.h.  It is an important
part of the ondisk format because the ondisk dquot record size is not an
even power of two, which means that the buffer size we use is
significant here because the kernel leaves slack space at the end of the
buffer to avoid having to deal with a dquot record crossing a block
boundary.

This is also an excuse to fix one of the longstanding discrepancies
between kernel and userspace libxfs headers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h |   16 ++++++++++++++++
 fs/xfs/xfs_qm.h            |   11 -----------
 2 files changed, 16 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 79fbabeb476c..76d34b77031a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1209,6 +1209,22 @@ typedef struct xfs_dqblk {
 
 #define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
 
+/*
+ * This defines the unit of allocation of dquots.
+ *
+ * Currently, it is just one file system block, and a 4K blk contains 30
+ * (136 * 30 = 4080) dquots. It's probably not worth trying to make
+ * this more dynamic.
+ *
+ * However, if this number is changed, we have to make sure that we don't
+ * implicitly assume that we do allocations in chunks of a single filesystem
+ * block in the dquot/xqm code.
+ *
+ * This is part of the ondisk format because the structure size is not a power
+ * of two, which leaves slack at the end of the disk block.
+ */
+#define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
+
 /*
  * Remote symlink format and access functions.
  */
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 27789272da95..c5d0716b378e 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -30,17 +30,6 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
 	!dqp->q_core.d_rtbcount && \
 	!dqp->q_core.d_icount)
 
-/*
- * This defines the unit of allocation of dquots.
- * Currently, it is just one file system block, and a 4K blk contains 30
- * (136 * 30 = 4080) dquots. It's probably not worth trying to make
- * this more dynamic.
- * XXXsup However, if this number is changed, we have to make sure that we don't
- * implicitly assume that we do allocations in chunks of a single filesystem
- * block in the dquot/xqm code.
- */
-#define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
-
 /* Defaults for each quota type: time limits, warn limits, usage limits */
 struct xfs_def_quota {
 	time64_t	btimelimit;	/* limit for blks timer */


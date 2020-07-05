Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 444FFC433DF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CACE2075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jBpXKqL1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgGEWNJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:13:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45072 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbgGEWNJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:13:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MBe8L001856
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DiFBhQpKoi8notTLIyBH7XpjeLDfi1Y8pa0OVoxQOt8=;
 b=jBpXKqL1XavL1k/jaT9sf63TSzXGJ50ywHGHix/xyXWvQnmrIsE0zTldc5XP/oS41PFB
 2l0RdRyc5J9mUBxjrAQFz6+GWpW0qX5rJkDzGP/xO4rDXRnaWn2mSruhPpZYrwbShqxf
 cO+gTCkqak5XhpGNgCiuMUah8Dig3knJLaF8bWVi+y6TIZpjDPzV0ZDT6qOew93nEk6g
 +/ZXiSjawkPMjrOmLdDdmBiSG1DitMHLtAt3xf4wGrNtPYAZ9w4IRgN/P8XVrH59mipb
 wfXGUqMyXtJofQwXXjhoezMcFcCTqLXpx/8jsF2TAGqj5UbaPgBer9KgR6o4UYVN1LH2 kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 322h6r3j31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:13:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065M86Cc055643
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:13:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3233pubjd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:13:08 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 065MD7lR026075
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:13:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:13:07 -0700
Subject: [PATCH 05/22] xfs: make XFS_DQUOT_CLUSTER_SIZE_FSB part of the ondisk
 format
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:13:06 -0700
Message-ID: <159398718628.425236.8654425233877130537.stgit@magnolia>
In-Reply-To: <159398715269.425236.15910213189856396341.stgit@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007050171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=1 adultscore=0 mlxscore=0 spamscore=0 impostorscore=0
 cotscore=-2147483648 malwarescore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
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
---
 fs/xfs/libxfs/xfs_format.h |   16 ++++++++++++++++
 fs/xfs/xfs_qm.h            |   11 -----------
 2 files changed, 16 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index fcd270194e47..d6615103db0c 100644
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
index 7b0e771fcbce..2c8ca9df23af 100644
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


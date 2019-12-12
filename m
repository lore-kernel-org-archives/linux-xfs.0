Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADB7C04E30
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E9D9206A5
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 04:17:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fI+8t+eK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbfLLERb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 23:17:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44518 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfLLERa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 23:17:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4EkHK129017
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=r7+4HOepn/mpkgk5xvo3jCoPScI35JfcKbuK/UD4RAA=;
 b=fI+8t+eKZtqQ3bKA9nyE7TAcxD3/vPbXTXBvVOF9lfLM2G43H0BviN/hCTXXyatyBst1
 /pmSOUx45bYUZpXI0p88WjhQT4DGn90A+ZsIusKydFch6G9qR5Zsl95V6c6J8dDf265v
 Uy1NvGPTl5fuPOoWoSK4zK7NOAEIn4C8bRj0kBWFnl2PxILFFxrDxWoASJR34Oqhp5IP
 9E6fYzgNy7SUipNSPsup5vUSJ53+lPtdoyW6/7mYMUvszFCiZlbd3W0lAHznveOTVTnP
 JfzR6pnI5eenq7AHvK4LegMBfH/rRiP8kUfZ6Z5k1s+7Qxow1teXEGyki/NnUCA3w8mF WQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wr4qrre3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:17:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4E36D127101
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wu2fveknn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:28 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBC4FRQh024936
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:15:28 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Dec 2019 20:15:27 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 05/14] xfs: Factor out new helper functions xfs_attr_rmtval_set
Date:   Wed, 11 Dec 2019 21:15:04 -0700
Message-Id: <20191212041513.13855-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212041513.13855-1-allison.henderson@oracle.com>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Break xfs_attr_rmtval_set into two helper functions
xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
xfs_attr_rmtval_set rolls the transaction between the
helpers, but delayed operations cannot.  We will use
the helpers later when constructing new delayed
attribute routines.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 71 +++++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_attr_remote.h |  3 +-
 2 files changed, 56 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 3e725c3..21f0001 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -22,6 +22,7 @@
 #include "xfs_attr_remote.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_attr_remote.h"
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
@@ -433,34 +434,20 @@ xfs_attr_rmtval_set(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
-	xfs_fileoff_t		lfileoff = 0;
-	uint8_t			*src = args->value;
 	int			blkcnt;
-	int			valuelen;
 	int			nmap;
 	int			error;
-	int			offset = 0;
 
 	trace_xfs_attr_rmtval_set(args);
 
-	/*
-	 * Find a "hole" in the attribute address space large enough for
-	 * us to drop the new attribute's value into. Because CRC enable
-	 * attributes have headers, we can't just do a straight byte to FSB
-	 * conversion and have to take the header space into account.
-	 */
-	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
-	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
-						   XFS_ATTR_FORK);
+	error = xfs_attr_rmt_find_hole(args);
 	if (error)
 		return error;
 
-	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
-	args->rmtblkcnt = blkcnt;
-
+	blkcnt = args->rmtblkcnt;
+	lblkno = (xfs_dablk_t)args->rmtblkno;
 	/*
 	 * Roll through the "value", allocating blocks on disk as required.
 	 */
@@ -501,6 +488,56 @@ xfs_attr_rmtval_set(
 			return error;
 	}
 
+	return xfs_attr_rmtval_set_value(args);
+}
+
+
+/*
+ * Find a "hole" in the attribute address space large enough for us to drop the
+ * new attribute's value into
+ */
+int
+xfs_attr_rmt_find_hole(
+	struct xfs_da_args	*args)
+{
+	struct xfs_inode        *dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	int			error;
+	int			blkcnt;
+	xfs_fileoff_t		lfileoff = 0;
+
+	/*
+	 * Because CRC enable attributes have headers, we can't just do a
+	 * straight byte to FSB conversion and have to take the header space
+	 * into account.
+	 */
+	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
+	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
+						   XFS_ATTR_FORK);
+	if (error)
+		return error;
+
+	args->rmtblkno = (xfs_dablk_t)lfileoff;
+	args->rmtblkcnt = blkcnt;
+
+	return 0;
+}
+
+int
+xfs_attr_rmtval_set_value(
+	struct xfs_da_args	*args)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	uint8_t			*src = args->value;
+	int			blkcnt;
+	int			valuelen;
+	int			nmap;
+	int			error;
+	int			offset = 0;
+
 	/*
 	 * Roll through the "value", copying the attribute value to the
 	 * already-allocated blocks.  Blocks are written synchronously
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9d20b66..cd7670d 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -11,5 +11,6 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
-
+int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
+int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4


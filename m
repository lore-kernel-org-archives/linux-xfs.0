Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4435FC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 711D12070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qOM8DkPD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389368AbfIEWTk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39622 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389781AbfIEWTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ8n4084607
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=YJHEq+T31polxip6SNnLHuc2Js08ENn9r8EHLCcZvF4=;
 b=qOM8DkPDhQL3iUb0zjASjsXZ9Bq3Df4zmWBWib7ydLrjlzJPPbPPmOajYt5D0iEdx3IG
 r3Kg8f2d9okCFYfKBrTixaMNab/tDoT3lYrI/LN1llkh2meF7Q9XA0XN+6C6nu3+UA0d
 LdTrwsxMK6dQb00CCjEr+d2Bhn9Nfzum7+TzVnmwaH7kneXNJqCz99gP7QNoMHk7M3Wg
 wxvgARzbzRoJF8KFOQpdn39JBfdCdwOuU5P0URF5plYyBt21jxrLju2dNKz6qGSPGeR0
 oZ9z6K3t4YUEEZdfq/+HezQMkJwNsysHxsI8CxtGFG8JP3MQIeRDPkLcsM8i9IB8v7sJ ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uuaqxr2g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIOri101633
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2uu1b9475n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:37 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x85MImsQ032485
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:48 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:18:47 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 13/19] xfs: Add delay context to xfs_da_args
Date:   Thu,  5 Sep 2019 15:18:31 -0700
Message-Id: <20190905221837.17388-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221837.17388-1-allison.henderson@oracle.com>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new struct xfs_delay_context, which we
will use to keep track of the current state of a delayed
attribute operation.

The flags member is used to track various operations that
are in progress so that we know not to repeat them, and
resume where we left off before EAGAIN was returned to
cycle out the transaction.  Other members take the place
of local variables that need to retain their values
across multiple function recalls.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h | 23 +++++++++++++++++++++++
 fs/xfs/scrub/common.c        |  2 ++
 fs/xfs/xfs_acl.c             |  2 ++
 fs/xfs/xfs_attr_list.c       |  1 +
 fs/xfs/xfs_ioctl.c           |  2 ++
 fs/xfs/xfs_ioctl32.c         |  2 ++
 fs/xfs/xfs_iops.c            |  2 ++
 fs/xfs/xfs_xattr.c           |  1 +
 8 files changed, 35 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index bed4f40..ebe1295 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -42,6 +42,28 @@ enum xfs_dacmp {
 	XFS_CMP_CASE		/* names are same but differ in case */
 };
 
+#define		XFS_DC_INIT		0x01 /* Init delay info */
+#define		XFS_DC_FOUND_LBLK	0x02 /* We found leaf blk for attr */
+#define		XFS_DC_FOUND_NBLK	0x04 /* We found node blk for attr */
+#define		XFS_DC_ALLOC_LEAF	0x08 /* We are allocating leaf blocks */
+#define		XFS_DC_ALLOC_NODE	0x10 /* We are allocating node blocks */
+#define		XFS_DC_RM_LEAF_BLKS	0x20 /* We are removing leaf blocks */
+#define		XFS_DC_RM_NODE_BLKS	0x40 /* We are removing node blocks */
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delay_context {
+	unsigned int		flags;
+	struct xfs_buf		*leaf_bp;
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	xfs_fileoff_t		lfileoff;
+	int			blkcnt;
+	struct xfs_da_state	*state;
+	struct xfs_da_state_blk *blk;
+};
+
 /*
  * Structure to ease passing around component names.
  */
@@ -69,6 +91,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	int		op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	struct xfs_delay_context  dc;	/* context used for delay attr ops */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1887605..9a649d1 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -24,6 +24,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index f8fb6e10..4e85b38 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -10,6 +10,8 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trace.h"
 #include <linux/posix_acl_xattr.h>
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 00758fd..467c53c 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -12,6 +12,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 626420d..2cabdc2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -15,6 +15,8 @@
 #include "xfs_iwalk.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 1e08bf7..7153780 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -17,6 +17,8 @@
 #include "xfs_itable.h"
 #include "xfs_fsops.h"
 #include "xfs_rtalloc.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_ioctl32.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 469e8e2..57de5f1 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -13,6 +13,8 @@
 #include "xfs_inode.h"
 #include "xfs_acl.h"
 #include "xfs_quota.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 6309da4..470e605 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -10,6 +10,7 @@
 #include "xfs_log_format.h"
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 
 #include <linux/posix_acl_xattr.h>
-- 
2.7.4


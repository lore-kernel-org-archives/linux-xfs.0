Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C70FC6197
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB159217D7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:28:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BFTCHQuh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfKGB24 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:28:56 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbfKGB24 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:28:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SsQo154880
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=20RZrFwnoI8xCsxWTmr4ji5+yDXqvQwsnQIbuiQu7m4=;
 b=BFTCHQuhG9NeLiNlLFb650LNPTPDVzK4B3GNk9YvM9Didw6427sYJonHon8vtVFySnNm
 8ZdeOG6r5h1FKAlTbVv24CyiYTFB3DUnh1wV3QDaPqalZaysMg1jVIz9vIX5YclxmISr
 88ZzajKv3tunamJkDKmyAh+VEieTeDJOYnmgYBZrFjRxXM0VX3Dqze9j1sZAPCmtpc+s
 OHGefqwurrZdNHiShw7ehReN/EDn+wIfqjwiQ56RW/Zbev1AAnBy4DAO1UssmpfUtHLD
 QlhuUqcRJHAtFANI9DTQXl8zCS6/5Wr4sUCkMgc6rHIyC96sx5XcdAJynTFhFGrMbI44 IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w41w0tq52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:28:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SqKX174279
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w41w8eun6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:28:52 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA71SmOh011258
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:48 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:28:48 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 14/17] xfs: Add delay context to xfs_da_args
Date:   Wed,  6 Nov 2019 18:27:58 -0700
Message-Id: <20191107012801.22863-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012801.22863-1-allison.henderson@oracle.com>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new struct xfs_delay_context, which we
will use to keep track of the current state of a delayed
attribute operation.

The new enum is used to track various operations that
are in progress so that we know not to repeat them, and
resume where we left off before EAGAIN was returned to
cycle out the transaction.  Other members take the place
of local variables that need to retain their values
across multiple function recalls.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h | 28 ++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c        |  2 ++
 fs/xfs/xfs_acl.c             |  2 ++
 fs/xfs/xfs_attr_list.c       |  1 +
 fs/xfs/xfs_ioctl.c           |  2 ++
 fs/xfs/xfs_ioctl32.c         |  2 ++
 fs/xfs/xfs_iops.c            |  2 ++
 fs/xfs/xfs_xattr.c           |  1 +
 8 files changed, 40 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index bed4f40..ef23ed8 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -42,6 +42,33 @@ enum xfs_dacmp {
 	XFS_CMP_CASE		/* names are same but differ in case */
 };
 
+enum xfs_attr_state {
+	XFS_DC_INIT		= 1, /* Init delay info */
+	XFS_DC_SF_TO_LEAF	= 2, /* Converted short form to leaf */
+	XFS_DC_FOUND_LBLK	= 3, /* We found leaf blk for attr */
+	XFS_DC_LEAF_TO_NODE	= 4, /* Converted leaf to node */
+	XFS_DC_FOUND_NBLK	= 5, /* We found node blk for attr */
+	XFS_DC_ALLOC_LEAF	= 6, /* We are allocating leaf blocks */
+	XFS_DC_ALLOC_NODE	= 7, /* We are allocating node blocks */
+	XFS_DC_RM_INVALIDATE	= 8, /* We are invalidating blocks */
+	XFS_DC_RM_SHRINK	= 9, /* We are shrinking the tree */
+	XFS_DC_RM_NODE_BLKS	= 10,/* We are removing node blocks */
+};
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delay_context {
+	enum xfs_attr_state	dc_state;
+	struct xfs_buf		*leaf_bp;
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	xfs_fileoff_t		lfileoff;
+	int			blkcnt;
+	struct xfs_da_state	*da_state;
+	struct xfs_da_state_blk *blk;
+};
+
 /*
  * Structure to ease passing around component names.
  */
@@ -69,6 +96,7 @@ typedef struct xfs_da_args {
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
index e868755..1336477 100644
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
index fab416c..e395864 100644
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
index ae0ed88..23b0ca6 100644
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
index 3c0d518..e3278ac 100644
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
index aef346e..68b9cd0 100644
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
index 6c5321d..0f0ebab 100644
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


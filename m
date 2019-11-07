Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C76F6FC619A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9893421D79
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O4oBiegK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbfKGB34 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:29:56 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732847AbfKGB3z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:29:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71TrrC155562
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=dQVmZsMV8CqWc0Tk9Sp2w6FGwXHM+WQbT+XQjj5WlrU=;
 b=O4oBiegKaF2WI0Gg1IYPVJSM6x96AmgeRJFG0DnJztiXJDmLrzalLmLXiKsbLcdSi71G
 ig87lD70OfQvjxmlVR10kBNrYht+gGMABfRp2Z8bcrsiXuc/bZNtlN1jNFrUCuXSLtri
 m3ugIdM6wyMVhkTVRH1SSCkXkW1OsCGy2Ua/D3oKPBhZGxwJngM2MbieAfXYkNei2Fgf
 5SsmnnSgzY+a3Pxm+sTQ1qljOt84aL6ckRv8Rmtx3x6nN4YCRSCHHOMWOL+ryChJi4a2
 5FFN6rV3Vi2dFkCsLFh0LEc69pgwP7ZTYyyhYHYYv06MmWR7+Dt6OlYYl1sEEU+UiD93 DQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w41w0tq95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SmQC126981
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w41wfvbtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:53 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA71Tqao009826
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:52 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:29:52 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 06/17] xfsprogs: Factor out new helper functions xfs_attr_rmtval_set
Date:   Wed,  6 Nov 2019 18:29:34 -0700
Message-Id: <20191107012945.22941-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012945.22941-1-allison.henderson@oracle.com>
References: <20191107012945.22941-1-allison.henderson@oracle.com>
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

Break xfs_attr_rmtval_set into two helper functions
xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
xfs_attr_rmtval_set rolls the transaction between the
helpers, but delayed operations cannot.  We will use
the helpers later when constructing new delayed
attribute routines.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr_remote.c | 71 ++++++++++++++++++++++++++++++++++++------------
 libxfs/xfs_attr_remote.h |  3 +-
 2 files changed, 56 insertions(+), 18 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index f67509b..633b392 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -19,6 +19,7 @@
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
+#include "xfs_attr_remote.h"
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
@@ -428,34 +429,20 @@ xfs_attr_rmtval_set(
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
@@ -496,6 +483,56 @@ xfs_attr_rmtval_set(
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
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 9d20b66..cd7670d 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
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


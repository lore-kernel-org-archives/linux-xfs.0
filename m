Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7157BC00307
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7D902082C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i8ZtDHnn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391136AbfIEWTP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59016 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391160AbfIEWTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ9oB049740
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=zDJ9eqJmpNU90HxSgfop5tGQ19kg1RmStjk+NNOzy+s=;
 b=i8ZtDHnn2Go6dP/5HAkSgA8bZnLMfZTTXE4YXVxWCTnNwZ7GkSjXAoUbOml2BJVMzo6G
 8qefUjif1IJF6IjOQRPDK/oieBm3+W6VwAmrU/gFBr+ctxZa2fvdi+tlw2fsannl7t2S
 cokz0ABEaGyHIIsbHAeRz2QNuzQsVq1gfC2jT5nzDaD4UwRFYyOYrOOURcuRz/TbGQek
 i8+n+n2Q60RP1wStgmhPNYMhAMsk6rwud5qaNEWA6L+rydi2pupm4oN+EdGFTXBtbe2V
 V/C3Uz9bJsgZq/agk47s9rEqKM3DBeG9L36ABsQ0wOoqQipbNFWnfj4+uU0GYBat9kWb sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uuarc820n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ3xw076476
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2utvr4a0y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:04 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MJ1I5001687
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:01 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:01 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 05/21] xfsprogs: Factor out new helper functions xfs_attr_rmtval_set
Date:   Thu,  5 Sep 2019 15:18:39 -0700
Message-Id: <20190905221855.17555-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221855.17555-1-allison.henderson@oracle.com>
References: <20190905221855.17555-1-allison.henderson@oracle.com>
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

Break xfs_attr_rmtval_set into two helper functions
xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
xfs_attr_rmtval_set rolls the transaction between the
helpers, but delayed operations cannot.  We will use
the helpers later when constructing new delayed
attribute routines.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr_remote.c | 72 ++++++++++++++++++++++++++++++++++++------------
 libxfs/xfs_attr_remote.h |  3 +-
 2 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index f67509b..eccf548 100644
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
@@ -496,6 +483,57 @@ xfs_attr_rmtval_set(
 			return error;
 	}
 
+	error = xfs_attr_rmtval_set_value(args);
+	return error;
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
+	xfs_fileoff_t		lfileoff = args->rmtblkno;
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


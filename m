Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA66C433E8
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C282087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Elk9ov9C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgH0A3P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:29:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54102 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgH0A3P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:29:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0E0wx045250
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=kNp8Gm9A4HzP4lVYd6QQfLUB+O8Xi52GRMSYZW8BRK4=;
 b=Elk9ov9CvmgelXjQ8XYT32p8k9QsnMu80q6311xc9a+5OZ66/ClXtZno/HswQfWwp4SJ
 i9OCSjYQOFwrbYHcUXCry0/2Sj05Elkt5ugZSWxhfVc7BzDUPr7+n7pZbMNceNycfp8V
 PJtzQTLicrFjMjIVFGoX22rrjFRKN+apDKbEU2mI1tODauT+xElL0sShGNsw2fsReOUT
 yy3Z/1DOIXi/SbbshKf6xZELgb1hgHlcG2ra0oUPQhrS/l0SHR5diMyUjvWNw1iV7ThS
 r8g/UhfppgfFV+g7ISCFZc0wlWLxBOLtwo4kcKJE1L7H9zurYAQDFjWHtbhc/wPJHvTk Ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 333dbs3dx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0AqW9025878
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 333r9mswtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:13 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07R0TCns024799
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:12 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:12 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 10/32] xfsprogs: Refactor xfs_attr_rmtval_remove
Date:   Wed, 26 Aug 2020 17:28:34 -0700
Message-Id: <20200827002856.1131-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Refactor xfs_attr_rmtval_remove to add helper function
__xfs_attr_rmtval_remove. We will use this later when we introduce
delayed attributes.  This function will eventually replace
xfs_attr_rmtval_remove

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr_remote.c | 46 ++++++++++++++++++++++++++++++++++++----------
 libxfs/xfs_attr_remote.h |  1 +
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index e09c1b6..52e5574 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -680,7 +680,7 @@ xfs_attr_rmtval_remove(
 	xfs_dablk_t		lblkno;
 	int			blkcnt;
 	int			error = 0;
-	int			done = 0;
+	int			retval = 0;
 
 	trace_xfs_attr_rmtval_remove(args);
 
@@ -692,14 +692,10 @@ xfs_attr_rmtval_remove(
 	 */
 	lblkno = args->rmtblkno;
 	blkcnt = args->rmtblkcnt;
-	while (!done) {
-		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
-				    XFS_BMAPI_ATTRFORK, 1, &done);
-		if (error)
-			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
+	do {
+		retval = __xfs_attr_rmtval_remove(args);
+		if (retval && retval != EAGAIN)
+			return retval;
 
 		/*
 		 * Close out trans and start the next one in the chain.
@@ -707,6 +703,36 @@ xfs_attr_rmtval_remove(
 		error = xfs_trans_roll_inode(&args->trans, args->dp);
 		if (error)
 			return error;
-	}
+	} while (retval == -EAGAIN);
+
 	return 0;
 }
+
+/*
+ * Remove the value associated with an attribute by deleting the out-of-line
+ * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
+ * transaction and re-call the function
+ */
+int
+__xfs_attr_rmtval_remove(
+	struct xfs_da_args	*args)
+{
+	int			error, done;
+
+	/*
+	 * Unmap value blocks for this attr.
+	 */
+	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
+			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
+	if (error)
+		return error;
+
+	error = xfs_defer_finish(&args->trans);
+	if (error)
+		return error;
+
+	if (!done)
+		return -EAGAIN;
+
+	return error;
+}
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 3616e88..9eee615 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
+int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4


Return-Path: <SRS0=IYU2=A5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFA2C433E8
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D1E72083E
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oDXEFuMv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgGREd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:33:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59294 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgGREd5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:33:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4TmaP056264
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=10cqHnyVqcQiQeKSEiiwLkTOXF9GykZ6/d7eVvFjBbk=;
 b=oDXEFuMvKapiPRVz63d9F+r3s00NoaOfprSpbK7S/tH5Y5mLUZ27SPcJ0ZWMGcRdxH30
 u4cCxXg+/Ss+zJWTFkiHV8SNiByyhfTLQiFhZdzYM9bYr09btbs1xVKAS9Oah7VjRZq7
 Iw3mAqNoQVW7OmRpdTroRbChQNjT24UrAw7mrb0MkOx9sP8pmJPGkYPd1FjFAjxezT09
 ASZaGTDYlmy9mBPXqxeeb+JaxJB5NF2pi/CSzZsgwHVzx5lMefd5mXZNVDixtX8xbaxl
 uSzQ6vGoWzoPS2N9GHDLfZ9l1Oq6oc1uzkqb1/07PmuODOj3kuZycKdA3/lwbK1SO8Cd IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32brgr05dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XlAq169323
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32brw1w7ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06I4XsdM003383
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:54 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:53 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 11/26] xfsprogs: Refactor xfs_attr_rmtval_remove
Date:   Fri, 17 Jul 2020 21:33:27 -0700
Message-Id: <20200718043342.6432-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718043342.6432-1-allison.henderson@oracle.com>
References: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
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
index eff5f95..ee3337b 100644
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


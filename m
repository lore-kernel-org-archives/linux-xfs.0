Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15875C2BA1A
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF31D2080C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XRkROx9c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgDCWKR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:10:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgDCWKQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M9wLA093185
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=QMpsyriJn6fIbDAOw+qIvsfOXoLOnzTP/iJO+ABARuw=;
 b=XRkROx9cSxOQFu2nZpJWOdHFHdRpzosW88Tx1bV7ZQo8zQxa7NPIvGomwtPwMmQApt8Y
 CTkPmDBO4joa1V82rHE7pWxf1LZKPCiVKRv285lV7aCZOdxuHUclIXy5KsJKBDOrK/5/
 fuqCtpjirFWa+BfOl5hrFqxR9TUlk3lrhPPFB+r6iW1KGp53fclOGyi9H0sy6WPttwRH
 Xov4qz/sAU9oDdcuQjBMpPQJEiZF7a8pYDsJU3Amyh9PeEk+uC21sSKO3oSouBcb6L06
 PaBcLcydPGBFrq3kmdaRVPnZYLXfQHJk7de42zNJoKgtYT0lK1noa3T6SpW+BDisx3m+ pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 303yunp0g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7JNw167755
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 304sju4cej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:15 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MAEDa009983
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:14 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:13 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 29/39] xfsprogs: Add helper function __xfs_attr_rmtval_remove
Date:   Fri,  3 Apr 2020 15:09:48 -0700
Message-Id: <20200403220958.4944-30-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 mlxlogscore=864 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=920 bulkscore=0
 suspectscore=1 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function is similar to xfs_attr_rmtval_remove, but adapted to
return EAGAIN for new transactions. We will use this later when we
introduce delayed attributes.  This function will eventually replace
xfs_attr_rmtval_remove

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr_remote.c | 25 +++++++++++++++++++++++++
 libxfs/xfs_attr_remote.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index e09c1b6..a9cd28d 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -710,3 +710,28 @@ xfs_attr_rmtval_remove(
 	}
 	return 0;
 }
+
+/*
+ * Remove the value associated with an attribute by deleting the out-of-line
+ * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
+ * transaction and recall the function
+ */
+int
+__xfs_attr_rmtval_remove(
+	struct xfs_da_args	*args)
+{
+	int	error, done;
+
+	/*
+	 * Unmap value blocks for this attr.
+	 */
+	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
+			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
+	if (error)
+		return error;
+
+	if (!done)
+		return -EAGAIN;
+
+	return 0;
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


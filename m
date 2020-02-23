Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41B0C35673
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D09220702
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gKkNfz+D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgBWCGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46018 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgBWCGG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N230pV180425
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=IhR3sA0OKGtR0SMyeH+Wru/7f24hNoPURSQf6of/kPg=;
 b=gKkNfz+D7zll4jr7+DN3yhHSxfTrpZVcsjrutcvmD5y4UQqAOISlx6156YP5mu9kQN8L
 xC0rDkAD/r2cRq51+0ziPwpzhOeK9KF0G/Vg0E9wFMgJgG9po+Woja6YU9EQoFRwyp+g
 1usWD3dHfu4O0xZMSEYCpcibu92Pv9sKnpW+Z1EnWmh31bbPAj5MDMr+mro1BSk+94WU
 iHZHhmBqPQRE7NevSrRpBWzuP2tS1PxcZ4JnDAkmGxFu/5iU9BZNV5tsE2LynnHF7tlk
 U1haM1Itho0cPgZLrEmqrgm1iOXw9yh0W2HSjOF7jyr2Xj5kL9Maz19Awdf7XczBO+cE 6w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yavxr9yym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1w54C146404
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ybdsd6q34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01N263Xm013077
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:03 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:03 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 13/20] xfsprogs: Add helper function xfs_attr_rmtval_unmap
Date:   Sat, 22 Feb 2020 19:05:47 -0700
Message-Id: <20200223020554.1731-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020554.1731-1-allison.henderson@oracle.com>
References: <20200223020554.1731-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=1 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function is similar to xfs_attr_rmtval_remove, but adapted to return EAGAIN for
new transactions. We will use this later when we introduce delayed attributes

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr_remote.c | 28 ++++++++++++++++++++++++++++
 libxfs/xfs_attr_remote.h |  1 +
 2 files changed, 29 insertions(+)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index cfeca71..5b92f2d 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -681,3 +681,31 @@ xfs_attr_rmtval_remove(
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
+xfs_attr_rmtval_unmap(
+	struct xfs_da_args	*args)
+{
+	int	error, done;
+
+	/*
+	 * Unmap value blocks for this attr.  This is similar to
+	 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
+	 * for new transactions
+	 */
+	error = xfs_bunmapi(args->trans, args->dp,
+		    args->rmtblkno, args->rmtblkcnt,
+		    XFS_BMAPI_ATTRFORK, 1, &done);
+	if (error)
+		return error;
+
+	if (!done)
+		return -EAGAIN;
+
+	return 0;
+}
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 85f2593..7ab3770 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -12,4 +12,5 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
+int xfs_attr_rmtval_unmap(struct xfs_da_args *args);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4


Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E33DC2BA1E
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AAF32078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wmW/MmHI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgDCWMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:12:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40594 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728570AbgDCWMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:12:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M8x5N019130
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=6Rlbh7Ej2NQqJWNsrjSZvIWFpwBKWsyo9FveCH1KwhQ=;
 b=wmW/MmHI43425tvvbdM0A4IQ3EMUK7lqSy5/c4zYtdE8iFJ37ru0Fdf0KajHnXb5gj8J
 22RChtplCKOBYDTEo7rDpbnqcecaajTfn607UypDE2LW+/EP0ehZ8Y95iiowQvkFUX8y
 lUIPbj8VETO/MAoQIEHKtHK29rXIRIMtlw1s7AJ0+cUP7qGDtwvi7+zQLS2Aror+cH6B
 geVoaHyR4+uGLkxllDWHL0DGd+59M1Xau2i/oEiWa2x2v55yz4UIHCRn5cPcap4jVIN0
 Lt8dLMjYQCajnqPCJ31h+W7cJjkdOGo9yGAspRw4NxIwJQKnR+sY8YU5adsLGdYepkuk 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 303aqj3wc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7Ksh167828
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 304sju4hrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MCf9m010816
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:41 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:12:40 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 10/20] xfs: Add helper function __xfs_attr_rmtval_remove
Date:   Fri,  3 Apr 2020 15:12:19 -0700
Message-Id: <20200403221229.4995-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403221229.4995-1-allison.henderson@oracle.com>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 mlxlogscore=864 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=920 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=1
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
 fs/xfs/libxfs/xfs_attr_remote.c | 25 +++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_remote.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 4d51969..fd4be9d 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -711,3 +711,28 @@ xfs_attr_rmtval_remove(
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
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index eff5f95..ee3337b 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
+int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4


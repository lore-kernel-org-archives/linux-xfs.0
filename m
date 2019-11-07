Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4958FC6199
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A409B217F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V+N4Dgh3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732910AbfKGBb6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:31:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40246 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732913AbfKGBb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:31:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71Ssje180113
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=TmjDWG4eK+/YjHbJVGr4EgUZ7c3jhcIpRPxQx3ag13o=;
 b=V+N4Dgh3DqLvHzFUd3Vg2/ET0qekAPyxyjnTDvQVlXmwfKB1o6Rxl67XEyL5r5j73WN4
 RbZV5Mk8TMCQK6sKsntJKc3+D8lb3TaAZXpY3FBqNjG7fDEbPDcv5haOnIdzZeCEdFC5
 MT3cUUOwZba9atl9QF68SVodvwK09n/uBwnphAkGiMIfe+tVAnF5Z63FXfcw7rPxl/Z7
 ei/CoTCIM8/EjgtEHwgPreWV4wR8nBjDAGyCesit/vzd/IKefOZi4vkq3hJr38L9qEYt
 MTiyFZpiPgu4UBcnkUyOuNVCHCp85BHHfd6v/vwZv0YaXn6kzcKdc1h4C0PAg+Woz4c6 Kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w12q47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:31:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SxPn008321
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w41wdmupn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:54 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA71TsDH009870
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:54 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:29:54 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 12/17] xfsprogs: Factor out xfs_attr_rmtval_invalidate
Date:   Wed,  6 Nov 2019 18:29:40 -0700
Message-Id: <20191107012945.22941-13-allison.henderson@oracle.com>
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

Because new delayed attribute routines cannot roll
transactions, we carve off the parts of
xfs_attr_rmtval_remove that we can use.  This will help to
reduce repetitive code later when we introduce delayed
attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr_remote.c | 30 +++++++++++++++++++++---------
 libxfs/xfs_attr_remote.h |  1 +
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 633b392..f27b5ea 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -584,21 +584,14 @@ xfs_attr_rmtval_set_value(
 	return 0;
 }
 
-/*
- * Remove the value associated with an attribute by deleting the
- * out-of-line buffer that it is stored on.
- */
 int
-xfs_attr_rmtval_remove(
+xfs_attr_rmtval_invalidate(
 	struct xfs_da_args	*args)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
 	int			blkcnt;
 	int			error;
-	int			done;
-
-	trace_xfs_attr_rmtval_remove(args);
 
 	/*
 	 * Roll through the "value", invalidating the attribute value's blocks.
@@ -640,13 +633,32 @@ xfs_attr_rmtval_remove(
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
 	}
+	return 0;
+}
 
+/*
+ * Remove the value associated with an attribute by deleting the
+ * out-of-line buffer that it is stored on.
+ */
+int
+xfs_attr_rmtval_remove(
+	struct xfs_da_args      *args)
+{
+	xfs_dablk_t		lblkno;
+	int			blkcnt;
+	int			error = 0;
+	int			done = 0;
+
+	trace_xfs_attr_rmtval_remove(args);
+
+	error = xfs_attr_rmtval_invalidate(args);
+	if (error)
+		return error;
 	/*
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
 	lblkno = args->rmtblkno;
 	blkcnt = args->rmtblkcnt;
-	done = 0;
 	while (!done) {
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK, 1, &done);
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index cd7670d..b6fd35a 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -11,6 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4


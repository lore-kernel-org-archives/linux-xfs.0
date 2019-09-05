Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAE2C00306
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2207420828
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eLn5rBCR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389801AbfIEWTm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59732 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389589AbfIEWTl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ8m1049698
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=UPaYKuBrxVWm36UQia6ZHKWYKb4Lm8NGT2/K5cIytjE=;
 b=eLn5rBCR0JgXST9SE/1z0hwoB2Lp+7eQMYoNV7Fkqewx22dH7oObWzN5VwLgvg0ublTD
 +nCzu+PeZ0m2svjoasCpjr9DybDlxPZPYXe1iBNphZpTNumue++7jeoyZ52iN9TQ2ijk
 GVBV3KJ3EvYtfdCYVWlFZjsmOa04LxUKty9RLWBeMm4HgiAU+wHBMTLnBgCAS4Gop7I+
 cWfM843ybkLvSrKIO93YieizYK71QQ3anrY/a/jEn8uezBkkhCz1fsYwYyj5w9Klv4ei
 Ms10XtnS7eyRCI/jcpJucwRf7txES4xV+o9iuu42wgUF0tUkhVdUSran8c+otgwXtsWP KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uuarc8237-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ5lV076712
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2utvr4a1dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:38 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x85MIiLD011543
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:45 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:18:44 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 03/19] xfs: Add xfs_dabuf defines
Date:   Thu,  5 Sep 2019 15:18:21 -0700
Message-Id: <20190905221837.17388-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221837.17388-1-allison.henderson@oracle.com>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=942
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

This patch adds two new defines XFS_DABUF_MAP_NOMAPPING and
XFS_DABUF_MAP_HOLE_OK.  This helps to clean up hard numbers and
makes the code easier to read

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.h | 3 +++
 fs/xfs/libxfs/xfs_da_btree.c  | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 7b74e18..536a290 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -16,6 +16,9 @@ struct xfs_da_state_blk;
 struct xfs_inode;
 struct xfs_trans;
 
+#define XFS_DABUF_MAP_NOMAPPING	(-1) /* Caller doesn't have a mapping. */
+#define XFS_DABUF_MAP_HOLE_OK	(-2) /* don't complain if we land in a hole. */
+
 /*
  * Used to keep a list of "remote value" extents when unlinking an inode.
  */
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 129ec09..2b94685 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2534,7 +2534,8 @@ xfs_dabuf_map(
 	 * Caller doesn't have a mapping.  -2 means don't complain
 	 * if we land in a hole.
 	 */
-	if (mappedbno == -1 || mappedbno == -2) {
+	if (mappedbno == XFS_DABUF_MAP_NOMAPPING ||
+	    mappedbno == XFS_DABUF_MAP_HOLE_OK) {
 		/*
 		 * Optimize the one-block case.
 		 */
-- 
2.7.4


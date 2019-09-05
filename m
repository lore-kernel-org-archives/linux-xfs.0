Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDFFEC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A56F2070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K9MvH1JO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387436AbfIEWVn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:21:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731541AbfIEWVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:21:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ89h084633
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:21:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=ybaR7O04sdUp707V9Ry344ybR5dP8nhnT08Dqe+1B6Y=;
 b=K9MvH1JO1/t7XtM0/sDCNRH8G1zGFusj1iwxQuRY9b2dQgsFSMIEoqGTKVP3h9Nr5ZGX
 +FYIT5zjyeaslUqW/ONLnTbtugTuRk/7N7B3jSrMccGHk4+Be+ZTUBjaFdDBmic70N4O
 45pgR80WyY4CyPp73gWUf3gOQMy4H47B+PabTQr0LbrE7C9JKAUUdef+T2kXJV9wWBvg
 7wL26Ww0Czv6uyE/n8shX3ybDAqDGNzJHkQBS1fKqsl8jK7qugd23V89C90zuzwXdFoP
 R001zkew+5xqb4pzi9raANXSWOo856PbZ1yf2FrjwvAtVl2peUKwlGK58v45Xa0m5Mb5 nQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uuaqxr2q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:21:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ2Ro076436
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2utvr4a1dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MJ1kk001680
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:01 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:01 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 03/21] xfsprogs: Add xfs_dabuf defines
Date:   Thu,  5 Sep 2019 15:18:37 -0700
Message-Id: <20190905221855.17555-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221855.17555-1-allison.henderson@oracle.com>
References: <20190905221855.17555-1-allison.henderson@oracle.com>
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
 libxfs/xfs_attr_leaf.h | 3 +++
 libxfs/xfs_da_btree.c  | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 7b74e18..536a290 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -16,6 +16,9 @@ struct xfs_da_state_blk;
 struct xfs_inode;
 struct xfs_trans;
 
+#define XFS_DABUF_MAP_NOMAPPING	(-1) /* Caller doesn't have a mapping. */
+#define XFS_DABUF_MAP_HOLE_OK	(-2) /* don't complain if we land in a hole. */
+
 /*
  * Used to keep a list of "remote value" extents when unlinking an inode.
  */
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index f8e0432..0a7c601 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2531,7 +2531,8 @@ xfs_dabuf_map(
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


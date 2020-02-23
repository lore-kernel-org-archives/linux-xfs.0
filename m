Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01DFC11D20
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5BA120707
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZnD40IOF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgBWCGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45652 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgBWCGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N21nKc189646
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=QG84cIFRd8U2eOU0XRBKRpJtTzoSx/CSs1E7wvXJG2s=;
 b=ZnD40IOFpEHkrHAG8aFmcLQlNWT6SPWCE7egeUNwF7UJ1Wu3FbCfbTOq1WzHf/TjePjl
 hcT2dfQ0Q5mhBQOvtd0pfeAPdjpdHl7VKRtR0F9DzHFnSMs/KE2jeYo6oeJoRoijB/bE
 ZV+2hTYeHyMI5BcCTORKZ7lLvYD26R37ggQeRs82ciYwVfwofIIJzUvTa2quH6emgUpw
 7xeqCFO2VZikbN+vSKcdbu4oYxErlUcdjdOWUANtlR6sgzlKt6E1fLp/tRVSDMmDL07E
 xlRgx7O6wKEwrJvR2Lzk076+Q2bMA08bSUSdch0HOEbHWbGlAC9qyL/pxenFKjh24g+0 yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yauqu21x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1wJmi054360
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ybe38md5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01N2644f013083
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:04 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:04 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 18/20] xfsprogs: Add helper function xfs_attr_leaf_mark_incomplete
Date:   Sat, 22 Feb 2020 19:05:52 -0700
Message-Id: <20200223020554.1731-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020554.1731-1-allison.henderson@oracle.com>
References: <20200223020554.1731-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch helps to simplify xfs_attr_node_removename by modularizing the code
around the transactions into helper functions.  This will make the function easier
to follow when we introduce delayed attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 0635d8b..1e6aba6 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1414,6 +1414,36 @@ xfs_attr_node_shrink(
 }
 
 /*
+ * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
+ * for later deletion of the entry.
+ */
+STATIC int
+xfs_attr_leaf_mark_incomplete(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	int error;
+
+	/*
+	 * Fill in disk block numbers in the state structure
+	 * so that we can get the buffers back after we commit
+	 * several transactions in the following calls.
+	 */
+	error = xfs_attr_fillstate(state);
+	if (error)
+		return error;
+
+	/*
+	 * Mark the attribute as INCOMPLETE
+	 */
+	error = xfs_attr3_leaf_setflag(args);
+	if (error)
+		return error;
+
+	return 0;
+}
+
+/*
  * Remove a name from a B-tree attribute list.
  *
  * This will involve walking down the Btree, and may involve joining
@@ -1471,20 +1501,7 @@ xfs_attr_node_removename(
 	args->dac.da_state = state;
 
 	if (args->rmtblkno > 0) {
-		/*
-		 * Fill in disk block numbers in the state structure
-		 * so that we can get the buffers back after we commit
-		 * several transactions in the following calls.
-		 */
-		error = xfs_attr_fillstate(state);
-		if (error)
-			goto out;
-
-		/*
-		 * Mark the attribute as INCOMPLETE, then bunmapi() the
-		 * remote value.
-		 */
-		error = xfs_attr3_leaf_setflag(args);
+		error = xfs_attr_leaf_mark_incomplete(args, state);
 		if (error)
 			goto out;
 
-- 
2.7.4


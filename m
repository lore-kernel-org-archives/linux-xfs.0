Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5D6C55178
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD9402223F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ahWiS0EV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372843AbgJWGfU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:35:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45154 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372848AbgJWGfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 02:35:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6OKOd025425
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=pyB9iK+MRlpaMj2mfDK3+42kjtMHTbOUh58jymyV/EY=;
 b=ahWiS0EVXnysC9l4RQX+zUJZoM+iAAxp4NsFXkChpK2s5f2h66m7WxWBD8GQOBQ3MLE4
 r7DrTa52P5zjD/yDscFJLZpxf9D3lchlI5X4mmpVujLjib0RidHqxeiAql57cKw6X/me
 lM62xAv/L+gjIaxVdklJ8uowXkbnJ5sb6vrqcg/H/CVd5GvEOcUCClZnRUhby6vmx1K+
 Ok8xcL740pp/ea2cy1YC4A5j5eYofYcKiQWdzFQwahGr1ZqSWIDYmiQBAhsjunMWu6R9
 y269RJ4W4VR4kWaroCDtRwGlp8tnvfcj81TDlHK4OxWGfkaQyml87WjNxN2lNQC3MF5j kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34ak16snps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:35:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6P6RB178387
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 348aj0n970-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:18 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09N6XHV6008350
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:17 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 23:33:17 -0700
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 03/14] xfsprogs: Add helper xfs_attr_node_remove_step
Date:   Thu, 22 Oct 2020 23:32:55 -0700
Message-Id: <20201023063306.7441-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023063306.7441-1-allison.henderson@oracle.com>
References: <20201023063306.7441-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230045
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

Source kernel commit: 5e2aff99f8f0b7ff511b7bbd1213743f59806878

This patch adds a new helper function xfs_attr_node_remove_step.  This
will help simplify and modularize the calling function
xfs_attr_node_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1c1092f..1bf71dc 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1220,19 +1220,14 @@ xfs_attr_node_remove_rmt(
  * the root node (a special case of an intermediate node).
  */
 STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+xfs_attr_node_remove_step(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
 {
-	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
-	trace_xfs_attr_node_removename(args);
-
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1242,7 +1237,7 @@ xfs_attr_node_removename(
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_node_remove_rmt(args, state);
 		if (error)
-			goto out;
+			return error;
 	}
 
 	/*
@@ -1259,18 +1254,45 @@ xfs_attr_node_removename(
 	if (retval && (state->path.active > 1)) {
 		error = xfs_da3_join(state);
 		if (error)
-			goto out;
+			return error;
 		error = xfs_defer_finish(&args->trans);
 		if (error)
-			goto out;
+			return error;
 		/*
 		 * Commit the Btree join operation and start a new trans.
 		 */
 		error = xfs_trans_roll_inode(&args->trans, dp);
 		if (error)
-			goto out;
+			return error;
 	}
 
+	return error;
+}
+
+/*
+ * Remove a name from a B-tree attribute list.
+ *
+ * This routine will find the blocks of the name to remove, remove them and
+ * shirnk the tree if needed.
+ */
+STATIC int
+xfs_attr_node_removename(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state;
+	int			error;
+	struct xfs_inode	*dp = args->dp;
+
+	trace_xfs_attr_node_removename(args);
+
+	error = xfs_attr_node_removename_setup(args, &state);
+	if (error)
+		goto out;
+
+	error = xfs_attr_node_remove_step(args, state);
+	if (error)
+		goto out;
+
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
-- 
2.7.4


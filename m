Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2586EC2BA19
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB892078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ndjFDkTq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgDCWKT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:10:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54222 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728456AbgDCWKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033MACJ6093412
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=DjIwqtkQW7Y5bwaT/46wMGz5Ns3szy1K0MYSt6b2BtU=;
 b=ndjFDkTquTTOyzEPyXXW0aNNo4ousZ4nYS47Iccch+lXj/9r8dCOmXvxanYfZri8o1/O
 /9dUs4zW+90q+mrETczVTMLT9xkuQTL3MaRHMOiSYsl/N6jzONDhXyIDgxi06IUrryKj
 FtYtPz4HXHYRnxTiM2gO/9LvKKwKGPvMTx1m/Ccb5QfebwW4PukgLj0B6bqHcBbP0oIt
 tgUavU5c7Q28HpuCgV6gpGKjr8pCiGypoNMsmVJmO8ko+x6jDb1VrirnKRGZXUe/ob8A
 Wfsa86NXIdRH94ikKfRP7SbDfFKdJk94fi3rOdsXFLP22oSkOFMa6OSUjf3a2FEIdXoE wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 303yunp0g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M8Wxb101918
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 302g4y9gf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:16 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MAGVo005682
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:16 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:16 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 36/39] xfsprogs: Add helper function xfs_attr_node_removename_rmt
Date:   Fri,  3 Apr 2020 15:09:55 -0700
Message-Id: <20200403220958.4944-37-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=1
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=934 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=1 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds another new helper function
xfs_attr_node_removename_rmt. This will also help modularize
xfs_attr_node_removename when we add delay ready attributes later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index c844f8f..fa706f5 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1222,6 +1222,28 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
+STATIC int
+xfs_attr_node_removename_rmt (
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	int			error = 0;
+
+	error = xfs_attr_rmtval_remove(args);
+	if (error)
+		return error;
+
+	/*
+	 * Refill the state structure with buffers, the prior calls
+	 * released our buffers.
+	 */
+	error = xfs_attr_refillstate(state);
+	if (error)
+		return error;
+
+	return 0;
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1250,15 +1272,7 @@ xfs_attr_node_removename(
 	 * overflow the maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			goto out;
-
-		/*
-		 * Refill the state structure with buffers, the prior calls
-		 * released our buffers.
-		 */
-		error = xfs_attr_refillstate(state);
+		error = xfs_attr_node_removename_rmt(args, state);
 		if (error)
 			goto out;
 	}
-- 
2.7.4


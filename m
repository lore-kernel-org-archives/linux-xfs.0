Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1030AC47257
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEFA3208CA
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g05FjxeY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgD3WrU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43758 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727886AbgD3WrR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhR0p128734
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=EZwhkpVmazikyNZSz9aV1YCtwVzcHJiLbTUVvvag4sE=;
 b=g05FjxeYKHTzZfLM/6RCX1qUgxfzQvbt99HP3G8PE7kZ35ZsMprhTDmFNEwKdsIG3iz4
 xKEDbMLJN1yEN2JlmLf5pHSHC/MPGRaV60U/l9NzjB0sAZppmB/kBfRyexvpI/0IuYDj
 39ehEPi7vPEtGFlO5YToIb/tEzf7EeyDOVUDoB0Iu883Mq9Bkn9FaQR0IO7N5vjF2/AH
 zyXZfbokft9XCL1TNacmnQLNLQs6eOAm7kA01WeYe9gICoxIAVKnkZoiQy53miMQp+Ct
 B6/Cn3yih46ZYvwwmF3W0yPN1crCMGnqRnHaIdowjUfMHHF+2l7a6N9NpUATvifzWMbu DQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30r7f3g23e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgEYl141518
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30qtg23dxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:15 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UMlEb6011781
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:14 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:14 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 37/43] xfsprogs: Add helper function xfs_attr_node_removename_rmt
Date:   Thu, 30 Apr 2020 15:46:54 -0700
Message-Id: <20200430224700.4183-38-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=997 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds another new helper function
xfs_attr_node_removename_rmt. This will also help modularize
xfs_attr_node_removename when we add delay ready attributes later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 7ca925a..27b818d8 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1217,6 +1217,24 @@ int xfs_attr_node_removename_setup(
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
+	 * Refill the state structure with buffers, the prior calls released our
+	 * buffers.
+	 */
+	return xfs_attr_refillstate(state);
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1245,15 +1263,7 @@ xfs_attr_node_removename(
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


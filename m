Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0756C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC86C20768
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:30:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q/r3N8FY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgFYXax (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:30:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54316 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgFYXav (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:30:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNQl0O037988
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=c5JshRRztJ9eTssPu/t/3fqF9t/8shlQxG96Hd+cuuI=;
 b=Q/r3N8FYtPRe8AIpoSpUBw6G5vpR5QdbtPcpdPq0JmmvuS+C1+sm8KyafL9A1EtgR31y
 JdrwpFnLvT7zne7yMlkKnP5FqyBlU8+fJwhjj8E9ecjKvk0OdmGSZUZnKn7DRhq48MkX
 Ym0GrGjNXP6TiroaNX0EomO5qZXOHETOOR+NGVw4PWKvgciXNDqVEGR2hC7eYyhRBex7
 6qJtHSenxnRM+whs5AdWnxLQ6xWW/WyqOgq73ohf2PdEXWUk1MpxK0Z3vxrJ45dkI2R8
 oHXmfdZoKVHy74Z+1/Tb9ZD0nEwX1QUjtHBaTGI/IkaX9vhgIVNFsnaipwqGeIuvhuVi 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31uut5u9xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNS2Pl141146
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31uur1wcv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:49 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PNUmi4008520
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:48 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:30:47 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 19/25] xfs: Add helper function xfs_attr_node_removename_rmt
Date:   Thu, 25 Jun 2020 16:30:12 -0700
Message-Id: <20200625233018.14585-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625233018.14585-1-allison.henderson@oracle.com>
References: <20200625233018.14585-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=1 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=1
 phishscore=0 impostorscore=0 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250136
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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f84c163..f993af5 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1205,6 +1205,24 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
+STATIC int
+xfs_attr_node_remove_rmt(
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
@@ -1233,15 +1251,7 @@ xfs_attr_node_removename(
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
+		error = xfs_attr_node_remove_rmt(args, state);
 		if (error)
 			goto out;
 	}
-- 
2.7.4


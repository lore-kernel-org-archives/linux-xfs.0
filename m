Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B434C4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28358207DD
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:50:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="neu9US+N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgD3Wuf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:50:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45932 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgD3Wuf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:50:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMn1gh133090
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=PPgHwhEdcnjd1v+fHBVcj+3DkHO2/Hub2RRnDI9RwaQ=;
 b=neu9US+N2hjlLR5SRcIHnHwEZkUaXT8NRDHhsPsJheQBsIk84C4JEBXoUooBqpRV9u3m
 tr8wS6hZui7JxOhT32R9ApI0aKjku94ad//Bo50Qiej1S7KKQvXOyTThHebMmIwRIvJH
 eFh6HhsCOgYQa/4xeHX4YbIVcAf0YKlOZGMCSfsrpgnHXbkiC8ZyAZH8g5ZRdSrzI+pm
 /8yQqfXGNN+tv4KjyHMcKH5kkEFbYYhp++UtxmFcK1vyqtEXpKj50i57hyWL/KTmDhXK
 3A79YzKKD6qi5cw0EarVadD1SwECybjG3POGGxeOs0usR/aNis7/7/MDtL2I0gKuJwuT FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30r7f3g2fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgGW3141591
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30qtg23n0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:33 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMoWXt010287
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:32 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:50:32 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 04/24] xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
Date:   Thu, 30 Apr 2020 15:49:56 -0700
Message-Id: <20200430225016.4287-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430225016.4287-1-allison.henderson@oracle.com>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
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

Since delayed operations cannot roll transactions, pull up the
transaction handling into the calling function

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 14 ++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c |  7 +------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5467af6..dcbc475 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -622,6 +622,13 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return error;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			return error;
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
@@ -968,6 +975,13 @@ xfs_attr_node_addname(
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			goto out;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			goto out;
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 9f39e7a..ab87bae 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2953,10 +2953,5 @@ xfs_attr3_leaf_flipflags(
 			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-
-	return error;
+	return 0;
 }
-- 
2.7.4


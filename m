Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1B7C433EB
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECDB522BF3
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:18:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NaREcSgO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgGUASV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:18:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39612 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgGUASV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:18:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L02ccd102328
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:18:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=qjUIVUlY2mlCt0Y9p78bgesjqAlAhADUnZla+cTGT5k=;
 b=NaREcSgOwQqHlMY7PiBY/KOTQnm/4vUDERTK1j3ZSF4xnMG2vGcR4pwqtlMBjUZSUzE7
 TnULZlilUNlzXGoJA6Un2VBnSYELqyRmz/YXb6y+HI5+VncveP9Tuyv4MluYmur6C2tx
 rNNKHijkOeZMV5NkkH7KEb1N9GMrF4O/nVaAFY8G2AKfdcB+6a+mN6RepIe22AXiz1hz
 XDcks9V7i17WCvcA+CaleELokv4B308mTbUtioQDO1PsQLP3C0Bu1rjqcUp7NFXXvdKJ
 0/HFupn4yEZEEKYl4w0e2jZ+JCY548F++4pT9oP7aKCMzfLYhroX7loOjSerpnXdOCsC bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32brgr9yvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:18:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L04NsS097343
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32dnfngf0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:19 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L0GIbS014544
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:18 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 17:16:18 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 22/25] xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname
Date:   Mon, 20 Jul 2020 17:16:03 -0700
Message-Id: <20200721001606.10781-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721001606.10781-1-allison.henderson@oracle.com>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lift -ENOSPC handler from xfs_attr_leaf_addname.  This will help to
reorganize transitions between the attr forms later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e618b09..4b78c86 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -299,6 +299,13 @@ xfs_attr_set_args(
 			return error;
 
 		/*
+		 * Promote the attribute list to the Btree format.
+		 */
+		error = xfs_attr3_leaf_to_node(args);
+		if (error)
+			return error;
+
+		/*
 		 * Finish any deferred work items and roll the transaction once
 		 * more.  The goal here is to call node_addname with the inode
 		 * and transaction in the same state (inode locked and joined,
@@ -603,7 +610,7 @@ xfs_attr_leaf_try_add(
 	struct xfs_da_args	*args,
 	struct xfs_buf		*bp)
 {
-	int			retval, error;
+	int			retval;
 
 	/*
 	 * Look up the given attribute in the leaf block.  Figure out if
@@ -635,20 +642,10 @@ xfs_attr_leaf_try_add(
 	}
 
 	/*
-	 * Add the attribute to the leaf block, transitioning to a Btree
-	 * if required.
+	 * Add the attribute to the leaf block
 	 */
-	retval = xfs_attr3_leaf_add(bp, args);
-	if (retval == -ENOSPC) {
-		/*
-		 * Promote the attribute list to the Btree format. Unless an
-		 * error occurs, retain the -ENOSPC retval
-		 */
-		error = xfs_attr3_leaf_to_node(args);
-		if (error)
-			return error;
-	}
-	return retval;
+	return xfs_attr3_leaf_add(bp, args);
+
 out_brelse:
 	xfs_trans_brelse(args->trans, bp);
 	return retval;
-- 
2.7.4


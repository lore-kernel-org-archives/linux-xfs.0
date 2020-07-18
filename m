Return-Path: <SRS0=IYU2=A5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B9CC433F2
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7379B20809
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:34:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B6XPzwYQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgGREd7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:33:59 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59562 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgGREd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:33:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4WG5W051725
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=hp/QhrrGwwUdNPPt3cdqQJlJivrzjE4EzgbHussUlKw=;
 b=B6XPzwYQIsE3kf9xIHJFj6m1LSnXd6ZzVJukpTeE4FjUMNXiNI0IVB0gzrkzBNgcihgM
 mSVJHrz0rmfNeaC27gVYUlF/9C3MdYKv0ZtDPq0LaOlnPDEHg2DfOszpmz88FMpwpJGL
 t3YyZy36PIEAB9LHR1OM73+oiMeG3JL1B+DPA0TkmwylJFVt5US/nwM3EA7VeF03q2/n
 AHM/Ulker1Bdfyv3a/X0IdOyfl6hi7NBONbXOpcvtnyrgeQ9tj03ZHoRoZZt8GIYtYwE
 29XeimgZT4sWZ5C5xyqsKVVtohj39xSHsnTXrX6wF4iugnWGEn3Ce0fcB5vgS6l3gNwd vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 32bpkarbjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XnKW058336
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32br1n3nh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:57 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06I4XvPJ019784
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:57 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:57 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 23/26] xfsprogs: Lift -ENOSPC handler from xfs_attr_leaf_addname
Date:   Fri, 17 Jul 2020 21:33:39 -0700
Message-Id: <20200718043342.6432-24-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718043342.6432-1-allison.henderson@oracle.com>
References: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 suspectscore=1 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007180030
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
 libxfs/xfs_attr.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6ff064d..6827440 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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


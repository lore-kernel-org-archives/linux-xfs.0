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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AAEC433E1
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8207320809
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L44iWiWM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgGREdz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:33:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42836 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgGREdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:33:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XB44004094
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=H9nh7YBcFYTybQ92q2peSWm5UbHjZTBbKKxHUvISfFs=;
 b=L44iWiWMurPbNGf2m7WWbNom7USDTpmVL696wiyphOWRBx/ja1V/Kzm+NMTbZa0Ujw+c
 Vl8Duglc6rOY1O1X0nMDcSuScU0iOpf0rHJKl2uG6k0gylljInKL7JccSok+mHfo5ECa
 tqhK3VhCRiotu5la+En/RRN85x+yH25ZapftJvnchNpcK3pAmKp541+yW7owbTvWpq0t
 sogNEsDnJTaH66nus0lY3uoboTI+x1r07vTFE7sywiq5YqKgb9mQM9MPAfkwPF16ZJ57
 qLf8XyOk1PcL2GQvFpRYuvcNS4dl1LaISJ97srg9BAWqSgcPDeZwwLE/YDADXCxAoUai pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32bs1m03r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4Wofv177087
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32bqan5g56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:53 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06I4Xqtt019765
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:52 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:52 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 05/26] xfsprogs: Pull up trans handling in xfs_attr3_leaf_flipflags
Date:   Fri, 17 Jul 2020 21:33:21 -0700
Message-Id: <20200718043342.6432-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718043342.6432-1-allison.henderson@oracle.com>
References: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=1
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
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
 libxfs/xfs_attr.c      | 14 ++++++++++++++
 libxfs/xfs_attr_leaf.c |  7 +------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 88ddfb5..313aa5f 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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
@@ -968,6 +975,13 @@ restart:
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
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 553b3c0..9ea85d1 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2950,10 +2950,5 @@ xfs_attr3_leaf_flipflags(
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


Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32170C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 084ED20718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WAt5g8s2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgAABOw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:14:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABOw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:14:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011ESv0112743
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=HATCefDHLMKYYzD8r2JmOqSksH2Jk0zeVhXNUTAhmIY=;
 b=WAt5g8s238VAI3J9YNCBo/r1daypkEPDDyonLq+Y4ioZ+4MfpZdzalTP2aUj2K+VKX57
 dYdYypBNw7LRZajSopNa+S5Ja/Ym2JtZwEgL1Xu+ep1an5UBjsp+4v/yEoCPSFbeZO4A
 Ow/MytsWGVKXNbD/Iih01VKqqLRL0Ti2F6qTg6mU4SMhUwRlZb2slsGIhkAeMrMOAVrb
 6bpHbbumM9PYaM89cYC+YbZpeUWVnzz9OAvEKoTm5SBQf2/XwIVwWX7FfRPZN2NqSgg7
 t0gx/gVhMySnHxY9XKvHHJe3J8rhHDiI21nwYNNXyO8mO0F1NxRwKRR3Tn4//v+7U0nv Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011912O012768
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x8guef4df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:50 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011EnOh000984
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:49 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:14:48 -0800
Subject: [PATCH 21/21] xfs: get rid of cross_rename
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:14:46 -0800
Message-ID: <157784128641.1365473.131694919545176820.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=841
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=894 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Get rid of the largely pointless xfs_cross_rename now that we've
refactored its parent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   41 +++++------------------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 59d9fae1e48c..1e70cf4a75de 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2268,36 +2268,6 @@ xfs_finish_rename(
 	return xfs_trans_commit(tp);
 }
 
-/*
- * xfs_cross_rename()
- *
- * responsible for handling RENAME_EXCHANGE flag in renameat2() sytemcall
- */
-STATIC int
-xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
-{
-	int			error;
-
-	error = xfs_dir_exchange(tp, dp1, name1, ip1, dp2, name2, ip2,
-			spaceres);
-	if (error)
-		goto out_trans_abort;
-
-	return xfs_finish_rename(tp);
-
-out_trans_abort:
-	xfs_trans_cancel(tp);
-	return error;
-}
-
 /*
  * xfs_rename_alloc_whiteout()
  *
@@ -2436,12 +2406,11 @@ xfs_rename(
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
-					target_dp, target_name, target_ip,
-					spaceres);
-
-	error = xfs_dir_rename(tp, src_dp, src_name, src_ip, target_dp,
-			target_name, target_ip, spaceres, wip);
+		error = xfs_dir_exchange(tp, src_dp, src_name, src_ip,
+				target_dp, target_name, target_ip, spaceres);
+	else
+		error = xfs_dir_rename(tp, src_dp, src_name, src_ip, target_dp,
+				target_name, target_ip, spaceres, wip);
 	if (error)
 		goto out_trans_cancel;
 


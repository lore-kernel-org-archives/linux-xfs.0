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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792EBC433EB
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5075E22B4E
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h9fdE8qm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgGUAQV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:16:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43178 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgGUAQS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:16:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L02TAK132550
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=EgTPTTYj2muH8HO/jtlIhMvX0tpCAT7fWjzTVKGQ7aQ=;
 b=h9fdE8qmlrV1oKJwEUfq5rxy2LtQfHTCbc+L/QIy3kAKL2rHSevDBbtV30FG36Ljzp7D
 MGqFcxthaaUzdE4KJtnaH+HxjckNyqYMTOIo6LryjqrbuNMcu7iMnG41Aw56nqFYddcm
 3uX4L6Q0QOmBGNAaGjFczWQSW5Rk+UpkVj3zx3iAVc6r3IHqAe21dxmivabKkaCKEVFZ
 IZNbNAGKd1ViNkkSE6d2ZwkO+BnP7BJAMI94EjtX5nK5JAQ6HTl8AQ2Tr9H0ljWalCdA
 6X0UyVSFHKzRMBiEOeuAC5I07squVe7LkoJu+i0SovE9sN+vt3MSBJ6VO+ILFvISkPnR BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 32bpkb25sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0E3KN008924
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32dnafgn5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06L0GGcw001235
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:16 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 17:16:16 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 14/25] xfs: Remove xfs_trans_roll in xfs_attr_node_removename
Date:   Mon, 20 Jul 2020 17:15:55 -0700
Message-Id: <20200721001606.10781-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721001606.10781-1-allison.henderson@oracle.com>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A transaction roll is not necessary immediately after setting the
INCOMPLETE flag when removing a node xattr entry with remote value
blocks. The remote block invalidation that immediately follows setting
the flag is an in-core only change. The next step after that is to start
unmapping the remote blocks from the attr fork, but the xattr remove
transaction reservation includes reservation for full tree splits of the
dabtree and bmap tree. The remote block unmap code will roll the
transaction as extents are unmapped and freed.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1a78023..f1becca 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1148,10 +1148,6 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			goto out;
-
 		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			return error;
-- 
2.7.4


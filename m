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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DBCC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF72A22B4E
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U988AnF2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGUAQQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:16:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgGUAQQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:16:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L03ucH102908
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Io3WZbPOfZOCDWGnSvd7/mtOHFFKyPz8eTw/UZxg9Pc=;
 b=U988AnF2621ZBZS4k2GLh5Vunw/Zf2N8Df3rbJJvmENi1qoyuESuY2fwAIbrcCjrt1zu
 2RvcaDJLQZWPPN1p8Uyn0ctF1MJTTNhYry6T/cUZb0FmdftZwHq5tAVPJv4V75uz3xXu
 kRZLz7Njsi2tI+u2O5n9AQ+lZsTAyXL33zb7F5Fs3qjV0HnvoHjHc5e/AVNASwTe6Mpc
 BFZtKlJ1E3RsfGHD8VVFeQqH0HAuTsHDiJX3xSNnjwCbh7qfdDbjrJ+2HO9tgraDDPQB
 y9NaTlHq8uvdH/xN2nCA6bCLuyYlRFkon1q2dUEwpU0uh0LnUnvxRXR7IWL42aVX3sYp iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32brgr9ym6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0DJqI176929
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32dnmq82th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:14 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L0GDN2014517
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:13 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 17:16:13 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 02/25] xfs: Check for -ENOATTR or -EEXIST
Date:   Mon, 20 Jul 2020 17:15:43 -0700
Message-Id: <20200721001606.10781-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721001606.10781-1-allison.henderson@oracle.com>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=1 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200146
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

Delayed operations cannot return error codes.  So we must check for
these conditions first before starting set or remove operations

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index cecc794..ff28d6e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -404,6 +404,15 @@ xfs_attr_set(
 				args->total, 0, quota_flags);
 		if (error)
 			goto out_trans_cancel;
+
+		error = xfs_has_attr(args);
+		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
+			goto out_trans_cancel;
+		if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
+			goto out_trans_cancel;
+		if (error != -ENOATTR && error != -EEXIST)
+			goto out_trans_cancel;
+
 		error = xfs_attr_set_args(args);
 		if (error)
 			goto out_trans_cancel;
@@ -411,6 +420,10 @@ xfs_attr_set(
 		if (!args->trans)
 			goto out_unlock;
 	} else {
+		error = xfs_has_attr(args);
+		if (error != -EEXIST)
+			goto out_trans_cancel;
+
 		error = xfs_attr_remove_args(args);
 		if (error)
 			goto out_trans_cancel;
-- 
2.7.4


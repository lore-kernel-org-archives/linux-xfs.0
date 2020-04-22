Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F4BC54FD0
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F1DC206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:06:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VOh1paje"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDVCGN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:06:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43552 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVCGN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:06:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M24OvE167642
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wpdVerkyR3phR9lRpMX/8lMojQc3Iap2LcNNRLhrPVc=;
 b=VOh1pajeU3xvgOzOSL74Zsf0QFnMCpC+rv+YEk/PNKDUxkJnZGpyH828MqBkGwPpCRb8
 IzhfRslvsZVwVxw9k1eutUXRyfFKNg43uFBj7NIJJZUGW6MT6Rk34qVopX3AYo4NDBZu
 9aRaB0SE1NWeLkN4u6YacehAZHEE9wWpLp2DhDY/0wV+0Q04garYdFtYeeYdxiSQ1vAz
 zRYypyok+qDou6QKhvqLuIWY9hlEXKJesGQHfLJ80/lVVKrPQGw/mNztyQG6UCDK9aNf
 V/deFSTk6PjO/K9576UMp0tEO5SZ5Wiukrb6Cv+iwDDr5WOiZP73TgnQr48xm+Hn43sj XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30grpgmhj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M21a13064811
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30gb3t4m4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:11 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03M26A7T014658
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:06:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:06:10 -0700
Subject: [PATCH 01/19] xfs: complain when we don't recognize the log item
 type
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:06:09 -0700
Message-ID: <158752116938.2140829.6588657626837150802.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=1 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're sorting recovered log items ahead of recovering them and
encounter a log item of unknown type, actually print the type code when
we're rejecting the whole transaction to aid in debugging.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 11c3502b07b1..5f803083ddc3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1887,8 +1887,8 @@ xlog_recover_reorder_trans(
 			break;
 		default:
 			xfs_warn(log->l_mp,
-				"%s: unrecognized type of log operation",
-				__func__);
+				"%s: unrecognized type of log operation (%d)",
+				__func__, ITEM_TYPE(item));
 			ASSERT(0);
 			/*
 			 * return the remaining items back to the transaction


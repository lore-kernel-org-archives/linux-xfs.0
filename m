Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6557C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C774206EF
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hn02iMjp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgBWCGE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56178 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbgBWCGE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N21gdZ008714
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=24y04A8xDIj2KxruRIH9zBKTJYk/j8Zq5KvPvWJShm4=;
 b=hn02iMjpVXomfqTpK3vtQxH9IAwE9nuBxn4tt6Q/iqX87XRzLa0WjobfzDnFKG3M3/f1
 1cVOn/KliBft5yl7aPqyITEOk1zphmKiBS8eI0Jrv/sqBRpaOV/YdcdRUCOCJ5g+mn4U
 2og+UtINeU/OyfSkujUKZDO3PyFzldl/DAa6oPMbYuvKfzyA2gFykO/XwzuxKVzFOIda
 XRbFTy0JOfhFAWnNq+VlaZT1K7USuKNI9uRwbM4EQzPWhySyTTBpEWjW/6CITAL2OgLq
 3X8xTWrUyLWer+M/4fkzelc32ExoxRQsyg0wriv2fMVFHzgk6A8hLa965ez63GQzY/Cn HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yav8qa0sb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1x9wV081964
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ybe0wr0r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01N261Jq028809
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:01 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:01 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 05/20] xfsprogs: Check for -ENOATTR or -EEXIST
Date:   Sat, 22 Feb 2020 19:05:39 -0700
Message-Id: <20200223020554.1731-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020554.1731-1-allison.henderson@oracle.com>
References: <20200223020554.1731-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=1 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 impostorscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Delayed operations cannot return error codes.  So we must check for these conditions
first before starting set or remove operations

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9d4c79a..73d656c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -436,6 +436,14 @@ xfs_attr_set(
 		goto out_trans_cancel;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
+
+	error = xfs_has_attr(&args);
+	if (error == -EEXIST && (name->type & ATTR_CREATE))
+		goto out_trans_cancel;
+
+	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
+		goto out_trans_cancel;
+
 	error = xfs_attr_set_args(&args);
 	if (error)
 		goto out_trans_cancel;
@@ -524,6 +532,10 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
+	error = xfs_has_attr(&args);
+	if (error != -EEXIST)
+		goto out;
+
 	error = xfs_attr_remove_args(&args);
 	if (error)
 		goto out;
-- 
2.7.4


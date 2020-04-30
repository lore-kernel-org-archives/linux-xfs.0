Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2C7C47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B89020870
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZBPfHbWI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgD3WtN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:49:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45158 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgD3WtN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:49:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMmv1d132932
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:49:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=E4MR8444MNhJhCP+hStkePxG6PwV0jbGqR9vInD+OSw=;
 b=ZBPfHbWI6sI1ul20Kyc/FxPKT8/k+rDLJwJRYgmIk2VQujZP9rtNNBAM203fwC0Hl7le
 Q67c2YFnADgKupi9/oxqwtdS5RlXTUw/L3B60ULXFdlJV3Ke4uxaErPq23VzpJJLNXB7
 RSSgHiS3OgHPkXuOAvHw/EZssPMS8BiKw3nQE/NGDDKdRFvxs5KuT4KiX0eK/V6XVQdu
 aYglMrFRXUPzUii0KgP8hleQKc3UWczyWIrj0ETdAClPkQDuGKDE0i4yQKqeozADbV9f
 Ip4m4i4lAQ7FL4qxPGWUSSThEKrngv2i4Ml2j2x2C2LYykwTVBB+RFWirqt8dm27YehQ aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30r7f3g2b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:49:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhP44181147
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30r7fes2d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:11 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UMlAqS012887
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:10 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:10 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 21/43] xfsprogs: Check for -ENOATTR or -EEXIST
Date:   Thu, 30 Apr 2020 15:46:38 -0700
Message-Id: <20200430224700.4183-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=1 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
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

Delayed operations cannot return error codes.  So we must check for
these conditions first before starting set or remove operations

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 7ab623d..d993203 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -405,6 +405,15 @@ xfs_attr_set(
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
@@ -412,6 +421,10 @@ xfs_attr_set(
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


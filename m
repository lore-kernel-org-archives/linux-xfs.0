Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A0BC2BA1B
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C7E22078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vGLO/V5c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgDCWKO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:10:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54156 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbgDCWKO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033MACDE093419
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=00/vlmuEFEKSmGGeRyvkg8Jkm/RxARXUnWcazcwxKyw=;
 b=vGLO/V5cqQjdRofpvlRq255xnwXHKIaIBHtrO/JT74vLFcyJwJK9VLnD5RcRBk5dRqrj
 W9mOYqsNRnpcDMuDIWMy31U7kUAE0WKlEfl+xG1RLVT+6TIo42xClVrc+wX7LVnEidTZ
 51q4Tu4k/sMM02m1SZk4NnBGeQ3Be8ncBtzEKAvw6svRCFBWtR81KHN33o+alctV6UKF
 CNR5isJikwjdogtQhYHtVNpQZgEqxecanZsEBRRBrasP56FtKHqkl2ze7hz02nT5DbZh
 WdWEOb5bBDsUJeeYX8kN9h+X6ZfU7KLXYA+r3GmYYBy3Yjfd5Xmpmt5lcceNwByVRaK/ Aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 303yunp0fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M8OQL062412
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302ga6120u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:12 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MABeJ009871
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:11 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:11 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 21/39] xfsprogs: Check for -ENOATTR or -EEXIST
Date:   Fri,  3 Apr 2020 15:09:40 -0700
Message-Id: <20200403220958.4944-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=1 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Delayed operations cannot return error codes.  So we must check for
these conditions first before starting set or remove operations

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 728e7e8..ea662d6 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -405,6 +405,17 @@ xfs_attr_set(
 				args->total, 0, quota_flags);
 		if (error)
 			goto out_trans_cancel;
+
+		error = xfs_has_attr(args);
+		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
+			goto out_trans_cancel;
+
+		if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
+			goto out_trans_cancel;
+
+		if (error != -ENOATTR && error != -EEXIST)
+			goto out_trans_cancel;
+
 		error = xfs_attr_set_args(args);
 		if (error)
 			goto out_trans_cancel;
@@ -412,6 +423,10 @@ xfs_attr_set(
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


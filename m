Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E3CC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32F2E20768
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jZoqjnuU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgFYX3l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:29:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49470 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731557AbgFYX3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:29:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNRwnU151793
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=a50LgytzE6F0Z65RaW5xCoG5SU+SjAnxVuimxE8OK1E=;
 b=jZoqjnuUsxVSV8Nm0CCQ6RoBzFhqfPslrSosXwe/zZHno7YIcuRycnJdix7kvSbf4rQ2
 uaEp3p2BuAPWV6zbA0Vg+hkix5HUFqvkLkpreF2OHr67jP9wbQAZ3Y+gVlJ77hYGvqW2
 prFHnYcXb6FwNqJq8dgfYW54vCJ6VAeXHIq5p7QdB+aSjvi017lW6VTSf9DjwXpFgjRW
 6EDCy6nD7UEiG/jASt9rfw/kPOvoCEUyOeKqMl8hBTLTitTn+ZiDbkM2xmS+OwTP3OCQ
 N3FjFLQSph5uDUkmHLATvguRSBJnqrO7dL3YG5aAV/ypkQsovreomiW9iSQROKquKxNG hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31uusu3a9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIVS117230
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31uuram0sb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:00 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05PNSxqL016767
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:28:59 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:28:58 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 03/26] xfsprogs: Check for -ENOATTR or -EEXIST
Date:   Thu, 25 Jun 2020 16:28:25 -0700
Message-Id: <20200625232848.14465-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625232848.14465-1-allison.henderson@oracle.com>
References: <20200625232848.14465-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
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
index 7275b64..88ddfb5 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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


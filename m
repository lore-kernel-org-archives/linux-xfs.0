Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5121C47254
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A26D220774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Va10btPC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgD3WtK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:49:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgD3WtJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:49:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMlXLc066919
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=BOD0LOZtG4VezGq74iXQ8aUjJTE1jyIhn68/qZLSKzo=;
 b=Va10btPCOoysUo1vDr8KeZA1wOtLqJoCpI6WiKI6m5aWnEKQkSsE5FPcst2wUIVIlb6b
 b1vw4Nncd+NBcPTm2+3ds2hrSfOpfw5GoVYkmMn7hpHYjIF+kJQt7xxzHMqq2LS/2grd
 yJzkTDKM5H3gahjtP3ZXteWChACmMZeIR8K0qLQCYdVuSkRHzjH9BCwKZoACkxDNy/Lm
 ETuRGjxCztJAteUJ92JKXVNXIfP0xZY8C/PZAQuxsPwNUrs4XR6WFH+pQagkqJnCoHpJ
 vwUE03s4S4CcwLJqfRezbWVGsTnJyphkGjU0YFDkoFh4GF4FP1VJ4BkxBPF4q+GDsBYK Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30r7f802e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:49:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgSXM015967
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30r7f298e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:07 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMl6Rp012277
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:06 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:06 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 04/43] xfsprogs: remove the MAXNAMELEN check from xfs_attr_args_init
Date:   Thu, 30 Apr 2020 15:46:21 -0700
Message-Id: <20200430224700.4183-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All the callers already check the length when allocating the
in-kernel xattrs buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b7c46c0..00cd7c2 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -72,9 +72,6 @@ xfs_attr_args_init(
 	args->flags = flags;
 	args->name = name;
 	args->namelen = namelen;
-	if (args->namelen >= MAXNAMELEN)
-		return -EFAULT;		/* match IRIX behaviour */
-
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	return 0;
 }
-- 
2.7.4


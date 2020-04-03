Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C949C2BA17
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01FF92082F
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CZq6H5qz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgDCWKI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:10:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54046 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgDCWKI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033MA0PN093196
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=BOD0LOZtG4VezGq74iXQ8aUjJTE1jyIhn68/qZLSKzo=;
 b=CZq6H5qzjx7KQGkRxEZdc8tiKcoQwNm1tq9NNbfbI0r6rrjpQSkIMR0C2hjd+f3gBRiW
 47O33garSbD3ijmuKGZtKIzBkJFclyahw/vFmawWQJk8cUw+VN5gx7lppP4K14WLCgvS
 29pdpMq9ptswboqz3rEmSXeU0W9APVuG2BH8cWQHCFhbDmqCZ86oKZtyc0LSi/95gnQv
 TON3+WYZ2LcVKRJleMRPYy79PXCuys7ZFnzTRvihn9XyD2T+czW82fCYjakiHS9CSjDL
 BGBbywOzkARFyR4SckmtaeynJPaLgWoyTAXn8SyrABD4U4j8BhwflZou2rDRRJgcnShV JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 303yunp0fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M8Wih101939
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 302g4y9g15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:06 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033MA5qm028163
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:05 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:05 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 04/39] xfsprogs: remove the MAXNAMELEN check from xfs_attr_args_init
Date:   Fri,  3 Apr 2020 15:09:23 -0700
Message-Id: <20200403220958.4944-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=1
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
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


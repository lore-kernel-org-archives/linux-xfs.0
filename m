Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9E0C433DF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8A992075B
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 22:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CoXZtH2Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgGEWOx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 18:14:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57310 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgGEWOx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 18:14:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MD2EK080767
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:14:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=78GK4zTtFFSQNiEjZSuV5CegbVO/y9d5ImXa9tEobcI=;
 b=CoXZtH2Z+mv/pCj0zGcfwTtBrqvtLs87uB46wUcM4r5NDYnzOcXGBrlHuJBESIPU1wJS
 fJW5i90q9YYDYe1QwFlAlUA7/Q//MF0kvVV3sgs4WYBCpJTvxApJ+ilPJm89xkrbV1If
 1V3h765tPU4zkQvlU/B78leVGePEP+vRRiDawF7Pe0wsBQTGLI8uxLU3DEgybLbvEtjF
 aPwy8y37cJ+pfjcDLrSvJN1XQgxPcQrUsfoVYm3GA0eaLhRGFxfPtMLHsN1UpLBFH6RI
 bpoQ3tcGDV3DVPd0oZgkXWv8Xni4bHq75kaqbvFqkmxovxUvB+DnnXyAfqWTfUQIoX6E Yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 322kv63b10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:14:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 065MD5pI159021
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:14:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3233bkj1ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 05 Jul 2020 22:14:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 065MEor0003609
        for <linux-xfs@vger.kernel.org>; Sun, 5 Jul 2020 22:14:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 05 Jul 2020 15:14:50 -0700
Subject: [PATCH 21/22] xfs: actually bump warning counts when we send warnings
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 05 Jul 2020 15:14:49 -0700
Message-ID: <159398728931.425236.1765099671637463521.stgit@magnolia>
In-Reply-To: <159398715269.425236.15910213189856396341.stgit@magnolia>
References: <159398715269.425236.15910213189856396341.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007050172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007050172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Currently, xfs quotas have the ability to send netlink warnings when a
user exceeds the limits.  They also have all the support code necessary
to convert softlimit warnings into failures if the number of warnings
exceeds a limit set by the administrator.  Unfortunately, we never
actually increase the warning counter, so this never actually happens.
Make it so we actually do something useful with the warning counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trans_dquot.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 4439fe04f928..1c3385f7f273 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -589,6 +589,7 @@ xfs_dqresv_check(
 			return QUOTA_NL_ISOFTLONGWARN;
 		}
 
+		res->warnings++;
 		return QUOTA_NL_ISOFTWARN;
 	}
 


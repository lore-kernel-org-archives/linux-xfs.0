Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5611CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8674C20B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OnLwJY6z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732564AbfJVStd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:49:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52208 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732322AbfJVStd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:49:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiQNN091102;
        Tue, 22 Oct 2019 18:49:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=SIF9MsbjVW8lLlBSg4WEZhsgNjZ5x9biUumq/sBBr38=;
 b=OnLwJY6zgERCBUaoC78dCJNPZ/jXNcXUrdzYi/nd0enxfuMrCtoGDCEVczjl4CXY3gZl
 GIAIRiNgQQ/UIo/ZsNKi1dxzp7N/mhf/7FW8+cAar3Lc8FqBKEDIf07zuH44I+N2BuPF
 Jr9DxiQkbfUay5Kd4KARFSe8l3Q/zIIAeEeP7DU2wlJHAYaNIsZcNumdMckMYQYEJ4hB
 7sLQ69GH+49FqZtOX9LVdg+Y6ojkTGMiUsLWEqh9vdwmmINsxQL7Uoj9kWSJHz3Rj2EI
 dFvtE7Pwh/FGZVMzBqd/p+UBRAuQMtHwJkmoZ5vedMZSWPQWgm1c+r0bmu+wCFHW1Qco XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vqteprrc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhNYH125176;
        Tue, 22 Oct 2019 18:49:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vsx239snu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:29 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MInT01030685;
        Tue, 22 Oct 2019 18:49:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:49:29 -0700
Subject: [PATCH 6/7] xfs_scrub: refactor xfs_scrub_excessive_errors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:49:28 -0700
Message-ID: <157177016827.1460394.10119847764483927499.stgit@magnolia>
In-Reply-To: <157177012894.1460394.4672572733673534420.stgit@magnolia>
References: <157177012894.1460394.4672572733673534420.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor this helper to avoid cycling the scrub context lock when the
user hasn't configured a maximum error count threshold.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index b1c6abd1..261c6bb2 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -33,13 +33,20 @@ bool
 xfs_scrub_excessive_errors(
 	struct scrub_ctx	*ctx)
 {
-	bool			ret;
+	unsigned long long	errors_seen;
+
+	/*
+	 * We only set max_errors at the start of the program, so it's safe to
+	 * access it locklessly.
+	 */
+	if (ctx->max_errors <= 0)
+		return false;
 
 	pthread_mutex_lock(&ctx->lock);
-	ret = ctx->max_errors > 0 && ctx->corruptions_found >= ctx->max_errors;
+	errors_seen = ctx->corruptions_found;
 	pthread_mutex_unlock(&ctx->lock);
 
-	return ret;
+	return errors_seen >= ctx->max_errors;
 }
 
 static struct {


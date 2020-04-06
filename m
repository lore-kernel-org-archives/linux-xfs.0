Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FDBC2BA17
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CB31206B8
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eDyGqVHH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgDFSxB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 14:53:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgDFSxA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 14:53:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036IgvRT144975;
        Mon, 6 Apr 2020 18:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/R9ky4jOa9DBOuiThrM3vwZ1/skxcS4KqcxLWVK5t4s=;
 b=eDyGqVHHSzut5Q/QYPwTaVJN+axE+KDZSLGJzzCuDrPjmQC2wUpGgpeWX/EkWVTXhj4G
 aKD3twdXL3u9pZs6/KVAeWNd5DjaI6PfUv5Jppqo1WwDqmOl141IQAgGjLdiTupU7R8K
 yPwEgnohQcqfT4xaeevByWT3b+PcYKAsP3k0eJKHjvPcBuW7rlgkTpzA7doGRK55e2FC
 KM+KC9TwplOBejWO5sXJb20fpvWB+uTXY4R4be/wuCPnqjpLa9AzGKyIglvgxnM263iP
 tuAnoQK2BFJNa+9BZXlqERUo3oaRr5AKnaZHaB3aV3OOh97ZP3JkcdlTmuCx1H+3S8UK AA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 306jvn0neh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:52:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036Iga68071272;
        Mon, 6 Apr 2020 18:52:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3073sqf8uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:52:58 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 036IquuR003025;
        Mon, 6 Apr 2020 18:52:57 GMT
Received: from localhost (/10.159.131.9)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 11:52:56 -0700
Subject: [PATCH 5/5] xfs_scrub: fix type error in render_ino_from_handle
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 06 Apr 2020 11:52:55 -0700
Message-ID: <158619917550.469742.14501955862263559558.stgit@magnolia>
In-Reply-To: <158619914362.469742.7048317858423621957.stgit@magnolia>
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

render_ino_from_handle is passed a struct xfs_bulkstat, not xfs_bstat.
Fix this.

Fixes: 4cca629d6ae3807 ("misc: convert xfrog_bulkstat functions to have v5 semantics")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 540b840d..fcd5ba27 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -242,7 +242,7 @@ render_ino_from_handle(
 	size_t			buflen,
 	void			*data)
 {
-	struct xfs_bstat	*bstat = data;
+	struct xfs_bulkstat	*bstat = data;
 
 	return scrub_render_ino_descr(ctx, buf, buflen, bstat->bs_ino,
 			bstat->bs_gen, NULL);


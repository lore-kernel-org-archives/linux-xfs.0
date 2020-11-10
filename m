Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52359C55ABD
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB2E1207D3
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VfhiZhHe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgKJSD6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:03:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57770 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgKJSD6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:03:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHxGHo018036;
        Tue, 10 Nov 2020 18:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=E8jgLWq7yjXaMTZ8Vl8v3fCYOhF6ayx0xinO/KWHRgI=;
 b=VfhiZhHea9OQnEg12QhRDAwBzTL8R/aSdOZEjBK7h7mB6mD8X8E5XHqreTDkKdAJl91v
 zZeeobG4Na4VszphQS+h2zcuItDpDp15EvpdLUgTWpE3tpvmmVaXIOBdG6Nw9NNhee5Z
 dUDXbP/vl63CNd1IsEdx3TaQ2UTqW2qogxj1ngV0D6cO5ElvrjZ91zZanUEp3UTFoqIW
 Ugp1o8n8ej2hFHBPo+Tphs2e1ycA2qRRBsxgejcd6w1IZgaupun0mmJCoxHLAXe9RJXp
 fQX7azJ+wyMce5Ox41uT+2/kyLXoc/vz10c3vWCU3IWyw3txJhS4me3e1yDewheTC5bN Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72ek8p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 18:03:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAI0ss5081611;
        Tue, 10 Nov 2020 18:03:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34p5g0p2sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 18:03:55 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AAI3tCF012779;
        Tue, 10 Nov 2020 18:03:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 10:03:55 -0800
Subject: [PATCH 8/9] xfs_repair: directly compare refcount records
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Nov 2020 10:03:54 -0800
Message-ID: <160503143411.1201232.10096865635977108103.stgit@magnolia>
In-Reply-To: <160503138275.1201232.927488386999483691.stgit@magnolia>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check that our observed refcount records have exact matches for what's
in the ondisk refcount btree, since they're supposed to match exactly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index a4cc6a4937c9..54451a7e262d 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1402,8 +1402,8 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
 
 		/* Compare each refcount observation against the btree's */
 		if (tmp.rc_startblock != rl_rec->rc_startblock ||
-		    tmp.rc_blockcount < rl_rec->rc_blockcount ||
-		    tmp.rc_refcount < rl_rec->rc_refcount)
+		    tmp.rc_blockcount != rl_rec->rc_blockcount ||
+		    tmp.rc_refcount != rl_rec->rc_refcount)
 			do_warn(
 _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) len %u nlinks %u\n"),
 				agno, tmp.rc_startblock, tmp.rc_blockcount,


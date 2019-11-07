Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49DDFC6194
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63FE02077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nvng9h9X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732937AbfKGDDG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:03:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57438 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDDF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:03:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72x72K039081
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gGrxLALMCzBI5C8rQDQbF1/bPSHrbrOa9nKhQvQrMEo=;
 b=nvng9h9XYwt/mwJLMmQSayIf7ZT5IHQrbNqb/2bfvnN8phmDcNCT2efmhI58YSNlDvi8
 ees6YmRlGAH9HvOd9iEULt3BBqgattI93K8738PLoDgSVSgd+DP1M5We9IG7waaRPimj
 v+uZJVESRJZbFDW5kOrLXMjI543hrMnjhO2PHbMuVe0LAjiq4HUnuQuPEQgWOIJ/6gqc
 xlKZGjHMFERm8LpG/OzstaDcTk5hXd+UZuHxxawdT7eGFjtxfWExTalHCWjOVDSEU4P6
 mycYkeps1Vs39AJseKjY8+CrLGo3+6+kaXtHOfdCvYF65ytIH+EoQyOHji+KVCiJnUzA +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w41w0u0m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:03:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72whm9168558
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w41wds6bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:03:03 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA7332xw017890
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:03:02 -0800
Subject: [PATCH 6/6] xfs: range check ri_cnt when recovering log items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:03:01 -0800
Message-ID: <157309578133.46520.12978933521645962496.stgit@magnolia>
In-Reply-To: <157309573874.46520.18107298984141751739.stgit@magnolia>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Range check the region counter when we're reassembling regions from log
items during log recovery.  In the old days ASSERT would halt the
kernel, but this isn't true any more so we have to make an explicit
error return.

Coverity-id: 1132508
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 648d5ecafd91..b0257ef9d29f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4301,7 +4301,16 @@ xlog_recover_add_to_trans(
 			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
 				    0);
 	}
-	ASSERT(item->ri_total > item->ri_cnt);
+
+	if (item->ri_total <= item->ri_cnt) {
+		xfs_warn(log->l_mp,
+	"log item region count (%d) overflowed size (%d)",
+				item->ri_cnt, item->ri_total);
+		ASSERT(0);
+		kmem_free(ptr);
+		return -EFSCORRUPTED;
+	}
+
 	/* Description region is ri_buf[0] */
 	item->ri_buf[item->ri_cnt].i_addr = ptr;
 	item->ri_buf[item->ri_cnt].i_len  = len;


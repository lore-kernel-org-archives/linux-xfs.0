Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9E4C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 20:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3EF02072E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 20:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FrQo1SVs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgJBUSk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 16:18:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59354 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgJBUSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 16:18:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092KE6bd039320;
        Fri, 2 Oct 2020 20:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=/0woIICSglmVeiWz/dxuHgdmbFQB3EG7SRf6Ez1QwHw=;
 b=FrQo1SVswpiZA4feIuFyc1u/cqyzEcJd6yOwTYfQJzQ0Ybmmd9ukD8XsyYDhe97UHJcV
 2Rb4dXbYngc9/rXv4jXh4wH1F/oZ/3VPB5ZLKkGlsqqW5Epy/yBpoLdKWXhAp3Pcek+Y
 O37jzyW8z+CUk/7ynZuqEG2mECXyVscttNhKP5fNAvhNTDBiKgeSSxy42L9eSglPl4Xc
 DsiSFYr8bPFwC2IQv+XjQiPlEicB96iAUKEzLfkeIDDfhzC0OqVeYHFs/JPZfaxDW26E
 xLGjhsfEmE83hNyIcJ3Vh3bhjCJnBDApeq7v8TTALgrrgzjtBhjPOi0SADd5pgsmHap/ Ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkmcruq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 20:18:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092KEdOf132911;
        Fri, 2 Oct 2020 20:18:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33tfj3hekw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 20:18:37 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 092KIZO1024810;
        Fri, 2 Oct 2020 20:18:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 13:18:35 -0700
Date:   Fri, 2 Oct 2020 13:18:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_scrub: don't use statvfs to collect data volume block
 counts
Message-ID: <20201002201834.GC49524@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=5 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=5 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020147
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The function scrub_scan_estimate_blocks naïvely uses the statvfs counts
to estimate the size and free blocks on the data volume.  Unfortunately,
it fails to account for the fact that statvfs can return the size and
free counts for the realtime volume if the root directory has the
rtinherit flag set, which leads to phase 7 reporting totally absurd
quantities.

The XFS_IOC_FSCOUNTS ioctl returns the size and free block count of both
volumes correctly, so use that instead.

Fixes: 604dd3345f35 ("xfs_scrub: filesystem counter collection functions")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/fscounters.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index f9d64f8c008f..a2ca0b3f018c 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -154,10 +154,8 @@ scrub_scan_estimate_blocks(
 
 	sfs.f_bfree += rb.resblks_avail;
 
-	*d_blocks = sfs.f_blocks;
-	if (ctx->mnt.fsgeom.logstart > 0)
-		*d_blocks += ctx->mnt.fsgeom.logblocks;
-	*d_bfree = sfs.f_bfree;
+	*d_blocks = ctx->mnt.fsgeom.datablocks;
+	*d_bfree = fc.freedata;
 	*r_blocks = ctx->mnt.fsgeom.rtblocks;
 	*r_bfree = fc.freertx;
 	*f_files = sfs.f_files;

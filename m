Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00FBC3F68F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75F55214AF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 05:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FlmEJkJn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgAPFKw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 00:10:52 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47120 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgAPFKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 00:10:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59GGt170238;
        Thu, 16 Jan 2020 05:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yHte+m1k3QLIW74ONo99HBcpAipmWDryCCmduGYRVBk=;
 b=FlmEJkJneeGFgV11XOdOOZYgREeo0wzhq4HJ8+H+4GDkj2HLklitGDrrkOkGDih9ZKN4
 urac7SkINsLLoRyXzrgonN3Euq1BR0FOLdc1+0W2y81M7onWqnTqs1DctNv431L0QFh6
 wgvsHxkhc+MhmedRX1CLx9CCps/SfQhzECb49WYstz4Nfj1vfyCuRJG7acqRv1vRfFmZ
 GJlrJ7L3U4u8fiwCmZejwHX7pDuyBQDqJeukKoTILwe+r8uEC/6PzAOYegSPCqLAr9xB
 fQVgV4bzO4msmYts+FWvju1ksF4v1fFtYiNpjvpGqM9xRZtU1kMttDYcD0NvIif4bZkI qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xf73yr779-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:10:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G59NXw097197;
        Thu, 16 Jan 2020 05:10:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xhy22mr51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 05:10:49 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G5Anof000572;
        Thu, 16 Jan 2020 05:10:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 21:10:48 -0800
Subject: [PATCH 2/7] xfs/122: add disk dquot structure to the list
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Wed, 15 Jan 2020 21:10:48 -0800
Message-ID: <157915144805.2374854.13253824378743886853.stgit@magnolia>
In-Reply-To: <157915143549.2374854.7759901526137960493.stgit@magnolia>
References: <157915143549.2374854.7759901526137960493.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add disk dquot structures to the check list now that we killed the
typedef.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index d2d5a184..91a3bdae 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -81,6 +81,7 @@ sizeof(struct xfs_dir3_free) = 64
 sizeof(struct xfs_dir3_free_hdr) = 64
 sizeof(struct xfs_dir3_leaf) = 64
 sizeof(struct xfs_dir3_leaf_hdr) = 64
+sizeof(struct xfs_disk_dquot) = 104
 sizeof(struct xfs_dsymlink_hdr) = 56
 sizeof(struct xfs_extent_data) = 24
 sizeof(struct xfs_extent_data_info) = 32


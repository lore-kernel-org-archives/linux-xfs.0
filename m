Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD362C4360D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F0AB21D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NtYctukw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfIYVfw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:35:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60122 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfIYVfv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:35:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYZRk054965;
        Wed, 25 Sep 2019 21:35:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=on1+A8FomuxiRkvyrWNovC5Tib37Rb5iUHxgWJMkgEI=;
 b=NtYctukwQcX6D7xI64AIQ13+Oxjbwy6mHYQIAuuiwAjk+dwWKUa7eb3342KDWbjqnxWB
 lGU60dHnlG/2dU+FTi2OLMe82GiBnRw7vErozbVvGb/9pAsO1m7ZdpjQ/kwK+zhjtd33
 DPwIYoqV7WTNpiPx6IqQWktCWbKbaAX9C6Wo6UrCDlziesThP4iH8HXdJuP6iaN1PGrI
 KQqQ3MJRMb+57FYBF/F3aUVVqDI0svg96HvVEb3pFHp/M+3sPA7T/MYUosRbNhLizBQE
 M/dROiQAWmWGbzNwv1SjwWIYOLtiTu69geUkvNVrW1NLQDg8WCrXNibvb4zecmHAMA2P JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgr7f18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYMv1023572;
        Wed, 25 Sep 2019 21:35:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuqyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLZlO0015852;
        Wed, 25 Sep 2019 21:35:47 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:35:47 -0700
Subject: [PATCH 08/11] xfs_scrub: enforce read verify pool minimum io size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:35:45 -0700
Message-ID: <156944734585.298887.10261889375809730388.stgit@magnolia>
In-Reply-To: <156944728875.298887.8311229116097714980.stgit@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we always issue media verification requests aligned to the
minimum IO size that the caller cares about.  Concretely, this means
that we only care about doing IO in filesystem block-sized chunks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/read_verify.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 73d30817..9d9be68d 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -77,6 +77,15 @@ read_verify_pool_alloc(
 	struct read_verify_pool		*rvp;
 	int				ret;
 
+	/*
+	 * The minimum IO size must be a multiple of the disk sector size
+	 * and a factor of the max io size.
+	 */
+	if (miniosz % disk->d_lbasize)
+		return EINVAL;
+	if (RVP_IO_MAX_SIZE % miniosz)
+		return EINVAL;
+
 	rvp = calloc(1, sizeof(struct read_verify_pool));
 	if (!rvp)
 		return errno;
@@ -245,6 +254,11 @@ read_verify_schedule_io(
 	int				ret;
 
 	assert(rvp->readbuf);
+
+	/* Round up and down to the start of a miniosz chunk. */
+	start &= ~(rvp->miniosz - 1);
+	length = roundup(length, rvp->miniosz);
+
 	rv = ptvar_get(rvp->rvstate, &ret);
 	if (ret)
 		return ret;


Return-Path: <SRS0=IS9S=2E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35EF1C43603
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 18:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01909207FD
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 18:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BFRI3gNc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfLNSGI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Dec 2019 13:06:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35440 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfLNSGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Dec 2019 13:06:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBEI5aLf086509;
        Sat, 14 Dec 2019 18:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=iluDMdT/WDIE9UymVyA7SxeYtxi4yJYYOpWAJ1FeT1E=;
 b=BFRI3gNchYTP2MwC3DhO9NX7OCTSdybH31ZYYXca7ZF06k3tVQaZrwzN5a4uy4CmnfiB
 Caq3869GKCzG4YxKfQhBEINb66g8DPJyBILKYAjUhjKmTaqFR8Rv9Z1JOWc3JIyVyICH
 8bqbSx1QfWk9Qhwk9x4RjkQ3u2VKu9gb6MTaytYYuMXEfrAZM1duTUHtQZmpEuSfP57g
 j1TmybV+N2oepBvDVY9PUAm4kFlW4pip7o7cLH0kpn+GifUROZaV1vWbAKVwg748yeuc
 B+GcEfkQ9UJqw7pdxopqskJtROaRRjbsuUhIZfMkvpsNJ29o3RMGlfCKRP/L3/jwXn4Q rQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wvqppshf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 18:06:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBEI4Gq5027713;
        Sat, 14 Dec 2019 18:06:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wvnsy6t4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 18:06:03 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBEI61ol015021;
        Sat, 14 Dec 2019 18:06:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 14 Dec 2019 18:06:00 +0000
Date:   Sat, 14 Dec 2019 10:05:59 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] mkfs: print newline if discard fails
Message-ID: <20191214180559.GN99875@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9471 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912140134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9471 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912140134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure the "Discarding..." gets a newline after it no matter how we
exit the function.  Don't bother with any printing it even a small
discard request fails.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4bfdebf6..948a5a77 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1251,6 +1251,14 @@ discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
 	fd = libxfs_device_to_fd(dev);
 	if (fd <= 0)
 		return;
+
+	/*
+	 * Try discarding the first 64k; if that fails, don't bother printing
+	 * any messages at all.
+	 */
+	if (platform_discard_blocks(fd, offset, 65536))
+		return;
+
 	if (!quiet) {
 		printf("Discarding blocks...");
 		fflush(stdout);
@@ -1267,8 +1275,10 @@ discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
 		 * not necessary for the mkfs functionality but just an
 		 * optimization. However we should stop on error.
 		 */
-		if (platform_discard_blocks(fd, offset, tmp_step))
+		if (platform_discard_blocks(fd, offset, tmp_step)) {
+			printf("\n");
 			return;
+		}
 
 		offset += tmp_step;
 	}

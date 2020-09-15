Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A878C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1757212CC
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rjfkO1ze"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIOBpX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:45:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51340 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgIOBpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:45:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1jAsd031495;
        Tue, 15 Sep 2020 01:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dtBMW03p1FAG3GBvJjSHy6PxIDhFPFkBmYQ5LiGyTbw=;
 b=rjfkO1zeFoB9I61pd6RltYharHyppxpgv+efL7CEEkxauJqjKQ/ASJDP7PDV78eBtnh/
 m4BjcDmBlMeVWAmYZBkeWIGGbG0miDYOUwbsoWAeDNJkPa9i3ksAZkSCy2NFCfqCP2B6
 GRHEAlDCg9kjpX3qGYoyblECeunq/+HW3/e63cyAnej86hxm3lIDSdGIApdn+pN5gImE
 tODBjQ/e48SDhOwVkYEDLXNl21YvOdhjMVsMQ89ddEZ80uaj/i7q4hLA/Rqs5dIfp5W3
 4zREgasBO8UQlF6vvF5mLuRwD46LtJ9YIglTVy6XEDZ2OqjnFWoufaE+5e4SuYhYvjy4 Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9m1wv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:45:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1dsuq075943;
        Tue, 15 Sep 2020 01:45:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33h7wn6jjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:45:17 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1jGfb007460;
        Tue, 15 Sep 2020 01:45:16 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:45:16 +0000
Subject: [PATCH 22/24] xfs/141: run for longer with TIME_FACTOR
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:45:15 -0700
Message-ID: <160013431528.2923511.17636617456077025611.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=851 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=859
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Allow the test runner to run the crash loop in this test for longer by
setting TIME_FACTOR.  This has been useful for finding bugs in log
recovery.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/141 |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/141 b/tests/xfs/141
index 754ca37a..ef7210ff 100755
--- a/tests/xfs/141
+++ b/tests/xfs/141
@@ -50,7 +50,8 @@ _scratch_mount
 
 sdev=$(_short_dev $SCRATCH_DEV)
 
-for i in $(seq 1 5); do
+nr_times=$((TIME_FACTOR * 5))
+while [ $nr_times -gt 0 ]; do
 	# Enable error injection. Use a random bad crc factor up to 100
 	# (increase this value to run fsstress longer).
 	factor=$((RANDOM % 100 + 1))
@@ -65,6 +66,7 @@ for i in $(seq 1 5); do
 	# write.
 	_scratch_unmount
 	_scratch_mount
+	nr_times=$((nr_times - 1))
 done
 
 # success, all done


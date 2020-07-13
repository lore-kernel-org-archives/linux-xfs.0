Return-Path: <SRS0=4kkz=AY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9DAC433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 18:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 805532065D
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 18:49:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yl5H3MSh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgGMStg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 14:49:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59390 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgGMStf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 14:49:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DIkqEU094385;
        Mon, 13 Jul 2020 18:49:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=CUM2GXoJT8hx4ItWDiCKkf+wYZuPnboFf+uHb18MpXE=;
 b=Yl5H3MShy9A+8llalJUJbhzT+a6aQ6qwvn78GYu6/Z60EmN2B4iU8DhSCHya2pbZCQ3s
 FMguO8MkSIdYHxk49gnmm8ncY4eAXdREvplYIGcBykQlURhkZprMDMJ1zpv0+1DQvqeS
 bbLgk1R7fKvtMmqF69sH+FXd1PqKdalgtXk7ZHk7EQefSoUA0asgjKU+OTHTcE5MwQ3w
 XGxgbLJ/qqmgra1zfzi4unIaYT06kyoko3o4NG8wpYalNYhlSFcW2EZCgc/826rPh9R3
 PfDlQvo8tmnik4VOuGHu9mQPL8QGpeSTZwsCiYC8pmb5hyVI7y1Q/XjRtQUw6QpUFfyM Zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32762n8qx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 18:49:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DIlWo2196585;
        Mon, 13 Jul 2020 18:49:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 327qb1dfpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 18:49:32 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06DInWvF027185;
        Mon, 13 Jul 2020 18:49:32 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 11:49:31 -0700
Date:   Mon, 13 Jul 2020 11:49:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs/010,030: filter AG header CRC error warnings
Message-ID: <20200713184930.GK7600@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=1 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Filter out the new AG header CRC verification warnings in xfs_repair
since these tests were built before that existed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/010 |    6 +++++-
 tests/xfs/030 |    2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/010 b/tests/xfs/010
index c341795d..ec23507a 100755
--- a/tests/xfs/010
+++ b/tests/xfs/010
@@ -113,7 +113,11 @@ _check_scratch_fs
 # nuke the finobt root, repair will have to regenerate from the inobt
 _corrupt_finobt_root $SCRATCH_DEV
 
-_scratch_xfs_repair 2>&1 | sed -e '/^bad finobt block/d' | _filter_repair_lostblocks
+filter_finobt_repair() {
+	sed -e '/^agi has bad CRC/d' -e '/^bad finobt block/d' | _filter_repair_lostblocks
+}
+
+_scratch_xfs_repair 2>&1 | filter_finobt_repair
 
 status=0
 exit
diff --git a/tests/xfs/030 b/tests/xfs/030
index 8f95331a..a270e36c 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -43,6 +43,8 @@ _check_ag()
 			    -e '/^bad agbno AGBNO for rmapbt/d' \
 			    -e '/^bad agbno AGBNO for refcntbt/d' \
 			    -e '/^bad inobt block count/d' \
+			    -e '/^agf has bad CRC/d' \
+			    -e '/^agi has bad CRC/d' \
 			    -e '/^bad finobt block count/d' \
 			    -e '/^Missing reverse-mapping record.*/d' \
 			    -e '/^unknown block state, ag AGNO, block.*/d'

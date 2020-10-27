Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA027C388F9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 724DC21527
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CskHry16"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829274AbgJ0TDs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:03:48 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57022 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444462AbgJ0TDs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:03:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItCWa021962;
        Tue, 27 Oct 2020 19:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=k24mu1SEzrRVr0eQZFRK8u2EfMsNnwp40aWcyaLM0zI=;
 b=CskHry16tRqFkjbnO0p+O4Md7o4FjnPF65RtsXRPOeNrhkqJczJamFcnJ7r2iTO0w1tV
 HAajTGXfsecZa7kHsW+DbI3a3sc0baSG0VkP8okTEiNIdYIz7SAVfthDMeQjjrQuGbhG
 EgBNbWlgJcxh3VBYec2i1bj4MlbzyBLy0loUMks1S2J1/WssM5bHjlT7Oab3pfGyqWg7
 z+PEYTr/RaYPFoG05DeyhJuygXHk0I/024iebrW5h71PrVAua6hah0V3fmp05GBExJeX
 pGQIQleCROjhw3D8F4EEBJFrJ3RxD+dfU8PelG+x8hoBKxYdne3z2rwLH9aGz7ro2PTW Kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sav0c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:03:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIu2E0133014;
        Tue, 27 Oct 2020 19:03:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5xg9ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:03:46 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RJ3j4L024163;
        Tue, 27 Oct 2020 19:03:45 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:03:43 -0700
Subject: [PATCH 1/2] xfs/122: embiggen struct xfs_agi size for inobtcount
 feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:03:42 -0700
Message-ID: <160382542261.1203756.6377970904886103725.stgit@magnolia>
In-Reply-To: <160382541643.1203756.12015378093281554469.stgit@magnolia>
References: <160382541643.1203756.12015378093281554469.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make the expected AGI size larger for the inobtcount feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/010     |    3 ++-
 tests/xfs/030     |    2 ++
 tests/xfs/122.out |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/010 b/tests/xfs/010
index 1f9bcdff..95cc2555 100755
--- a/tests/xfs/010
+++ b/tests/xfs/010
@@ -113,7 +113,8 @@ _check_scratch_fs
 _corrupt_finobt_root $SCRATCH_DEV
 
 filter_finobt_repair() {
-	sed -e '/^agi has bad CRC/d' | \
+	sed -e '/^agi has bad CRC/d' \
+	    -e '/^bad finobt block/d' | \
 		_filter_repair_lostblocks
 }
 
diff --git a/tests/xfs/030 b/tests/xfs/030
index 04440f9c..906d9019 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -44,6 +44,8 @@ _check_ag()
 			    -e '/^bad agbno AGBNO for refcntbt/d' \
 			    -e '/^agf has bad CRC/d' \
 			    -e '/^agi has bad CRC/d' \
+			    -e '/^bad inobt block count/d' \
+			    -e '/^bad finobt block count/d' \
 			    -e '/^Missing reverse-mapping record.*/d' \
 			    -e '/^bad levels LEVELS for [a-z]* root.*/d' \
 			    -e '/^unknown block state, ag AGNO, block.*/d'
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index cfe09c6d..b0773756 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -113,7 +113,7 @@ sizeof(struct xfs_scrub_metadata) = 64
 sizeof(struct xfs_unmount_log_format) = 8
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
-sizeof(xfs_agi_t) = 336
+sizeof(xfs_agi_t) = 344
 sizeof(xfs_alloc_key_t) = 8
 sizeof(xfs_alloc_rec_incore_t) = 8
 sizeof(xfs_alloc_rec_t) = 8


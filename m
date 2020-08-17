Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35C1C433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BE0F204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xeaCnycH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgHQXBI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:01:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53246 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728241AbgHQXBE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:01:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwRhk062519;
        Mon, 17 Aug 2020 23:01:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+g2PZx/TR92HVgEKixvinl5tbZKZ0I/HPqbjXHTqpmI=;
 b=xeaCnycHgyHWFcZpgKQhNlFZJXr66E2pWiChmnaGxuVDT7KpMgko/Cu1YG/p11q65qrj
 Q8SQdtPFr/IDZ7p21gZwCCk+dlsCSHt6xx2LmiCWgi37NJ+iFLoJ9oCtGCxF8FdOU5Oh
 PraVH3MVtOAXAv098jgnnvxjnNlbJzfQWf4YmXVpkjW625XH7G6kPY+Gr2f8HtbQKacg
 rHyz6j6EBrxOiydGq19eoOZuDyWCq6LgCF6JSv4GXa6dqkzYHYFhI8ru6MKryNRfPLmb
 wAXxc1VhseA7qhJumkQKUFwSO+I959evBtZ6mbBHpyY5ouhebc+gr0Ua+eHAWGYQ4NlC wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32x7nm9jxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:01:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvjDR113883;
        Mon, 17 Aug 2020 23:01:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32xsm18ub0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 23:01:01 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HN11ms015559;
        Mon, 17 Aug 2020 23:01:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 16:01:01 -0700
Subject: [PATCH 1/4] xfs/122: embiggen struct xfs_agi size for inobtcount
 feature
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 17 Aug 2020 16:01:00 -0700
Message-ID: <159770526028.3960575.6276880648755854682.stgit@magnolia>
In-Reply-To: <159770525400.3960575.11977829712550002800.stgit@magnolia>
References: <159770525400.3960575.11977829712550002800.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
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
index b65dd3ba..a5090316 100755
--- a/tests/xfs/010
+++ b/tests/xfs/010
@@ -114,7 +114,8 @@ _check_scratch_fs
 _corrupt_finobt_root $SCRATCH_DEV
 
 filter_finobt_repair() {
-	sed -e '/^agi has bad CRC/d' | \
+	sed -e '/^agi has bad CRC/d' \
+	    -e '/^bad finobt block/d' | \
 		_filter_repair_lostblocks
 }
 
diff --git a/tests/xfs/030 b/tests/xfs/030
index ebe4c92a..52a43ebc 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -44,6 +44,8 @@ _check_ag()
 			    -e '/^bad agbno AGBNO for refcntbt/d' \
 			    -e '/^agf has bad CRC/d' \
 			    -e '/^agi has bad CRC/d' \
+			    -e '/^bad inobt block count/d' \
+			    -e '/^bad finobt block count/d' \
 			    -e '/^Missing reverse-mapping record.*/d' \
 			    -e '/^unknown block state, ag AGNO, block.*/d'
 	done
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 45c42e59..837f4cae 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -112,7 +112,7 @@ sizeof(struct xfs_scrub_metadata) = 64
 sizeof(struct xfs_unmount_log_format) = 8
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
-sizeof(xfs_agi_t) = 336
+sizeof(xfs_agi_t) = 344
 sizeof(xfs_alloc_key_t) = 8
 sizeof(xfs_alloc_rec_incore_t) = 8
 sizeof(xfs_alloc_rec_t) = 8


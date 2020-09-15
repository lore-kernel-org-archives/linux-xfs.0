Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B1FC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99EDA212CC
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="agfbbtaf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgIOBnr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:43:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50172 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOBnq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:43:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1cqmC012873;
        Tue, 15 Sep 2020 01:43:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=uPrGD9Rdam4KA+phRxbDX9Q9/qEY+NgM2lVJEGdNTVk=;
 b=agfbbtafbsJ5D1T88Px4hEMOwM0AurBdhxdd2tEFO3UVIyIuMr7CrSaCKSzZIfvlgTj9
 p8J/U1VDD3nKtHLSXDEUKutswDKfY0OT59GtYzvGh9wMbn9J2UwedUC0wjtRvgRk5t9o
 lQcb+7EVryvAC6dZmFW8p53klc9xmgMnLcui7ScwI7iRdxryHKZhz/NnSFoVufasUcgX
 U93O/PWmiCBpvjtcW21X6lt1BnzPv7Fq3JP2OGdPeNgh4RS2vDyTXB0iv+kZaXXSuYEa
 BxDeDgj0o+m6BHgubpyNDDaF8YCOIAnECjtCipk9g51k8bXEcIoksGfT90qK6Tas9G1b 4Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33gp9m1wr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:43:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1fPqb109438;
        Tue, 15 Sep 2020 01:43:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33h8837y6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:43:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08F1hgap001129;
        Tue, 15 Sep 2020 01:43:42 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:43:41 +0000
Subject: [PATCH 07/24] xfs/{111,137}: replace open-coded calls to repair with
 _scratch_xfs_repair
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:43:40 -0700
Message-ID: <160013422059.2923511.8441653519485642397.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/111 |    2 +-
 tests/xfs/137 |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/111 b/tests/xfs/111
index 0db33cb8..1f778966 100755
--- a/tests/xfs/111
+++ b/tests/xfs/111
@@ -62,7 +62,7 @@ $XFS_FSR_PROG -g $SCRATCH_MNT | _filter_scratch
 
 # Fix up intentional corruption so test can pass
 _scratch_unmount
-$XFS_REPAIR_PROG $SCRATCH_DEV >> $seqres.full 2>&1
+_scratch_xfs_repair >> $seqres.full 2>&1
 
 status=0
 exit
diff --git a/tests/xfs/137 b/tests/xfs/137
index 79106c66..c10860bb 100755
--- a/tests/xfs/137
+++ b/tests/xfs/137
@@ -64,11 +64,11 @@ else
 fi
 
 # verify that repair detects invalid LSNs as well
-$XFS_REPAIR_PROG -n $SCRATCH_DEV >> $seqres.full 2>&1 || \
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || \
 	echo repair failure detected
 
 # repair for real so the post-test check can verify repair fixed things up
-$XFS_REPAIR_PROG $SCRATCH_DEV >> $seqres.full 2>&1
+_scratch_xfs_repair >> $seqres.full 2>&1
 
 # success, all done
 status=0


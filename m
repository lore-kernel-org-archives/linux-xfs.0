Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABF3C47404
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 01:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F34421479
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 01:03:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PFRduCy4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbfJHBDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 21:03:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57848 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbfJHBDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Oct 2019 21:03:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x980xNir190797;
        Tue, 8 Oct 2019 01:03:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/P4HlNzecQYTk7oidI45U4323OgpjZLmg406TAvtVBU=;
 b=PFRduCy4HK6MwCBv+arM7B7xRAMxidDHycKxW2qJ6sVsZjSBgmsj1l8R1wlvifTzorzk
 eR4Uabkkwdt5j1wSaU5u8ZZYjQ5ynsjr4XX4bGJIP7SUnpgzG2dZ7fk85/K3Q80yPgF1
 fHkvnfj6zCQBc/pQ077Y4hS92wjOj4NWaoJi+86H+Ns27Is7Jhn6FwgAI1QrWCRInP+L
 nrurs7XyB1fo0zT6MrdZ4ieOlFF4Xp7t4H/Pg+ncngSBEUpBIOq/ktO4Ojs9006XT1/n
 ArEKn6LtlpuGnShY8S/GnZHaCWvFf8ZPx+jBzGIj2TYOD2t5IaCpyWRrhIzIX5K+xEGS Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vek4qa4fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 01:03:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x980wKDw112805;
        Tue, 8 Oct 2019 01:03:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vgeuwnbpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 01:03:19 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9813IMi003854;
        Tue, 8 Oct 2019 01:03:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Oct 2019 18:03:18 -0700
Subject: [PATCH 2/4] xfs/{088, 089,
 091}: redirect stderr when writing to corrupt fs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 07 Oct 2019 18:03:17 -0700
Message-ID: <157049659754.2397321.4949328613812405852.stgit@magnolia>
In-Reply-To: <157049658503.2397321.13914737091290093511.stgit@magnolia>
References: <157049658503.2397321.13914737091290093511.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

These tests primarily check that writes to a corrupt fs don't take down
the system, and that running repair will fix them.  Therefore, redirect
stderr to seqres.full so that we don't fail these tests in DAX mode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/088 |    2 +-
 tests/xfs/089 |    2 +-
 tests/xfs/091 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/088 b/tests/xfs/088
index 74b45163..d8ca877a 100755
--- a/tests/xfs/088
+++ b/tests/xfs/088
@@ -80,7 +80,7 @@ echo "+ mount image && modify files"
 if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	for x in `seq 1 64`; do
-		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full 2>> $seqres.full
 	done
 	umount "${SCRATCH_MNT}"
 fi
diff --git a/tests/xfs/089 b/tests/xfs/089
index bcbc6363..ad980769 100755
--- a/tests/xfs/089
+++ b/tests/xfs/089
@@ -80,7 +80,7 @@ echo "+ mount image && modify files"
 if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	for x in `seq 1 64`; do
-		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full 2>> $seqres.full
 	done
 	umount "${SCRATCH_MNT}"
 fi
diff --git a/tests/xfs/091 b/tests/xfs/091
index be56d8ae..37c07a52 100755
--- a/tests/xfs/091
+++ b/tests/xfs/091
@@ -80,7 +80,7 @@ echo "+ mount image && modify files"
 if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	for x in `seq 1 64`; do
-		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full 2>> $seqres.full
 	done
 	umount "${SCRATCH_MNT}"
 fi


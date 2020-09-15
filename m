Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1988C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 660A3208DB
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M42/ZXVe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgIOBoA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:44:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50298 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgIOBn5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:43:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1dDqn012963;
        Tue, 15 Sep 2020 01:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6xY5IL+38AWttvMR6v4Y+kP2QnNJmLgxNZkUwzoCPI4=;
 b=M42/ZXVeCiKKhwmGwp17UOisrgjdjaAOBwC0KBBHse190FGP6FKB5YXrY6REE0Hhp4OV
 SPVn/4B7W1unDrwkhyvgmXMe+p5iiCqMRfNh0ZWPB/L1YAxbaN6bToglUMSi5U/seDCS
 Zbk6abSYTfz7w25p0ksISIyxk+fICFPTfSMker7y/LxAU874P5yQpUBZVAntwobmfQpS
 JCdB/wHkkZOggC98cmUH8PBtlx8nCZmN5Ci4BpW2U2EzPBnYEmqi3m0XbdcBT8Osd2zm
 yKcJL4evYURQw0arRuBg3q5FafGDufTdVVP+zat6IKTfwLLvmhCkl4M8UurDZcvUt0UR vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9m1wrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:43:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1dsHP076012;
        Tue, 15 Sep 2020 01:43:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33h7wn6gya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:43:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1hs3Y006929;
        Tue, 15 Sep 2020 01:43:54 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:43:54 +0000
Subject: [PATCH 09/24] xfs/070: add scratch log device options to direct
 repair invocation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:43:53 -0700
Message-ID: <160013423329.2923511.3252823001209034556.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=902 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=910
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
 tests/xfs/070 |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/070 b/tests/xfs/070
index 5d52a830..313864b7 100755
--- a/tests/xfs/070
+++ b/tests/xfs/070
@@ -41,9 +41,11 @@ _cleanup()
 _xfs_repair_noscan()
 {
 	# invoke repair directly so we can kill the process if need be
+	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+		log_repair_opts="-l $SCRATCH_LOGDEV"
 	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \
 		rt_repair_opts="-r $SCRATCH_RTDEV"
-	$XFS_REPAIR_PROG $rt_repair_opts $SCRATCH_DEV 2>&1 |
+	$XFS_REPAIR_PROG $log_repair_opts $rt_repair_opts $SCRATCH_DEV 2>&1 |
 		tee -a $seqres.full > $tmp.repair &
 	repair_pid=$!
 


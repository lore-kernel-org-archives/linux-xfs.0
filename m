Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F2FC54FCB
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 043A321655
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rFFjH+GJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDWXd2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 19:33:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59592 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDWXd2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 19:33:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNWmDJ143365;
        Thu, 23 Apr 2020 23:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lRfXjblsE4bztCx00Kfg3lXe590/N1QhHeZ8dgeZhFg=;
 b=rFFjH+GJhzM7YJS/VcwTZxEKPbj4M0qol95jEZTgRB7vFM2HfmUI1uz2YFoqx92XpQQ7
 Qvv9CPjoMD3wSzSVgFryA/PBeduhjAdJRU1sAK638IKdhEWo2WyeiQcSUmOHTWAFjwQt
 Pge8eaqVrqzq1WSMIceoxMkyh0vBT0VTAU0l8jnHPhZi+GVP5DS25um5OpXUuHghSV3x
 bztEbjWp4cb5QpH4kOFq6YRo0NyHsCJCxsf/q4/pvvdPfpmcuq46CLZptaI10hdYqoXY
 SZUEQncds618RU0HffxgHKCMyaxwzByw3M4I3wQFCDWsBPAx8WVt/16srUW721881gaz 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30ketdhm8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:33:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNRaDb160131;
        Thu, 23 Apr 2020 23:31:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30k7qw2bnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:31:26 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03NNVPHx032379;
        Thu, 23 Apr 2020 23:31:25 GMT
Received: from localhost (/10.159.232.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 16:31:25 -0700
Subject: [PATCH 2/5] xfs/126: make sure we corrupt the attr leaf in a
 detectable way
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 23 Apr 2020 16:31:24 -0700
Message-ID: <158768468419.3019327.7338437062843317243.stgit@magnolia>
In-Reply-To: <158768467175.3019327.8681440148230401150.stgit@magnolia>
References: <158768467175.3019327.8681440148230401150.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=930
 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=981 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Try harder to fuzz the attr leaf so this consistently trips a verifier.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/126 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/126 b/tests/xfs/126
index 4f9f8cf9..0d497779 100755
--- a/tests/xfs/126
+++ b/tests/xfs/126
@@ -72,7 +72,7 @@ echo "+ corrupt xattr"
 loff=1
 while true; do
 	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" | grep -q 'file attr block is unmapped' && break
-	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
+	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 4096 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 	loff="$((loff + 1))"
 done
 


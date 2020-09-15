Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3412FC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E562821D80
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fB3qR5LA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgIOBnw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:43:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45062 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOBnv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:43:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1hXb6147208;
        Tue, 15 Sep 2020 01:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=q886AmJtZoeXo+Bq3YFmONGlq7gyGxxKGk22uGwNQAM=;
 b=fB3qR5LA6kOWm58pFKBdI2/CuhKhWUhToTYbWifuV1uAU+2gZSUolo97Sm2vOVfBqfMZ
 BGSzfiEqpdyWevGjVFsb46Nta71z/PaKOAYC97y3wSuYsGX7t55BYQJpi55sLmYn6UR/
 t1I3egQISGd6T0dJi3VVSa4ja3ZoR5EAoG3scAd2Y0DqmFOdMD+Pru7UVQbc6Cp0CCl1
 dLP5L+nZ2EsQS6MAy7+Yr4JFSKqSq3ysRmIA18NIPc2TfHNTJQ2NVuxS5kmwPkycP7Ob
 6QwNPh7AgOWwzAXC5Kj8AjCtNq3rQCYOq5yr9dr6b1vxfLniIniA1jGbGfMpQOKnuZV7 lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33gnrqsxtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:43:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1dt5L076049;
        Tue, 15 Sep 2020 01:43:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33h7wn6gtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:43:48 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08F1hmRb001145;
        Tue, 15 Sep 2020 01:43:48 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:43:48 +0000
Subject: [PATCH 08/24] xfs: replace open-coded calls to xfs_logprint with
 helpers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:43:47 -0700
Message-ID: <160013422703.2923511.4608245885181531356.stgit@magnolia>
In-Reply-To: <160013417420.2923511.6825722200699287884.stgit@magnolia>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the test/scratch xfs_logprint helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/135 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/135 b/tests/xfs/135
index cc505980..9783cfc2 100755
--- a/tests/xfs/135
+++ b/tests/xfs/135
@@ -48,7 +48,7 @@ for i in 16 32 64 128 256; do
 	_scratch_xfs_db -x -c "logformat -c 3 -s $lsunit" | \
 		tee -a $seqres.full
 	# don't redirect error output so it causes test failure
-	$XFS_LOGPRINT_PROG $SCRATCH_DEV >> $seqres.full
+	_scratch_xfs_logprint >> $seqres.full
 done
 
 # success, all done


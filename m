Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35EDDC2BA19
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 171A720736
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XTtpV6D4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgDWXbl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 19:31:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44126 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgDWXbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 19:31:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNSZYL110765;
        Thu, 23 Apr 2020 23:31:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ICcM+3BZ9y71dmOw7Erd6v+N0K4kldhixQtPU0gRz8Q=;
 b=XTtpV6D4CUuQTa7SIjFi770jwlKWTg5HwhaFJ+mIpHaUjGGbF7uiRtRdQMtC8DuT5S+D
 63S3xAeqM4gFzHBTvZUoRtiA+yRFZFzROPMd2+rdS5SEZqGMPJvaJJhQN+h6leynH9MZ
 Hff+LQLlkcwOIqVpjYHtKfUbD9qVGeEzzbfAu052eq4gdupfqSf5vXpwC2evw2jJWArS
 WKp9Bnfxi/jHX4Zx4U6q2FmdSVuym6Oek9MGQINOAGLy0w49cF+7OI5hkfQVIlFfLs0v
 TWz/+NYQm8wqn6/JAz5gzsrH7jRFD5F/ohYM+jVW/2mVftvsZDLM7TW4YEjbNpf4IY8/ KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30jvq4xbpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:31:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNSNJn031703;
        Thu, 23 Apr 2020 23:31:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30gb1nms7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:31:38 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03NNVckB021389;
        Thu, 23 Apr 2020 23:31:38 GMT
Received: from localhost (/10.159.232.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 16:31:37 -0700
Subject: [PATCH 4/5] xfs/30[78]: fix regressions due to strengthened AGF
 checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 23 Apr 2020 16:31:36 -0700
Message-ID: <158768469665.3019327.1634286381311814235.stgit@magnolia>
In-Reply-To: <158768467175.3019327.8681440148230401150.stgit@magnolia>
References: <158768467175.3019327.8681440148230401150.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=923 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=964 phishscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Reorder the order in which we tweak AGF fields to avoid falling afoul of
the new AGF sanity checks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/307 |    2 +-
 tests/xfs/308 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/307 b/tests/xfs/307
index 705643da..2f517952 100755
--- a/tests/xfs/307
+++ b/tests/xfs/307
@@ -115,8 +115,8 @@ debris_bno=$((bno + len - debris_len))
 echo "Remove the extent from the freesp btrees"
 _set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr bnoroot'
 _set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr cntroot'
-_set_agf_data freeblks $((agf_freeblks - debris_len))
 _set_agf_data longest $((len - debris_len))
+_set_agf_data freeblks $((agf_freeblks - debris_len))
 _set_sb_data fdblocks $((sb_fdblocks - debris_len))
 
 echo "Add the extent to the refcount btree"
diff --git a/tests/xfs/308 b/tests/xfs/308
index f809b499..569a25f1 100755
--- a/tests/xfs/308
+++ b/tests/xfs/308
@@ -115,8 +115,8 @@ debris_bno=$((bno + len - debris_len))
 echo "Remove the extent from the freesp btrees"
 _set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr bnoroot'
 _set_agf_data "recs[1].blockcount" $((len - debris_len)) -c 'addr cntroot'
-_set_agf_data freeblks $((agf_freeblks - debris_len))
 _set_agf_data longest $((len - debris_len))
+_set_agf_data freeblks $((agf_freeblks - debris_len))
 _set_sb_data fdblocks $((sb_fdblocks - debris_len))
 
 echo "Add the extent to the refcount btree"


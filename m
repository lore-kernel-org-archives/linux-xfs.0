Return-Path: <SRS0=myhp=BJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5E5C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 18:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB6F20838
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jul 2020 18:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aV3/tICh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgG3Sfk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jul 2020 14:35:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3Sfk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jul 2020 14:35:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UIILoZ049598;
        Thu, 30 Jul 2020 18:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=KX1a7idqlACmkcirGvRyHcTbsLkmkythGDjK4hjFGTo=;
 b=aV3/tIChw70HDmlYyKAEw82TgEjlpHfnTwrLMkFyvpjeK1SB8jz+MyAepInJ05iKge6s
 JUZU/zV1oo8jnRPR9ZArnb6BHQbt/mkrx0EtZ6nfa5R4HuD8faTTGIfaWQYm+wxFsgNj
 JLeIBnEuouU7ZPn0/TQkbgtx3ZjjWXwfDz92Gb03+O5aqyG6tMzS1U/NMJ7/bVgkc2L2
 uZQLNi6Ykn6oJWn8OrjHK4x7HEsfdox+yuPV5bGEwn7X7xxuORBVAJKO7ogdLdxIkWkQ
 JHX+3DFZ788+9GhJAYxf1OScW+pT9fxg3aQn9tJTq8FxGYD2gth8QXO6q5AtjLDGMoAK Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32hu1jnatg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 Jul 2020 18:35:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UIJT5r012820;
        Thu, 30 Jul 2020 18:35:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32hu5x6uf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 18:35:35 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06UIZYHN020333;
        Thu, 30 Jul 2020 18:35:34 GMT
Received: from localhost (/10.159.249.46)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jul 2020 11:35:34 -0700
Date:   Thu, 30 Jul 2020 11:35:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Cc:     "Bill O'Donnell" <billodo@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs/{263,106} erase max warnings printout
Message-ID: <20200730183533.GB67809@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=1 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Both of these tests encode the xfs_quota output in the golden output.
Now that we've changed xfs_quota to emit max warnings, we have to fix
the test to avoid regressions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/106 |    3 ++-
 tests/xfs/263 |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/106 b/tests/xfs/106
index 7a71ec09..e6a9b3d1 100755
--- a/tests/xfs/106
+++ b/tests/xfs/106
@@ -96,7 +96,8 @@ filter_state()
 {
 	_filter_quota | sed -e "s/Inode: #[0-9]* (0 blocks, 0 extents)/Inode: #[INO] (0 blocks, 0 extents)/g" \
 			    -e "s/Inode: #[0-9]* ([0-9]* blocks, [0-9]* extents)/Inode: #[INO] (X blocks, Y extents)/g" \
-			    -e "/[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/s/ [0-9][0-9]:[0-9][0-9]:[0-9][0-9]//g"
+			    -e "/[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/s/ [0-9][0-9]:[0-9][0-9]:[0-9][0-9]//g" \
+			    -e '/max warnings:/d'
 }
 
 test_quot()
diff --git a/tests/xfs/263 b/tests/xfs/263
index 578f9ee7..2f23318d 100755
--- a/tests/xfs/263
+++ b/tests/xfs/263
@@ -57,7 +57,9 @@ function option_string()
 }
 
 filter_quota_state() {
-	sed -e 's/Inode: #[0-9]\+/Inode #XXX/g' | _filter_scratch
+	sed -e 's/Inode: #[0-9]\+/Inode #XXX/g' \
+	    -e '/max warnings:/d' \
+		| _filter_scratch
 }
 
 function test_all_state()

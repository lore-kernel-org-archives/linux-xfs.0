Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE95C43215
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 02:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03ECB2080A
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 02:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KOpqF58i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfLDCgy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 21:36:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36958 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfLDCgy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 21:36:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB42TqZ0093484;
        Wed, 4 Dec 2019 02:36:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=UFZvGEQx1YDWdVF96hVr625o8C09l6ZzmH2/Ztc2Ivg=;
 b=KOpqF58icx+Lh7NIq66OMxMN7f69WdTQeAZfQD2u/7TthOpmDfinM31PDVPaR2jKS/7l
 YzODys3QgJ4CA4FwY1Mns6Xr4thRLlOWrgaNfgFYF2UL9fWDTUx/Hmj12W8mpEhDWH9P
 p2qZcw+j7xoMJph1Bs8wTgWNxM5j7NveBGrbVZUzWHFbTlLlzdbTY6urq4CiRj0EXJiN
 BHfWXPUjfVKEvIpTUi0K6gsYwLdO3BCX90OaJIj4QsltmLGmlNzKeh/ZETxDOvvBG9dQ
 hrh8WFIg78SWXNoEtlWcHH332shWFFuJJ+fXK5RaDbTvoEV8cTI6a3Iatob3pB4/9E2y ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wkfuubpba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 02:36:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB42XZlI056703;
        Wed, 4 Dec 2019 02:36:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wp2085pht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 02:36:44 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB42ahCW008020;
        Wed, 4 Dec 2019 02:36:43 GMT
Received: from localhost (/10.159.254.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 18:36:43 -0800
Date:   Tue, 3 Dec 2019 18:36:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Yang Xu <xuyang2018.ky@cn.fujitsu.com>,
        fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs/148: sort attribute list output
Message-ID: <20191204023642.GD7328@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912040016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912040016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Yang Xu reported a test failure in xfs/148 that I think comes from
extended attributes being returned in a different order than they were
set.  Since order isn't important in this test, sort the output to make
it consistent.

Reported-by: Yang Xu <xuyang2018.ky@cn.fujitsu.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/148     |    2 +-
 tests/xfs/148.out |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/148 b/tests/xfs/148
index 42cfdab0..ec1d0ece 100755
--- a/tests/xfs/148
+++ b/tests/xfs/148
@@ -76,7 +76,7 @@ test_names+=("too_many" "are_bad/for_you")
 
 access_stuff() {
 	ls $testdir
-	$ATTR_PROG -l $testfile
+	$ATTR_PROG -l $testfile | grep 'a_' | sort
 
 	for name in "${test_names[@]}"; do
 		ls "$testdir/f_$name"
diff --git a/tests/xfs/148.out b/tests/xfs/148.out
index c301ecb6..f95b55b7 100644
--- a/tests/xfs/148.out
+++ b/tests/xfs/148.out
@@ -4,10 +4,10 @@ f_another
 f_are_bad_for_you
 f_something
 f_too_many_beans
+Attribute "a_another" has a 3 byte value for TEST_DIR/mount-148/testfile
+Attribute "a_are_bad_for_you" has a 3 byte value for TEST_DIR/mount-148/testfile
 Attribute "a_something" has a 3 byte value for TEST_DIR/mount-148/testfile
 Attribute "a_too_many_beans" has a 3 byte value for TEST_DIR/mount-148/testfile
-Attribute "a_are_bad_for_you" has a 3 byte value for TEST_DIR/mount-148/testfile
-Attribute "a_another" has a 3 byte value for TEST_DIR/mount-148/testfile
 TEST_DIR/mount-148/testdir/f_something
 Attribute "a_something" had a 3 byte value for TEST_DIR/mount-148/testfile:
 heh

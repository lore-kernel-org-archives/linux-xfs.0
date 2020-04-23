Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D789C54FCB
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EFC321556
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:31:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xrRzWCdn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgDWXbg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 19:31:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58456 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgDWXbf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 19:31:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNSZhw140226;
        Thu, 23 Apr 2020 23:31:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IOsj+bExliai5MHbuopsJBvWMjXXGOg3kSDZexC961A=;
 b=xrRzWCdnCSHDIQBSFT3hRzihPyUpSgGZpqaiQM13/BcTTbqNnVG3j+yYf5i43nVIXLdl
 mWWP+Zz1PudIihj+7IY3pB8fPq1kGplHgfP0VLwuP8KCekWKFj6bcreY4TyIVc+Z7gOa
 uXwpkUnKdV08o5eLuO39fEMUwqgoeOfl5MuKHrqMwD0pOzU0tfkA1inFgFA3kFeG295F
 8LhYW3yHEDmkLke/YqSIrbHrYKCrDacmPOhp2jEXud8a1GgMUp58wN5xMYVct7qvCZTc
 wgFR7qb6ReIOnFhnNUND62oskKfFtrMJDh6A3QZIVERnzwzH/kEUxQBhnIvSTJ3m+Jlw nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30ketdhm4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:31:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNSOYx031776;
        Thu, 23 Apr 2020 23:31:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30gb1nms46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:31:33 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03NNVVJO032377;
        Thu, 23 Apr 2020 23:31:31 GMT
Received: from localhost (/10.159.232.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 16:31:31 -0700
Subject: [PATCH 3/5] generic/570: don't run this test on systems supporting
 userspace hibernate
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 23 Apr 2020 16:31:30 -0700
Message-ID: <158768469040.3019327.7570482503352003021.stgit@magnolia>
In-Reply-To: <158768467175.3019327.8681440148230401150.stgit@magnolia>
References: <158768467175.3019327.8681440148230401150.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

It turns out that userspace actually does need the ability to write to
an active swapfile if userspace hibernation (uswsusp) is enabled.
Therefore, this test doesn't apply under those conditions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/570 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/generic/570 b/tests/generic/570
index d574f4b7..e5da2381 100755
--- a/tests/generic/570
+++ b/tests/generic/570
@@ -32,6 +32,7 @@ _supported_fs generic
 _require_test_program swapon
 _require_scratch_nocheck
 _require_block_device $SCRATCH_DEV
+test -e /dev/snapshot && _notrun "userspace hibernation to swap is enabled"
 
 rm -f $seqres.full
 


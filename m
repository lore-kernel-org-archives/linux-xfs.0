Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261D7C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E975920872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ME2ZJF3y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbfIYVhX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:37:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbfIYVhX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:37:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYc3l055018;
        Wed, 25 Sep 2019 21:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=t0kydBrI7SUTsLEhNKwIHIZR55Vibq40h+ULNx0iGR0=;
 b=ME2ZJF3y9wLOa3YHP7qKyViyzmKIsCY2bCdUzkWQEDGXWV+GwPMjOC3dN9wbgQAb8uY6
 vSDdFmVkbK2GV8YFlUll27De+/vGCvtaSp+DMCxAM+jzDeQEJcGcQxd/2oh3PDsZc4JU
 pBVXMHN3AJtJ7GIE2Q4PpxAsU877I2gNNYG2oFdlc5/LEuwqHFsFk/VFRw58icCtzYQS
 e02/vGx/36+W8b/B6Fdnl4BGNPA1Mt+lYczUP+HH33V8ogofhZS9Aw4b1qd1ppXesFUx
 jJl3x2je3XaN+ny5h58ZKFVJWcWz8SFAqO+kZvoJPjGErx+/VXP8TilCsTR7mLNWK/tE Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2v5cgr7f6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:37:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYQxu078638;
        Wed, 25 Sep 2019 21:37:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2v82tkrm14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:37:20 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLbJmG016012;
        Wed, 25 Sep 2019 21:37:19 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:37:19 -0700
Subject: [PATCH 0/3] xfs_scrub: deferred labelling to save time
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:37:17 -0700
Message-ID: <156944743778.300433.15946504547062490997.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I noticed from profiling xfs_scrub that the program spent a significant
amount of time in phase 3 rendering descriptive strings in case we found
an error and needed to report where we found them.  Most of the time
there aren't going to be errors, so we can reduce the runtime by 10% by
only rendering those strings when we need to report an error.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-deferred-descriptions

Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B82C55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A9D521556
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oK7qEhsj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829242AbgJ0TBh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:01:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48074 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1829232AbgJ0TBf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:01:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsWGA111607;
        Tue, 27 Oct 2020 19:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Xk+AyRCV0pZZzNovL9u8uITY8vGc6FI9GJmCX8C4rXM=;
 b=oK7qEhsjyzfEPg+mC8EXA1TFVxKIj69Gg23pE9sBZeK6CMwyfByRNC3bz9YH9wdxqwvY
 UsNJO6BnvaRluDvEQ7B31+krorMqTepM8JwDqiZkY07I+uYNROyxUY2O1Qi1VfwLsN02
 EithR3cB0Om2fM86V8xfBOpnsRpRgexS86hkfTvN1fpD7/t8qWtJWNGD+4HfP4b7TJ/i
 SeteXbCUJzccZb/3VVlqTML/3/0e5t1toVl1mQHObI92POMMixlNpKHy59XriibmVkqh
 cGZH4Ra/z9T5/A5TTGK1oVD7rrlqsVBIDtjRJlOgqTa95cla+rbHYHKWgaBTzCnzzbv/ Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm41ew0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:01:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsPSQ076504;
        Tue, 27 Oct 2020 19:01:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwumrhaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:01:32 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RJ1WUC005682;
        Tue, 27 Oct 2020 19:01:32 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:01:30 -0700
Subject: [PATCH 0/9] xfstests: random fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:01:29 -0700
Message-ID: <160382528936.1202316.2338876126552815991.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series contains random fixes to fstests.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 check             |   21 ++++++++++++++++++++-
 common/populate   |    5 +++++
 common/rc         |   13 ++++++++++---
 common/repair     |    1 +
 common/xfs        |   20 ++++++++++++++++++++
 tests/xfs/030     |    1 +
 tests/xfs/272     |    3 +++
 tests/xfs/276     |    8 +++++++-
 tests/xfs/327     |   18 ++++++++++++++++--
 tests/xfs/327.out |   13 +++++++------
 tests/xfs/328     |    2 +-
 tests/xfs/341     |    8 +++++---
 tests/xfs/520     |    3 +++
 13 files changed, 99 insertions(+), 17 deletions(-)


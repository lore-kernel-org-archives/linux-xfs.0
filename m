Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7E2C5517A
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CB83221E9
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cRmuLsst"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732345AbgKKAnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:43:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34660 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732398AbgKKAnw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:43:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0ZhMi016937;
        Wed, 11 Nov 2020 00:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=fbW2P+59j/jihYwxqFdcS35tD6MaE3Of6zR7VL/XgQc=;
 b=cRmuLsstZyxgumPoJ/GhEGEfk2MXHG1X4V7fvAY115ss4BGc7gc4DBjasVovSJbLH/Ex
 jVLpKnKdcGNWI+eVLUaDNg/rjoSRrB3ShBYWkzCSTD8NOa3Z4bqSd3AnBYJNlKvnfTLs
 1xsPLGRMR9bCWIerSleZowC08E1ST2HMJoiGMgu8M55khwNFdpyKy4wYe0QP5fcV7bwj
 CpbdAT7TzMeVDIXJJhGJ9/Q8WeYkPr4uZoJ9sv7ZiBy2JQ9oWd9rOyKHaG38YIuc+2O2
 gqNJKxmvB6XIPKUEFkSyzjuHYt8ZOM1sxdXZHzfN4hBU0fDKO0WE7Sg/iPGGAcV7aqvI Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34p72emv4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:43:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0UAdD097653;
        Wed, 11 Nov 2020 00:43:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34p5gxq731-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:43:50 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB0hnu9028978;
        Wed, 11 Nov 2020 00:43:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:43:49 -0800
Subject: [PATCH 0/7] various: test xfs things fixed in 5.10
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:43:48 -0800
Message-ID: <160505542802.1388823.10368384826199448253.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are a bunch of new tests for problems that were fixed in 5.10.
Er.... 5.10 and 5.9.  I have not been good at sending to fstests
upstream lately. :( :(

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=test-fixes-5.10
---
 tests/generic/947     |  117 ++++++++++++++++++++++++++++++++
 tests/generic/947.out |   15 ++++
 tests/generic/948     |   90 ++++++++++++++++++++++++
 tests/generic/948.out |    9 ++
 tests/generic/group   |    2 +
 tests/xfs/122         |    1 
 tests/xfs/122.out     |    1 
 tests/xfs/758         |   59 ++++++++++++++++
 tests/xfs/758.out     |    2 +
 tests/xfs/759         |   99 +++++++++++++++++++++++++++
 tests/xfs/759.out     |    2 +
 tests/xfs/760         |   66 ++++++++++++++++++
 tests/xfs/760.out     |    9 ++
 tests/xfs/761         |   42 +++++++++++
 tests/xfs/761.out     |    1 
 tests/xfs/763         |  181 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/763.out     |   91 +++++++++++++++++++++++++
 tests/xfs/915         |  176 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/915.out     |  151 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group       |    6 ++
 20 files changed, 1119 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/947
 create mode 100644 tests/generic/947.out
 create mode 100755 tests/generic/948
 create mode 100644 tests/generic/948.out
 create mode 100755 tests/xfs/758
 create mode 100644 tests/xfs/758.out
 create mode 100755 tests/xfs/759
 create mode 100644 tests/xfs/759.out
 create mode 100755 tests/xfs/760
 create mode 100644 tests/xfs/760.out
 create mode 100755 tests/xfs/761
 create mode 100644 tests/xfs/761.out
 create mode 100755 tests/xfs/763
 create mode 100644 tests/xfs/763.out
 create mode 100755 tests/xfs/915
 create mode 100644 tests/xfs/915.out


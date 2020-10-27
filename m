Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B2DC388F9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45F64206F7
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:02:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YVSNEc6c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444590AbgJ0TCh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:02:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410146AbgJ0TCh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:02:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsvGZ111768;
        Tue, 27 Oct 2020 19:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=3lYKUZLvpTAtEALRNzgnXM33houhJf3g+MckXXvw+A0=;
 b=YVSNEc6cW4gZCt3tdIrrhbop2D72XV2ruO3kFiTbUUFf5GaRPvhtapKsA0xwcJd+TmnL
 BxNrO+2KLsZoi+uXANrhIUvYaRB1/QJTri4SYDQz7oPrMTrQVzvRwtyc7u5KBGlfvhwl
 MdqNV3rzAA8VrndujZM5ukeAvpvXjAz8sRK5iLgFmqwbjNQ5UJAnFWhYW214Ldn4689L
 pOmxDoAaeXkIrGFQGQati2NmCGhDYI9barTecQfTYjM6kDIiuiC1xgoW2XrZmkd0GyTF
 Zm2PaqJ57ZIz+J/JRTh7yqyz0QSkv7yfMD3bD0Sj12kkF4XPokbtr8Bqn1+Q6Xr5JQF4 DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm41f1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:02:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIu2Pk132992;
        Tue, 27 Oct 2020 19:02:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5xg8bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:02:33 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RJ2Wae001225;
        Tue, 27 Oct 2020 19:02:32 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:02:32 -0700
Subject: [PATCH 0/7] various: test xfs things fixed in 5.10
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:02:31 -0700
Message-ID: <160382535113.1203387.16777876271740782481.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
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
 19 files changed, 1119 insertions(+)
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


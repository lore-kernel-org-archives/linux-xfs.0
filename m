Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43EAC43140
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9AF62070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FLUMPB+R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389194AbfIEWTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59670 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389589AbfIEWTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ9b1049766
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=kead5fque0m3AhUA4EPaT4XC3CXD3YzHCsxvOu4MUIk=;
 b=FLUMPB+RQEhxPbzwgHhPmR0XJYXcM2Bs15N0GmDikgMaQ7gNDGkLhjyBGqD4htrlBWks
 wW/ubGyD+0AiSD8CbyL0H0PDgP9M1Ml2izXMz3d7yWeMr2joqcTtTpYJw3ZQlEmmVQwW
 iAu9v4YccBGQz0O3bvpphSpLHoUGDn0EJU3tF8npDNRmIMlQseyvcJjfZE9U7+mdI4Ny
 yNloDX4waev6sjdIxftbsZgbkX613uabiB7ordFHyV2yLDIerC3FCl4M87cQuh2MRx26
 Nko1pokdnYrIURDiFvSWV/hTdgQCfEXQTDB22EubOkwE3cHjfWJTAE51Z9Vv/gHFxiRr Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uuarc822r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIPP9101774
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uu1b9475e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:37 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MJLDH009028
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:21 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:21 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/1] Add delayed attributes test 
Date:   Thu,  5 Sep 2019 15:19:16 -0700
Message-Id: <20190905221917.17733-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=887
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=967 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a quick test to excersize the delayed attribute
error inject and log replay.  Since v2, the test case has been
expanded to test attributes of incrementing sizes up to 64k.
It has also been updated to use the new mkfs.xfs -n delattr cli
option added in the new xfsprogs set.

Allison Collins (1):
  xfstests: Add Delayed Attribute test

 common/rc         |   3 ++
 common/xfs        |   7 +++
 tests/xfs/512     | 101 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/512.out | 131 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |   1 +
 5 files changed, 243 insertions(+)
 create mode 100755 tests/xfs/512
 create mode 100644 tests/xfs/512.out

-- 
2.7.4


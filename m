Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA76C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76FBC20760
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgLaWtP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:49:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35768 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbgLaWtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:49:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMlFov148543;
        Thu, 31 Dec 2020 22:48:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9QcNr8k3P+HhhGZNU1aQzBSS9kWTPDgYZBib0LvRuKE=;
 b=huMyTl6ENT1tlHts+XfkNFVVBCVCKrDWo+77fh5nIYzI6nQYX7YJpaMzg6FW6VtWuOx8
 VjpmonX3Bl77TdGnw5AcubnPiA9JQQdrePp+S5Fyhi7VD4D//LCIpslrxAr7xhJPT6Zh
 juVR0NgYP7IhEpK4LGisTKO68Eu8WRoWkkrO8nlPlTKyUKoZLJSUr81akFfRC9w8VJ5w
 KE+3ezBnAxgBhnreU0sUSsfDQROAfGx+FaD+qYAGXeQV5L3JeLDVw8kM0vj/NsNKpvYL
 U+IaFFPYF2/q9jxLo28lO0kMbfT86za8ibKVNlkap6H9YCfa8vShCNl8P4Zbg28Dy0Mw pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35phm1jt57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 31 Dec 2020 22:48:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMk7LJ153864;
        Thu, 31 Dec 2020 22:48:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35pexukux1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Dec 2020 22:48:31 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMmUsS026227;
        Thu, 31 Dec 2020 22:48:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:48:30 -0800
Subject: [PATCHSET 0/2] xfstests: strengthen fuzz testing
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:48:29 -0800
Message-ID: <160945490944.2837649.17724670398871130217.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add new fuzz tests to try the "online then offline" repair strategy.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=more-fuzz-testing
---
 tests/xfs/1500     |   46 +++++
 tests/xfs/1500.out |  173 ++++++++++++++++++
 tests/xfs/1501     |   46 +++++
 tests/xfs/1501.out |  117 ++++++++++++
 tests/xfs/1502     |   51 +++++
 tests/xfs/1502.out |  148 +++++++++++++++
 tests/xfs/1503     |   46 +++++
 tests/xfs/1503.out |  156 ++++++++++++++++
 tests/xfs/1504     |   46 +++++
 tests/xfs/1504.out |    9 +
 tests/xfs/1505     |   46 +++++
 tests/xfs/1505.out |   48 +++++
 tests/xfs/1506     |   46 +++++
 tests/xfs/1506.out |    9 +
 tests/xfs/1507     |   46 +++++
 tests/xfs/1507.out |    4 
 tests/xfs/1508     |   47 +++++
 tests/xfs/1508.out |    6 +
 tests/xfs/1509     |   47 +++++
 tests/xfs/1509.out |  254 ++++++++++++++++++++++++++
 tests/xfs/1510     |   47 +++++
 tests/xfs/1510.out |  355 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1511     |   48 +++++
 tests/xfs/1511.out |   85 +++++++++
 tests/xfs/1512     |   51 +++++
 tests/xfs/1512.out |  309 ++++++++++++++++++++++++++++++++
 tests/xfs/1513     |   51 +++++
 tests/xfs/1513.out |  301 +++++++++++++++++++++++++++++++
 tests/xfs/1514     |   51 +++++
 tests/xfs/1514.out |  289 ++++++++++++++++++++++++++++++
 tests/xfs/1515     |   53 ++++++
 tests/xfs/1515.out |    5 +
 tests/xfs/1516     |   51 +++++
 tests/xfs/1516.out |   13 +
 tests/xfs/1517     |   51 +++++
 tests/xfs/1517.out |  416 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1518     |   51 +++++
 tests/xfs/1518.out |  179 +++++++++++++++++++
 tests/xfs/1519     |   52 +++++
 tests/xfs/1519.out |  262 +++++++++++++++++++++++++++
 tests/xfs/1520     |   53 ++++++
 tests/xfs/1520.out |    5 +
 tests/xfs/1521     |   53 ++++++
 tests/xfs/1521.out |   25 +++
 tests/xfs/1522     |   53 ++++++
 tests/xfs/1522.out |   11 +
 tests/xfs/1523     |   53 ++++++
 tests/xfs/1523.out |    5 +
 tests/xfs/1524     |   51 +++++
 tests/xfs/1524.out |  381 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1525     |   51 +++++
 tests/xfs/1525.out |  501 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1526     |   51 +++++
 tests/xfs/1526.out |   12 +
 tests/xfs/1527     |   51 +++++
 tests/xfs/1527.out |   29 +++
 tests/xfs/1528     |   50 +++++
 tests/xfs/1528.out |   20 ++
 tests/xfs/1529     |   48 +++++
 tests/xfs/1529.out |  146 +++++++++++++++
 tests/xfs/1530     |   48 +++++
 tests/xfs/1530.out |   10 +
 tests/xfs/1531     |   51 +++++
 tests/xfs/1531.out |  271 ++++++++++++++++++++++++++++
 tests/xfs/1532     |   51 +++++
 tests/xfs/1532.out |  291 ++++++++++++++++++++++++++++++
 tests/xfs/1533     |   51 +++++
 tests/xfs/1533.out |  300 +++++++++++++++++++++++++++++++
 tests/xfs/1534     |   49 +++++
 tests/xfs/1534.out |  141 +++++++++++++++
 tests/xfs/1535     |   49 +++++
 tests/xfs/1535.out |  141 +++++++++++++++
 tests/xfs/1536     |   49 +++++
 tests/xfs/1536.out |  141 +++++++++++++++
 tests/xfs/1537     |   52 +++++
 tests/xfs/1537.out |   17 ++
 tests/xfs/1560     |   52 +++++
 tests/xfs/1560.out |  220 +++++++++++++++++++++++
 tests/xfs/1561     |   52 +++++
 tests/xfs/1561.out |   20 ++
 tests/xfs/group    |   40 ++++
 81 files changed, 7856 insertions(+)
 create mode 100755 tests/xfs/1500
 create mode 100644 tests/xfs/1500.out
 create mode 100755 tests/xfs/1501
 create mode 100644 tests/xfs/1501.out
 create mode 100755 tests/xfs/1502
 create mode 100644 tests/xfs/1502.out
 create mode 100755 tests/xfs/1503
 create mode 100644 tests/xfs/1503.out
 create mode 100755 tests/xfs/1504
 create mode 100644 tests/xfs/1504.out
 create mode 100755 tests/xfs/1505
 create mode 100644 tests/xfs/1505.out
 create mode 100755 tests/xfs/1506
 create mode 100644 tests/xfs/1506.out
 create mode 100755 tests/xfs/1507
 create mode 100644 tests/xfs/1507.out
 create mode 100755 tests/xfs/1508
 create mode 100644 tests/xfs/1508.out
 create mode 100755 tests/xfs/1509
 create mode 100644 tests/xfs/1509.out
 create mode 100755 tests/xfs/1510
 create mode 100644 tests/xfs/1510.out
 create mode 100755 tests/xfs/1511
 create mode 100644 tests/xfs/1511.out
 create mode 100755 tests/xfs/1512
 create mode 100644 tests/xfs/1512.out
 create mode 100755 tests/xfs/1513
 create mode 100644 tests/xfs/1513.out
 create mode 100755 tests/xfs/1514
 create mode 100644 tests/xfs/1514.out
 create mode 100755 tests/xfs/1515
 create mode 100644 tests/xfs/1515.out
 create mode 100755 tests/xfs/1516
 create mode 100644 tests/xfs/1516.out
 create mode 100755 tests/xfs/1517
 create mode 100644 tests/xfs/1517.out
 create mode 100755 tests/xfs/1518
 create mode 100644 tests/xfs/1518.out
 create mode 100755 tests/xfs/1519
 create mode 100644 tests/xfs/1519.out
 create mode 100755 tests/xfs/1520
 create mode 100644 tests/xfs/1520.out
 create mode 100755 tests/xfs/1521
 create mode 100644 tests/xfs/1521.out
 create mode 100755 tests/xfs/1522
 create mode 100644 tests/xfs/1522.out
 create mode 100755 tests/xfs/1523
 create mode 100644 tests/xfs/1523.out
 create mode 100755 tests/xfs/1524
 create mode 100644 tests/xfs/1524.out
 create mode 100755 tests/xfs/1525
 create mode 100644 tests/xfs/1525.out
 create mode 100755 tests/xfs/1526
 create mode 100644 tests/xfs/1526.out
 create mode 100755 tests/xfs/1527
 create mode 100644 tests/xfs/1527.out
 create mode 100755 tests/xfs/1528
 create mode 100644 tests/xfs/1528.out
 create mode 100755 tests/xfs/1529
 create mode 100644 tests/xfs/1529.out
 create mode 100755 tests/xfs/1530
 create mode 100644 tests/xfs/1530.out
 create mode 100755 tests/xfs/1531
 create mode 100644 tests/xfs/1531.out
 create mode 100755 tests/xfs/1532
 create mode 100644 tests/xfs/1532.out
 create mode 100755 tests/xfs/1533
 create mode 100644 tests/xfs/1533.out
 create mode 100755 tests/xfs/1534
 create mode 100644 tests/xfs/1534.out
 create mode 100755 tests/xfs/1535
 create mode 100644 tests/xfs/1535.out
 create mode 100755 tests/xfs/1536
 create mode 100644 tests/xfs/1536.out
 create mode 100755 tests/xfs/1537
 create mode 100644 tests/xfs/1537.out
 create mode 100755 tests/xfs/1560
 create mode 100644 tests/xfs/1560.out
 create mode 100755 tests/xfs/1561
 create mode 100644 tests/xfs/1561.out


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C323C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C77E2076E
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbgLaWvA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:51:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58716 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbgLaWu7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:50:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMkxZC155774;
        Thu, 31 Dec 2020 22:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bNQ9cBLDzORJwVEDO3EqDLRQdbx65f7Xai6fpYOKET4=;
 b=J1lQxVnDDHIN409mUceucdMdIHoo1xTFOoiDcZtLtvlnNZcZl2OJKL5Bvvroq0JFgCE/
 rntLYJju3hwImBmGisiVbqvS3pzFi52YwAvefiT2xyvEGPXcbThZrqAKUSotmQ/GupAk
 FKR1u9sepEHTmFky+A60wLnpTpW05ScvwhUnCQv0dqDOaN96AqM8W1guXRrM+kqP9aZo
 pCsN5obKoRrp+nKiFw0Y4UZTdLeqMbiYy5a/UU70wt8jxEdqT6c5RPFULPUleP7YbN2M
 Ezdyj8nI6mdc8mkqPzBArvdFIa4bfVMplh+qSu9fVtB/FNOK18bLb2n+hC6As4IYLw3C eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 31 Dec 2020 22:50:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMj7xJ016133;
        Thu, 31 Dec 2020 22:48:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35pf40pfgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Dec 2020 22:48:16 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMmF7X026211;
        Thu, 31 Dec 2020 22:48:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:48:15 -0800
Subject: [PATCHSET 0/5] xfstests: establish baseline for fuzz tests
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:48:12 -0800
Message-ID: <160945489277.2837367.11419591381764300886.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 mlxlogscore=909 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=921 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Establish a baseline golden output for the fuzz tests.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fuzz-baseline
---
 tests/xfs/1554     |   51 ++++
 tests/xfs/1554.out |  392 +++++++++++++++++++++++++++++++
 tests/xfs/1555     |   51 ++++
 tests/xfs/1555.out |   41 +++
 tests/xfs/1556     |   51 ++++
 tests/xfs/1556.out |   10 +
 tests/xfs/1557     |   51 ++++
 tests/xfs/1557.out |   89 +++++++
 tests/xfs/1558     |   51 ++++
 tests/xfs/1558.out |   18 +
 tests/xfs/1559     |   51 ++++
 tests/xfs/1559.out |   10 +
 tests/xfs/350.out  |  133 ++++++++++
 tests/xfs/351.out  |   68 +++++
 tests/xfs/353.out  |  114 +++++++++
 tests/xfs/354.out  |   93 +++++++
 tests/xfs/355.out  |   49 ++++
 tests/xfs/356.out  |   13 +
 tests/xfs/357.out  |  131 ++++++++++
 tests/xfs/358.out  |    5 
 tests/xfs/360.out  |   30 ++
 tests/xfs/361.out  |   14 +
 tests/xfs/362.out  |    5 
 tests/xfs/364.out  |    2 
 tests/xfs/366.out  |    2 
 tests/xfs/368.out  |   11 +
 tests/xfs/369.out  |  190 +++++++++++++++
 tests/xfs/370.out  |  330 ++++++++++++++++++++++++++
 tests/xfs/372.out  |    6 
 tests/xfs/373.out  |   75 ++++++
 tests/xfs/374.out  |  114 +++++++++
 tests/xfs/375.out  |  217 +++++++++++++++++
 tests/xfs/376.out  |  104 ++++++++
 tests/xfs/377.out  |  204 ++++++++++++++++
 tests/xfs/378.out  |  101 ++++++++
 tests/xfs/379.out  |  195 +++++++++++++++
 tests/xfs/380.out  |    6 
 tests/xfs/382.out  |    4 
 tests/xfs/383.out  |    4 
 tests/xfs/384.out  |  122 ++++++++++
 tests/xfs/385.out  |  638 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/386.out  |   49 ++++
 tests/xfs/387.out  |  658 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/388.out  |  369 +++++++++++++++++++++++++++++
 tests/xfs/389.out  |  661 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/392.out  |   18 +
 tests/xfs/393.out  |    5 
 tests/xfs/394.out  |   12 +
 tests/xfs/398.out  |  158 ++++++++++++
 tests/xfs/399.out  |  242 +++++++++++++++++++
 tests/xfs/400.out  |  226 ++++++++++++++++++
 tests/xfs/401.out  |  275 ++++++++++++++++++++++
 tests/xfs/402.out  |    7 +
 tests/xfs/404.out  |   33 +++
 tests/xfs/405.out  |    5 
 tests/xfs/406.out  |   34 +++
 tests/xfs/407.out  |   28 ++
 tests/xfs/408.out  |  143 +++++++++++
 tests/xfs/409.out  |   16 +
 tests/xfs/410.out  |    6 
 tests/xfs/412.out  |  100 ++++++++
 tests/xfs/413.out  |  173 ++++++++++++++
 tests/xfs/414.out  |   98 ++++++++
 tests/xfs/415.out  |  238 +++++++++++++++++++
 tests/xfs/416.out  |   91 +++++++
 tests/xfs/417.out  |  233 ++++++++++++++++++
 tests/xfs/418.out  |  143 +++++++++++
 tests/xfs/425.out  |   90 +++++++
 tests/xfs/426.out  |   65 +++++
 tests/xfs/427.out  |   90 +++++++
 tests/xfs/428.out  |   65 +++++
 tests/xfs/429.out  |   90 +++++++
 tests/xfs/430.out  |   65 +++++
 tests/xfs/453.out  |  169 +++++++++++++
 tests/xfs/454.out  |   99 ++++++++
 tests/xfs/455.out  |  135 +++++++++++
 tests/xfs/456.out  |  132 ++++++++++
 tests/xfs/457.out  |    5 
 tests/xfs/458.out  |   44 +++
 tests/xfs/459.out  |    5 
 tests/xfs/460.out  |    9 +
 tests/xfs/461.out  |    2 
 tests/xfs/462.out  |   12 +
 tests/xfs/463.out  |  351 ++++++++++++++++++++++++++++
 tests/xfs/464.out  |   81 ++++++
 tests/xfs/465.out  |  267 +++++++++++++++++++++
 tests/xfs/466.out  |  249 ++++++++++++++++++++
 tests/xfs/467.out  |  242 +++++++++++++++++++
 tests/xfs/469.out  |    8 +
 tests/xfs/470.out  |  287 +++++++++++++++++++++++
 tests/xfs/471.out  |   22 ++
 tests/xfs/472.out  |   23 ++
 tests/xfs/474.out  |   20 ++
 tests/xfs/475.out  |    6 
 tests/xfs/477.out  |  337 +++++++++++++++++++++++++++
 tests/xfs/478.out  |  492 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/479.out  |    7 +
 tests/xfs/480.out  |   24 ++
 tests/xfs/481.out  |   32 +++
 tests/xfs/482.out  |  142 +++++++++++
 tests/xfs/483.out  |    6 
 tests/xfs/484.out  |  239 +++++++++++++++++++
 tests/xfs/485.out  |  224 ++++++++++++++++++
 tests/xfs/486.out  |  235 ++++++++++++++++++
 tests/xfs/487.out  |  137 +++++++++++
 tests/xfs/488.out  |  137 +++++++++++
 tests/xfs/489.out  |  137 +++++++++++
 tests/xfs/496.out  |   24 ++
 tests/xfs/498.out  |   12 +
 tests/xfs/713.out  |   14 +
 tests/xfs/group    |    6 
 111 files changed, 12704 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1554
 create mode 100644 tests/xfs/1554.out
 create mode 100755 tests/xfs/1555
 create mode 100644 tests/xfs/1555.out
 create mode 100755 tests/xfs/1556
 create mode 100644 tests/xfs/1556.out
 create mode 100755 tests/xfs/1557
 create mode 100644 tests/xfs/1557.out
 create mode 100755 tests/xfs/1558
 create mode 100644 tests/xfs/1558.out
 create mode 100755 tests/xfs/1559
 create mode 100644 tests/xfs/1559.out


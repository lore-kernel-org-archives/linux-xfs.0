Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C788EC388F9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77EEF21D42
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qpxE2o7L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501996AbgJ0TDZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:03:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47044 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444462AbgJ0TDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:03:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItLQA108159;
        Tue, 27 Oct 2020 19:03:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=7PqWsaYXvE8tUExoUneXqH2S2J0SDvKTjNriWOK/F80=;
 b=qpxE2o7L2pFemAZ5nyBq017O+RCpo67L9bju/tAXqykJWDcrv+CjkPT5jKnPJSJuwOj3
 L+dfOcddDWuXIBE+RZ0zxxAA3csbeT201GfXBnObt6P2U+l7S71Qo1Ad+82YtCNJOOBx
 jvoK585wP5IssJ+bYMvzhKUuxo70BPjIEFkTVnMbZKm8iQti3OgTr4MjABlqLm/cbOxg
 mfIQ257rmPHnzoPYZtLFHQ61bylO/xoB0DMTsk2frR4KZWmHA5+aW/xTP5M4AlQmrp/l
 M5Pmzlpgiapbhy2vJiHda1KwqcEKu7+PlC7ybTjZEVFJH5/rwt+TnWra7vfmJ0QzlQLD hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kuuw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:03:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsQ1B076600;
        Tue, 27 Oct 2020 19:03:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwumrjtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:03:22 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RJ3LBZ028003;
        Tue, 27 Oct 2020 19:03:21 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:03:21 -0700
Subject: [PATCH RFC 0/2] xfs_db: add minimal directory navigation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:03:20 -0700
Message-ID: <160382540004.1203622.14607732322524118731.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are functional tests for a couple of xfs_db tests to improve the
usability of xfs_db by enabling users to navigate to inodes by path and
to list the contents of directories.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs_db-directory-navigation

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs_db-directory-navigation
---
 tests/xfs/917     |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/917.out |   19 ++++++++++
 tests/xfs/918     |   87 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/918.out |   23 ++++++++++++
 tests/xfs/group   |    2 +
 5 files changed, 229 insertions(+)
 create mode 100755 tests/xfs/917
 create mode 100644 tests/xfs/917.out
 create mode 100755 tests/xfs/918
 create mode 100644 tests/xfs/918.out


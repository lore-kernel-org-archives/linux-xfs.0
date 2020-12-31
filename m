Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A578CC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D54207A2
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgLaWtX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:49:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57840 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbgLaWtV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:49:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMmdV6156628;
        Thu, 31 Dec 2020 22:48:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aa1mUzScJhpEW5EUmWxgreZ6CThiQNFHImARYx2TBEo=;
 b=eCViAzC0r1VG31jpIsUggaTPQ/U6tU05WO57EfwoXJ6vRRd2bCtz7VT/UUS/XdUmEtR3
 UOnli639lLdBMA0qg9oV5IP+VgCo6YyJTsP9hFNlBPJRARRNO7eXLddA7+qxj91Tz7ng
 IxU+TpDitn9KKVamDePZCEKWis+Itp0IWtFGEVnIhVS1ZJsGFKJDXHVbJlOt/G85ib+e
 XptJdiDsRujwXLfcTMgFIiE9tC0RHt24bJQQE2+jdJDdk68x3+y0ep4y7JWSS+MGcIzX
 qCJ+x1GbEdD5rU8iIBjfg4tRbCAAIeBGu5t/GkY4S4oAaMw19PaEedORhhgk8GRkBvIp cA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 31 Dec 2020 22:48:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMj4Yn015836;
        Thu, 31 Dec 2020 22:48:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35pf40pg9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Dec 2020 22:48:38 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMmcZe004364;
        Thu, 31 Dec 2020 22:48:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:48:37 -0800
Subject: [PATCHSET 0/3] common/dm*: support external log and rt devices
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:48:36 -0800
Message-ID: <160945491676.2837714.5992879624452060269.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There are a growing number of fstests that examine what happens to a
filesystem when the block device underneath it goes offline.  Many of
them do this to simulate system crashes, and none of them (outside of
btrfs) can handle filesystems with multiple devices.  XFS is one of
those beasts that does, so enhance the dm-error and dm-flakey helpers to
take the log and rt devices offline when they're testing the data
device.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=dmerror-on-rt-devices
---
 common/dmerror    |  163 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 common/dmflakey   |  106 +++++++++++++++++++++++++++++++++-
 tests/generic/250 |    3 -
 tests/generic/252 |    3 -
 tests/generic/441 |    3 -
 tests/generic/484 |    3 -
 tests/generic/487 |    3 -
 7 files changed, 257 insertions(+), 27 deletions(-)


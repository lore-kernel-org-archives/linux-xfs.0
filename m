Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BBBC4741F
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6407820797
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jJHSyESQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgKJSDZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:03:25 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52024 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKJSDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:03:24 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHxrkS048755;
        Tue, 10 Nov 2020 18:03:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=EyAUCOxqtMoukpDHDSmR7s3mUDnZLBj12Zx9hBE65nk=;
 b=jJHSyESQzu6/TvyPudUjnvLMu17MeeMvEZb1QxG33ibnjRrOUWzODU00V2S5Np60S50j
 qFi304YPb/+BQp0cAWZM0y8gkxfJN9/aCxl0QrFB3XvSQl3nL+Ds/udSP1N3U6jZUAqG
 rQbuL70ETXlNqxOj7T4/G67vJXtgFycCoVKDlqeHO5MuJ3lFGtLuqu3ZgYpiVo9iMFS7
 UUkR2n21SxSiEWZUTVeXTphBtqXn2uThCmecIwz3BUj2KvPW+d4ltx3TBGsXNTRbhNXv
 4HuNrenR+O47ULwJV/tjqvn8jdw7Vg7r5nbSN0hcZigIRka4uVoIu6HqsCJztJcHjULU Rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3aw94e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 18:03:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAI16i2092666;
        Tue, 10 Nov 2020 18:03:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34qgp76knm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 18:03:12 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AAI34D0012260;
        Tue, 10 Nov 2020 18:03:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 10:03:04 -0800
Subject: [PATCH v2 0/9] xfsprogs: fixes for 5.10
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 10 Nov 2020 10:03:02 -0800
Message-ID: <160503138275.1201232.927488386999483691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fix a few bugs ahead of landing all the 5.10 stuff.

v2: Add a few more fixes and cleanups.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.10-fixes
---
 db/check.c          |   33 +++++++++
 man/man8/mkfs.xfs.8 |   17 ++++-
 mkfs/xfs_mkfs.c     |   14 +++-
 repair/dinode.c     |  180 ++++++++++++++++++++++++++++++++-------------------
 repair/rmap.c       |    4 +
 repair/scan.c       |   36 +++++++---
 scrub/fscounters.c  |    8 +-
 scrub/fscounters.h  |    2 -
 scrub/phase6.c      |    7 +-
 scrub/phase7.c      |    5 -
 tools/libxfs-apply  |   14 +++-
 11 files changed, 213 insertions(+), 107 deletions(-)


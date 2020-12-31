Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF08C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88451206D7
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgLaWqG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:46:06 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56136 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgLaWqF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:46:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMjPMM155305
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=UP/5LGW8yIJSgP3EmqDnicMNi+7/slu0IDuQIUW0dLM=;
 b=fDVpW/CHPXcoUAsaNvyOKTsy5d04Jur5w3EENC3DTzax85bj4JKSPTYeJ0K04wci8QC6
 q5UVY6jNbK29TJ4QiUGBKjj8nweUYwPkvFmJmO071EePuzgB5ffN2Jo9ET3Dg9kpqdJ1
 sa/STZMTzJycDWt/J5f54v8j1HSRsNo7jt8bYAETN7h4iOQVH00L6w+NKXdZRLQWHPSQ
 Cv4CNlqYWAA1Tkz5AvGdJp0exqXxFpnFeSOXwjf0cnUmfC0GVcYPyg+Tn5I5CPTvMrNw
 SmdAFWPo98KbVQFeJt1XGDI1iuud4qG6fn2FI2OUQ3WaOC9HkO62V19BpTQk416WClV2 Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe50p143849
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35pexuktc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:24 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMhNjv018190
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:43:23 -0800
Subject: [PATCHSET v22 0/6] xfs: online repair of quota and counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:43:22 -0800
Message-ID: <160945460218.2828925.12278060521110365609.stgit@magnolia>
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
 definitions=main-2012310134
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

This series starts by implementing quick repairs for obvious problems
with quota records.  Next, we implement a new scrubber to check all
quota counters in the system.  This is done by walking all inodes (just
like mount time quotacheck) but with the added twist that the online
quotacheck code hooks the regular quota update mechanism to stay abreast
of changes to quota counters, thereby ensuring that the quota counters
are always up to date.  The series ends by adding the ability to commit
the new counters to the dquots.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quota

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quota

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-quota
---
 fs/xfs/Kconfig                   |    1 
 fs/xfs/Makefile                  |   11 
 fs/xfs/libxfs/xfs_bmap.c         |   41 ++
 fs/xfs/libxfs/xfs_bmap.h         |    3 
 fs/xfs/libxfs/xfs_fs.h           |    3 
 fs/xfs/scrub/bmap_repair.c       |   16 +
 fs/xfs/scrub/common.c            |   11 
 fs/xfs/scrub/common.h            |   16 +
 fs/xfs/scrub/quota.c             |   12 -
 fs/xfs/scrub/quota.h             |   11 
 fs/xfs/scrub/quota_repair.c      |  401 ++++++++++++++++++
 fs/xfs/scrub/quotacheck.c        |  838 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/quotacheck.h        |   73 +++
 fs/xfs/scrub/quotacheck_repair.c |  247 +++++++++++
 fs/xfs/scrub/repair.c            |   80 ++++
 fs/xfs/scrub/repair.h            |   12 +
 fs/xfs/scrub/scrub.c             |   20 +
 fs/xfs/scrub/scrub.h             |   12 +
 fs/xfs/scrub/trace.c             |    1 
 fs/xfs/scrub/trace.h             |   27 +
 fs/xfs/xfs_inode.c               |   26 -
 fs/xfs/xfs_iwalk.c               |  118 +++++
 fs/xfs/xfs_iwalk.h               |    3 
 fs/xfs/xfs_mount.c               |   43 ++
 fs/xfs/xfs_mount.h               |   10 
 fs/xfs/xfs_qm.c                  |   18 -
 fs/xfs/xfs_qm.h                  |   15 +
 fs/xfs/xfs_quota.h               |   19 +
 fs/xfs/xfs_trans_dquot.c         |   72 +++
 29 files changed, 2100 insertions(+), 60 deletions(-)
 create mode 100644 fs/xfs/scrub/quota.h
 create mode 100644 fs/xfs/scrub/quota_repair.c
 create mode 100644 fs/xfs/scrub/quotacheck.c
 create mode 100644 fs/xfs/scrub/quotacheck.h
 create mode 100644 fs/xfs/scrub/quotacheck_repair.c


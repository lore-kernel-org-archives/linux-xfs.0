Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0C8C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E48020658
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgLaWqw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:46:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56528 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgLaWqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:46:52 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMkBFN155379
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0GdUOOP16zU2pgrBv6VGGTELN6KALd/T7x1o4gdML2k=;
 b=GT5EkpGXnfYlyqKmz7XgVYRjWVo8cKUy6ht/ZvmzIbKPtorJD9B6HZaihoNT8WjAlKhN
 dPWKMA+Urm69gKUEJgiCqmeb1oNhiLXBgd8oOX8u3h6LSAjPeJg7jaqQS1WXWn092dGx
 9wytSkNDBRuBUEPIxYbhMvICbeFHROTZSDr4jjfELvOK2QdIWXurqgEOH+smqxYgIfSo
 zP9L5ns1rpZvkfYPtxlxnzEE0h65Wx7zYOvQrnRpCQOUf4MgKWGPtoviZollkG1umUhH
 V0Zf387YaYG/PAtVMCy1C8l1N4yaJrCE3RpW29kgvzGrIj2dDWrh0h+Hh4KUJq3tWSri bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe5W9143819
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35pexuktkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:10 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMi9ON008434
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:44:09 -0800
Subject: [PATCHSET v22 0/5] xfs: online repair hard problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:44:08 -0800
Message-ID: <160945464874.2830632.6081935213178010313.stgit@magnolia>
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

This series tackles hard problems for online repair to solve.  Hard
problems are defined as ones that cannot be done without running afoul
of the regular xfs locking and synchronization rules.

We solve these problems by adding ability to freeze the filesystem to
perform a scrub operation, and then we add a couple more repair
functions to deal with incorrect fs summary counters and rebuild reverse
mapping btrees.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-hard-problems

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-hard-problems

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-hard-problems
---
 fs/xfs/Makefile                  |    2 
 fs/xfs/libxfs/xfs_bmap.c         |   34 +
 fs/xfs/libxfs/xfs_bmap.h         |    8 
 fs/xfs/libxfs/xfs_fs.h           |    6 
 fs/xfs/scrub/bitmap.c            |   14 
 fs/xfs/scrub/bitmap.h            |    1 
 fs/xfs/scrub/common.c            |   91 +++
 fs/xfs/scrub/common.h            |    2 
 fs/xfs/scrub/fscounters.c        |   90 ++-
 fs/xfs/scrub/fscounters_repair.c |   63 ++
 fs/xfs/scrub/repair.c            |   27 +
 fs/xfs/scrub/repair.h            |   17 
 fs/xfs/scrub/rmap.c              |    6 
 fs/xfs/scrub/rmap_repair.c       | 1344 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c             |   14 
 fs/xfs/scrub/scrub.h             |    1 
 fs/xfs/scrub/trace.h             |   51 +
 fs/xfs/xfs_icache.c              |    3 
 fs/xfs/xfs_icache.h              |    6 
 fs/xfs/xfs_mount.h               |    7 
 fs/xfs/xfs_super.c               |   47 +
 fs/xfs/xfs_trans.c               |    5 
 22 files changed, 1796 insertions(+), 43 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters_repair.c
 create mode 100644 fs/xfs/scrub/rmap_repair.c


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88067C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54D0120678
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgLaWo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:44:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55268 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgLaWo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:44:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMfXDe152789
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VrnlcLBKKQr5L7IkyBD5NfB14tv3QWsT85ErV0EFAp8=;
 b=z6IQFcPzvhVVIqjvPulnc4eOfwzCN4pTIMDDw5EpT4/ZX/tNHuwc799fzSMzmizdu49i
 GyU/2PdO9b4UUG1lR1I2+jAaTVNqzCELf2n9EQmyny5ZHU8rgP9LUdfl9/pQXRaVQ6Kh
 tNJtVoCKray4Kd5x92QgtKQXCGHOG+0/mfACYYNkkmXl3SdOZi46YKqDpDKTYHHGXJyO
 sVOeKTahy1x05hHcAJUVXQWknVH4QEBaxbb+rP0U7aQf9zc4eAqvkETZaTqGCQs9topb
 O+zsKmliflngqvk+j4rmYYK/mYL1QycqaS/+hIcfNvy+ijUlq3kfaawH5gdJe4t/g9gt 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMf69m008349
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35pf40p7b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:47 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMhkS1018297
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:43:46 -0800
Subject: [PATCHSET 0/6] xfs: consolidate posteof and cowblocks cleanup
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:43:45 -0800
Message-ID: <160945462553.2829246.730655044170661817.stgit@magnolia>
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
 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Currently, we treat the garbage collection of post-EOF preallocations
and copy-on-write preallocations as totally separate tasks -- different
incore inode tags, different workqueues, etc.  This is wasteful of radix
tree tags and workqueue resources since we effectively have parallel
code paths to do the same thing.

Therefore, consolidate both functions under one radix tree bit and one
workqueue function that scans an inode for both things at the same time.
At the end of the series we make the scanning per-AG instead of per-fs
so that the scanning can run in parallel.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=eofblocks-consolidation

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=eofblocks-consolidation
---
 fs/xfs/scrub/common.c  |    4 -
 fs/xfs/xfs_bmap_util.c |  109 ++++++++++------------
 fs/xfs/xfs_globals.c   |    7 +
 fs/xfs/xfs_icache.c    |  237 +++++++++++++++++++++++-------------------------
 fs/xfs/xfs_icache.h    |   13 +--
 fs/xfs/xfs_inode.c     |   36 +++++++
 fs/xfs/xfs_inode.h     |    2 
 fs/xfs/xfs_linux.h     |    3 -
 fs/xfs/xfs_mount.c     |    5 +
 fs/xfs/xfs_mount.h     |    9 +-
 fs/xfs/xfs_super.c     |   43 ++++++---
 fs/xfs/xfs_sysctl.c    |   15 +--
 fs/xfs/xfs_sysctl.h    |    3 -
 fs/xfs/xfs_trace.h     |    6 -
 14 files changed, 256 insertions(+), 236 deletions(-)


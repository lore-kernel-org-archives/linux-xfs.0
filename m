Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A065C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F6720678
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgLaWoh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:44:37 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55302 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgLaWoh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:44:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMeYgr152305
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+/6za46DLCTAWkhgTzC5+1DJeJgfEVIOPHJRJhtgxhk=;
 b=vCEoklrngz/CRbQNT6nbMROpuqWo8yw1MMS0ETRtOdLkVQqLg6q+dJVOsjuoy7hMK2wS
 C7ju6qxozPrdPABcIlYKoFC+sSvvL0hP4rHuK/Q2cYnEwIRlnC2P3AHF+A760ZzzjZnG
 o2CkSP9kvNsbv7/AznQuqqiSpgIaYVHaUGqaQvas9pQhtCeyc4UeNpXlLWNHTiIdG7+B
 zKY6Hk6H5fkD4fh7uC/iwVyDqjB4U2fyzqJVlgUTx9hca23Sr8T/FCY1tLt9/vGKKipl
 pu5LAGEXInbypRDFLZqX2TpbpIA/OQ156rqxfe6vwbZ8E/f+o4V17P7fNY9r1eTyux8P Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMf5tu008202
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35pf40p7mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMhsIk018304
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:43:54 -0800
Subject: [PATCHSET v2 0/7] xfs: deferred inode inactivation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:43:53 -0800
Message-ID: <160945463320.2829350.7049216038166756070.stgit@magnolia>
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

This patch series implements deferred inode inactivation.  Inactivation
is the process of updating all on-disk metadata when a file is deleted
-- freeing the data/attr/COW fork extent allocations, removing the inode
from the unlinked hash, marking the inode record itself free, and
updating the inode btrees so that they show the inode as not being in
use.

Currently, all this inactivation is performed during in-core inode
reclaim, which creates two big headaches: first, this makes direct
memory reclamation /really/ slow, and second, it prohibits us from
partially freezing the filesystem for online fsck activity because scrub
can hit direct memory reclaim.  It's ok for scrub to fail with ENOMEM,
but it's not ok for scrub to deadlock memory reclaim. :)

The implementation will be familiar to those who have studied how XFS
scans for reclaimable in-core inodes -- we create a couple more inode
state flags to mark an inode as needing inactivation and being in the
middle of inactivation.  When inodes need inactivation, we set iflags,
set the RECLAIM radix tree tag, update a count of how many resources
will be freed by the pending inactivations, and schedule a deferred work
item.  The deferred work item scans the inode radix tree for inodes to
inactivate, and does all the on-disk metadata updates.  Once the inode
has been inactivated, it is left in the reclaim state and the background
reclaim worker (or direct reclaim) will get to it eventually.

Patch 1-2 refactor some of the inactivation predicates.

Patches 3-4 implement the count of blocks/quota that can be freed by
running inactivation; this is necessary to preserve the behavior where
you rm a file and the fs counters update immediately.

Patches 5-6 refactor more inode reclaim code so that we can reuse some
of it for inactivation.

Patch 8 delivers the core of the inactivation changes by altering the
inode lifetime state machine to include the new inode flags and
background workers.

Patches 9-10 makes it so that if an allocation attempt hits ENOSPC it
will force inactivation to free resources and try again.

Patch 11 converts the per-fs inactivation scanner to be tracked on a
per-AG basis so that we can be more targeted in our inactivation.

Patches 12-14 teach the per-AG sick status to remember if we inactivate
inodes that themselves had unfixed sick flags set, and for scrub to
clear all those flags if it finds that the filesystem is clean.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation
---
 fs/xfs/scrub/common.c     |    2 
 fs/xfs/scrub/quotacheck.c |    7 +
 fs/xfs/xfs_bmap_util.c    |   38 +++
 fs/xfs/xfs_fsops.c        |    9 +
 fs/xfs/xfs_icache.c       |  555 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h       |   13 +
 fs/xfs/xfs_inode.c        |  102 ++++++++
 fs/xfs/xfs_inode.h        |   15 +
 fs/xfs/xfs_iomap.c        |   14 +
 fs/xfs/xfs_log_recover.c  |    7 +
 fs/xfs/xfs_mount.c        |   23 ++
 fs/xfs/xfs_mount.h        |   12 +
 fs/xfs/xfs_qm.c           |   29 ++
 fs/xfs/xfs_qm.h           |   17 +
 fs/xfs/xfs_qm_syscalls.c  |   20 ++
 fs/xfs/xfs_super.c        |   63 ++++-
 fs/xfs/xfs_trace.h        |   15 +
 17 files changed, 909 insertions(+), 32 deletions(-)


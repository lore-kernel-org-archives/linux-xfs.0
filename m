Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A29BC433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 269B3206E4
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgLaWsE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:48:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59132 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgLaWsE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:48:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMj7jQ018873
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:47:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vqLlyzMAgotfp9nTsmE9f9dIKUQB4fQmrc9YAHdYp3I=;
 b=jKVWYGVIAf+RsIoFHdEdqsl/rIL4BIjp9GIfN0rui7KgRwX6/Ve85fBWEFBwIYGtsxwo
 rvnNPYC/dE3VMpxzoSNOlagariPMq2UKPmTltzf92x42gu0r8h3PC0xOR1QH9ZxgUWuE
 qvKzjsw3eWUDEWZpp0T5D2hOZXq6BCGMjqHq2ZJxCSMDG6HUtgWXIC8iHslZ4y5Wpz2r
 6gqSB+gVgDYZBZouZifoRs7+rGChjfKjYri9ZqPvMa1oiBtal85iETE8zHS9heTSdQdQ
 aWqNXUcKfUu7hDfIkIWTB4Cbb52Y1EY5zbfhqI0Ypnx9UGD0Y4h3BpKQwnrFoq7d5cSv 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35nvkquwbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:47:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe8Bn015241
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35perpndpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:22 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMjLC7025193
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:45:21 -0800
Subject: [PATCHSET 00/14] xfs: refactor btrees to support records in inode
 root
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:45:20 -0800
Message-ID: <160945472041.2831685.11898007701914419132.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series prepares the btree code to support realtime reverse mapping
btrees by refactoring xfs_ifork_realloc to be fed a per-btree ops
structure so that it can handle multiple types of inode-rooted btrees.
It moves on to refactoring the btree code to use the new realloc
routines and to support storing btree rcords in the inode root, because
the current bmbt code does not support this.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-ifork-records

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-ifork-records
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    6 -
 fs/xfs/libxfs/xfs_alloc_btree.h    |    3 
 fs/xfs/libxfs/xfs_attr_leaf.c      |    8 -
 fs/xfs/libxfs/xfs_bmap.c           |   60 ++----
 fs/xfs/libxfs/xfs_bmap_btree.c     |   94 ++++++++-
 fs/xfs/libxfs/xfs_bmap_btree.h     |  219 +++++++++++++++------
 fs/xfs/libxfs/xfs_btree.c          |  382 ++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_btree.h          |    4 
 fs/xfs/libxfs/xfs_btree_staging.c  |    4 
 fs/xfs/libxfs/xfs_ialloc.c         |    4 
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    6 -
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    3 
 fs/xfs/libxfs/xfs_inode_fork.c     |  168 +++++++---------
 fs/xfs/libxfs/xfs_inode_fork.h     |   27 ++-
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 
 fs/xfs/libxfs/xfs_rmap_btree.c     |    7 -
 fs/xfs/libxfs/xfs_rmap_btree.h     |    3 
 fs/xfs/libxfs/xfs_sb.c             |   16 +-
 fs/xfs/libxfs/xfs_trans_resv.c     |    2 
 fs/xfs/scrub/bmap_repair.c         |    4 
 fs/xfs/scrub/inode_repair.c        |    2 
 fs/xfs/xfs_xchgrange.c             |    4 
 23 files changed, 705 insertions(+), 329 deletions(-)


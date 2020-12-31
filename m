Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8BFC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4D2320658
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgLaWqN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:46:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgLaWqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:46:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMjVmS147725
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YOZjpG7Wfk4AkyvNAYuvQKiKAQsIJGVbkReN1uBxeH8=;
 b=KbOipc0m4SHbvPWjyyUn2QpzIztllg0xyvyPRDnaacAB59c+2blZPkJ40u0UYNubsGSJ
 GUPMbj8XKt5SVw6VtGr9qQWxodg+dGJ0kYgbZnI3XYOhbn3SZFbs6mk+rqjOFUL6872X
 n2vX+Gro3856H0+Xg9YJbttdOZ0UN3zT0XkC7rbfXq27W6CMnbT24xs1ZA7IpZT3uu4Y
 B0fEc8Ka+AWV1a3jw7eWAXR9TC3le160ZYfNpaMKXZ42PbHYNe8tp5vx0w+PDvDUhyOG
 89U7b9QWHm3APNIzHst4qE09t6Hv1dUrUT6tlKuGZ234HsWk1J00wGKoc5r43MIjI+AI Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35phm1jt3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMj4nt015846
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35pf40p9a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:30 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMjTCY018825
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:45:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:45:29 -0800
Subject: [PATCHSET 00/13] xfs: support dynamic btree cursor height
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:45:28 -0800
Message-ID: <160945472844.2831845.17832405719589598191.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Rearrange the incore btree cursor so that we can support btrees of any
height.  This will become necessary for realtime rmap and reflink since
we'd like to handle tall trees without bloating the ag btree cursors.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-dynamic-depth

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-dynamic-depth
---
 fs/xfs/libxfs/xfs_ag_resv.c        |    4 -
 fs/xfs/libxfs/xfs_alloc.c          |   18 +--
 fs/xfs/libxfs/xfs_alloc_btree.c    |    8 -
 fs/xfs/libxfs/xfs_bmap.c           |   24 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c     |    7 -
 fs/xfs/libxfs/xfs_btree.c          |  236 ++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_btree.h          |   50 +++++---
 fs/xfs/libxfs/xfs_btree_staging.c  |    6 -
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    7 -
 fs/xfs/libxfs/xfs_refcount_btree.c |    6 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |   60 ++++++---
 fs/xfs/libxfs/xfs_trans_resv.c     |   18 ++-
 fs/xfs/libxfs/xfs_trans_space.h    |    7 +
 fs/xfs/scrub/agheader.c            |   13 +-
 fs/xfs/scrub/agheader_repair.c     |    8 +
 fs/xfs/scrub/bitmap.c              |   16 +-
 fs/xfs/scrub/bmap.c                |    2 
 fs/xfs/scrub/btree.c               |  124 ++++++++++---------
 fs/xfs/scrub/btree.h               |   17 ++-
 fs/xfs/scrub/repair.h              |    3 
 fs/xfs/scrub/trace.c               |    4 -
 fs/xfs/scrub/trace.h               |   10 +-
 fs/xfs/xfs_super.c                 |   11 --
 fs/xfs/xfs_trace.h                 |    2 
 24 files changed, 383 insertions(+), 278 deletions(-)


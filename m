Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF76C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9BD720658
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgLaWnu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:43:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53068 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgLaWnu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:43:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMdS5b015106
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zMzrNTsLO+dLoc0MEgoPyG8dmZlZ2txJo3C6DWZj/Kg=;
 b=x1A1PQe7iZq2+aSEhjvTzL8517Ow2uNIVeD3hy4hipielh7ZprHU0hOgr4hcP44y/s8z
 6o+jObzItwh7sH219FVA0LCxhckJQMXwd5PbwqgPMLsdTtqPoaVflJ8XN4beAOmo8rFr
 aW4YnO+XJavKaKoIY7CpsOpUDV7sXOD0C9cq+F54vKLDFiNCOrRPkbtpXOL3BPkZmD5K
 95FYD55Im/ia5IPiAlZZFDmyRwUP8cj1GLWI7TVu/Bp8Ideyahcv8wA/gILvD6TGm+46
 CHif6SLH692+4ADlvcKJiHMNdfSIafVA9XiHUt4IXp1bCnfd5R5rPYvcR9jNjKVBdzPe ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35nvkquw8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMf5xp008118
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35pf40p633-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:08 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMh7J9024565
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:43:07 -0800
Subject: [PATCHSET v22 0/4] xfs: online repair of AG btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:43:06 -0800
Message-ID: <160945458619.2828765.6206386218226536020.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the first part of the twenty-second revision of a patchset that
adds to XFS kernel support for online metadata scrubbing and repair.
There aren't any on-disk format changes.

New for this version is a rebase against 5.5-rc4, bulk loading of
btrees, integration with the health reporting subsystem, and the
explicit revalidation of all metadata structures that were rebuilt.

First, create a new data structure that provides an abstraction of a big
memory array by using linked lists.  This is where we store records for
btree reconstruction.  This first implementation is memory inefficient
and consumes a /lot/ of kernel memory, but lays the groundwork for a
later patch in the set to convert the implementation to use a (memfd)
swap file, which enables us to use pageable memory without pounding the
slab cache.

The three patches after that implement reconstruction of the free space
btrees, inode btrees, and reference count btree.  The reverse mapping
btree requires considerably more thought and will be covered later.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-ag-btrees

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-ag-btrees
---
 fs/xfs/Makefile                  |    3 
 fs/xfs/libxfs/xfs_ag_resv.c      |    2 
 fs/xfs/libxfs/xfs_ialloc.c       |   20 +
 fs/xfs/libxfs/xfs_ialloc.h       |    1 
 fs/xfs/libxfs/xfs_ialloc_btree.c |    2 
 fs/xfs/libxfs/xfs_ialloc_btree.h |    2 
 fs/xfs/libxfs/xfs_types.c        |   20 +
 fs/xfs/libxfs/xfs_types.h        |    9 
 fs/xfs/scrub/alloc_repair.c      |  761 +++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c            |    9 
 fs/xfs/scrub/health.c            |   10 
 fs/xfs/scrub/ialloc_repair.c     |  837 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/refcount_repair.c   |  653 ++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c            |   66 +++
 fs/xfs/scrub/repair.h            |   32 +
 fs/xfs/scrub/scrub.c             |   19 +
 fs/xfs/scrub/scrub.h             |    9 
 fs/xfs/scrub/trace.h             |  103 +++--
 fs/xfs/xfs_extent_busy.c         |   13 +
 fs/xfs/xfs_extent_busy.h         |    2 
 20 files changed, 2517 insertions(+), 56 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc_repair.c
 create mode 100644 fs/xfs/scrub/ialloc_repair.c
 create mode 100644 fs/xfs/scrub/refcount_repair.c


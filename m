Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A15BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6358420678
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgLaWn5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:43:57 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54966 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgLaWn5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:43:57 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMeUqL152299
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fz7cNuKhzuddOumlT2qzL2Hxt/YRb+i5wIRir9HTQIg=;
 b=OqTjVRtxra4uG2NZPpV13Eot7xz3cPFLib5WlWtSkucmGEeYnlGoTGF5QdpNro2MmqFw
 fRCKk1ErGP2O+FwtTfZqCtb0o/XTz8NSCgwEfQ7fhg1KXPVhAdPNbLauhbN/vnMjFla4
 3wzvypSMqx+sbrFyYH8VjKnXvw8s/d+cEbRxWhkPhJGQSdwkz5dxx76n+dksxxibc98N
 GVRpSjTr+q3+NuA/wC9UrvK0Mr4QiqvTrPwRmW6qQSkFQ4Bf08D3knH3EO+MGljXv9NL
 QN6tOz35Unf3hvEhwzS720JXCRkjgfVZ24Ej54lHNTlSyZiCu8Y27Rt75kheDnb3IQTZ 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe7b6015210
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35perpnd21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BVMhFxv018178
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:43:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:43:15 -0800
Subject: [PATCHSET v22 0/4] xfs: online repair of inodes and extent maps
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:43:14 -0800
Message-ID: <160945459423.2828845.8632761203647432250.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In the second part of the twenty-second revision of the online repair
patchset, we implement repairing of inode records, inode forks, and
inode block maps.  We also implement a meager symbolic link repair
ability.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inodes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-inodes
---
 fs/xfs/Makefile                   |    3 
 fs/xfs/libxfs/xfs_attr_leaf.c     |   32 +
 fs/xfs/libxfs/xfs_attr_leaf.h     |    2 
 fs/xfs/libxfs/xfs_bmap.c          |   22 +
 fs/xfs/libxfs/xfs_bmap.h          |    2 
 fs/xfs/libxfs/xfs_bmap_btree.c    |  117 +++-
 fs/xfs/libxfs/xfs_bmap_btree.h    |    8 
 fs/xfs/libxfs/xfs_btree_staging.c |   11 
 fs/xfs/libxfs/xfs_btree_staging.h |    8 
 fs/xfs/libxfs/xfs_format.h        |    3 
 fs/xfs/libxfs/xfs_iext_tree.c     |   23 +
 fs/xfs/libxfs/xfs_inode_fork.c    |    1 
 fs/xfs/libxfs/xfs_inode_fork.h    |    3 
 fs/xfs/scrub/bmap.c               |   22 +
 fs/xfs/scrub/bmap_repair.c        |  637 ++++++++++++++++++++++
 fs/xfs/scrub/inode_repair.c       | 1053 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/refcount_repair.c    |    6 
 fs/xfs/scrub/repair.h             |   24 +
 fs/xfs/scrub/scrub.c              |    8 
 fs/xfs/scrub/symlink.c            |    5 
 fs/xfs/scrub/symlink_repair.c     |  245 +++++++++
 fs/xfs/scrub/trace.h              |   34 +
 fs/xfs/xfs_symlink.c              |  147 +++--
 fs/xfs/xfs_symlink.h              |    3 
 fs/xfs/xfs_trans.c                |   54 ++
 fs/xfs/xfs_trans.h                |    2 
 26 files changed, 2347 insertions(+), 128 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap_repair.c
 create mode 100644 fs/xfs/scrub/inode_repair.c
 create mode 100644 fs/xfs/scrub/symlink_repair.c


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD01C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B59D020678
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgLaWrA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:47:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56606 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgLaWq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:46:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMiUTC154617
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0yB7lyt9yHZxyD7qGZVcSdicGLeWnif68OYrhGJyHUQ=;
 b=jivlt+xGsCPWk9TFShTAlpSEtCZ+AMYGGeFcQ+hY3DpEFHqY68c6H8kTuKjfM7pcFrB8
 7EMjLkXIyCHAmEpJiuijaCXlEpDjyqVsSFZe/NKdqeg75ffeTjxb/T0qR1geis4WatSs
 DZlnDjLLW0GPhS8JLIfvSQ+N6MILJj8eF8JEbwfx9mJOh6ZLSuev1FF/bXG6J/6/czop
 N0wcfI7zdSlgHA09HftpMNVg7eHlMxpi5OKcpEUGzSkGpWqtgQuA1VvIX6r2tSVv+v+p
 liTxwreSIn+85c6UIIL9DFx5dYqMaHV8wzLfRRwSyKZ0/xELa9E3PBP3CRoRUd7HLE92 MQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMj5qc015928
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35pf40pb65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:18 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMkHGT009149
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:46:17 -0800
Subject: [PATCHSET 00/31] xfs: reflink on the realtime device
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:46:16 -0800
Message-ID: <160945477567.2833676.4112646582104319587.stgit@magnolia>
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

This patchset enables use of the file data block sharing feature (i.e.
reflink) on the realtime device.  It follows the same basic sequence as
the realtime rmap series -- first a few cleanups; then widening of the
API parameters; and introduction of the new btree format and inode fork
format.  Next comes enabling CoW and remapping for the rt device; new
scrub, repair, and health reporting code; and at the end we implement
some code to lengthen write requests so that rt extents are always CoWed
fully.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-reflink
---
 fs/xfs/Makefile                      |    3 
 fs/xfs/libxfs/xfs_ag_resv.c          |    5 
 fs/xfs/libxfs/xfs_bmap.c             |   10 
 fs/xfs/libxfs/xfs_btree.c            |    8 
 fs/xfs/libxfs/xfs_btree.h            |   14 -
 fs/xfs/libxfs/xfs_format.h           |   53 ++-
 fs/xfs/libxfs/xfs_fs.h               |    4 
 fs/xfs/libxfs/xfs_health.h           |    4 
 fs/xfs/libxfs/xfs_imeta.c            |    2 
 fs/xfs/libxfs/xfs_imeta.h            |    1 
 fs/xfs/libxfs/xfs_inode_buf.c        |   20 +
 fs/xfs/libxfs/xfs_inode_fork.c       |   13 +
 fs/xfs/libxfs/xfs_log_format.h       |    5 
 fs/xfs/libxfs/xfs_refcount.c         |  693 ++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_refcount.h         |   34 +-
 fs/xfs/libxfs/xfs_rmap.c             |    4 
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  704 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |  184 +++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |   44 ++
 fs/xfs/libxfs/xfs_sb.c               |    8 
 fs/xfs/libxfs/xfs_shared.h           |    1 
 fs/xfs/libxfs/xfs_trans_resv.c       |   25 +
 fs/xfs/libxfs/xfs_types.h            |    5 
 fs/xfs/scrub/bmap.c                  |   12 +
 fs/xfs/scrub/bmap_repair.c           |    3 
 fs/xfs/scrub/common.c                |    8 
 fs/xfs/scrub/common.h                |    6 
 fs/xfs/scrub/health.c                |    1 
 fs/xfs/scrub/inode.c                 |    6 
 fs/xfs/scrub/inode_repair.c          |    6 
 fs/xfs/scrub/repair.c                |   20 +
 fs/xfs/scrub/repair.h                |    5 
 fs/xfs/scrub/rmap.c                  |    4 
 fs/xfs/scrub/rmap_repair.c           |   23 +
 fs/xfs/scrub/rtbitmap.c              |    1 
 fs/xfs/scrub/rtbitmap_repair.c       |   13 +
 fs/xfs/scrub/rtrefcount.c            |  574 ++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrefcount_repair.c     |  706 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrmap.c                |   52 ++-
 fs/xfs/scrub/rtrmap_repair.c         |    3 
 fs/xfs/scrub/scrub.c                 |    7 
 fs/xfs/scrub/scrub.h                 |   13 +
 fs/xfs/scrub/trace.h                 |   27 +
 fs/xfs/xfs_bmap_util.c               |   60 ++-
 fs/xfs/xfs_buf_item_recover.c        |    4 
 fs/xfs/xfs_fsmap.c                   |   16 -
 fs/xfs/xfs_health.c                  |    4 
 fs/xfs/xfs_inode.c                   |    7 
 fs/xfs/xfs_inode_item.c              |    2 
 fs/xfs/xfs_inode_item_recover.c      |    5 
 fs/xfs/xfs_ioctl.c                   |   15 -
 fs/xfs/xfs_mount.c                   |    2 
 fs/xfs/xfs_mount.h                   |    4 
 fs/xfs/xfs_ondisk.h                  |    3 
 fs/xfs/xfs_refcount_item.c           |   48 ++
 fs/xfs/xfs_reflink.c                 |  163 +++++---
 fs/xfs/xfs_reflink.h                 |    3 
 fs/xfs/xfs_rtalloc.c                 |   33 ++
 fs/xfs/xfs_rtalloc.h                 |    4 
 fs/xfs/xfs_super.c                   |    5 
 fs/xfs/xfs_trace.h                   |  107 +++--
 61 files changed, 3308 insertions(+), 511 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.h
 create mode 100644 fs/xfs/scrub/rtrefcount.c
 create mode 100644 fs/xfs/scrub/rtrefcount_repair.c


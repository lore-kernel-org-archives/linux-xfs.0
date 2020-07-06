Return-Path: <SRS0=eqR3=AR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940F6C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 18:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ED92206E2
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 18:06:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y9wWQ8MQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbgGFSGL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 14:06:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35098 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729589AbgGFSGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jul 2020 14:06:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 066HuS6Y067756
        for <linux-xfs@vger.kernel.org>; Mon, 6 Jul 2020 18:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=taaMh9LfUVbQor51HxjsSLndt0zq1xkdLj6rzC9hhqA=;
 b=Y9wWQ8MQd/7qUMmWY71gpXX6ziM6XO488mC4yVkhfeekOmZxgHxxfWVqwoAVpL7sEnN3
 YfT+ksV1YGYGx/55iF6JKUPGdDCpX1qmm9XpamxhmSQGdx9mkP9LgVRkBgB6Np+3lJDp
 v4RBGtuT+CHRcI7uvRXlxGDFl8F6HIwBffwuH9yh0W4gvepPioofH/hWqP6n3qD6LAKT
 +KkAZrCYXoJXvkWUq7DyW/HhVGh4n6pzUvGImLSTfUydGZgDCN/tIC+H0v21G/QJTSQs
 vYrr9ufnrmNsHh3z2zdUmOjGPQgiqhBEgkeFIy67HIDa2mwXQFu3zBwBVbLue/Rbnmgw BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 323sxxm9j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jul 2020 18:06:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 066Hw8X1013112
        for <linux-xfs@vger.kernel.org>; Mon, 6 Jul 2020 18:06:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3233pvrpc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jul 2020 18:06:08 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 066I67il010924
        for <linux-xfs@vger.kernel.org>; Mon, 6 Jul 2020 18:06:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jul 2020 11:06:07 -0700
Date:   Mon, 6 Jul 2020 11:06:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE DONOTREBASEYET] xfs-linux: for-next updated to 5710e1092b71
Message-ID: <20200706180606.GH7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007060124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9673 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 adultscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=2 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007060124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

This initial update to for-next contains Dave's recent inode async
reclaim patchset.  I think he and I have managed to fix all the strange
problems that we've found, but I'm pushing this out early to get the
rest of you to test it out.  It ran fstests all weekend just fine for
me, but YMMV. :)

That means, please do download and test this, but please don't stress
yourselves out rebasing your development trees on top of it, in case all
he11 breaks loose and reverting it starts sounding like the least bad
option.  If 72h go by and nobody complains, I think that's long enough
to declare that we're good to go.

Ok, now on to reading the delay ready xattr patchset.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

5710e1092b71 xfs: rtbitmap scrubber should check inode size

New Commits:

Brian Foster (1):
      [f74681ba2006] xfs: preserve rmapbt swapext block reservation from freed blocks

Darrick J. Wong (12):
      [eb0efe5063bb] xfs: don't eat an EIO/ENOSPC writeback error when scrubbing data fork
      [83895227aba1] xfs: fix reflink quota reservation accounting error
      [877f58f53684] xfs: rename xfs_bmap_is_real_extent to is_written_extent
      [00fd1d56dd08] xfs: redesign the reflink remap loop to fix blkres depletion crash
      [aa5d0ba0b5db] xfs: only reserve quota blocks for bmbt changes if we're changing the data fork
      [94b941fd7a98] xfs: only reserve quota blocks if we're mapping into a hole
      [168eae803ced] xfs: reflink can skip remap existing mappings
      [451d34ee0750] xfs: fix xfs_reflink_remap_prep calling conventions
      [10b4bd6c9cbc] xfs: refactor locking and unlocking two inodes against userspace IO
      [e2aaee9cd34d] xfs: move helpers that lock and unlock two inodes against userspace IO
      [8d39c060ad37] xfs: rtbitmap scrubber should verify written extents
      [5710e1092b71] xfs: rtbitmap scrubber should check inode size

Dave Chinner (31):
      [cd647d5651c0] xfs: use MMAPLOCK around filemap_map_pages()
      [96355d5a1f0e] xfs: Don't allow logging of XFS_ISTALE inodes
      [1dfde687a65f] xfs: remove logged flag from inode log item
      [1319ebefd6ed] xfs: add an inode item lock
      [f593bf144c7d] xfs: mark inode buffers in cache
      [0c7e5afbea99] xfs: mark dquot buffers in cache
      [9fe5c77cbe3c] xfs: mark log recovery buffers for completion
      [b01d1461ae6d] xfs: call xfs_buf_iodone directly
      [a7e134ef3717] xfs: clean up whacky buffer log item list reinit
      [aac855ab1a98] xfs: make inode IO completion buffer centric
      [018dc1667913] xfs: use direct calls for dquot IO completion
      [d17450801422] xfs: clean up the buffer iodone callback functions
      [a48e9ebc1c26] xfs: get rid of log item callbacks
      [cfcd441819f0] xfs: handle buffer log item IO errors directly
      [a3a2fc5ff894] xfs: unwind log item error flagging
      [1dc02df3d503] xfs: move xfs_clear_li_failed out of xfs_ail_delete_one()
      [142c4fc235d0] xfs: pin inode backing buffer to the inode log item
      [b5915c8c3f8a] xfs: make inode reclaim almost non-blocking
      [4481f68b6121] xfs: remove IO submission from xfs_reclaim_inode()
      [fe1b8c5ee525] xfs: allow multiple reclaimers per AG
      [8591571f6fac] xfs: don't block inode reclaim on the ILOCK
      [f6df8ba6dc51] xfs: remove SYNC_TRYLOCK from inode reclaim
      [9b31e9ef71c2] xfs: remove SYNC_WAIT from xfs_reclaim_inodes()
      [9c57388324bc] xfs: clean up inode reclaim comments
      [838c279b016a] xfs: rework stale inodes in xfs_ifree_cluster
      [c59327d5d161] xfs: attach inodes to the cluster buffer when dirtied
      [bd42aa1a45c9] xfs: xfs_iflush() is no longer necessary
      [e042993f4b5f] xfs: rename xfs_iflush_int()
      [246e631c5414] xfs: rework xfs_iflush_cluster() dirty inode iteration
      [c131be389b45] xfs: factor xfs_iflush_done
      [f3f2321221bd] xfs: remove xfs_inobp_check()

Keyur Patel (1):
      [06734e3c95a3] xfs: Couple of typo fixes in comments

Yafang Shao (1):
      [0d5a57140b3e] xfs: remove useless definitions in xfs_linux.h


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.h        |  19 +-
 fs/xfs/libxfs/xfs_inode_buf.c   |  33 +-
 fs/xfs/libxfs/xfs_inode_buf.h   |   6 -
 fs/xfs/libxfs/xfs_rtbitmap.c    |   2 +-
 fs/xfs/libxfs/xfs_shared.h      |   1 +
 fs/xfs/libxfs/xfs_trans_inode.c | 110 +++++--
 fs/xfs/scrub/bmap.c             |  22 +-
 fs/xfs/scrub/rtbitmap.c         |  47 +++
 fs/xfs/xfs_bmap_util.c          |  18 +-
 fs/xfs/xfs_buf.c                |  40 ++-
 fs/xfs/xfs_buf.h                |  48 +--
 fs/xfs/xfs_buf_item.c           | 433 +++++++++++++-------------
 fs/xfs/xfs_buf_item.h           |   8 +-
 fs/xfs/xfs_buf_item_recover.c   |   5 +-
 fs/xfs/xfs_dquot.c              |  29 +-
 fs/xfs/xfs_dquot.h              |   1 +
 fs/xfs/xfs_dquot_item.c         |  18 --
 fs/xfs/xfs_dquot_item_recover.c |   2 +-
 fs/xfs/xfs_file.c               |  28 +-
 fs/xfs/xfs_icache.c             | 364 +++++++---------------
 fs/xfs/xfs_icache.h             |   2 +-
 fs/xfs/xfs_inode.c              | 664 +++++++++++++++++++---------------------
 fs/xfs/xfs_inode.h              |   5 +-
 fs/xfs/xfs_inode_item.c         | 319 ++++++++++---------
 fs/xfs/xfs_inode_item.h         |  24 +-
 fs/xfs/xfs_inode_item_recover.c |   2 +-
 fs/xfs/xfs_linux.h              |   4 -
 fs/xfs/xfs_log_recover.c        |   5 +-
 fs/xfs/xfs_mount.c              |  15 +-
 fs/xfs/xfs_mount.h              |   1 -
 fs/xfs/xfs_reflink.c            | 355 ++++++++++-----------
 fs/xfs/xfs_reflink.h            |   2 -
 fs/xfs/xfs_super.c              |   3 -
 fs/xfs/xfs_trace.h              |  52 +---
 fs/xfs/xfs_trans.c              |  19 +-
 fs/xfs/xfs_trans.h              |   5 -
 fs/xfs/xfs_trans_ail.c          |  10 +-
 fs/xfs/xfs_trans_buf.c          |  15 +-
 38 files changed, 1299 insertions(+), 1437 deletions(-)

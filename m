Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D4DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 16:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98CF220720
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 16:44:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HisPPCA4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgGIQo1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 12:44:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51262 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGIQo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 12:44:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069Gbnlw054539
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jul 2020 16:44:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=7y2JHE0nqlDma88aRrIQ2x4DleG8AQg9HMIlDekWdCI=;
 b=HisPPCA4g6JTSxTayT11QkJ11Q00vV1IlYOgxDwzU4kHrcQN2j4YEYJYJogYxUXvilxS
 4WT2t/rEXyfLasb6D8wJ/9/lKDACMoZiGaB4rCvdGyAU5KRlcice8jZEQVFpg8nrajwC
 +Z82ZaERnL5YaSD1O3A59+XIiWoerG2aux/3NayJ/qRTwDTpBleC6Mce/plsSPIStt4E
 j8J1Iel/Csw0XsquNwBJfZMn5cD+II5+l6qepQmJBV/NjtQnCqmvnYOrsUAmrLRl/Svt
 c6kxg1y21zwE69uw/AXzzXSR/esuUg8nGnHOrLuv46DR1XL23Oc1LGjWR5sivqtzl7hx jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 325y0ajydu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jul 2020 16:44:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069GdKpO016747
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jul 2020 16:44:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 325k3h7sqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jul 2020 16:44:24 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 069GiO6D017874
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jul 2020 16:44:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jul 2020 09:44:23 -0700
Date:   Thu, 9 Jul 2020 09:44:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to c3f2375b90d0
Message-ID: <20200709164422.GS7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=2 mlxlogscore=999 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007090120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  I did end up having to rework the branch to fix a
compilation bug in the inode flush series that we missed.

The new head of the for-next branch is commit:

c3f2375b90d0 xfs: Fix false positive lockdep warning with sb_internal & fs_reclaim

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
      [f866560be219] xfs: rtbitmap scrubber should verify written extents
      [2fb94e36b683] xfs: rtbitmap scrubber should check inode size

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
      [6f5de1808e36] xfs: use direct calls for dquot IO completion
      [fec671cd350f] xfs: clean up the buffer iodone callback functions
      [2ef3f7f5db15] xfs: get rid of log item callbacks
      [428947e9d525] xfs: handle buffer log item IO errors directly
      [3536b61e74aa] xfs: unwind log item error flagging
      [e98084b8bef7] xfs: move xfs_clear_li_failed out of xfs_ail_delete_one()
      [298f7bec503f] xfs: pin inode backing buffer to the inode log item
      [993f951f501c] xfs: make inode reclaim almost non-blocking
      [617825fe3489] xfs: remove IO submission from xfs_reclaim_inode()
      [0e8e2c6343dd] xfs: allow multiple reclaimers per AG
      [9552e14d3e87] xfs: don't block inode reclaim on the ILOCK
      [50718b8d73dd] xfs: remove SYNC_TRYLOCK from inode reclaim
      [4d0bab3a4468] xfs: remove SYNC_WAIT from xfs_reclaim_inodes()
      [02511a5a6a49] xfs: clean up inode reclaim comments
      [71e3e3564686] xfs: rework stale inodes in xfs_ifree_cluster
      [48d55e2ae3ce] xfs: attach inodes to the cluster buffer when dirtied
      [90c60e164012] xfs: xfs_iflush() is no longer necessary
      [e6187b3444e8] xfs: rename xfs_iflush_int()
      [5717ea4d527a] xfs: rework xfs_iflush_cluster() dirty inode iteration
      [a69a1dc2842e] xfs: factor xfs_iflush_done
      [e2705b030477] xfs: remove xfs_inobp_check()

Keyur Patel (1):
      [06734e3c95a3] xfs: Couple of typo fixes in comments

Waiman Long (1):
      [c3f2375b90d0] xfs: Fix false positive lockdep warning with sb_internal & fs_reclaim

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
 fs/xfs/xfs_quota.h              |   9 +
 fs/xfs/xfs_reflink.c            | 355 ++++++++++-----------
 fs/xfs/xfs_reflink.h            |   2 -
 fs/xfs/xfs_super.c              |  15 +-
 fs/xfs/xfs_trace.h              |  52 +---
 fs/xfs/xfs_trans.c              |  19 +-
 fs/xfs/xfs_trans.h              |   5 -
 fs/xfs/xfs_trans_ail.c          |  10 +-
 fs/xfs/xfs_trans_buf.c          |  15 +-
 38 files changed, 1318 insertions(+), 1438 deletions(-)

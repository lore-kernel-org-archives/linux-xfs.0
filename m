Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D12C47247
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 15:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CBF6207DD
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 15:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LQuqBHsv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgEGPgn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 11:36:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35162 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgEGPgn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 11:36:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047FYtLU079107
        for <linux-xfs@vger.kernel.org>; Thu, 7 May 2020 15:36:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=QTRyiLwt0vTNXBJU0ZeLEdZqeGW8STB2UcncFCtWqgQ=;
 b=LQuqBHsvcTGo7Qj+UA1lY5NmM/7FMglXJstDpasykB78ElXtOpDBkTAWeQ/auTx222mG
 lIeNLT7VmbBkLdWmty5f/ICnwM++xbI6w7FngxJn5ZcjiBfE5P5jgfODK5ymcH8jncLD
 aQPbGrK/jfnoANw5TZAmRDWvPXbLvwcEH3JsVONGX6aPv7dAODIWg9xKw6qYFd4S0KBD
 6cLJKgj5VW3LOk38VORzwr8PsIcb5OZ/PJ5jvJ8ktX7IbKAZgDnf4EKuAcMVyZwE5tNj
 OV3S3EmHR6X+Q9lLR5BicscvH2MeBZ2hkMRLbE2BDgh+YaRMsBA9Vgb+5NkS/xA1DO2d HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30vhvyh6pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 May 2020 15:36:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 047FZ6ee159636
        for <linux-xfs@vger.kernel.org>; Thu, 7 May 2020 15:36:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30sjdyapbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 May 2020 15:36:40 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 047FadWF010096
        for <linux-xfs@vger.kernel.org>; Thu, 7 May 2020 15:36:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 08:36:39 -0700
Date:   Thu, 7 May 2020 08:36:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to c199507993ed
Message-ID: <20200507153639.GG6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=2 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070125
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
the next update.  Still reading patches...

The new head of the for-next branch is commit:

c199507993ed xfs: remove unused iget_flags param from xfs_imap_to_bp()

New Commits:

Arnd Bergmann (1):
      [166405f6b53b] xfs: stop CONFIG_XFS_DEBUG from changing compiler flags

Brian Foster (17):
      [cb6ad0993eb8] xfs: refactor failed buffer resubmission into xfsaild
      [54b3b1f619ef] xfs: factor out buffer I/O failure code
      [f20192991d79] xfs: simplify inode flush error handling
      [15fab3b9be22] xfs: remove unnecessary shutdown check from xfs_iflush()
      [b6983e80b03b] xfs: reset buffer write failure state on successful completion
      [f9bccfcc3b59] xfs: refactor ratelimited buffer error messages into helper
      [61948b6fb276] xfs: ratelimit unmount time per-buffer I/O error alert
      [629dcb38dc35] xfs: fix duplicate verification from xfs_qm_dqflush()
      [b707fffda6a3] xfs: abort consistently on dquot flush failure
      [849274c103ae] xfs: acquire ->ail_lock from xfs_trans_ail_delete()
      [655879290c28] xfs: use delete helper for items expected to be in AIL
      [6af0479d8b6b] xfs: drop unused shutdown parameter from xfs_trans_ail_remove()
      [2b3cf09356d5] xfs: combine xfs_trans_ail_[remove|delete]()
      [88fc187984c9] xfs: remove unused iflush stale parameter
      [7376d7454734] xfs: random buffer write failure errortag
      [28d84620797e] xfs: remove unused shutdown types
      [c199507993ed] xfs: remove unused iget_flags param from xfs_imap_to_bp()

Christoph Hellwig (16):
      [e968350aadf3] xfs: refactor the buffer cancellation table helpers
      [5ce70b770d16] xfs: rename inode_list xlog_recover_reorder_trans
      [7d4894b4ce07] xfs: factor out a xlog_buf_readahead helper
      [f15ab3f60ef3] xfs: simplify xlog_recover_inode_ra_pass2
      [98b69b1285be] xfs: refactor xlog_recover_buffer_pass1
      [82ff450b2d93] xfs: remove the xfs_efi_log_item_t typedef
      [c84e819090f3] xfs: remove the xfs_efd_log_item_t typedef
      [fd9cbe512151] xfs: remove the xfs_inode_log_item_t typedef
      [e046e949486e] xfs: factor out a xfs_defer_create_intent helper
      [c1f09188e8de] xfs: merge the ->log_item defer op into ->create_intent
      [d367a868e46b] xfs: merge the ->diff_items defer op into ->create_intent
      [13a833333907] xfs: turn dfp_intent into a xfs_log_item
      [bb47d79750f1] xfs: refactor xfs_defer_finish_noroll
      [f09d167c2033] xfs: turn dfp_done into a xfs_log_item
      [3ec1b26c04d4] xfs: use a xfs_btree_cur for the ->finish_cleanup state
      [2f88f1efd02d] xfs: spell out the parameter name for ->cancel_item

Darrick J. Wong (2):
      [0d2d35a33ea7] xfs: report unrecognized log item type codes during recovery
      [8bc3b5e4b70d] xfs: clean up the error handling in xfs_swap_extents

Eric Sandeen (1):
      [ec43f6da31f1] xfs: define printk_once variants for xfs messages

Ira Weiny (5):
      [d45344d6c49c] fs/xfs: Remove unnecessary initialization of i_rwsem
      [606723d98293] fs/xfs: Change XFS_MOUNT_DAX to XFS_MOUNT_DAX_ALWAYS
      [8d6c3446ec23] fs/xfs: Make DAX mount option a tri-state
      [32dbc5655f1c] fs/xfs: Create function xfs_inode_should_enable_dax()
      [840d493dff1a] fs/xfs: Combine xfs_diflags_to_linux() and xfs_diflags_to_iflags()

Kaixu Xia (7):
      [c140735bbb65] xfs: trace quota allocations for all quota types
      [d51bafe0d227] xfs: combine two if statements with same condition
      [fb353ff19d34] xfs: reserve quota inode transaction space only when needed
      [ea1c90403d5d] xfs: remove unnecessary variable udqp from xfs_ioctl_setattr
      [7994aae8516a] xfs: remove unnecessary assertion from xfs_qm_vop_create_dqattach
      [cd59455980f9] xfs: simplify the flags setting in xfs_qm_scall_quotaon
      [57fd2d8f61a2] xfs: remove unnecessary check of the variable resblks in xfs_symlink


Code Diffstat:

 fs/xfs/Makefile                 |   2 -
 fs/xfs/libxfs/xfs_defer.c       | 152 +++++++++++-----------
 fs/xfs/libxfs/xfs_defer.h       |  24 ++--
 fs/xfs/libxfs/xfs_errortag.h    |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c   |  12 +-
 fs/xfs/libxfs/xfs_inode_buf.h   |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |   2 +-
 fs/xfs/libxfs/xfs_trans_inode.c |   2 +-
 fs/xfs/scrub/ialloc.c           |   3 +-
 fs/xfs/xfs_bmap_item.c          |  70 +++++------
 fs/xfs/xfs_bmap_util.c          |   2 +-
 fs/xfs/xfs_buf.c                |  71 ++++++++---
 fs/xfs/xfs_buf.h                |   2 +
 fs/xfs/xfs_buf_item.c           | 106 +++-------------
 fs/xfs/xfs_buf_item.h           |   2 -
 fs/xfs/xfs_dquot.c              |  47 +++----
 fs/xfs/xfs_dquot_item.c         |  17 +--
 fs/xfs/xfs_error.c              |   3 +
 fs/xfs/xfs_extfree_item.c       |  80 ++++++------
 fs/xfs/xfs_extfree_item.h       |  14 +--
 fs/xfs/xfs_fsops.c              |   5 +-
 fs/xfs/xfs_icache.c             |   6 +-
 fs/xfs/xfs_inode.c              | 143 ++++++++-------------
 fs/xfs/xfs_inode.h              |   1 +
 fs/xfs/xfs_inode_item.c         |  28 +----
 fs/xfs/xfs_inode_item.h         |   6 +-
 fs/xfs/xfs_ioctl.c              |  40 +-----
 fs/xfs/xfs_iops.c               |  77 +++++++-----
 fs/xfs/xfs_log_recover.c        | 270 +++++++++++++++++++---------------------
 fs/xfs/xfs_message.c            |  22 ++++
 fs/xfs/xfs_message.h            |  24 +++-
 fs/xfs/xfs_mount.c              |   7 +-
 fs/xfs/xfs_mount.h              |   6 +-
 fs/xfs/xfs_pnfs.c               |   5 +-
 fs/xfs/xfs_qm.c                 |   7 +-
 fs/xfs/xfs_qm_syscalls.c        |   6 +-
 fs/xfs/xfs_refcount_item.c      |  92 ++++++--------
 fs/xfs/xfs_rmap_item.c          |  95 ++++++--------
 fs/xfs/xfs_super.c              |  48 ++++++-
 fs/xfs/xfs_symlink.c            |   6 +-
 fs/xfs/xfs_trans_ail.c          |  68 ++++++----
 fs/xfs/xfs_trans_priv.h         |  18 +--
 42 files changed, 728 insertions(+), 869 deletions(-)

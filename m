Return-Path: <SRS0=Yx8G=BD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1F6C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 16:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 377AF206F6
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jul 2020 16:43:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lYO/oLNo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGXQnG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 12:43:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33804 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXQnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 12:43:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06OGWet3137593
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 16:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=aWKcJtprvT5DjVSiT0zikw1G+q6b5v29bvF43hLcTyw=;
 b=lYO/oLNoDiPay0gLbSD0y0T03mTuY6712PNgkken1eoidb83AHc57rS2kvEYgyvu1WBk
 ohJE2jp9cwBdWa1GrupAFUg+t2zMcX1xfuEme1IS3dDonTyjHGI1WNyntEe5dRshRxVf
 v3Bos4JcLzdAXLwDqXolT8h9yOoeTHhZ5SDc0icOljlluhaYN3eip4XQnHyuC+swCWtO
 2y0bI57cH6UR5qabUaSPO0jGtUHXd550S43YmWZGYoZ3KtXQZ72vObotGGDgXZs5H6XY
 SB0E9b8W3/m0EQv91ex/XeFbN4OR/v+H0NYEwg+zRCKfKnt2uk/996tclGKH3D16BRFs 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32brgs04w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 16:43:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06OGYK5E175378
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 16:43:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32g38w8yx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 16:43:02 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06OGgrso026951
        for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2020 16:42:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 16:42:53 +0000
Date:   Fri, 24 Jul 2020 09:42:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 073a5a695e63
Message-ID: <20200724164252.GJ7625@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=2 spamscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=2 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

This branch adds both quota cleanup patchsets to the async inode
flushing series from two weeks ago.  This is about as far as I want to
go during the first week of the merge window.

The new head of the for-next branch is commit:

073a5a695e63 xfs: xfs_btree_staging.h: delete duplicated words

New Commits:

Brian Foster (3):
      [f74681ba2006] xfs: preserve rmapbt swapext block reservation from freed blocks
      [c22c309bbfb2] xfs: drain the buf delwri queue before xfsaild idles
      [dddf0bdecbbd] xfs: fix inode allocation block res calculation precedence

Christoph Hellwig (1):
      [76622c88c2ce] xfs: remove SYNC_WAIT and SYNC_TRYLOCK

Darrick J. Wong (47):
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
      [80173d80c71d] xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush
      [e21952105397] xfs: fix inode quota reservation checks
      [8dbcc82de92c] xfs: validate ondisk/incore dquot flags
      [55dd2acf0ba0] xfs: move the flags argument of xfs_qm_scall_trunc_qfiles to XFS_QMOPT_*
      [b28727897146] xfs: refactor quotacheck flags usage
      [7c69193f7bbb] xfs: rename dquot incore state flags
      [930ba8279a27] xfs: make XFS_DQUOT_CLUSTER_SIZE_FSB part of the ondisk format
      [edce943d38d8] xfs: stop using q_core.d_flags in the quota code
      [97c063443107] xfs: stop using q_core.d_id in the quota code
      [c5b54558911f] xfs: use a per-resource struct for incore dquot data
      [6acefb6b8425] xfs: stop using q_core limits in the quota code
      [296614b5cc0f] xfs: stop using q_core counters in the quota code
      [520dbb0f1a26] xfs: stop using q_core warning counters in the quota code
      [7359faf11c31] xfs: stop using q_core timers in the quota code
      [b7029e39b725] xfs: remove qcore from incore dquots
      [da67bbae6436] xfs: refactor default quota limits by resource
      [4ad67354ac45] xfs: remove unnecessary arguments from quota adjust functions
      [e7ff64e6d4d8] xfs: refactor quota exceeded test
      [6ca6b9a7bbdf] xfs: refactor xfs_qm_scall_setqlim
      [fd93db86adfd] xfs: refactor xfs_trans_dqresv
      [647ad56d03b0] xfs: refactor xfs_trans_apply_dquot_deltas
      [daed79d91b5f] xfs: assume the default quota limits are always set in xfs_qm_adjust_dqlimits
      [74388072e2e7] xfs: actually bump warning counts when we send warnings
      [e4c039328d54] xfs: add more dquot tracepoints
      [d2ab70323d96] xfs: drop the type parameter from xfs_dquot_verify
      [d307681cfc35] xfs: rename XFS_DQ_{USER,GROUP,PROJ} to XFS_DQTYPE_*
      [9ba905aaffe4] xfs: refactor testing if a particular dquot is being enforced
      [0350dbfe4e60] xfs: remove the XFS_QM_IS[UGP]DQ macros
      [178d57f792fe] xfs: refactor quota type testing
      [873aa0e36625] xfs: always use xfs_dquot_type when extracting type from a dquot
      [99c1aa0fd76a] xfs: remove unnecessary quota type masking
      [c92b1646dc44] xfs: replace a few open-coded XFS_DQTYPE_REC_MASK uses
      [0e98ad9caee2] xfs: create xfs_dqtype_t to represent quota types
      [7223a7180b9c] xfs: improve ondisk dquot flags checking
      [762d41cc223d] xfs: rename the ondisk dquot d_flags to d_type

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

Eric Sandeen (1):
      [ea52eff66dcd] xfs: preserve inode versioning across remounts

Gao Xiang (1):
      [92a005448f6f] xfs: get rid of unnecessary xfs_perag_{get,put} pairs

Keyur Patel (1):
      [06734e3c95a3] xfs: Couple of typo fixes in comments

Randy Dunlap (1):
      [073a5a695e63] xfs: xfs_btree_staging.h: delete duplicated words

Waiman Long (1):
      [c3f2375b90d0] xfs: Fix false positive lockdep warning with sb_internal & fs_reclaim

Yafang Shao (1):
      [0d5a57140b3e] xfs: remove useless definitions in xfs_linux.h

YueHaibing (1):
      [8464e650b957] xfs: remove duplicated include from xfs_buf_item.c


Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c             |   4 +-
 fs/xfs/libxfs/xfs_ag_resv.h        |  12 -
 fs/xfs/libxfs/xfs_alloc.c          |  22 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |   8 +-
 fs/xfs/libxfs/xfs_bmap.h           |  19 +-
 fs/xfs/libxfs/xfs_btree_staging.h  |   6 +-
 fs/xfs/libxfs/xfs_dquot_buf.c      |  25 +-
 fs/xfs/libxfs/xfs_format.h         |  36 +-
 fs/xfs/libxfs/xfs_ialloc.c         |  28 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |  33 +-
 fs/xfs/libxfs/xfs_inode_buf.h      |   6 -
 fs/xfs/libxfs/xfs_quota_defs.h     |  31 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   4 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |   9 +-
 fs/xfs/libxfs/xfs_rtbitmap.c       |   2 +-
 fs/xfs/libxfs/xfs_shared.h         |   1 +
 fs/xfs/libxfs/xfs_trans_inode.c    | 110 ++++--
 fs/xfs/libxfs/xfs_trans_space.h    |   2 +-
 fs/xfs/scrub/bmap.c                |  22 +-
 fs/xfs/scrub/quota.c               |  83 ++---
 fs/xfs/scrub/repair.c              |  10 +-
 fs/xfs/scrub/repair.h              |   4 +-
 fs/xfs/scrub/rtbitmap.c            |  47 +++
 fs/xfs/xfs_bmap_util.c             |  18 +-
 fs/xfs/xfs_buf.c                   |  40 ++-
 fs/xfs/xfs_buf.h                   |  48 ++-
 fs/xfs/xfs_buf_item.c              | 434 +++++++++++------------
 fs/xfs/xfs_buf_item.h              |   8 +-
 fs/xfs/xfs_buf_item_recover.c      |  14 +-
 fs/xfs/xfs_dquot.c                 | 413 ++++++++++++----------
 fs/xfs/xfs_dquot.h                 | 129 ++++---
 fs/xfs/xfs_dquot_item.c            |  26 +-
 fs/xfs/xfs_dquot_item_recover.c    |  14 +-
 fs/xfs/xfs_file.c                  |  28 +-
 fs/xfs/xfs_icache.c                | 368 ++++++-------------
 fs/xfs/xfs_icache.h                |   5 +-
 fs/xfs/xfs_inode.c                 | 702 +++++++++++++++++--------------------
 fs/xfs/xfs_inode.h                 |   5 +-
 fs/xfs/xfs_inode_item.c            | 319 +++++++++--------
 fs/xfs/xfs_inode_item.h            |  24 +-
 fs/xfs/xfs_inode_item_recover.c    |   2 +-
 fs/xfs/xfs_iomap.c                 |  42 +--
 fs/xfs/xfs_linux.h                 |   4 -
 fs/xfs/xfs_log_recover.c           |   5 +-
 fs/xfs/xfs_mount.c                 |  15 +-
 fs/xfs/xfs_mount.h                 |   1 -
 fs/xfs/xfs_qm.c                    | 189 +++++-----
 fs/xfs/xfs_qm.h                    | 104 +++---
 fs/xfs/xfs_qm_bhv.c                |  22 +-
 fs/xfs/xfs_qm_syscalls.c           | 250 ++++++-------
 fs/xfs/xfs_quota.h                 |  19 +-
 fs/xfs/xfs_quotaops.c              |  26 +-
 fs/xfs/xfs_reflink.c               | 355 +++++++++----------
 fs/xfs/xfs_reflink.h               |   2 -
 fs/xfs/xfs_super.c                 |  19 +-
 fs/xfs/xfs_trace.h                 | 225 ++++++++----
 fs/xfs/xfs_trans.c                 |  19 +-
 fs/xfs/xfs_trans.h                 |   5 -
 fs/xfs/xfs_trans_ail.c             |  26 +-
 fs/xfs/xfs_trans_buf.c             |  15 +-
 fs/xfs/xfs_trans_dquot.c           | 366 +++++++++----------
 61 files changed, 2440 insertions(+), 2390 deletions(-)

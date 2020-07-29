Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FE8C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 18:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E72492075D
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 18:52:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l9JyhTDh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgG2Swh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:52:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56532 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2Swg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jul 2020 14:52:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06TIl2kh116807
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 18:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=tvoQdSHZghd5Orw6/xAhqHZyfFzI56U81huygWPaoJo=;
 b=l9JyhTDhNOcA31Vi6SOmMyUY5xqIm7Mrh+dIzz0+KZCIlrvzL7q7GB8ltYNr7Z5iQw9w
 fH64sMHlHLW1Hi2QKn2SQQUCOl3DI2HFACzkEBEsMRkVf3WSoQHmeCQekUolnNoyrhaC
 3cN72Cf5AkENaaKxl+FfB1Ginxdl2TmhN+Bej0BmG5qRjsGDs5LUZUGCFPTi9MY5mwy9
 Gph5p2ggswkVYWbd1aaGi7hDb1APNNeDcUxarK3VwrIER2Jfe2j5S2noQ8VhNvPFg76t
 q7vt5RlKNZVJw9Ex7FODeDdrcLzoKJsbqL8cUBjLuPCdR3PNls0R4ToBs2r3ojFPNqDt SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32hu1jfenk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 18:52:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06TImd7g121409
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 18:52:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32hu5vcfga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 18:52:32 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06TIqWdb009778
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 18:52:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jul 2020 11:52:31 -0700
Date:   Wed, 29 Jul 2020 11:52:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next rebased to 818d5a91559f
Message-ID: <20200729185230.GE3151642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=2 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=2 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290127
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
the next update.  I rebased the branch to fix some missing SOB/RVB tags,
integrated Allison's xattr fixes, and added one more patch for FS_DAX_FL
support.

The new head of the for-next branch is commit:

818d5a91559f fs/xfs: Support that ioctl(SETXFLAGS/GETXFLAGS) can set/get inode DAX on XFS.

New Commits:

Allison Collins (22):
      [07120f1abdff] xfs: Add xfs_has_attr and subroutines
      [deed9512872d] xfs: Check for -ENOATTR or -EEXIST
      [1a485fc1e965] xfs: Factor out new helper functions xfs_attr_rmtval_set
      [e3be1272ddaf] xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
      [7c93d4a8fc39] xfs: Split apart xfs_attr_leaf_addname
      [6cc5b5f89840] xfs: Refactor xfs_attr_try_sf_addname
      [0949d317aee0] xfs: Pull up trans roll from xfs_attr3_leaf_setflag
      [795141099abc] xfs: Factor out xfs_attr_rmtval_invalidate
      [1fc618d76266] xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
      [8b8e0cc0208b] xfs: Refactor xfs_attr_rmtval_remove
      [d4034c4662af] xfs: Pull up xfs_attr_rmtval_invalidate
      [3f6e011ee2bf] xfs: Add helper function xfs_attr_node_shrink
      [0feaef17db9d] xfs: Remove unneeded xfs_trans_roll_inode calls
      [a237f2ddae4b] xfs: Remove xfs_trans_roll in xfs_attr_node_removename
      [db1a28cc591c] xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
      [f44df68c82dc] xfs: Add helper function xfs_attr_leaf_mark_incomplete
      [410c19885db5] xfs: Add remote block helper functions
      [674eb548cf0c] xfs: Add helper function xfs_attr_node_removename_setup
      [72b97ea40d23] xfs: Add helper function xfs_attr_node_removename_rmt
      [5fdca0ad5c95] xfs: Simplify xfs_attr_leaf_addname
      [bf4a5cfffee0] xfs: Simplify xfs_attr_node_addname
      [0f89edcd8e84] xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname

Brian Foster (3):
      [f74681ba2006] xfs: preserve rmapbt swapext block reservation from freed blocks
      [f376b45e861d] xfs: drain the buf delwri queue before xfsaild idles
      [b2a886472868] xfs: fix inode allocation block res calculation precedence

Carlos Maiolino (5):
      [3050bd0bfe70] xfs: Remove kmem_zone_alloc() usage
      [32a2b11f4676] xfs: Remove kmem_zone_zalloc() usage
      [ca4f25899059] xfs: Modify xlog_ticket_alloc() to use kernel's MM API
      [bae633a4a283] xfs: remove xfs_zone_{alloc,zalloc} helpers
      [4491a3dd7192] xfs: Refactor xfs_da_state_alloc() helper

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
      [c97738a960a8] xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush
      [f959b5d037e7] xfs: fix inode quota reservation checks
      [afeda6000b0c] xfs: validate ondisk/incore dquot flags
      [41ed4a5f2ba4] xfs: move the flags argument of xfs_qm_scall_trunc_qfiles to XFS_QMOPT_*
      [0dcc0728c119] xfs: refactor quotacheck flags usage
      [985a78fdde15] xfs: rename dquot incore state flags
      [cb64e1299364] xfs: make XFS_DQUOT_CLUSTER_SIZE_FSB part of the ondisk format
      [0b0fa1d1d167] xfs: stop using q_core.d_flags in the quota code
      [c51df7334167] xfs: stop using q_core.d_id in the quota code
      [784e80f5640d] xfs: use a per-resource struct for incore dquot data
      [d3537cf93e5e] xfs: stop using q_core limits in the quota code
      [be37d40c1ba0] xfs: stop using q_core counters in the quota code
      [c8c45fb2f614] xfs: stop using q_core warning counters in the quota code
      [19dce7eaef7f] xfs: stop using q_core timers in the quota code
      [51dbb1be52fe] xfs: remove qcore from incore dquots
      [438769e31e44] xfs: refactor default quota limits by resource
      [c8c753e19a76] xfs: remove unnecessary arguments from quota adjust functions
      [ea0cc6fa8f89] xfs: refactor quota exceeded test
      [d1520deab039] xfs: refactor xfs_qm_scall_setqlim
      [292b47b4fcfa] xfs: refactor xfs_trans_dqresv
      [d92c881538c4] xfs: refactor xfs_trans_apply_dquot_deltas
      [12d720fb8645] xfs: assume the default quota limits are always set in xfs_qm_adjust_dqlimits
      [4b8628d57b72] xfs: actually bump warning counts when we send warnings
      [2cb91bab4fa4] xfs: add more dquot tracepoints
      [f9751c4ad3d1] xfs: drop the type parameter from xfs_dquot_verify
      [8cd4901da56c] xfs: rename XFS_DQ_{USER,GROUP,PROJ} to XFS_DQTYPE_*
      [dbcbc7b90e8a] xfs: refactor testing if a particular dquot is being enforced
      [00a342e4965e] xfs: remove the XFS_QM_IS[UGP]DQ macros
      [e6eb603c7e4f] xfs: refactor quota type testing
      [0b04dd5d7ca7] xfs: always use xfs_dquot_type when extracting type from a dquot
      [af1db8f12e2d] xfs: remove unnecessary quota type masking
      [74ddd6b3dd55] xfs: replace a few open-coded XFS_DQTYPE_REC_MASK uses
      [1a7ed271653a] xfs: create xfs_dqtype_t to represent quota types
      [a990f7a84edc] xfs: improve ondisk dquot flags checking
      [d8c1af0d6ad6] xfs: rename the ondisk dquot d_flags to d_type

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
      [4750a171c329] xfs: preserve inode versioning across remounts

Gao Xiang (1):
      [92a005448f6f] xfs: get rid of unnecessary xfs_perag_{get,put} pairs

Keyur Patel (1):
      [06734e3c95a3] xfs: Couple of typo fixes in comments

Randy Dunlap (1):
      [26270c9f4cf7] xfs: xfs_btree_staging.h: delete duplicated words

Waiman Long (1):
      [c3f2375b90d0] xfs: Fix false positive lockdep warning with sb_internal & fs_reclaim

Xiao Yang (1):
      [818d5a91559f] fs/xfs: Support that ioctl(SETXFLAGS/GETXFLAGS) can set/get inode DAX on XFS.

Yafang Shao (1):
      [0d5a57140b3e] xfs: remove useless definitions in xfs_linux.h

YueHaibing (1):
      [8464e650b957] xfs: remove duplicated include from xfs_buf_item.c


Code Diffstat:

 fs/xfs/kmem.c                      |  21 -
 fs/xfs/kmem.h                      |   8 -
 fs/xfs/libxfs/xfs_ag.c             |   4 +-
 fs/xfs/libxfs/xfs_ag_resv.h        |  12 -
 fs/xfs/libxfs/xfs_alloc.c          |  25 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |  10 +-
 fs/xfs/libxfs/xfs_attr.c           | 913 ++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h           |   1 +
 fs/xfs/libxfs/xfs_attr_leaf.c      | 117 +++--
 fs/xfs/libxfs/xfs_attr_leaf.h      |   3 +
 fs/xfs/libxfs/xfs_attr_remote.c    | 216 ++++++---
 fs/xfs/libxfs/xfs_attr_remote.h    |   3 +-
 fs/xfs/libxfs/xfs_bmap.c           |   8 +-
 fs/xfs/libxfs/xfs_bmap.h           |  19 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |   2 +-
 fs/xfs/libxfs/xfs_btree_staging.h  |   6 +-
 fs/xfs/libxfs/xfs_da_btree.c       |  12 +-
 fs/xfs/libxfs/xfs_da_btree.h       |   2 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |  17 +-
 fs/xfs/libxfs/xfs_dquot_buf.c      |  25 +-
 fs/xfs/libxfs/xfs_format.h         |  36 +-
 fs/xfs/libxfs/xfs_ialloc.c         |  28 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |  33 +-
 fs/xfs/libxfs/xfs_inode_buf.h      |   6 -
 fs/xfs/libxfs/xfs_inode_fork.c     |   6 +-
 fs/xfs/libxfs/xfs_quota_defs.h     |  31 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   6 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  11 +-
 fs/xfs/libxfs/xfs_rtbitmap.c       |   2 +-
 fs/xfs/libxfs/xfs_shared.h         |   1 +
 fs/xfs/libxfs/xfs_trans_inode.c    | 110 +++--
 fs/xfs/libxfs/xfs_trans_space.h    |   2 +-
 fs/xfs/scrub/bmap.c                |  22 +-
 fs/xfs/scrub/dabtree.c             |   4 +-
 fs/xfs/scrub/quota.c               |  83 ++--
 fs/xfs/scrub/repair.c              |  10 +-
 fs/xfs/scrub/repair.h              |   4 +-
 fs/xfs/scrub/rtbitmap.c            |  47 ++
 fs/xfs/xfs_bmap_item.c             |   4 +-
 fs/xfs/xfs_bmap_util.c             |  18 +-
 fs/xfs/xfs_buf.c                   |  44 +-
 fs/xfs/xfs_buf.h                   |  48 +-
 fs/xfs/xfs_buf_item.c              | 436 +++++++++---------
 fs/xfs/xfs_buf_item.h              |   8 +-
 fs/xfs/xfs_buf_item_recover.c      |  14 +-
 fs/xfs/xfs_dquot.c                 | 415 +++++++++--------
 fs/xfs/xfs_dquot.h                 | 129 ++++--
 fs/xfs/xfs_dquot_item.c            |  26 +-
 fs/xfs/xfs_dquot_item_recover.c    |  14 +-
 fs/xfs/xfs_extfree_item.c          |   6 +-
 fs/xfs/xfs_file.c                  |  28 +-
 fs/xfs/xfs_icache.c                | 378 +++++----------
 fs/xfs/xfs_icache.h                |   5 +-
 fs/xfs/xfs_icreate_item.c          |   2 +-
 fs/xfs/xfs_inode.c                 | 702 +++++++++++++---------------
 fs/xfs/xfs_inode.h                 |   5 +-
 fs/xfs/xfs_inode_item.c            | 322 ++++++-------
 fs/xfs/xfs_inode_item.h            |  24 +-
 fs/xfs/xfs_inode_item_recover.c    |   2 +-
 fs/xfs/xfs_ioctl.c                 |  14 +-
 fs/xfs/xfs_iomap.c                 |  42 +-
 fs/xfs/xfs_linux.h                 |   4 -
 fs/xfs/xfs_log.c                   |   9 +-
 fs/xfs/xfs_log_cil.c               |   3 +-
 fs/xfs/xfs_log_priv.h              |   4 +-
 fs/xfs/xfs_log_recover.c           |   5 +-
 fs/xfs/xfs_mount.c                 |  15 +-
 fs/xfs/xfs_mount.h                 |   1 -
 fs/xfs/xfs_qm.c                    | 189 ++++----
 fs/xfs/xfs_qm.h                    | 104 ++---
 fs/xfs/xfs_qm_bhv.c                |  22 +-
 fs/xfs/xfs_qm_syscalls.c           | 250 +++++-----
 fs/xfs/xfs_quota.h                 |  19 +-
 fs/xfs/xfs_quotaops.c              |  26 +-
 fs/xfs/xfs_refcount_item.c         |   5 +-
 fs/xfs/xfs_reflink.c               | 355 +++++++-------
 fs/xfs/xfs_reflink.h               |   2 -
 fs/xfs/xfs_rmap_item.c             |   5 +-
 fs/xfs/xfs_super.c                 |  19 +-
 fs/xfs/xfs_trace.h                 | 226 ++++++---
 fs/xfs/xfs_trans.c                 |  23 +-
 fs/xfs/xfs_trans.h                 |   5 -
 fs/xfs/xfs_trans_ail.c             |  26 +-
 fs/xfs/xfs_trans_buf.c             |  15 +-
 fs/xfs/xfs_trans_dquot.c           | 369 ++++++++-------
 86 files changed, 3288 insertions(+), 2967 deletions(-)

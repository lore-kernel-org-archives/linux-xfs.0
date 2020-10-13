Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EC1C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 16:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75AD22528A
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 16:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nF/wMlzg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389654AbgJMQWR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 12:22:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47780 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389406AbgJMQWR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 12:22:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DGKHlu149002
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 16:22:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=bb35xLZQZangFEUHHsyytUd/NwzSSi9AJQmvEF4F0c0=;
 b=nF/wMlzgOY3tCEltZZCzl3u9HmUaXeitXhAC6gb3Ot7P2bofY5McOnVs2g0nDmmy0qTj
 rHksHOa/nMf8vR3743E3mMApFxUDRhS3zenyrQfLghSfIv/W41Ro4rjTYgoON3p7sIkR
 yZ9bdBl87tmkIJFVVA2+MAwWcujYSIjylOYmGrISPlChGfaq7ZFuXGojdVyZ73LGOrW1
 jW9DgOliSsirhqc9C8ifghK86c6K6EWNHMzqfYBAS2UzaPUbf1PU0KcKuqDQNzHDui7s
 jO17I9mS2Fei6/kug1MuR7FluLZYU5bWAkOfhoZzukMHmrVbANBVTjjzrZBJEpTN00Y0 LA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3434wkk3y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 16:22:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DGGcLL175243
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 16:22:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 343pvwm504-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 16:22:14 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DGMD0D026501
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 16:22:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 09:22:13 -0700
Date:   Tue, 13 Oct 2020 09:22:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 7e75d8faa7e6
Message-ID: <20201013162212.GA9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=7 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=7 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130120
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
the next update.  Today's push to the branch incorporates all the rt
growfs fixes, fixes for Kconfig problems, and a fix for rtextsize > 1
fallocate parameter validation that wasn't done right.

The new head of the for-next branch is commit:

7e75d8faa7e6 xfs: fix Kconfig asking about XFS_SUPPORT_V4 when XFS_FS=n

New Commits:

Brian Foster (1):
      [6dd379c7fa81] xfs: drop extra transaction roll from inode extent truncate

Carlos Maiolino (6):
      [771915c4f688] xfs: remove kmem_realloc()
      [8ca79df85b7f] xfs: Remove kmem_zalloc_large()
      [6337c84466c2] xfs: remove typedef xfs_attr_sf_entry_t
      [47e6cc100054] xfs: Remove typedef xfs_attr_shortform_t
      [c418dbc9805d] xfs: Use variable-size array for nameval in xfs_attr_sf_entry
      [e01b7eed5d0a] xfs: Convert xfs_attr_sf macros to inline functions

Chandan Babu R (2):
      [72cc95132a93] xfs: Set xfs_buf type flag when growing summary/bitmap files
      [c54e14d155f5] xfs: Set xfs_buf's b_ops member when zeroing bitmap/summary files

Christoph Hellwig (15):
      [12e164aa1f9d] xfs: refactor the buf ioend disposition code
      [76b2d3234611] xfs: mark xfs_buf_ioend static
      [23fb5a93c21f] xfs: refactor xfs_buf_ioend
      [664ffb8a429a] xfs: move the buffer retry logic to xfs_buf.c
      [6a7584b1d82b] xfs: fold xfs_buf_ioend_finish into xfs_ioend
      [f58d0ea95611] xfs: refactor xfs_buf_ioerror_fail_without_retry
      [3cc498845a0c] xfs: remove xfs_buf_ioerror_retry
      [844c9358dfda] xfs: lift the XBF_IOEND_FAIL handling into xfs_buf_ioend_disposition
      [70796c6b74c2] xfs: simplify the xfs_buf_ioend_disposition calling convention
      [b840e2ada8af] xfs: use xfs_buf_item_relse in xfs_buf_item_done
      [55b7d7115fcd] xfs: clear the read/write flags later in xfs_buf_ioend
      [22c10589a10b] xfs: remove xlog_recover_iodone
      [cead0b10f557] xfs: simplify xfs_trans_getsb
      [b3f8e08ca815] xfs: remove xfs_getsb
      [26e328759b9b] xfs: reuse _xfs_buf_read for re-reading the superblock

Darrick J. Wong (47):
      [2a39946c9844] xfs: store inode btree block counts in AGI header
      [1ac35f061af0] xfs: use the finobt block counts to speed up mount times
      [1dbbff029f93] xfs: support inode btree blockcounts in online scrub
      [11f744234f05] xfs: support inode btree blockcounts in online repair
      [b896a39faa5a] xfs: enable new inode btree counters feature
      [876fdc7c4f36] xfs: explicitly define inode timestamp range
      [11d8a9190275] xfs: refactor quota expiration timer modification
      [ccc8e771aa7a] xfs: refactor default quota grace period setting code
      [9f99c8fe551a] xfs: refactor quota timestamp coding
      [88947ea0ba71] xfs: move xfs_log_dinode_to_disk to the log recovery code
      [5a0bb066f60f] xfs: redefine xfs_timestamp_t
      [30e05599219f] xfs: redefine xfs_ictimestamp_t
      [f93e5436f0ee] xfs: widen ondisk inode timestamps to deal with y2038+
      [4ea1ff3b4968] xfs: widen ondisk quota expiration timestamps to handle y2038+
      [06dbf82b044c] xfs: trace timestamp limits
      [29887a227131] xfs: enable big timestamps
      [5ffce3cc22a0] xfs: force the log after remapping a synchronous-writes file
      [2a6ca4baed62] xfs: make sure the rt allocator doesn't run off the end
      [fe341eb151ec] xfs: ensure that fpunch, fcollapse, and finsert operations are aligned to rt extent size
      [8a569d717ed0] xfs: refactor inode flags propagation code
      [d4f2c14cc979] xfs: don't propagate RTINHERIT -> REALTIME when there is no rtdev
      [b96cb835e37c] xfs: deprecate the V4 format
      [8df0fa39bdd8] xfs: don't free rt blocks when we're doing a REMAP bunmapi call
      [e581c9397a25] xfs: check dabtree node hash values when loading child blocks
      [93293bcbde93] xfs: log new intent items created as part of finishing recovered intent items
      [2dbf872c042e] xfs: attach inode to dquot in xfs_bui_item_recover
      [384ff09ba2e5] xfs: don't release log intent items when recovery fails
      [d7884e6e90da] xfs: avoid shared rmap operations for attr fork extents
      [b80b29d602a8] xfs: remove xfs_defer_reset
      [901219bb2507] xfs: remove XFS_LI_RECOVERED
      [e6fff81e4870] xfs: proper replay of deferred ops queued during log recovery
      [4f9a60c48078] xfs: xfs_defer_capture should absorb remaining block reservations
      [929b92f64048] xfs: xfs_defer_capture should absorb remaining transaction reservation
      [919522e89f8e] xfs: clean up bmap intent item recovery checking
      [64a3f3315bc6] xfs: clean up xfs_bui_item_recover iget/trans_alloc/ilock ordering
      [ff4ab5e02a04] xfs: fix an incore inode UAF in xfs_bui_recover
      [27dada070d59] xfs: change the order in which child and parent defer ops are finished
      [4e919af7827a] xfs: periodically relog deferred intent items
      [ed1575daf71e] xfs: expose the log push threshold
      [74f4d6a1e065] xfs: only relog deferred intent items if free space in the log gets low
      [acd1ac3aa22f] xfs: limit entries returned when counting fsmap records
      [8ffa90e1145c] xfs: fix deadlock and streamline xfs_getfsmap performance
      [f4c32e87de7d] xfs: fix realtime bitmap/summary file truncation when growing rt volume
      [7249c95a3fd7] xfs: make xfs_growfs_rt update secondary superblocks
      [ace74e797a82] xfs: annotate grabbing the realtime bitmap/summary locks in growfs
      [b0de008012fd] xfs: fix fallocate functions when rtextsize is larger than 1
      [7e75d8faa7e6] xfs: fix Kconfig asking about XFS_SUPPORT_V4 when XFS_FS=n

Dave Chinner (2):
      [718ecc50359e] xfs: xfs_iflock is no longer a completion
      [671459676ab0] xfs: fix finobt btree block recovery ordering

Gao Xiang (3):
      [f692d09e9c8f] xfs: avoid LR buffer overrun due to crafted h_len
      [0c771b99d6c9] xfs: clean up calculation of LR header blocks
      [b38e07401ec7] xfs: drop the obsolete comment on filestream locking

Kaixu Xia (11):
      [c63290e300c4] xfs: remove the unused SYNCHRONIZE macro
      [9c0fce4c16fc] xfs: use the existing type definition for di_projid
      [5aff6750d56d] xfs: remove the unnecessary xfs_dqid_t type cast
      [a647d109e08a] xfs: fix some comments
      [3feb4ffbf693] xfs: remove the redundant crc feature check in xfs_attr3_rmt_verify
      [74af4c1770f9] xfs: remove the unused parameter id from xfs_qm_dqattach_one
      [d6b8fc6c7afa] xfs: do the assert for all the log done items in xfs_trans_cancel
      [61ef5230518a] xfs: code cleanup in xfs_attr_leaf_entsize_{remote,local}
      [c9c626b354dc] xfs: directly call xfs_generic_create() for ->create() and ->mkdir()
      [97611f936674] xfs: do the ASSERT for the arguments O_{u,g,p}dqpp
      [e5b23740db9b] xfs: fix the indent in xfs_trans_mod_dquot

Pavel Reichl (2):
      [c23c393eaab5] xfs: remove deprecated mount options
      [3442de9cc322] xfs: remove deprecated sysctl options

Zheng Bin (1):
      [0f4ec0f15746] xfs: Remove unneeded semicolon


Code Diffstat:

 Documentation/admin-guide/xfs.rst |  32 ++++-
 fs/xfs/Kconfig                    |  25 ++++
 fs/xfs/kmem.c                     |  22 ---
 fs/xfs/kmem.h                     |   7 -
 fs/xfs/libxfs/xfs_ag.c            |   5 +
 fs/xfs/libxfs/xfs_attr.c          |  14 +-
 fs/xfs/libxfs/xfs_attr_leaf.c     |  43 +++---
 fs/xfs/libxfs/xfs_attr_remote.c   |   2 -
 fs/xfs/libxfs/xfs_attr_sf.h       |  29 ++--
 fs/xfs/libxfs/xfs_bmap.c          |  19 ++-
 fs/xfs/libxfs/xfs_da_format.h     |  24 ++--
 fs/xfs/libxfs/xfs_defer.c         | 232 ++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_defer.h         |  37 +++++
 fs/xfs/libxfs/xfs_dquot_buf.c     |  35 +++++
 fs/xfs/libxfs/xfs_format.h        | 211 +++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_fs.h            |   1 +
 fs/xfs/libxfs/xfs_ialloc.c        |   5 +
 fs/xfs/libxfs/xfs_ialloc_btree.c  |  65 ++++++++-
 fs/xfs/libxfs/xfs_iext_tree.c     |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c     | 130 +++++++++---------
 fs/xfs/libxfs/xfs_inode_buf.h     |  17 ++-
 fs/xfs/libxfs/xfs_inode_fork.c    |   8 +-
 fs/xfs/libxfs/xfs_log_format.h    |   7 +-
 fs/xfs/libxfs/xfs_log_recover.h   |   1 -
 fs/xfs/libxfs/xfs_quota_defs.h    |   8 +-
 fs/xfs/libxfs/xfs_rmap.c          |  27 ++--
 fs/xfs/libxfs/xfs_sb.c            |   6 +-
 fs/xfs/libxfs/xfs_shared.h        |   3 +
 fs/xfs/libxfs/xfs_trans_inode.c   |  17 ++-
 fs/xfs/scrub/agheader.c           |  30 ++++
 fs/xfs/scrub/agheader_repair.c    |  24 ++++
 fs/xfs/scrub/dabtree.c            |  14 ++
 fs/xfs/scrub/inode.c              |  31 +++--
 fs/xfs/scrub/symlink.c            |   2 +-
 fs/xfs/xfs_acl.c                  |   2 +-
 fs/xfs/xfs_attr_list.c            |   6 +-
 fs/xfs/xfs_bmap_item.c            | 136 +++++++++---------
 fs/xfs/xfs_bmap_util.c            |   7 +
 fs/xfs/xfs_buf.c                  | 208 +++++++++++++++++++++++-----
 fs/xfs/xfs_buf.h                  |  17 +--
 fs/xfs/xfs_buf_item.c             | 264 ++---------------------------------
 fs/xfs/xfs_buf_item.h             |  12 ++
 fs/xfs/xfs_buf_item_recover.c     |   4 +-
 fs/xfs/xfs_dquot.c                |  70 ++++++++--
 fs/xfs/xfs_dquot.h                |   3 +
 fs/xfs/xfs_extfree_item.c         |  44 ++++--
 fs/xfs/xfs_file.c                 |  27 +++-
 fs/xfs/xfs_filestream.c           |  34 +----
 fs/xfs/xfs_fsmap.c                |  48 ++++---
 fs/xfs/xfs_fsmap.h                |   6 +-
 fs/xfs/xfs_icache.c               |  19 ++-
 fs/xfs/xfs_inode.c                | 219 ++++++++++++++---------------
 fs/xfs/xfs_inode.h                |  39 +-----
 fs/xfs/xfs_inode_item.c           |  61 ++++++---
 fs/xfs/xfs_inode_item.h           |   5 +-
 fs/xfs/xfs_inode_item_recover.c   |  76 +++++++++++
 fs/xfs/xfs_ioctl.c                | 153 ++++++++++++++-------
 fs/xfs/xfs_iops.c                 |   4 +-
 fs/xfs/xfs_linux.h                |   1 -
 fs/xfs/xfs_log.c                  |  44 ++++--
 fs/xfs/xfs_log.h                  |   2 +
 fs/xfs/xfs_log_recover.c          | 281 +++++++++++++++++---------------------
 fs/xfs/xfs_mount.c                |  32 ++---
 fs/xfs/xfs_mount.h                |   1 -
 fs/xfs/xfs_ondisk.h               |  38 ++++--
 fs/xfs/xfs_qm.c                   |  29 +++-
 fs/xfs/xfs_qm.h                   |   4 +
 fs/xfs/xfs_qm_syscalls.c          |  18 ++-
 fs/xfs/xfs_quota.h                |   8 --
 fs/xfs/xfs_refcount_item.c        |  51 ++++---
 fs/xfs/xfs_rmap_item.c            |  42 ++++--
 fs/xfs/xfs_rtalloc.c              |  44 +++++-
 fs/xfs/xfs_stats.c                |   4 +
 fs/xfs/xfs_stats.h                |   1 +
 fs/xfs/xfs_super.c                |  72 +++++++---
 fs/xfs/xfs_sysctl.c               |  36 ++++-
 fs/xfs/xfs_trace.h                |  30 +++-
 fs/xfs/xfs_trans.c                |   4 +-
 fs/xfs/xfs_trans.h                |  35 ++++-
 fs/xfs/xfs_trans_buf.c            |  46 ++-----
 fs/xfs/xfs_trans_dquot.c          |  49 +++----
 81 files changed, 2214 insertions(+), 1257 deletions(-)

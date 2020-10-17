Return-Path: <SRS0=9vdY=DY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578C1C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Oct 2020 19:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1506A207FF
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Oct 2020 19:53:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z/LKbsN2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439592AbgJQTxq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Oct 2020 15:53:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52208 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439611AbgJQTxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Oct 2020 15:53:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09HJoKre076881
        for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2020 19:53:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=I8lIAgt//oRvlk5OL3CoR7W3nh0fOZFwmfiiw7gC/Yc=;
 b=Z/LKbsN249XhEPUd66QXO9phnjTxahAvLVksszrjrF1tPQ8QCf/6GoOQHpOgLGXoE0V/
 c+YqyMIaxtDFaCEOxFi4Klbzo9dWWgR3Wz5+fvwMJ3dQHnJVUqQAYh6B743UV6Xc4Afe
 tf3+i3VgoiSNNbh6FqFdZJQVzZe5B9rPW87iYrJN9ITsB0Rm3kJLMbt1IKasTfJPSwFO
 dMb2+CR0PK/0YbY0JVFdaTzGf/FsEHVbAMkbQDYrsgtdP064YGXd+4PGpYD4DkV0j2iF
 I1jduwAQqy7cGF2EXA2mNMli1Uvxprr/YkDXdG3Mno7b/ixihAl0VX+x02cFMczdqkYN Kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 347rjkh879-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2020 19:53:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09HJnq8r167178
        for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2020 19:53:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 347pn8t8mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2020 19:53:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09HJrh9j020954
        for <linux-xfs@vger.kernel.org>; Sat, 17 Oct 2020 19:53:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 17 Oct 2020 12:53:42 -0700
Date:   Sat, 17 Oct 2020 12:53:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next rebased to 894645546bb1
Message-ID: <20201017195341.GF9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9777 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=7 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010170141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9777 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=7 clxscore=1015 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010170141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been rebased.

NOTE: I discovered that the patch fixing the patch fixing alignment
checking of fallocate requests had some serious design errors because I
didn't realize that the rt extent size doen't have to be power-of-two
multiples of the block size.  I've rebased the branch to remove the
(second) broken patch and will send a correct fix immediately.

Sorry about that. :( :(

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  Today's push to the branch incorporates all the rt
growfs fixes, and fixes for Kconfig problems.

(Note: I'm only collecting bug fixes for 5.10 now.  If you've sent
patches implementing cleanups or new features in the past week, you can
relax for a little while because that's all 5.11 fodder.  Please help
review the 5.10 bug fixes or help Eric review xfsprogs 5.10 patches.)

The new head of the for-next branch is commit:

894645546bb1 xfs: fix Kconfig asking about XFS_SUPPORT_V4 when XFS_FS=n

New Commits:

Brian Foster (1):
      [6dd379c7fa81] xfs: drop extra transaction roll from inode extent truncate

Chandan Babu R (2):
      [72cc95132a93] xfs: Set xfs_buf type flag when growing summary/bitmap files
      [c54e14d155f5] xfs: Set xfs_buf's b_ops member when zeroing bitmap/summary files

Darrick J. Wong (28):
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
      [d88850bd5516] xfs: fix high key handling in the rt allocator's query_range function
      [894645546bb1] xfs: fix Kconfig asking about XFS_SUPPORT_V4 when XFS_FS=n

Dave Chinner (1):
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


Code Diffstat:

 Documentation/admin-guide/xfs.rst |  32 +++++-
 fs/xfs/Kconfig                    |  25 ++++
 fs/xfs/libxfs/xfs_attr_remote.c   |   2 -
 fs/xfs/libxfs/xfs_bmap.c          |  19 ++--
 fs/xfs/libxfs/xfs_da_format.h     |  18 +--
 fs/xfs/libxfs/xfs_defer.c         | 232 ++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_defer.h         |  37 ++++++
 fs/xfs/libxfs/xfs_inode_buf.h     |   2 +-
 fs/xfs/libxfs/xfs_rmap.c          |  27 +++--
 fs/xfs/libxfs/xfs_rtbitmap.c      |  11 +-
 fs/xfs/scrub/dabtree.c            |  14 +++
 fs/xfs/xfs_bmap_item.c            | 136 +++++++++++-----------
 fs/xfs/xfs_buf_item_recover.c     |   2 +
 fs/xfs/xfs_dquot.c                |   4 +-
 fs/xfs/xfs_extfree_item.c         |  44 ++++++--
 fs/xfs/xfs_filestream.c           |  34 +-----
 fs/xfs/xfs_fsmap.c                |  48 ++++----
 fs/xfs/xfs_fsmap.h                |   6 +-
 fs/xfs/xfs_inode.c                | 123 +++++++++++---------
 fs/xfs/xfs_ioctl.c                | 146 ++++++++++++++++--------
 fs/xfs/xfs_iops.c                 |   4 +-
 fs/xfs/xfs_linux.h                |   1 -
 fs/xfs/xfs_log.c                  |  44 +++++---
 fs/xfs/xfs_log.h                  |   2 +
 fs/xfs/xfs_log_recover.c          | 221 ++++++++++++++++++------------------
 fs/xfs/xfs_qm.c                   |  16 +--
 fs/xfs/xfs_refcount_item.c        |  51 +++++----
 fs/xfs/xfs_rmap_item.c            |  42 +++++--
 fs/xfs/xfs_rtalloc.c              |  31 ++++-
 fs/xfs/xfs_stats.c                |   4 +
 fs/xfs/xfs_stats.h                |   1 +
 fs/xfs/xfs_super.c                |  44 +++++---
 fs/xfs/xfs_sysctl.c               |  36 +++++-
 fs/xfs/xfs_trace.h                |   1 +
 fs/xfs/xfs_trans.c                |   2 +-
 fs/xfs/xfs_trans.h                |  33 +++++-
 fs/xfs/xfs_trans_dquot.c          |  43 +++----
 37 files changed, 1026 insertions(+), 512 deletions(-)

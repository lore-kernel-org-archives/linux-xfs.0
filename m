Return-Path: <SRS0=0uIH=W3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF395C3A5A6
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 19:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 836F621874
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Aug 2019 19:39:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kn/O+FTf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbfHaTjU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 31 Aug 2019 15:39:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35494 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbfHaTjU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 31 Aug 2019 15:39:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7VJdIAu147994
        for <linux-xfs@vger.kernel.org>; Sat, 31 Aug 2019 19:39:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=pwYX2Av3/8CqE4H0rCltP4nPswkNqwHcKwSIeESVQrc=;
 b=Kn/O+FTf/6aMWQxjAuLkDPfHu8eD+XW6vIMpELN2u/siQpk6GBr9iIolH5eU5EK8sx6C
 bWdkW6BtD/GXN6k9huEnZ0U9wKPm5SkGk/r5qazNe51u5VaezGbn0tXl4JYmSy4tCaWg
 xE/0B92E1Yp3xDrhrenUqqha6AQos9XNHWPL14zWoccL4kKsOyHRGCOgehACMl0PdnEu
 DRyWLMqqW3sur+sy9yGM0ayyyNizQfYer8FzPG8TTPaiBnGPH2w/KTGC1lCeJsYIsMyY
 119scfkkVrI0RRPVMFzZktRMbpAdZaBA9U9a4mAnH4jtsILL7qzDgbIbcyAk9zSM1OcO HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uqy7k802x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 31 Aug 2019 19:39:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7VJcVKg116708
        for <linux-xfs@vger.kernel.org>; Sat, 31 Aug 2019 19:39:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2uqg81993e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 31 Aug 2019 19:39:17 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7VJdHuM031415
        for <linux-xfs@vger.kernel.org>; Sat, 31 Aug 2019 19:39:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 31 Aug 2019 12:39:16 -0700
Date:   Sat, 31 Aug 2019 12:39:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 1baa2800e62d
Message-ID: <20190831193917.GA568270@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9366 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908310227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9366 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908310226
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
the next update.

The new head of the for-next branch is commit:

1baa2800e62d xfs: remove the unused XFS_ALLOC_USERDATA flag

New Commits:

Christoph Hellwig (3):
      [adcb0ca2330b] xfs: fix the dax supported check in xfs_ioctl_setattr_dax_invalidate
      [ecfc28a41cf1] xfs: cleanup xfs_fsb_to_db
      [1baa2800e62d] xfs: remove the unused XFS_ALLOC_USERDATA flag

Darrick J. Wong (11):
      [519e5869d50d] xfs: bmap scrub should only scrub records once
      [c94613feefd7] xfs: fix maxicount division by zero error
      [7380e8fec16b] xfs: don't return _QUERY_ABORT from xfs_rmap_has_other_keys
      [b521c89027f4] xfs: fix sign handling problem in xfs_bmbt_diff_two_keys
      [2ca09177ab9d] xfs: remove unnecessary parameter from xfs_iext_inc_seq
      [bc46ac64713f] xfs: remove unnecessary int returns from deferred rmap functions
      [74b4c5d4a9c0] xfs: remove unnecessary int returns from deferred refcount functions
      [3e08f42ae782] xfs: remove unnecessary int returns from deferred bmap functions
      [ffb5696f7555] xfs: reinitialize rm_flags when unpacking an offset into an rmap irec
      [e7ee96dfb8c2] xfs: remove all *_ITER_ABORT values
      [39ee2239a5a2] xfs: remove all *_ITER_CONTINUE values

Dave Chinner (13):
      [0ad95687c3ad] xfs: add kmem allocation trace points
      [d916275aa4dd] xfs: get allocation alignment from the buftarg
      [f8f9ee479439] xfs: add kmem_alloc_io()
      [aee7754bbeb1] xfs: move xfs_dir2_addname()
      [a07258a69528] xfs: factor data block addition from xfs_dir2_node_addname_int()
      [0e822255f95d] xfs: factor free block index lookup from xfs_dir2_node_addname_int()
      [610125ab1e4b] xfs: speed up directory bestfree block scanning
      [756c6f0f7efe] xfs: reverse search directory freespace indexes
      [728bcaa3e0f9] xfs: make attr lookup returns consistent
      [a0e959d3c9d5] xfs: remove unnecessary indenting from xfs_attr3_leaf_getvalue
      [e3cc4554ce1b] xfs: move remote attr retrieval into xfs_attr3_leaf_getvalue
      [9df243a1a9e6] xfs: consolidate attribute value copying
      [ddbca70cc45c] xfs: allocate xattr buffer on demand

Eric Sandeen (1):
      [7f313eda8fcc] xfs: log proper length of btree block in scrub/repair

Jan Kara (3):
      [692fe62433d4] mm: Handle MADV_WILLNEED through vfs_fadvise()
      [cf1ea0592dbf] fs: Export generic_fadvise()
      [40144e49ff84] xfs: Fix stale data exposure when readahead races with hole punch

Tetsuo Handa (1):
      [707e0ddaf67e] fs: xfs: Remove KM_NOSLEEP and KM_SLEEP.

zhengbin (1):
      [71912e08e06b] xfs: remove excess function parameter description in 'xfs_btree_sblock_v5hdr_verify'


Code Diffstat:

 fs/xfs/kmem.c                   |  79 +++--
 fs/xfs/kmem.h                   |  15 +-
 fs/xfs/libxfs/xfs_alloc.c       |   2 +-
 fs/xfs/libxfs/xfs_alloc.h       |   7 +-
 fs/xfs/libxfs/xfs_attr.c        |  79 +++--
 fs/xfs/libxfs/xfs_attr.h        |   6 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   | 130 ++++----
 fs/xfs/libxfs/xfs_attr_remote.c |   2 +
 fs/xfs/libxfs/xfs_bmap.c        |  83 ++---
 fs/xfs/libxfs/xfs_bmap.h        |   4 +-
 fs/xfs/libxfs/xfs_bmap_btree.c  |  16 +-
 fs/xfs/libxfs/xfs_btree.c       |  14 +-
 fs/xfs/libxfs/xfs_btree.h       |  10 +-
 fs/xfs/libxfs/xfs_da_btree.c    |   6 +-
 fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
 fs/xfs/libxfs/xfs_defer.c       |   2 +-
 fs/xfs/libxfs/xfs_dir2.c        |  14 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |   2 +-
 fs/xfs/libxfs/xfs_dir2_node.c   | 678 +++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_dir2_sf.c     |   8 +-
 fs/xfs/libxfs/xfs_ialloc.c      |   9 +-
 fs/xfs/libxfs/xfs_iext_tree.c   |   8 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |  16 +-
 fs/xfs/libxfs/xfs_refcount.c    |  50 ++-
 fs/xfs/libxfs/xfs_refcount.h    |  12 +-
 fs/xfs/libxfs/xfs_rmap.c        |  59 ++--
 fs/xfs/libxfs/xfs_rmap.h        |  11 +-
 fs/xfs/libxfs/xfs_shared.h      |   6 -
 fs/xfs/libxfs/xfs_types.h       |   8 +
 fs/xfs/scrub/agheader.c         |   4 +-
 fs/xfs/scrub/attr.c             |   6 +-
 fs/xfs/scrub/bmap.c             |  81 +++--
 fs/xfs/scrub/fscounters.c       |   2 +-
 fs/xfs/scrub/repair.c           |   6 +-
 fs/xfs/scrub/symlink.c          |   2 +-
 fs/xfs/xfs_acl.c                |  14 +-
 fs/xfs/xfs_attr_inactive.c      |   2 +-
 fs/xfs/xfs_attr_list.c          |   2 +-
 fs/xfs/xfs_bmap_item.c          |   8 +-
 fs/xfs/xfs_bmap_util.c          |  22 +-
 fs/xfs/xfs_buf.c                |   7 +-
 fs/xfs/xfs_buf.h                |   6 +
 fs/xfs/xfs_buf_item.c           |   4 +-
 fs/xfs/xfs_dquot.c              |   4 +-
 fs/xfs/xfs_dquot_item.c         |   2 +-
 fs/xfs/xfs_error.c              |   2 +-
 fs/xfs/xfs_extent_busy.c        |   2 +-
 fs/xfs/xfs_extfree_item.c       |   8 +-
 fs/xfs/xfs_file.c               |  26 ++
 fs/xfs/xfs_fsmap.c              |  12 +-
 fs/xfs/xfs_icache.c             |   2 +-
 fs/xfs/xfs_icreate_item.c       |   2 +-
 fs/xfs/xfs_inode.c              |   2 +-
 fs/xfs/xfs_inode_item.c         |   2 +-
 fs/xfs/xfs_ioctl.c              |  21 +-
 fs/xfs/xfs_ioctl32.c            |   2 +-
 fs/xfs/xfs_itable.c             |  10 +-
 fs/xfs/xfs_itable.h             |  13 +-
 fs/xfs/xfs_iwalk.c              |   4 +-
 fs/xfs/xfs_iwalk.h              |  13 +-
 fs/xfs/xfs_log.c                |   8 +-
 fs/xfs/xfs_log_cil.c            |  10 +-
 fs/xfs/xfs_log_recover.c        |  20 +-
 fs/xfs/xfs_mount.c              |   2 +-
 fs/xfs/xfs_mount.h              |   7 -
 fs/xfs/xfs_mru_cache.c          |   4 +-
 fs/xfs/xfs_qm.c                 |   4 +-
 fs/xfs/xfs_refcount_item.c      |  16 +-
 fs/xfs/xfs_reflink.c            |  23 +-
 fs/xfs/xfs_rmap_item.c          |   6 +-
 fs/xfs/xfs_rtalloc.c            |   4 +-
 fs/xfs/xfs_trace.h              |  34 ++
 fs/xfs/xfs_trans.c              |   4 +-
 fs/xfs/xfs_trans_dquot.c        |   2 +-
 fs/xfs/xfs_xattr.c              |   2 +-
 include/linux/fs.h              |   2 +
 mm/fadvise.c                    |   4 +-
 mm/madvise.c                    |  22 +-
 78 files changed, 961 insertions(+), 846 deletions(-)

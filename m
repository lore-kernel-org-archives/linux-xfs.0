Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA635C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 16:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97412206CD
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 16:28:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qkHWRuoj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389035AbfIFQ2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Sep 2019 12:28:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52834 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388816AbfIFQ2v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Sep 2019 12:28:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86GSnS6166609
        for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2019 16:28:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=DMpW4e0Ib23DkYIhSTY69QYRYAikq/PHLWcwvj19iZM=;
 b=qkHWRuojkyB7rqHqDgpPMffHmI7jYp3OV0IzLAG4I8CFaplx10f8PPWIqfq1DRaGz1ru
 ncFwIYPrSwO2tWzkKpKR4azDrFXTO1BdqyJHKcxKQ8f0MBN8EzyI1BKT651r6w65Qcl0
 raugocPzMtoVI4MeaDMVQ1f0oFLQkLEteJyWrJ4XmB3GHtML2ZGZvpNuW4Af0CMvhojR
 9JPN8kCIPA0uCJgt44lyPE+fxNB0EBL1HbmXZ2gwv7qE2rUuo9NGvQ1sc6AAQB6KzEJm
 el2v6693iZQRI9f7ak3CfX9VKnLezdLWoaoAlLIYW1i0/Y0D2PPdBEGnzeZEaA3X/7kt 6Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uutys80g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2019 16:28:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86GSafZ003100
        for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2019 16:28:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uud7ppjsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2019 16:28:39 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x86GS2oS028012
        for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2019 16:28:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Sep 2019 09:28:02 -0700
Date:   Fri, 6 Sep 2019 09:27:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 14e15f1bcd73
Message-ID: <20190906162757.GV2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9372 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9372 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060175
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
the next update.  I think this is pretty much it for 5.4, though bug
fixes can of course be sent at any time.

The new head of the for-next branch is commit:

14e15f1bcd73 xfs: push the grant head when the log head moves forward

New Commits:

Austin Kim (1):
      [eb2e99943c5b] xfs: Use WARN_ON_ONCE for bailout mount-operation

Christoph Hellwig (4):
      [adcb0ca2330b] xfs: fix the dax supported check in xfs_ioctl_setattr_dax_invalidate
      [ecfc28a41cf1] xfs: cleanup xfs_fsb_to_db
      [1baa2800e62d] xfs: remove the unused XFS_ALLOC_USERDATA flag
      [eb77b23b565e] xfs: add a xfs_valid_startblock helper

Darrick J. Wong (12):
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
      [76f1793359db] xfs: define a flags field for the AG geometry ioctl structure

Dave Chinner (20):
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
      [7c107afb871a] xfs: push the AIL in xlog_grant_head_wake
      [8ab39f11d974] xfs: prevent CIL push holdoff in log recovery
      [6769aa2a4f2b] xfs: factor debug code out of xlog_state_do_callback()
      [6546818c8570] xfs: factor callbacks out of xlog_state_do_callback()
      [5e96fa8d2b09] xfs: factor iclog state processing out of xlog_state_do_callback()
      [0383f543d870] xfs: push iclog state cleaning into xlog_state_clean_log
      [14e15f1bcd73] xfs: push the grant head when the log head moves forward

Eric Sandeen (1):
      [7f313eda8fcc] xfs: log proper length of btree block in scrub/repair

Jan Kara (3):
      [692fe62433d4] mm: Handle MADV_WILLNEED through vfs_fadvise()
      [cf1ea0592dbf] fs: Export generic_fadvise()
      [40144e49ff84] xfs: Fix stale data exposure when readahead races with hole punch

Rik van Riel (1):
      [cdea5459ce26] xfs: fix missed wakeup on l_flush_wait

Tetsuo Handa (1):
      [707e0ddaf67e] fs: xfs: Remove KM_NOSLEEP and KM_SLEEP.

kaixuxia (1):
      [bc56ad8c74b8] xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT

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
 fs/xfs/libxfs/xfs_bmap.c        |  85 ++---
 fs/xfs/libxfs/xfs_bmap.h        |  11 +-
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
 fs/xfs/libxfs/xfs_fs.h          |   2 +-
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
 fs/xfs/xfs_inode.c              |  85 ++---
 fs/xfs/xfs_inode_item.c         |   2 +-
 fs/xfs/xfs_ioctl.c              |  25 +-
 fs/xfs/xfs_ioctl32.c            |   2 +-
 fs/xfs/xfs_iomap.c              |   6 +-
 fs/xfs/xfs_itable.c             |  10 +-
 fs/xfs/xfs_itable.h             |  13 +-
 fs/xfs/xfs_iwalk.c              |   4 +-
 fs/xfs/xfs_iwalk.h              |  13 +-
 fs/xfs/xfs_log.c                | 466 ++++++++++++++++-----------
 fs/xfs/xfs_log_cil.c            |  10 +-
 fs/xfs/xfs_log_recover.c        |  50 +--
 fs/xfs/xfs_mount.c              |   4 +-
 fs/xfs/xfs_mount.h              |   7 -
 fs/xfs/xfs_mru_cache.c          |   4 +-
 fs/xfs/xfs_qm.c                 |   4 +-
 fs/xfs/xfs_refcount_item.c      |  16 +-
 fs/xfs/xfs_reflink.c            |  23 +-
 fs/xfs/xfs_rmap_item.c          |   6 +-
 fs/xfs/xfs_rtalloc.c            |   4 +-
 fs/xfs/xfs_super.c              |   3 +-
 fs/xfs/xfs_trace.h              |  34 ++
 fs/xfs/xfs_trans.c              |   4 +-
 fs/xfs/xfs_trans_dquot.c        |   2 +-
 fs/xfs/xfs_xattr.c              |   2 +-
 include/linux/fs.h              |   2 +
 mm/fadvise.c                    |   4 +-
 mm/madvise.c                    |  22 +-
 81 files changed, 1315 insertions(+), 1089 deletions(-)

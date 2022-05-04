Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85534C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  4 May 2022 09:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbiEDJ0I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 May 2022 05:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiEDJ0F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 May 2022 05:26:05 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED25120BF1
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 02:22:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 963F610E6279
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 19:22:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nmBDG-007raX-0i
        for linux-xfs@vger.kernel.org; Wed, 04 May 2022 19:22:26 +1000
Date:   Wed, 4 May 2022 19:22:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs: for-next branch updated to
 86810a9ebd9e69498524c57a83f1271ade56ded8
Message-ID: <20220504092226.GI1360180@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=627245d3
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=zJ0plvGdeyWlBSTgpDEA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I've just pushed a new for-next branch for the XFS tree:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next

The include update includes:

- Rmap speedups
- Reflink speedups
- Transaction size reductions and legacy minimum log size
  calculations allowing us to further reduce transaction sizes.
- CIL-based intent whiteouts
- Better detection of various malicious corruptions
- Miscellaneous fixes

This all passes my local regression testing, though further smoke
testing in different environments would be appreaciated.

If I've missed anything you were expecting to see in this update,
let me know and I'll get them sorted for the next update.

Cheers,

Dave.

----------------------------------------------------------------

Head Commit:

86810a9ebd9e Merge branch 'guilt/xfs-5.19-fuzz-fixes' into xfs-5.19-for-next

----------------------------------------------------------------

New commits since a44a027a8b2a:

Brian Foster (1):
      xfs: fix soft lockup via spinning in filestream ag selection loop

Darrick J. Wong (13):
      xfs: capture buffer ops in the xfs_buf tracepoints
      xfs: simplify xfs_rmap_lookup_le call sites
      xfs: speed up rmap lookups by using non-overlapped lookups when possible
      xfs: speed up write operations by using non-overlapped lookups when possible
      xfs: count EFIs when deciding to ask for a continuation of a refcount update
      xfs: stop artificially limiting the length of bunmap calls
      xfs: remove a __xfs_bunmapi call from reflink
      xfs: create shadow transaction reservations for computing minimum log size
      xfs: report "max_resp" used for min log size computation
      xfs: reduce the absurdly large log operation count
      xfs: reduce transaction reservations with reflink
      xfs: rewrite xfs_reflink_end_cow to use intents
      xfs: rename xfs_*alloc*_log_count to _block_count

Dave Chinner (19):
      xfs: zero inode fork buffer at allocation
      xfs: fix potential log item leak
      xfs: hide log iovec alignment constraints
      xfs: don't commit the first deferred transaction without intents
      xfs: add log item flags to indicate intents
      xfs: tag transactions that contain intent done items
      xfs: factor and move some code in xfs_log_cil.c
      xfs: add log item method to return related intents
      xfs: whiteouts release intents that are not in the AIL
      xfs: intent item whiteouts
      xfs: detect self referencing btree sibling pointers
      xfs: validate inode fork size against fork format
      xfs: set XFS_FEAT_NLINK correctly
      xfs: validate v5 feature fields
      Merge branch 'guilt/xfs-5.19-misc-2' into xfs-5.19-for-next
      Merge branch 'guilt/xlog-intent-whiteouts' into xfs-5.19-for-next
      Merge tag 'rmap-speedups-5.19_2022-04-28' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.19-for-next
      Merge tag 'reflink-speedups-5.19_2022-04-28' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.19-for-next
      Merge branch 'guilt/xfs-5.19-fuzz-fixes' into xfs-5.19-for-next

Eric Sandeen (1):
      xfs: revert "xfs: actually bump warning counts when we send warnings"

Yang Xu (1):
      xfs: improve __xfs_set_acl

 fs/xfs/libxfs/xfs_bmap.c        |  22 +---------
 fs/xfs/libxfs/xfs_btree.c       | 140 ++++++++++++++++++++++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_defer.c       |  30 ++++++++------
 fs/xfs/libxfs/xfs_inode_buf.c   |  35 ++++++++++++----
 fs/xfs/libxfs/xfs_inode_fork.c  |  12 ++----
 fs/xfs/libxfs/xfs_log_rlimit.c  |  75 +++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_refcount.c    |  14 ++++---
 fs/xfs/libxfs/xfs_refcount.h    |  13 +++---
 fs/xfs/libxfs/xfs_rmap.c        | 161 ++++++++++++++++++++++++++++++++++++++++++-----------------------------
 fs/xfs/libxfs/xfs_rmap.h        |   7 +---
 fs/xfs/libxfs/xfs_sb.c          |  70 ++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_shared.h      |  24 +++++++----
 fs/xfs/libxfs/xfs_trans_resv.c  | 214 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------
 fs/xfs/libxfs/xfs_trans_resv.h  |  16 ++++++--
 fs/xfs/scrub/bmap.c             |  24 ++---------
 fs/xfs/xfs_acl.h                |   8 ++--
 fs/xfs/xfs_bmap_item.c          |  25 ++++++++---
 fs/xfs/xfs_extfree_item.c       |  23 ++++++++---
 fs/xfs/xfs_filestream.c         |   7 ++--
 fs/xfs/xfs_icreate_item.c       |   1 +
 fs/xfs/xfs_inode_item.c         |  25 ++++-------
 fs/xfs/xfs_inode_item_recover.c |   4 +-
 fs/xfs/xfs_iops.c               |   2 -
 fs/xfs/xfs_log.h                |  42 +++++++++++++++++--
 fs/xfs/xfs_log_cil.c            | 195 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------
 fs/xfs/xfs_refcount_item.c      |  25 ++++++++---
 fs/xfs/xfs_reflink.c            |  95 ++++++++++++++++++++++++++----------------
 fs/xfs/xfs_rmap_item.c          |  25 ++++++++---
 fs/xfs/xfs_trace.h              |  40 ++++++++++++++++--
 fs/xfs/xfs_trans.c              |   3 --
 fs/xfs/xfs_trans.h              |  32 ++++++++-------
 fs/xfs/xfs_trans_dquot.c        |   1 -
 32 files changed, 974 insertions(+), 436 deletions(-)

-- 
Dave Chinner
david@fromorbit.com

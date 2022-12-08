Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724ADC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Dec 2022 17:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiLHRI2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Dec 2022 12:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiLHRI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2022 12:08:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27FC85D1B
        for <linux-xfs@vger.kernel.org>; Thu,  8 Dec 2022 09:08:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3322F61FEB
        for <linux-xfs@vger.kernel.org>; Thu,  8 Dec 2022 17:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC48C433D2;
        Thu,  8 Dec 2022 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670519305;
        bh=y7va8rItEiNsI6zTWMbvHsV7WVMO+4iyR7hN0HwV/cY=;
        h=Date:From:To:Cc:Subject:From;
        b=K3+OVFu4e5ANCaWTNNOpJzUgHWMbGbC7zgq8qvBGExU7HFDK2WY7O3uXqoTSSKI30
         9bT8m6sF80+EJ7bdUa+UnX4fC49crIqCO3jw6m1wHGtbwrUs3E8lFIQF+cew0UUfMG
         W1saSg3TtPyuHMkBdVb3ShyVFhmM3vz2euDeAtArD6SbHYsh+mhVmlrg8OloFVt9Kw
         6zFi9v5e+PYTS/8TxD+kMAriYPUQbuytvoCPRXIa/uKcvGFGbhQ846QsYaMo2nZMUB
         dC8O9tjqxSyZfmEHmxw5WdcG2wHS99hz8o6nzDlL13lLpcZoZr5r1gM6OM9Q/Oi4yl
         SKQzSKFQxFakQ==
Date:   Thu, 8 Dec 2022 09:08:24 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     aalbersh@redhat.com, abaci@linux.alibaba.com,
        allison.henderson@oracle.com, dchinner@redhat.com,
        guoxuenan@huawei.com, hch@lst.de, hsiangkao@linux.alibaba.com,
        leo.lilong@huawei.com, linux-xfs@vger.kernel.org,
        lukas@herbolt.com, ruansy.fnst@fujitsu.com, sandeen@redhat.com,
        syzbot+912776840162c13db1a3@syzkaller.appspotmail.com,
        yang.lee@linux.alibaba.com, yangx.jy@fujitsu.com
Subject: [ANNOUNCE] xfs-linux: for-next updated to 4883f57a2d86
Message-ID: <167051815561.3827402.12763361680222654455.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

As promised, this push includes the data corruption fixes for fsdax and
reflink mode that Ruan has been working on for some time.  I think I'll
hold off on pushing this to Linus until the second week of the merge
window, because this is a lot of changes to core code (insofar as
fs/dax.c is core code) that appeared /very/ late in the 6.2 cycle.

I am therefore very tempted to hold it for 6.3, but for the patchset
eliminating data corruption vectors.  The general lack of users of
dax+reflink makes me less anxious about pushing for 6.2, or so I gather
since this has been broken since 6.0-rc1 and nobody outside of the
fsdevel community has noticed.  Thoughts?

The new head of the for-next branch is commit:

4883f57a2d86 xfs: remove restrictions for fsdax and reflink

69 new commits:

Darrick J. Wong (44):
[9a48b4a6fd51] xfs: fully initialize xfs_da_args in xchk_directory_blocks
[be1317fdb8d4] xfs: don't track the AGFL buffer in the scrub AG context
[3e59c0103e66] xfs: log the AGI/AGF buffers when rolling transactions during an AG repair
[48ff40458f87] xfs: standardize GFP flags usage in online scrub
[b255fab0f80c] xfs: make AGFL repair function avoid crosslinked blocks
[a7a0f9a5503f] xfs: return EINTR when a fatal signal terminates scrub
[0a713bd41ea2] xfs: fix return code when fatal signal encountered during dquot scrub
[fcd2a43488d5] xfs: initialize the check_owner object fully
[6bf2f8791597] xfs: don't retry repairs harder when EAGAIN is returned
[306195f355bb] xfs: pivot online scrub away from kmem.[ch]
[9e13975bb062] xfs: load rtbitmap and rtsummary extent mapping btrees at mount time
[11f97e684583] xfs: skip fscounters comparisons when the scan is incomplete
[93b0c58ed04b] xfs: don't return -EFSCORRUPTED from repair when resources cannot be grabbed
[5f369dc5b4eb] xfs: make rtbitmap ILOCKing consistent when scanning the rt bitmap file
[e74331d6fa2c] xfs: online checking of the free rt extent count
[033985b6fe87] xfs: fix perag loop in xchk_bmap_check_rmaps
[6a5777865eeb] xfs: teach scrub to check for adjacent bmaps when rmap larger than bmap
[830ffa09fb13] xfs: block map scrub should handle incore delalloc reservations
[f23c40443d1c] xfs: check quota files for unwritten extents
[31785537010a] xfs: check that CoW fork extents are not shared
[5eef46358fae] xfs: teach scrub to flag non-extents format cow forks
[bd5ab5f98741] xfs: don't warn about files that are exactly s_maxbytes long
[f36b954a1f1b] xfs: check inode core when scrubbing metadata files
[823ca26a8f07] Merge tag 'scrub-fix-ag-header-handling-6.2_2022-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.2-mergeA
[af1077fa87c3] Merge tag 'scrub-cleanup-malloc-6.2_2022-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.2-mergeA
[3d8426b13bac] Merge tag 'scrub-fix-return-value-6.2_2022-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.2-mergeA
[b76f593b33aa] Merge tag 'scrub-fix-rtmeta-ilocking-6.2_2022-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.2-mergeA
[7aab8a05e7c7] Merge tag 'scrub-fscounters-enhancements-6.2_2022-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.2-mergeA
[cc5f38fa12fc] Merge tag 'scrub-bmap-enhancements-6.2_2022-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.2-mergeA
[7b082b5e8afa] Merge tag 'scrub-check-metadata-inode-records-6.2_2022-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.2-mergeA
[2653d53345bd] xfs: fix incorrect error-out in xfs_remove
[7dd73802f97d] Merge tag 'xfs-iomap-stale-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-6.2-mergeB
[c2beff99eb03] xfs: add debug knob to slow down writeback for fun
[254e3459285c] xfs: add debug knob to slow down write for fun
[032e160305f6] xfs: invalidate block device page cache during unmount
[fd5beaff250d] xfs: use memcpy, not strncpy, to format the attr prefix during listxattr
[e5827a007aa4] xfs: shut up -Wuninitialized in xfsaild_push
[4c6dbfd2756b] xfs: attach dquots to inode before reading data/cow fork mappings
[cd14f15b0e64] Merge tag 'iomap-write-race-testing-6.2_2022-11-30' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.2-mergeC
[4b4d11bbeca4] Merge tag 'random-fixes-6.2_2022-11-30' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.2-mergeC
[9d720a5a658f] xfs: hoist refcount record merge predicates
[b25d1984aa88] xfs: estimate post-merge refcounts correctly
[948961964b24] Merge tag 'maxrefcount-fixes-6.2_2022-12-01' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.2-mergeD
[ddfdd530e43f] xfs: invalidate xfs_bufs when allocating cow extents

Dave Chinner (10):
[118e021b4b66] xfs: write page faults in iomap are not buffered writes
[198dd8aedee6] xfs: punching delalloc extents on write failure is racy
[b71f889c18ad] xfs: use byte ranges for write cleanup ranges
[9c7babf94a0d] xfs,iomap: move delalloc punching to iomap
[f43dc4dc3eff] iomap: buffered write failure should not truncate the page cache
[7348b322332d] xfs: xfs_bmap_punch_delalloc_range() should take a byte range
[d7b64041164c] iomap: write iomap validity checks
[304a68b9c63b] xfs: use iomap_valid method to detect stale cached iomaps
[6e8af15ccdc4] xfs: drop write error injection is unfixable, remove it
[52f31ed22821] xfs: dquot shrinker doesn't check for XFS_DQFLAG_FREEING

Guo Xuenan (3):
[1eb52a6a7198] xfs: wait iclog complete before tearing down AIL
[575689fc0ffa] xfs: fix super block buf log item UAF during force shutdown
[8c25febf2396] xfs: get rid of assert from xfs_btree_islastblock

Long Li (2):
[59f6ab40fd87] xfs: fix sb write verify for lazysbcount
[28b4b0596343] xfs: fix incorrect i_nlink caused by inode racing

Lukas Herbolt (1):
[64c80dfd04d1] xfs: Print XFS UUID on mount and umount events.

Shiyang Ruan (8):
[0587d473e256] fsdax: introduce page->share for fsdax in reflink mode
[038587477f43] fsdax: invalidate pages when CoW
[624c2f49637c] fsdax: zero the edges if source is HOLE or UNWRITTEN
[03e54f961bda] fsdax,xfs: set the shared flag when file extent is shared
[06573bf13dc7] fsdax: dedupe: iter two files at the same time
[0d3ca2b4cbb3] xfs: use dax ops for zero and truncate in fsdax mode
[3a0a36f143e4] fsdax,xfs: port unshare to fsdax
[4883f57a2d86] xfs: remove restrictions for fsdax and reflink

Yang Li (1):
[1f5619ed8810] xfs: Remove duplicated include in xfs_iomap.c

Code Diffstat:

fs/dax.c                       | 221 +++++++++++++++++++++++------------
fs/iomap/buffered-io.c         | 254 ++++++++++++++++++++++++++++++++++++++++-
fs/iomap/iter.c                |  19 ++-
fs/xfs/libxfs/xfs_bmap.c       |   8 +-
fs/xfs/libxfs/xfs_btree.h      |   1 -
fs/xfs/libxfs/xfs_errortag.h   |  18 +--
fs/xfs/libxfs/xfs_refcount.c   | 146 ++++++++++++++++++++---
fs/xfs/libxfs/xfs_sb.c         |   4 +-
fs/xfs/scrub/agheader.c        |  47 +++++---
fs/xfs/scrub/agheader_repair.c |  81 ++++++++++---
fs/xfs/scrub/attr.c            |  11 +-
fs/xfs/scrub/bitmap.c          |  11 +-
fs/xfs/scrub/bmap.c            | 147 +++++++++++++++++++-----
fs/xfs/scrub/btree.c           |  14 ++-
fs/xfs/scrub/common.c          |  48 +++++---
fs/xfs/scrub/common.h          |   2 +-
fs/xfs/scrub/dabtree.c         |   4 +-
fs/xfs/scrub/dir.c             |  10 +-
fs/xfs/scrub/fscounters.c      | 109 +++++++++++++++++-
fs/xfs/scrub/inode.c           |   2 +-
fs/xfs/scrub/quota.c           |   8 +-
fs/xfs/scrub/refcount.c        |  12 +-
fs/xfs/scrub/repair.c          |  51 ++++++---
fs/xfs/scrub/scrub.c           |   6 +-
fs/xfs/scrub/scrub.h           |  18 +--
fs/xfs/scrub/symlink.c         |   2 +-
fs/xfs/xfs_aops.c              |  32 +++---
fs/xfs/xfs_bmap_util.c         |  10 +-
fs/xfs/xfs_bmap_util.h         |   2 +-
fs/xfs/xfs_buf.c               |   1 +
fs/xfs/xfs_buf_item.c          |   2 +
fs/xfs/xfs_error.c             |  46 ++++++--
fs/xfs/xfs_error.h             |  13 +++
fs/xfs/xfs_file.c              |   2 +-
fs/xfs/xfs_fsmap.c             |   4 +-
fs/xfs/xfs_icache.c            |   6 +
fs/xfs/xfs_inode.c             |   2 +-
fs/xfs/xfs_ioctl.c             |   4 -
fs/xfs/xfs_iomap.c             | 191 +++++++++++++++++++------------
fs/xfs/xfs_iomap.h             |   6 +-
fs/xfs/xfs_iops.c              |   4 -
fs/xfs/xfs_log.c               |  46 +++++---
fs/xfs/xfs_mount.c             |  15 +++
fs/xfs/xfs_pnfs.c              |   6 +-
fs/xfs/xfs_qm.c                |  16 ++-
fs/xfs/xfs_reflink.c           |   8 +-
fs/xfs/xfs_rtalloc.c           |  60 +++++++++-
fs/xfs/xfs_super.c             |   2 +-
fs/xfs/xfs_trace.c             |   2 +
fs/xfs/xfs_trace.h             |  86 ++++++++++++++
fs/xfs/xfs_trans_ail.c         |   4 +-
fs/xfs/xfs_xattr.c             |   2 +-
include/linux/dax.h            |   2 +
include/linux/iomap.h          |  47 ++++++--
include/linux/mm_types.h       |   5 +-
include/linux/page-flags.h     |   2 +-
56 files changed, 1484 insertions(+), 398 deletions(-)

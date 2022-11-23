Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87D9C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 17:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238355AbiKWRSl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 12:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238509AbiKWRSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 12:18:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D485C77B
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 09:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B279B81FDE
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 17:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74B7C433D6
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 17:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669223907;
        bh=2h6r+PNjrNcPwoSHDJlEWf3LfnwC9x9qlKefFEmhQbQ=;
        h=Date:From:To:Subject:From;
        b=grHf6si6Ofqp/xa+kl+SGu24Ro+eaSb200ufN0BBbI9jkvGbvonSzSsHw+oYMhm3G
         QNFi/+yN4IFK7WOsjhLWgteB0twYEjwn85e1hPfnSTrfhoK0s3bpfBPfGzGZIb4otx
         DqAnqK7oc3AEPeOKSiFuo8jS7zVOs7TwO1AVPkSJzvck3Lg8HumD+7ZT4KgqZAxxJ5
         VPPd/9d+s3RQURfTAwIdYwtDK06M1VE93hyeLZWylzmerdM2KlxDfRG+MWF0KLADvQ
         mdfZmZaKbcGrF9plNBsnGtECPQ8e9K7v0Hmpht2odQNjvR7bNXb3HtULS9HnaCox8N
         IpyDJj6he8Mbg==
Date:   Wed, 23 Nov 2022 09:18:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 28b4b0596343
Message-ID: <Y35V42hUQ08rOjvz@magnolia>
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
the next update.  I'll look at Dave's v4 write race fixes later today.

The new head of the for-next branch is commit:

28b4b0596343 xfs: fix incorrect i_nlink caused by inode racing

34 new commits:

Darrick J. Wong (31):
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

Long Li (2):
      [59f6ab40fd87] xfs: fix sb write verify for lazysbcount
      [28b4b0596343] xfs: fix incorrect i_nlink caused by inode racing

Lukas Herbolt (1):
      [64c80dfd04d1] xfs: Print XFS UUID on mount and umount events.

Code Diffstat:

 fs/xfs/libxfs/xfs_sb.c         |   4 +-
 fs/xfs/scrub/agheader.c        |  47 ++++++++-----
 fs/xfs/scrub/agheader_repair.c |  81 +++++++++++++++++++----
 fs/xfs/scrub/attr.c            |  11 ++-
 fs/xfs/scrub/bitmap.c          |  11 +--
 fs/xfs/scrub/bmap.c            | 147 +++++++++++++++++++++++++++++++++--------
 fs/xfs/scrub/btree.c           |  14 ++--
 fs/xfs/scrub/common.c          |  48 ++++++++++----
 fs/xfs/scrub/common.h          |   2 +-
 fs/xfs/scrub/dabtree.c         |   4 +-
 fs/xfs/scrub/dir.c             |  10 +--
 fs/xfs/scrub/fscounters.c      | 109 ++++++++++++++++++++++++++++--
 fs/xfs/scrub/inode.c           |   2 +-
 fs/xfs/scrub/quota.c           |   8 ++-
 fs/xfs/scrub/refcount.c        |  12 ++--
 fs/xfs/scrub/repair.c          |  51 +++++++++-----
 fs/xfs/scrub/scrub.c           |   6 +-
 fs/xfs/scrub/scrub.h           |  18 ++---
 fs/xfs/scrub/symlink.c         |   2 +-
 fs/xfs/xfs_fsmap.c             |   4 +-
 fs/xfs/xfs_icache.c            |   6 ++
 fs/xfs/xfs_inode.c             |   2 +-
 fs/xfs/xfs_log.c               |  10 +--
 fs/xfs/xfs_mount.c             |  15 +++++
 fs/xfs/xfs_rtalloc.c           |  60 +++++++++++++++--
 fs/xfs/xfs_super.c             |   2 +-
 26 files changed, 529 insertions(+), 157 deletions(-)

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC502C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 19:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8502522DBF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 19:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbhAWTmA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 14:42:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbhAWTl7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 14:41:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E6E522DBF;
        Sat, 23 Jan 2021 19:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611430879;
        bh=6Pvkg3MmVLM4o3cFueAMduSE4uXuuw4j9kzgdrHaDCs=;
        h=Date:From:To:Cc:Subject:From;
        b=imhtkFjCFJOYHhHxCi7/Xm5oHh5HqTQKgWNFXChcCfxiMy8BBRjCtnOo33UtphsXo
         HpcR28UaaYZSjGlUd3oXJyOaFozEouVMXUKaYZyeu7Ffe+KAncuCQaUjQLwPPigHB/
         rO0leWQzZ5gr47szCCenrG2PQ0rg6K0mpaaWUAe5BTArPv4Hd7Kbe55T13OZGlw5eI
         ZAwuN1Hch0JkZd1YKuRvSLUxKR2F5dzQ9lgvMuJ9fEu04vVUAaNtWub8/XcUxYwYvK
         hfqqovf5K97R9cw2An3NXcHkupk75liEwBickjFFSu2APiUaKVXObYC3xxMFwMFVyz
         a5nKE8mwgosag==
Date:   Sat, 23 Jan 2021 11:41:18 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to ae29e4220fd3
Message-ID: <20210123194118.GA7698@magnolia>
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
the next update.  This push doesn't include the unaligned direct write
patches while I figure out how/if I want to stage those for 5.12...

The new head of the for-next branch is commit:

ae29e4220fd3 xfs: reduce ilock acquisitions in xfs_file_fsync

New Commits:

Brian Foster (11):
      [10fb9ac1251f] xfs: rename xfs_wait_buftarg() to xfs_buftarg_drain()
      [8321ddb2fa29] xfs: don't drain buffer lru on freeze and read-only remount
      [50d25484bebe] xfs: sync lazy sb accounting on quiesce of read-only mounts
      [37444fc4cc39] xfs: lift writable fs check up into log worker task
      [9e54ee0fc9ef] xfs: separate log cleaning from log quiesce
      [303591a0a947] xfs: cover the log during log quiesce
      [b0eb9e118266] xfs: don't reset log idle state on covering checkpoints
      [f46e5a174655] xfs: fold sbcount quiesce logging into log covering
      [5232b9315034] xfs: remove duplicate wq cancel and log force from attr quiesce
      [ea2064da4592] xfs: remove xfs_quiesce_attr()
      [5b0ad7c2a52d] xfs: cover the log on freeze instead of cleaning it

Chandan Babu R (16):
      [b9b7e1dc56c5] xfs: Add helper for checking per-inode extent count overflow
      [727e1acd297c] xfs: Check for extent overflow when trivally adding a new extent
      [85ef08b5a667] xfs: Check for extent overflow when punching a hole
      [f5d927491914] xfs: Check for extent overflow when adding dir entries
      [0dbc5cb1a91c] xfs: Check for extent overflow when removing dir entries
      [02092a2f034f] xfs: Check for extent overflow when renaming dir entries
      [3a19bb147c72] xfs: Check for extent overflow when adding/removing xattrs
      [c442f3086d5a] xfs: Check for extent overflow when writing to unwritten extent
      [5f1d5bbfb2e6] xfs: Check for extent overflow when moving extent from cow to data fork
      [ee898d78c354] xfs: Check for extent overflow when remapping an extent
      [bcc561f21f11] xfs: Check for extent overflow when swapping extents
      [f9fa87169d2b] xfs: Introduce error injection to reduce maximum inode fork extent count
      [aff4db57d510] xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
      [0961fddfdd3f] xfs: Compute bmap extent alignments in a separate function
      [07c72e556299] xfs: Process allocated extent in a separate function
      [301519674699] xfs: Introduce error injection to allocate only minlen size extents for files

Christoph Hellwig (3):
      [01ea173e103e] xfs: fix up non-directory creation in SGID directories
      [f22c7f877773] xfs: refactor xfs_file_fsync
      [ae29e4220fd3] xfs: reduce ilock acquisitions in xfs_file_fsync

Darrick J. Wong (1):
      [6da1b4b1ab36] xfs: fix an ABBA deadlock in xfs_rename

Eric Biggers (1):
      [eaf92540a918] xfs: remove a stale comment from xfs_file_aio_write_checks()

Jeffrey Mitchell (1):
      [8aa921a95335] xfs: set inode size after creating symlink

Yumei Huang (1):
      [88a9e03beef2] xfs: Fix assert failure in xfs_setattr_size()


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c      |  50 ++++++++
 fs/xfs/libxfs/xfs_alloc.h      |   3 +
 fs/xfs/libxfs/xfs_attr.c       |  13 ++
 fs/xfs/libxfs/xfs_bmap.c       | 285 ++++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_dir2.h       |   2 -
 fs/xfs/libxfs/xfs_dir2_sf.c    |   2 +-
 fs/xfs/libxfs/xfs_errortag.h   |   6 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  27 ++++
 fs/xfs/libxfs/xfs_inode_fork.h |  63 +++++++++
 fs/xfs/xfs_bmap_item.c         |  10 ++
 fs/xfs/xfs_bmap_util.c         |  31 +++++
 fs/xfs/xfs_buf.c               |  30 +++--
 fs/xfs/xfs_buf.h               |  11 +-
 fs/xfs/xfs_dquot.c             |   8 +-
 fs/xfs/xfs_error.c             |   6 +
 fs/xfs/xfs_file.c              |  90 ++++++++-----
 fs/xfs/xfs_inode.c             | 110 ++++++++++++----
 fs/xfs/xfs_iomap.c             |  10 ++
 fs/xfs/xfs_iops.c              |   2 +-
 fs/xfs/xfs_log.c               | 136 ++++++++++++++++----
 fs/xfs/xfs_log.h               |   4 +-
 fs/xfs/xfs_mount.c             |  38 +-----
 fs/xfs/xfs_mount.h             |   1 -
 fs/xfs/xfs_reflink.c           |  16 +++
 fs/xfs/xfs_rtalloc.c           |   5 +
 fs/xfs/xfs_super.c             |  38 +-----
 fs/xfs/xfs_symlink.c           |   6 +
 fs/xfs/xfs_trace.h             |   2 +-
 28 files changed, 746 insertions(+), 259 deletions(-)

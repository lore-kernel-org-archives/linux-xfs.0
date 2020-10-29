Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F7EEC55178
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C622B206BE
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="afFcOzJO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgJ2KOY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgJ2KOX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:14:23 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0328C0613D2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:23 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b3so1957474pfo.2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+Oa4akqQuA03DpOEuunHhYKXvjCon113uZBfDfwJZRs=;
        b=afFcOzJOVn8rz6nClt53Q3bihiZtphVo/pFIsX5WHDQALql5TL7+E16Q+v78x5zX92
         mjiSHnmCZY66WNI6FIh2BP2ptHGkDskdwW8GRoc3+m1J+i1ctrAGNVwkIVCQU4Ry7bDw
         R0TFL3EOmNWeMoUNGpfoz2SKflzhBVwRYmF9/7lji3p7qwAIbC8RkjxrvAY/ZtPnAsB1
         EHogmdArZBkVkvrFvv7DWaxcun1UAT5Pb+lkcgHSwdHvRMI7XZVrc+HUG+JZ11oUKllA
         w7UnKXXyn9WraK+ztxM1fJzZwLC73OmYuScoxM+lF7s9qXRomMhtrgbSRFgI/DNfQQWi
         ibAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+Oa4akqQuA03DpOEuunHhYKXvjCon113uZBfDfwJZRs=;
        b=lGC4eGHVRmlbw6h7L87icn0M+QkQGIfs+uuFSnzjNo3fLQUeCO43xjKyLO5TT82j7a
         dJVsoz3tAQbmcXxZIOYAlrh8y0hV5qrW9wW5iDS295V+cukOJ4LEdhIXcqTNHLMjA44f
         d7k+PzkizTUD6WL4fUMgSNGRbfz4+v0B+mDo7Gd84c+fxb5ywe3944LNzBlHsFmHDjRp
         RzdH/OzspSKFjEWcJY6aoqDg3yEPbitPTFQbTk8+jJF2gZ+nESUP5qyeZb6gmTHt6RVZ
         EFgeqEgziDBjd2BNYxgQBs/deB9dl48HuRycjOokORTW0Lab1D9IiCHmtQSnE5pLYctb
         1Z0w==
X-Gm-Message-State: AOAM530xHPniCy7S4uEFLe4y3UWRHf/7qudcuqHSaNqoOCpivC8lpYAz
        repLp8RL2npFEfVCueAHWJ147YoiR6A=
X-Google-Smtp-Source: ABdhPJzxbObh6CYnLvtJJlBAGKyOEINxXCM864eqzZwOxaHwkZXIZWDPQMgdN+FZzye63sUnUqlHVQ==
X-Received: by 2002:a63:f14:: with SMTP id e20mr3549493pgl.52.1603966462857;
        Thu, 29 Oct 2020 03:14:22 -0700 (PDT)
Received: from localhost.localdomain ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id s9sm2488073pfh.67.2020.10.29.03.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:14:22 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V8 00/14] Bail out if transaction can cause extent count to overflow
Date:   Thu, 29 Oct 2020 15:43:34 +0530
Message-Id: <20201029101348.4442-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS does not check for possible overflow of per-inode extent counter
fields when adding extents to either data or attr fork.

For e.g.
1. Insert 5 million xattrs (each having a value size of 255 bytes) and
   then delete 50% of them in an alternating manner.

2. On a 4k block sized XFS filesystem instance, the above causes 98511
   extents to be created in the attr fork of the inode.

   xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131

3. The incore inode fork extent counter is a signed 32-bit
   quantity. However, the on-disk extent counter is an unsigned 16-bit
   quantity and hence cannot hold 98511 extents.

4. The following incorrect value is stored in the xattr extent counter,
   # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
   core.naextents = -32561

This patchset adds a new helper function
(i.e. xfs_iext_count_may_overflow()) to check for overflow of the
per-inode data and xattr extent counters and invokes it before
starting an fs operation (e.g. creating a new directory entry). With
this patchset applied, XFS detects counter overflows and returns with
an error rather than causing a silent corruption.

The patchset has been tested by executing xfstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

The patches can also be obtained from
https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v8.

I have two patches that define the newly introduced error injection
tags in xfsprogs
(https://github.com/chandanr/xfsprogs-dev/commit/7fd7aeef1cefbcc9abd6dd5887e710c80e48079d
and
https://github.com/chandanr/xfsprogs-dev/commit/3cbe12f6fdf306de06c4096eb50641fa2d834dc5).

I have also written tests
(https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
for verifying the checks introduced in the kernel. They depend on
error tags introduced in these patches . Hence, I am planning to post
the changes for xfsprogs and xfstests if other developers are fine
with the changes made in this patchset.

Changelog:
V7 -> V8:
  1. Rename local variable in xfs_alloc_fix_freelist() from "i" to "stat".

V6 -> V7:
  1. Create new function xfs_bmap_exact_minlen_extent_alloc() (enabled
     only when CONFIG_XFS_DEBUG is set to y) which issues allocation
     requests for minlen sized extents only. In order to achieve this,
     common code from xfs_bmap_btalloc() have been refactored into new
     functions.
  2. All major functions implementing logic associated with
     XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag are compiled only
     when CONFIG_XFS_DEBUG is set to y.
  3. Remove XFS_IEXT_REFLINK_REMAP_CNT macro and replace it with an
     integer which holds the number of new extents to be
     added to the data fork.

V5 -> V6:
  1. Rebased the patchset on xfs-linux/for-next branch.
  2. Drop "xfs: Set tp->t_firstblock only once during a transaction's
     lifetime" patch from the patchset.
  3. Add a comment to xfs_bmap_btalloc() describing why it was chosen
     to start "free space extent search" from AG 0 when
     XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is enabled and when the
     transaction is allocating its first extent.
  4. Fix review comments associated with coding style.

V4 -> V5:
  1. Introduce new error tag XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT to
     let user space programs to be able to guarantee that free space
     requests for files are satisfied by allocating minlen sized
     extents.
  2. Change xfs_bmap_btalloc() and xfs_alloc_vextent() to allocate
     minlen sized extents when XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is
     enabled.
  3. Introduce a new patch that causes tp->t_firstblock to be assigned
     to a value only when its previous value is NULLFSBLOCK.
  4. Replace the previously introduced MAXERRTAGEXTNUM (maximum inode
     fork extent count) with the hardcoded value of 10.
  5. xfs_bui_item_recover(): Use XFS_IEXT_ADD_NOSPLIT_CNT when mapping
     an extent.
  6. xfs_swap_extent_rmap(): Use xfs_bmap_is_real_extent() instead of
     xfs_bmap_is_update_needed() to assess if the extent really needs
     to be swapped.

V3 -> V4:
  1. Introduce new patch which lets userspace programs to test "extent
     count overflow detection" by injecting an error tag. The new
     error tag reduces the maximum allowed extent count to 10.
  2. Injecting the newly defined error tag prevents
     xfs_bmap_add_extent_hole_real() from merging a new extent with
     its neighbours to allow writing deterministic tests for testing
     extent count overflow for Directories, Xattr and growing realtime
     devices. This is required because the new extent being allocated
     can be contiguous with its neighbours (w.r.t both file and disk
     offsets).
  3. Injecting the newly defined error tag forces block sized extents
     to be allocated for summary/bitmap files when growing a realtime
     device. This is required because xfs_growfs_rt_alloc() allocates
     as large an extent as possible for summary/bitmap files and hence
     it would be impossible to write deterministic tests.
  4. Rename XFS_IEXT_REMOVE_CNT to XFS_IEXT_PUNCH_HOLE_CNT to reflect
     the actual meaning of the fs operation.
  5. Fold XFS_IEXT_INSERT_HOLE_CNT code into that associated with
     XFS_IEXT_PUNCH_HOLE_CNT since both perform the same job.
  6. xfs_swap_extent_rmap(): Check for extent overflow should be made
     on the source file only if the donor file extent has a valid
     on-disk mapping and vice versa.

V2 -> V3:
  1. Move the definition of xfs_iext_count_may_overflow() from
     libxfs/xfs_trans_resv.c to libxfs/xfs_inode_fork.c. Also, I tried
     to make xfs_iext_count_may_overflow() an inline function by
     placing the definition in libxfs/xfs_inode_fork.h. However this
     required that the definition of 'struct xfs_inode' be available,
     since xfs_iext_count_may_overflow() uses a 'struct xfs_inode *'
     type variable.
  2. Handle XFS_COW_FORK within xfs_iext_count_may_overflow() by
     returning a success value.
  3. Rename XFS_IEXT_ADD_CNT to XFS_IEXT_ADD_NOSPLIT_CNT. Thanks to
     Darrick for the suggesting the new name.
  4. Expand comments to make use of 80 columns.

V1 -> V2:
  1. Rename helper function from xfs_trans_resv_ext_cnt() to
     xfs_iext_count_may_overflow().
  2. Define and use macros to represent fs operations and the
     corresponding increase in extent count.
  3. Split the patches based on the fs operation being performed.

Chandan Babu R (14):
  xfs: Add helper for checking per-inode extent count overflow
  xfs: Check for extent overflow when trivally adding a new extent
  xfs: Check for extent overflow when punching a hole
  xfs: Check for extent overflow when adding/removing xattrs
  xfs: Check for extent overflow when adding/removing dir entries
  xfs: Check for extent overflow when writing to unwritten extent
  xfs: Check for extent overflow when moving extent from cow to data
    fork
  xfs: Check for extent overflow when remapping an extent
  xfs: Check for extent overflow when swapping extents
  xfs: Introduce error injection to reduce maximum inode fork extent
    count
  xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
  xfs: Compute bmap extent alignments in a separate function
  xfs: Process allocated extent in a separate function
  xfs: Introduce error injection to allocate only minlen size extents
    for files

 fs/xfs/libxfs/xfs_alloc.c      |  50 +++++++
 fs/xfs/libxfs/xfs_alloc.h      |   3 +
 fs/xfs/libxfs/xfs_attr.c       |  13 ++
 fs/xfs/libxfs/xfs_bmap.c       | 259 ++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_errortag.h   |   6 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  27 ++++
 fs/xfs/libxfs/xfs_inode_fork.h |  62 ++++++++
 fs/xfs/xfs_bmap_item.c         |  10 ++
 fs/xfs/xfs_bmap_util.c         |  31 ++++
 fs/xfs/xfs_dquot.c             |   8 +-
 fs/xfs/xfs_error.c             |   6 +
 fs/xfs/xfs_inode.c             |  27 ++++
 fs/xfs/xfs_iomap.c             |  10 ++
 fs/xfs/xfs_reflink.c           |  16 ++
 fs/xfs/xfs_rtalloc.c           |   5 +
 fs/xfs/xfs_symlink.c           |   5 +
 16 files changed, 465 insertions(+), 73 deletions(-)

-- 
2.28.0


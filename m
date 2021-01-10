Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCB2C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D2322AAA
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbhAJDaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbhAJDaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:30:22 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80678C061786
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:29:42 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j13so8415844pjz.3
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R0AFrNAkRA5bHKCSXse0ArghmMA7GjKM3J2a+7P00Lg=;
        b=Ff2wSc6RXD2tN0nYQfbE5YDEHqly7acyS9Fqv0XIZhGOpwUVQl8s2fyRx65OBjhqgf
         qTo9oaEcgl4VbFrgjXAphJQqjBSYbrOvY8BFOUMEFMT/RCL1hhghfU1MSgTbgncIc9Qg
         XcH+51DBv+LaZ1qfAplhRhX6GeVij0NrT6iqMsgI+lV+PY6C/NmIVz76mFtHXYslFOJ9
         tr/x6SvjQMaGl3nQ4CaXXXJGxUYutEXYtblbLQnPDbLjeW6RnfqrZToERKIP6aCs74RJ
         z84k5ppw6geyYLSgmFHChBTJXCaL4tCaNXkffKfkt8rnoEbTmDJwZviiHVoL5dY7drj+
         F8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R0AFrNAkRA5bHKCSXse0ArghmMA7GjKM3J2a+7P00Lg=;
        b=EcYAzleCjDJUhN/FLrxbtS9w7U839jmeqUqoHJ7zfm21KTL0RLrg7oyRNG+6pQLYlN
         gKBPDg//2ZMCMcKO0A5JehP42IewnOXuOmy1Z6EBRp4a6U0H0rKKdoebSvcK+ZJQciR0
         TjrbnkS+2N05bjJ35m1a3tvF/ZziEYzTO7U1coukUnvUYYxMtlCAChl6ZM0g3wD1SY6O
         qpkq+36zo9FmJed2/C0EtnwJ9TGZvDLWQ8G5jhNmyAs4AeSxxWWjTV9SHKAVZlNDeOYD
         4fH8uGdC/jqosWr7EKPaUOQAEydUxyjkiAXb1tUGhdPo7vcWab0KPbdH+N4gW+4eu0YV
         k7Rw==
X-Gm-Message-State: AOAM531uUezkuPICHEBpSrgdP/WBcAq2BoXd/75jNXjUkUCOg1/UaL5p
        B5IkEv1HO2TvhK48bSF4s6aS/l4Pn64Cug==
X-Google-Smtp-Source: ABdhPJy4cW9ZgebfN5lOC8+LL3aYjPWaLaXx8QX2UO8UTG65ArnBTxgh5olaA7vbgGV3LLdGkSQWNA==
X-Received: by 2002:a17:902:ac93:b029:db:c725:e321 with SMTP id h19-20020a170902ac93b02900dbc725e321mr10934074plr.41.1610249381519;
        Sat, 09 Jan 2021 19:29:41 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:29:40 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 00/16] Bail out if transaction can cause extent count to overflow
Date:   Sun, 10 Jan 2021 08:59:12 +0530
Message-Id: <20210110032928.3120861-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
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
https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v13.

I have two patches that define the newly introduced error injection
tags in xfsprogs
(https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/).

I have also written tests
(https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
for verifying the checks introduced in the kernel.

Changelog:
V12 -> V13:
  1. xfs_rename():
     - Add comment explaining why we do not check for extent count
       overflow for the source directory entry of a rename operation.
     - Fix grammatical nit in a comment.
  2. xfs_bmap_del_extent_real():
     Replace explicit checks for inode's mode and fork with an
     assert() call since extent count overflow check here is
     applicable only to directory entry remove/rename operation.
  
V11 -> V12:
  1. Rebase patches on top of Linux v5.11-rc1.
  2. Revert back to using using a pseudo max inode extent count of 10.
     Hence the patches
     - [PATCH V12 05/14] xfs: Check for extent overflow when adding/removing xattrs
     - [PATCH V12 10/14] xfs: Introduce error injection to reduce maximum
     have been reverted back (including retaining of corresponding RVB
     tags) to how it was under V10 of the patchset.

     V11 of the patchset had increased the max pseudo extent count to
     35 to allow for "directory entry remove" operation to always
     succeed. However the corresponding logic was incorrect. Please
     refer to "[PATCH V12 04/14] xfs: Check for extent overflow when
     adding/removing dir entries" to find logic and explaination of
     the newer logic.

     "[PATCH V12 04/14] xfs: Check for extent overflow when
     adding/removing dir entries" is the only patch yet to be reviewed.

V10 -> V11:
  1. For directory/xattr insert operations we now reserve sufficient
     number of "extent count" so as to guarantee a future
     directory/xattr remove operation.
  2. The pseudo max extent count value has been increased to 35.

V9 -> V10:
  1. Pull back changes which cause xfs_bmap_compute_alignments() to
     return "stripe alignment" into 12th patch i.e. "xfs: Compute bmap
     extent alignments in a separate function".

V8 -> V9:
  1. Enabling XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag will
     always allocate single block sized free extents (if
     available).
  2. xfs_bmap_compute_alignments() now returns stripe alignment as its
     return value.
  3. Dropped Allison's RVB tag for "xfs: Compute bmap extent
     alignments in a separate function" and "xfs: Introduce error
     injection to allocate only minlen size extents for files".

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

Chandan Babu R (16):
  xfs: Add helper for checking per-inode extent count overflow
  xfs: Check for extent overflow when trivally adding a new extent
  xfs: Check for extent overflow when punching a hole
  xfs: Check for extent overflow when adding dir entries
  xfs: Check for extent overflow when removing dir entries
  xfs: Check for extent overflow when renaming dir entries
  xfs: Check for extent overflow when adding/removing xattrs
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

 fs/xfs/libxfs/xfs_alloc.c      |  50 ++++++
 fs/xfs/libxfs/xfs_alloc.h      |   3 +
 fs/xfs/libxfs/xfs_attr.c       |  13 ++
 fs/xfs/libxfs/xfs_bmap.c       | 284 ++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_errortag.h   |   6 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  27 ++++
 fs/xfs/libxfs/xfs_inode_fork.h |  63 ++++++++
 fs/xfs/xfs_bmap_item.c         |  10 ++
 fs/xfs/xfs_bmap_util.c         |  31 ++++
 fs/xfs/xfs_dquot.c             |   8 +-
 fs/xfs/xfs_error.c             |   6 +
 fs/xfs/xfs_inode.c             |  54 ++++++-
 fs/xfs/xfs_iomap.c             |  10 ++
 fs/xfs/xfs_reflink.c           |  16 ++
 fs/xfs/xfs_rtalloc.c           |   5 +
 fs/xfs/xfs_symlink.c           |   5 +
 16 files changed, 512 insertions(+), 79 deletions(-)

-- 
2.29.2


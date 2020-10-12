Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C257BC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B3762087D
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Undl7DDl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgJLJaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 05:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729385AbgJLJaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 05:30:07 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BD4C0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:07 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id 1so2406126ple.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tHjEaWIYw9BiyszTfvvAQlfHL/dESzP6itXCGlfjbyY=;
        b=Undl7DDlMBn6jFzZcK4RzqtNn8nLgtLeQ9XWcU+uotfI8k+Yi7Xp28vHDjv2dh0+OY
         WIapGprndP8ZdPARzP8UVkxt5iO9pzJZ/kZK4S7VmXiZ6r91OccXnwq0IINbg2dW/6KR
         tpa0QBjRtWVN8q6q9dWEpXEXr6i09F1GinUSSz/Qdv+6XNNXJ6/TU1epmzWCb2teXHft
         QihagkA+wQ1D8Gbrf99cnD0O+2SJSP4E7ZKYKcvO+xessBvs4h1dneO4kU0wJdyH6lzK
         oBiwgmHwyH+fMSV4wyFRO9N+CRbinYam7zr9VY26cfsYoogEA/6x0eqXUgwCgf0cCBcx
         4MeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tHjEaWIYw9BiyszTfvvAQlfHL/dESzP6itXCGlfjbyY=;
        b=bcUW+b/WuA31Mw5LihrZRdqZVrFhKcD0JgB3M/rgaPbuyiMmz3tz5Az5ni7ftYKu1p
         YmJVrNpbi9YulODLmp7wjPjWQikvkabJ/S8uQwRWcnMbtqjNDIGJlVO7XVwcPH+Pv+7o
         xQ8bUmtuEv7HpZ1obMC2gq8ySW9jIhE9PxdzNLuMV6ENiX4iOsfTQd0k+1pWxTuIc0g9
         /C4VCYOadrdT80sOVIJqu3lfP09jupns2nnR4sPhUUocEtSvDMCXcf5zKAeYYtgXE9om
         IlydhEJdTyAZ8FtuIl0CMhZm69lhM9FU+LpG8nghsqYqJzlxmsYYH3+CGalH+1UxtFmt
         mjLQ==
X-Gm-Message-State: AOAM532dSR6yW2MR8oLRjj1yACFSokIO1u0ehs9vVNir1wyrO3rG2F81
        xNBWLnXQ77qEA0WZhA4qnbJofZtrL34=
X-Google-Smtp-Source: ABdhPJwEnehS2+CEDUa87i/CJjy3eESy1AcFmNRTkV4/2NkrCA0wElKSFb1KqYRw2rQsAmIBy3Gxxg==
X-Received: by 2002:a17:902:bf0a:b029:d2:88b1:29e6 with SMTP id bi10-20020a170902bf0ab02900d288b129e6mr23538656plb.15.1602495006305;
        Mon, 12 Oct 2020 02:30:06 -0700 (PDT)
Received: from localhost.localdomain ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id z142sm19451985pfc.179.2020.10.12.02.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 02:30:05 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V6 00/11] Bail out if transaction can cause extent count to overflow
Date:   Mon, 12 Oct 2020 14:59:27 +0530
Message-Id: <20201012092938.50946-1-chandanrlinux@gmail.com>
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
https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v6.

I have two patches that define the newly introduced error injection
tags in xfsprogs
(https://github.com/chandanr/xfsprogs-dev/commit/7fd7aeef1cefbcc9abd6dd5887e710c80e48079d
and
https://github.com/chandanr/xfsprogs-dev/commit/3cbe12f6fdf306de06c4096eb50641fa2d834dc5).

I have also written tests
(https://github.com/chandanr/check-iext-overflow/blob/master/check-iext-overflow.sh/)
for verifying the checks introduced in the kernel. The tests have to
be edited to make them suitable for merging with xfstests. But they
also depend on error tags introduced in these patches . Hence, I am
planning to post the changes for xfsprogs and xfstests if other
developers are fine with the changes made in this patchset.

Changelog:
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

Chandan Babu R (11):
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
  xfs: Introduce error injection to allocate only minlen size extents
    for files

 fs/xfs/libxfs/xfs_alloc.c      | 46 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h      |  1 +
 fs/xfs/libxfs/xfs_attr.c       | 13 ++++++
 fs/xfs/libxfs/xfs_bmap.c       | 40 ++++++++++++++----
 fs/xfs/libxfs/xfs_errortag.h   |  6 ++-
 fs/xfs/libxfs/xfs_inode_fork.c | 27 ++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 77 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.c         | 10 +++++
 fs/xfs/xfs_bmap_util.c         | 31 ++++++++++++++
 fs/xfs/xfs_dquot.c             |  8 +++-
 fs/xfs/xfs_error.c             |  6 +++
 fs/xfs/xfs_inode.c             | 27 ++++++++++++
 fs/xfs/xfs_iomap.c             | 10 +++++
 fs/xfs/xfs_reflink.c           | 10 +++++
 fs/xfs/xfs_rtalloc.c           |  5 +++
 fs/xfs/xfs_symlink.c           |  5 +++
 16 files changed, 313 insertions(+), 9 deletions(-)

-- 
2.28.0


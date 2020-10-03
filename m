Return-Path: <SRS0=fxM9=DK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F2FBC4363D
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D20DC206DB
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:56:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sQ4Indrh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgJCF4s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Oct 2020 01:56:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AB3C0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 22:56:46 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q4so2441809pjh.5
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 22:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b8ZuztcBYLWQqVQ3emWtfAW71IKOUR0iF+Lp7SCxAB4=;
        b=sQ4Indrhc7bNV2wpK1JUZeWo9GSR3h5t35p3Vs2cq9JPAdZ8Q0ohlHWBhdD29LXsFR
         7x9kMuZDR6J3J2Q/xUmJo0B0c6foUuqwPlcmfZoVKiG3lVCgFjlfgnFAf2+zxNXBnV5B
         b6YX44pfmQzIzF0sinMUVmCLNFUhqpO12nGnI2aqmK5TZFWUmywycKpY9kKAFRmh59C8
         /hO9D8Kb3aT+THg/szdUus28t9sKSW3WV+zIteec9RBEXhhNfjgFGIUMqQr4QCVe8Pc3
         Gw49/sR3rz8pyGlSBlJW3jzzNVBoNqAGTfUhN5XF3KXmvu0jCOu+xxyo1DNLflyzHq7g
         eHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b8ZuztcBYLWQqVQ3emWtfAW71IKOUR0iF+Lp7SCxAB4=;
        b=e5xzm1BXkOjocFCaWvtniHLr4FUaSIAmocpm5bdZK68okOZUsT9TnrdW4CouY5Nxgo
         EFJFuWxxVEWMtfA0HC5oX375mT4ZsKRfKS1dEG9kGX3Nc0hx2+6Wm67rsl0mPBJ7T/MR
         aG3HMySYvf74fZ8dD+thag1ESYea0Mmwo9H2W7dhbC2FYwK7P72jqxMB1YgrpJcvMTU4
         MXZgNu9A4TS0AG0sVzhPqc+hBlvJ4G+LENaTNhC8+7OYyHbscopQeRcQZVsT/UdFkcbv
         xBNq7aGpNmJzOwtRsUzdQxSgB0zn0jERzUOTRXsfUqSzjkrnHxox3v1cKWPxNFnf7TXC
         jCvg==
X-Gm-Message-State: AOAM532P2rDoHA/h9mbvLA1UXrOcLwXYiyQZrA2hUuaZG/u2OgRdq8vg
        SBP9Y+7yL6IewbrneebAKtDvUe2lcHQ=
X-Google-Smtp-Source: ABdhPJxcgNZ4Rv39C/BY77Qw+XVtf+b1V6JoqD/rUcmxHpNzXf7S1o5cklCvQhLTQGHgp1W9+F86sA==
X-Received: by 2002:a17:90b:384c:: with SMTP id nl12mr5281081pjb.166.1601704605748;
        Fri, 02 Oct 2020 22:56:45 -0700 (PDT)
Received: from localhost.localdomain ([122.171.168.96])
        by smtp.gmail.com with ESMTPSA id 125sm4106664pff.59.2020.10.02.22.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:56:45 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V5 00/12] Bail out if transaction can cause extent count to overflow
Date:   Sat,  3 Oct 2020 11:26:21 +0530
Message-Id: <20201003055633.9379-1-chandanrlinux@gmail.com>
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
https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v5.

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


Chandan Babu R (12):
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
  xfs: Set tp->t_firstblock only once during a transaction's lifetime
  xfs: Introduce error injection to allocate only minlen size extents
    for files

 fs/xfs/libxfs/xfs_alloc.c      | 46 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h      |  1 +
 fs/xfs/libxfs/xfs_attr.c       | 13 ++++++
 fs/xfs/libxfs/xfs_bmap.c       | 38 +++++++++++++----
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
 16 files changed, 309 insertions(+), 11 deletions(-)

-- 
2.28.0


Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EC3C43463
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED76921D7B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ODSGzIPx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgIRJsS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 05:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRJsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 05:48:18 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1049DC06174A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t7so2880964pjd.3
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oKVgNSzMZ12qJUEvb/NkNxVN0U4VEHofSdV/xbbrndY=;
        b=ODSGzIPxtbwPWdjKLcopedS/ouETLy6f9lZgMDKkwfoZgwjZ1vwcHanhQcQHOl6mfF
         7e8upzPjj+SJmnzchXsHeQhHf/6bdiJT7SOOPaq3X/iD8BvIYkKbI+OtYTzbEPTB4nlt
         RcsF360P/+Dd9+8SZbU6xquVk5+AZ4W3w2ZwVt6ZoRM3w8r8zQZEmwx/Cq6EvaTXucme
         EYCoX5gg56Nbuv41Ez58fzp2wylVFq54qhVD3UrYdMqESWBBEHtzc6E+0bZ8l+fDoEq+
         +EJVcVIRMyH+adDzE14cUcWDkAj9by3f4qkOpbpM1fDVgEYNNxfpX+HLcY+RRzSVDxha
         pTpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oKVgNSzMZ12qJUEvb/NkNxVN0U4VEHofSdV/xbbrndY=;
        b=FUyIu6JuWDnrpGd9pk/ahEc+q2V9OS/kSfvjPsKxNZkfZSVdPcb5SNNfwJMVlo2jmn
         W54u1cJLKhOo/xuGxYcoyayo96pEJwgUCP3vrXO8ZwsRBiCdmqLGDkKH9oVjEZ10mMdN
         hBjq+b4DeDOvDXhUk5sCO+WRw9qYxgsOJxpb0ZmSx5QGzsaxE4LbAFQqr4dznRRKPSsN
         3AJrHrBz7nu9dZnLR4J0dbFXn2YA695p9vDSaGYTrvBfW+DvmldJIrT4+BipcdTYzyLT
         tgB6TZ8XMR2QDN7WAA+MQSm/disvvfZWgD0HBbfCPrcK5nfROdKEO9btPCk58JoUlByr
         rXNA==
X-Gm-Message-State: AOAM530JiiNMl3EbWodA7E1Hg/ryvIc9fdOzmHE0l5IHHEkMxHVf2keN
        HNy7EHXnJ31w8glhDSJWrvP5rYZHYUc=
X-Google-Smtp-Source: ABdhPJyVHR0yXX4uP+ZlEhYiOBLLeX08YbTZA8p/X6J/9XojmxW51uDpg6F31uBtDqclxyXMrrayGg==
X-Received: by 2002:a17:90a:d997:: with SMTP id d23mr12702700pjv.171.1600422497016;
        Fri, 18 Sep 2020 02:48:17 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id s24sm2227194pjp.53.2020.09.18.02.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 02:48:16 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V4 00/10] Bail out if transaction can cause extent count to overflow
Date:   Fri, 18 Sep 2020 15:17:49 +0530
Message-Id: <20200918094759.2727564-1-chandanrlinux@gmail.com>
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
https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v4.

I have a patch that defines the newly introduced error injection tag
in xfsprogs
(https://github.com/chandanr/xfsprogs-dev/commit/7fd7aeef1cefbcc9abd6dd5887e710c80e48079d).
I have also written tests (https://paste.debian.net/1164261/) for
verifying the checks introduced in the kernel. The tests have to be
edited to make them suitable for merging with xfstests. But they also
depend on the changes introduced in xfs_bmap_add_extent_hole_real()
and xfs_growfs_rt_alloc(). Hence, I am planning to post the changes
for xfsprogs and xfstests if other developers are fine with the
changes made to the previously listed functions.

Changelog:
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


Chandan Babu R (10):
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

 fs/xfs/libxfs/xfs_attr.c       | 13 ++++++
 fs/xfs/libxfs/xfs_bmap.c       | 33 ++++++++++-----
 fs/xfs/libxfs/xfs_bmap.h       |  1 +
 fs/xfs/libxfs/xfs_errortag.h   |  4 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 27 ++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 77 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h      |  1 +
 fs/xfs/xfs_bmap_item.c         |  5 +++
 fs/xfs/xfs_bmap_util.c         | 32 ++++++++++++++
 fs/xfs/xfs_dquot.c             |  8 +++-
 fs/xfs/xfs_error.c             |  3 ++
 fs/xfs/xfs_inode.c             | 27 ++++++++++++
 fs/xfs/xfs_iomap.c             | 10 +++++
 fs/xfs/xfs_reflink.c           | 10 +++++
 fs/xfs/xfs_rtalloc.c           | 21 +++++++++-
 fs/xfs/xfs_symlink.c           |  5 +++
 16 files changed, 262 insertions(+), 15 deletions(-)

-- 
2.28.0


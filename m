Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED526C63777
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E26822269
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p8JhZlAE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgKUIXq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKUIXq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:23:46 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4A4C0613CF;
        Sat, 21 Nov 2020 00:23:45 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 81so9491836pgf.0;
        Sat, 21 Nov 2020 00:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OWMCz4AhGTMMM/gGCJooYKCo2WczL/OH1m4TcuXKgBk=;
        b=p8JhZlAEbPjHN+oq6f2FybnS7tqvKVeatRmyV9NbSpjtyKIiQM87EUupF7NC0xd+nU
         ApyYCowialT7V9rVoow0M9qz4bHLF0UxXePuyUJuaKaU2fgX3Re47MTt7GBKOrgG8Rq+
         /g1ECLJ4w+jqhoL8HZ0zVxW3DhvHpiM0ym1BQzqlgUUEwRJNa9cLQQsIdAWFuqJA/rJT
         xe11U+aUVsIf+brVbgIw1t5L0BdrYszJ21UxwMhg9EGvrhvuMVcsnn9BmRoHWmFNf8C+
         gCAswpPfLsCvyz33/t6mCD1ue80si2/0ChgpA/QDooBUBAaNAhIDAMVkyM1d0ycFerpW
         /NEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OWMCz4AhGTMMM/gGCJooYKCo2WczL/OH1m4TcuXKgBk=;
        b=DsTPtQcpZ90qQvzUcehastG/dEo9paELJyiN9xWtYICMrrSH5Qbb218MhbUE46CFx4
         Rlm6/tODqvEf6Drn9uWsTIxGifNLvcetb41mXCKYwr3mmzkCjGaZz8jNIWuO6hhKMgoH
         +T9cO/MYfwRmLDBNfmVtKmmwMT9FrHLNLRmmjtF7kL2sqQeqHXtfDtcVCUppphhlyOko
         xvLDwT8kHfC+fVHR8nfhW1B2O66LCH8cLjtUXXLJBzZ9Wxp3cSuWlqQ9NMelYk4GgdLJ
         XBzZKzQpLKNSo9o3KNheL5ImEb/+1QmgUQcyYZiEidEkRZr/m06DpRzm7tygAohxyUXA
         GFUQ==
X-Gm-Message-State: AOAM533rFiOENDeJHjQ+IS6oCirf9dJLcin8nFryuZSrD8iGGv69YoZd
        2kv17mQR/4QCl8LTzyRN7C3Q7aimjGU=
X-Google-Smtp-Source: ABdhPJx2k/+2kEadJW3rvZ8U4OC0jZDVEz541/ay0Bbu7R5E0lg5N3awjEu6CwySfMEKZxgqwPUaqA==
X-Received: by 2002:a17:90a:dd46:: with SMTP id u6mr14880798pjv.162.1605947024151;
        Sat, 21 Nov 2020 00:23:44 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:23:43 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 00/11] xfs: Tests to check for inode fork extent count overflow detection
Date:   Sat, 21 Nov 2020 13:53:21 +0530
Message-Id: <20201121082332.89739-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The patchset at
https://lore.kernel.org/linux-xfs/20201117134416.207945-1-chandanrlinux@gmail.com/T/
added support to XFS to detect inode extent count overflow when
performing various filesystem operations. The patchset also added
new error injection tags for,
1. Reducing maximum extent count to 35.
2. Allocating only single block sized extents.

The corresponding code for xfsprogs can be obtained from
https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/.

The patches posted along with this cover letter add tests to verify if
the in-kernel inode extent count overflow detection mechanism works
correctly.

These patches can also be obtained from
https://github.com/chandanr/xfstests.git at branch
extent-overflow-tests.

Changelog:
V1 -> V2:
  1. Obtain extent count for inodes accessible through filesystem path
     names via "xfs_io -c 'stat' ..." command line. This gets rid of
     unmount/mount cycles from most of the tests.
  2. Use _fill_fs() to consume free space of a filesystem.
  3. Use _scratch_inject_error() helper to enable/disable error tags.
  4. Use sizeof(struct xfs_dqblk) to calculate number of quotas inside
     one filesystem block.
  5. Write once to every block of the quota inode instead of
     sequentially filling up each block.
  6. Use _get_file_block_size() for tests involving regular files.
  7. Modify tests to suit the new pseudo max extent count of 35.
  8. Replace xfs_io with $XFS_IO_PROG.
  9. Remove code that extended a realtime file since this takes the
     same path as direct I/O to a regular file.
  10. For xattr, do not execute test script when block size is < 4k.
  11. Add code to test if removing an xattr from a full attribute fork
      succeeds.
  12. Add code to test if removing a file whose attribute fork is full
      succeeds.
  13. Add code to test if removing a entry from a full directory
      succeeds.
  14. Add code to test if removing a full directory succeeds.
  15. Writing to unwritten extents: Integrate buffered and direct I/O
      tests into a for loop.
  16. Writing to a shared extent test: Add test to check funshare
      operation.
  17. Use _scale_fsstress_args() to scale values for "-p" and "-n"
      arguments for fsstress.

Chandan Babu R (11):
  common/xfs: Add a helper to get an inode fork's extent count
  xfs: Check for extent overflow when trivally adding a new extent
  xfs: Check for extent overflow when growing realtime bitmap/summary
    inodes
  xfs: Check for extent overflow when punching a hole
  xfs: Check for extent overflow when adding/removing xattrs
  xfs: Check for extent overflow when adding/removing dir entries
  xfs: Check for extent overflow when writing to unwritten extent
  xfs: Check for extent overflow when moving extent from cow to data
    fork
  xfs: Check for extent overflow when remapping an extent
  xfs: Check for extent overflow when swapping extents
  xfs: Stress test with with bmap_alloc_minlen_extent error tag enabled

 common/xfs        |  22 ++++
 tests/xfs/522     | 175 ++++++++++++++++++++++++++++
 tests/xfs/522.out |  20 ++++
 tests/xfs/523     | 119 +++++++++++++++++++
 tests/xfs/523.out |  11 ++
 tests/xfs/524     |  84 ++++++++++++++
 tests/xfs/524.out |  19 ++++
 tests/xfs/525     | 176 ++++++++++++++++++++++++++++
 tests/xfs/525.out |  19 ++++
 tests/xfs/526     | 283 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/526.out |  32 ++++++
 tests/xfs/527     |  89 +++++++++++++++
 tests/xfs/527.out |  11 ++
 tests/xfs/528     | 110 ++++++++++++++++++
 tests/xfs/528.out |  12 ++
 tests/xfs/529     |  82 ++++++++++++++
 tests/xfs/529.out |   8 ++
 tests/xfs/530     | 109 ++++++++++++++++++
 tests/xfs/530.out |  13 +++
 tests/xfs/531     |  84 ++++++++++++++
 tests/xfs/531.out |   7 ++
 tests/xfs/group   |  10 ++
 22 files changed, 1495 insertions(+)
 create mode 100755 tests/xfs/522
 create mode 100644 tests/xfs/522.out
 create mode 100755 tests/xfs/523
 create mode 100644 tests/xfs/523.out
 create mode 100755 tests/xfs/524
 create mode 100644 tests/xfs/524.out
 create mode 100755 tests/xfs/525
 create mode 100644 tests/xfs/525.out
 create mode 100755 tests/xfs/526
 create mode 100644 tests/xfs/526.out
 create mode 100755 tests/xfs/527
 create mode 100644 tests/xfs/527.out
 create mode 100755 tests/xfs/528
 create mode 100644 tests/xfs/528.out
 create mode 100755 tests/xfs/529
 create mode 100644 tests/xfs/529.out
 create mode 100755 tests/xfs/530
 create mode 100644 tests/xfs/530.out
 create mode 100755 tests/xfs/531
 create mode 100644 tests/xfs/531.out

-- 
2.29.2


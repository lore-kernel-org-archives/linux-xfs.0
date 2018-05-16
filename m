Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33532 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbeEPUiz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 16:38:55 -0400
Received: by mail-pg0-f65.google.com with SMTP id v7-v6so807599pgs.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 13:38:55 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 0/5] xfstests: generic swap file tests
Date: Wed, 16 May 2018 13:38:44 -0700
Message-Id: <cover.1526503000.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Eryu Guan <guaneryu@gmail.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

Changes since v1:

- Add patch 1 to create a group for swap
- Add a helper for formatting a swap file instead of open coding
  everywhere
- Use $CHATTR_PROG instead of chattr in a few places that I forgot

Thanks!

Omar Sandoval (5):
  xfstests: create swap group
  generic: enable swapfile tests on Btrfs
  generic: add test for dedupe on an active swapfile
  generic: add test for truncate/fpunch of an active swapfile
  generic: test invalid swap file activation

 .gitignore            |  2 ++
 common/rc             | 15 ++++++--
 src/Makefile          |  2 +-
 src/mkswap.c          | 83 +++++++++++++++++++++++++++++++++++++++++++
 src/swapon.c          | 24 +++++++++++++
 tests/generic/356     |  7 ++--
 tests/generic/357     |  6 ++--
 tests/generic/488     | 76 +++++++++++++++++++++++++++++++++++++++
 tests/generic/488.out |  7 ++++
 tests/generic/489     | 73 +++++++++++++++++++++++++++++++++++++
 tests/generic/489.out |  8 +++++
 tests/generic/490     | 77 +++++++++++++++++++++++++++++++++++++++
 tests/generic/490.out |  5 +++
 tests/generic/group   |  7 ++--
 tests/xfs/group       |  2 +-
 15 files changed, 381 insertions(+), 13 deletions(-)
 create mode 100644 src/mkswap.c
 create mode 100644 src/swapon.c
 create mode 100755 tests/generic/488
 create mode 100644 tests/generic/488.out
 create mode 100755 tests/generic/489
 create mode 100644 tests/generic/489.out
 create mode 100755 tests/generic/490
 create mode 100644 tests/generic/490.out

-- 
2.17.0


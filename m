Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:40414 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753235AbeEVXeN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 19:34:13 -0400
Received: by mail-pg0-f68.google.com with SMTP id l2-v6so8528948pgc.7
        for <linux-xfs@vger.kernel.org>; Tue, 22 May 2018 16:34:13 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 0/5] xfstests: generic swap file tests
Date: Tue, 22 May 2018 16:33:55 -0700
Message-Id: <cover.1527031843.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Eryu Guan <guaneryu@gmail.com>, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

Changes since v2:

- Remove file before formatting in _format_swapfile
- Comment on chattr in _format_swapfile
- Remove unnecessary label
- Fix typo in commit message of patch 3
- Redirect chattr +C output in patch 5 to fix XFS failures

Omar Sandoval (5):
  xfstests: create swap group
  generic: enable swapfile tests on Btrfs
  generic: add test for dedupe on an active swapfile
  generic: add test for truncate/fpunch of an active swapfile
  generic: test invalid swap file activation

 .gitignore            |  2 ++
 common/rc             | 17 +++++++--
 src/Makefile          |  2 +-
 src/mkswap.c          | 83 +++++++++++++++++++++++++++++++++++++++++++
 src/swapon.c          | 24 +++++++++++++
 tests/generic/356     |  7 ++--
 tests/generic/357     |  6 ++--
 tests/generic/492     | 76 +++++++++++++++++++++++++++++++++++++++
 tests/generic/492.out |  7 ++++
 tests/generic/493     | 73 +++++++++++++++++++++++++++++++++++++
 tests/generic/493.out |  8 +++++
 tests/generic/494     | 77 +++++++++++++++++++++++++++++++++++++++
 tests/generic/494.out |  5 +++
 tests/generic/group   |  7 ++--
 tests/xfs/group       |  2 +-
 15 files changed, 383 insertions(+), 13 deletions(-)
 create mode 100644 src/mkswap.c
 create mode 100644 src/swapon.c
 create mode 100755 tests/generic/492
 create mode 100644 tests/generic/492.out
 create mode 100755 tests/generic/493
 create mode 100644 tests/generic/493.out
 create mode 100755 tests/generic/494
 create mode 100644 tests/generic/494.out

-- 
2.17.0


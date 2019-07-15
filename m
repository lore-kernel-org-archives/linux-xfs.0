Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33271 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728933AbfGOMzZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 08:55:25 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 0/3] fstests: copy_file_range() tests
Date: Mon, 15 Jul 2019 15:55:13 +0300
Message-Id: <20190715125516.7367-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Eryu,

These are the two remaining copy_file_range() tests which
I used to verify the kernel fixes that are now in master [1].

The bounds check test depends on an xfs_io change that was merged to
xfsprogs v5.1.0-rc1 (copy_range -f).

The cross-device copy test checks a new functionality, so it does
_notrun if copy_range return EXDEV instead of failing.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20190709163947.GE5164@magnolia/

Changes from v3:
- swapfile and immutable file tests already merged (generic/55[34])
- Use an actual loopdev owned by this test
- Use /dev/null and /dev/zero and char devices for test
- _notrun if cross-device copy_range return EXDEV

Changes from v2:
- Change blockdev in test to loop and _require_loop (Olga)
- Implement and use _require_xfs_io_command copy_range -f

Changes from v1:
- Remove patch to test EINVAL behavior instead of short copy
- Remove 'chmod -r' permission drop test case
- Split out test for swap/immutable file copy
- Split of cross-device copy test

Amir Goldstein (3):
  common/rc: check support for xfs_io copy_range -f N
  generic: copy_file_range bounds test
  generic: cross-device copy_file_range test

 common/rc             |   9 ++-
 tests/generic/990     | 134 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/990.out |  37 ++++++++++++
 tests/generic/991     |  64 ++++++++++++++++++++
 tests/generic/991.out |   4 ++
 tests/generic/group   |   2 +
 6 files changed, 249 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/990
 create mode 100644 tests/generic/990.out
 create mode 100755 tests/generic/991
 create mode 100644 tests/generic/991.out

-- 
2.17.1

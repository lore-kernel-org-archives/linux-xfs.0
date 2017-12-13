Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752905AbdLMApZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:45:25 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 0/9] fstests: few updates
Date: Tue, 12 Dec 2017 16:45:10 -0800
Message-Id: <20171213004519.29340-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>

I've deployed fstests on a relatively new system and ran into a few setup
snags which can be fixed easily. Other than this I also ran into a few
issues running a few tests which can easily also be fixed.

I've added a few new groups to help avoiding running tests with a basic
section. Some of these tests are better designed to be run with a custom
section and grouping them up helps with this.

Luis R. Rodriguez (9):
  generic/381: use username fsgqa-381
  README: document group fsgqa is required
  generic/group: add 304 to dedupe group
  build: update AC_PACKAGE_WANT_GDBM() and src/dbtest.c to build
  tests/xfs/group: add group for tests which require a logdev
  tests/ext4/group: add group for tests which require a logdev
  tests/xfs/group: add realtimedev group
  tests/xfs/group: add group for tests which require mkfs v4_5
  tests/xfs/group: add injection group

 README                |  3 ++-
 m4/package_gdbmdev.m4 |  8 ++++++++
 src/dbtest.c          |  1 +
 tests/ext4/group      |  2 +-
 tests/generic/381     | 16 ++++++++--------
 tests/generic/381.out |  4 ++--
 tests/generic/group   |  2 +-
 tests/xfs/group       | 52 +++++++++++++++++++++++++--------------------------
 8 files changed, 49 insertions(+), 39 deletions(-)

-- 
2.15.0


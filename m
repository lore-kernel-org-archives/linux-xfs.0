Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4163 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753817AbeAKGmT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 01:42:19 -0500
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH v4 0/4] test for XFS umount hang caused by the pending dquota log item in AIL
Date: Thu, 11 Jan 2018 14:49:29 +0800
Message-ID: <20180111064933.12088-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

Hi,

This is the v4 patchset for testing the XFS umount hang problem caused by
the pending dquota log item in AIL. The problem had been fixed by commit
373b058 ("xfs: Properly retry failed dquot items in case of error during
buffer writeback"). The changes for v4 are appended in the commit log
of each patches.

Comments and questions are welcome.

Regards,
Tao

Hou Tao (4):
  dmflakey: support multiple dm targets for a dm-flakey device
  dmflakey: support error_writes feature for dm-flakey
  xfs: test for umount hang caused by the pending dquota log item in AIL
  common/rc: factor out _scratch_xfs_[get|set]_sb_field

 common/dmflakey   |  31 +++++++++-
 common/fuzzy      |  33 -----------
 common/xfs        |  47 +++++++++++++++
 tests/xfs/007     |   6 +-
 tests/xfs/098     |   4 +-
 tests/xfs/186     |   3 +-
 tests/xfs/199     |  13 ++--
 tests/xfs/307     |  11 +---
 tests/xfs/308     |  11 +---
 tests/xfs/339     |   6 +-
 tests/xfs/340     |   2 +-
 tests/xfs/999     | 174 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |   2 +
 tests/xfs/group   |   1 +
 14 files changed, 269 insertions(+), 75 deletions(-)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

-- 
2.9.5


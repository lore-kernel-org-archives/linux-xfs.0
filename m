Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:53837 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751111AbdKHH5I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Nov 2017 02:57:08 -0500
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH v2 0/4] test for XFS umount hang caused by the pending dquota log item in AIL
Date: Wed, 8 Nov 2017 16:02:46 +0800
Message-ID: <20171108080250.5662-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

Hi,

This is the v2 patchset for testing the XFS umount hang problem caused by
the pending dquota log item in AIL. The problem has not been fixed in
XFS yet, and Carlos Maiolino is working on it [1]. I had tested
it on 4.14-rc7, and the problem can be reproduced reliably.

Changes since v1:
* dmflakey: support multiple dm targets for a dm-flakey device
	* no update

* xfs: test for umount hang caused by the pending dquota log item in AIL
	* a bunch of suggestions from Eryu Guan
	* update the dquota buffer after the error injection to better
	  reproduce the problem

* common/rc: support checking the version of dm-target in
_require_dm_target()
	* new patch
	* introduce a way to check the availability of error_write feature
	in dm-flakey target, and accomplish it by checking the version of
	dm-target.

* common/rc: factor out _get|set_xfs_scratch_sb_field()
	* new patch
	* the modified test cases had been tested after applying the patch:
	(1) xfs/098 failed, but the failure has nothing to do with the patch
	(2) xfs/339 and xfs/340 were not runnable, because rtdev + rmap is not
	  supported now.
	(3) the remaing test cases passed

v1:
	* https://www.spinics.net/lists/fstests/msg07622.html

Comments and questions are welcome.

Regards,
Tao

[1]: https://www.spinics.net/lists/linux-xfs/msg11614.html
---
Hou Tao (4):
  dmflakey: support multiple dm targets for a dm-flakey device
  common/rc: support checking the version of dm-target in
    _require_dm_target()
  xfs: test for umount hang caused by the pending dquota log item in AIL
  common/rc: factor out _get|set_xfs_scratch_sb_field()

 common/dmflakey   |   2 +-
 common/rc         |  39 +++++++++++--
 common/xfs        |  20 +++++++
 tests/xfs/007     |   6 +-
 tests/xfs/098     |   4 +-
 tests/xfs/186     |   3 +-
 tests/xfs/199     |  13 ++---
 tests/xfs/307     |  11 +---
 tests/xfs/308     |  11 +---
 tests/xfs/339     |   6 +-
 tests/xfs/340     |   2 +-
 tests/xfs/999     | 163 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |   2 +
 tests/xfs/group   |   1 +
 14 files changed, 238 insertions(+), 45 deletions(-)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

-- 
2.9.5


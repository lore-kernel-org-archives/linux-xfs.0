Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:10418 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752543AbdKIH0d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 02:26:33 -0500
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH v3 0/4] test for XFS umount hang caused by the pending dquota log item in AIL
Date: Thu, 9 Nov 2017 15:32:48 +0800
Message-ID: <20171109073252.36001-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

Hi,

This is the v3 patchset for testing the XFS umount hang problem caused by
the pending dquota log item in AIL. The problem has not been fixed in
XFS yet, and Carlos Maiolino is working on it [1].

The bug that the test case can not reproduced on a 15GB scratch device
has been fixed, and many thanks to Eryu Guan. I had tested it on 4.14-rc8,
and the problem can be reproduced reliably now.

Comments and questions are welcome.

Regards,
Tao

---
Changes since v2:

v3:
* dmflakey: support error_writes feature for dm-flakey
	* check the availability of error_writes by trial instead of version number

* xfs: test for umount hang caused by the pending dquota log item in AIL
	* calculate log_ofs correctly by using convert cmd in xfs_db

* common/rc: factor out _scratch_xfs_[get|set]_sb_field
	* reimplement _scratch_xfs_[get|set]_sb_field based on
	  _scratch_xfs_[get|set]_metadata_field.

v2:
	* http://www.spinics.net/lists/fstests/msg07792.html

v1:
	* https://www.spinics.net/lists/fstests/msg07622.html

[1]: https://www.spinics.net/lists/linux-xfs/msg11614.html

Hou Tao (4):
  dmflakey: support multiple dm targets for a dm-flakey device
  dmflakey: support error_writes feature for dm-flakey
  xfs: test for umount hang caused by the pending dquota log item in AIL
  common/rc: factor out _scratch_xfs_[get|set]_sb_field

 common/dmflakey   |  29 +++++++++-
 common/fuzzy      |  33 -----------
 common/xfs        |  47 ++++++++++++++++
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
 14 files changed, 257 insertions(+), 74 deletions(-)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

-- 
2.9.5


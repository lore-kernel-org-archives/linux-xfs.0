Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731410AbeISRgW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 13:36:22 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8JBsHvr141312
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 07:58:46 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mkkc9xvhf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 07:58:45 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 19 Sep 2018 07:58:43 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V4 00/20] Fix tests to work on non-4k block sized fs instances
Date: Wed, 19 Sep 2018 17:30:33 +0530
Message-Id: <20180919120053.7339-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

This patchset fixes tests (mostly XFS specific ones) to work on
variable block size. These patches now use the output of "od" utility
to verify the contents of the test files instead of the md5sum
utility.

Also, The patchset modifies _filter_fiemap() filter function to
optionally print the file offset range in block size units.

Changelog:
V3->V4:
1. The following tests now use _get_file_block_size() function to obtain the
   underlying filesystem's block size.
   xfs/009
   xfs/074
   xfs/139
   xfs/140
   xfs/299
   generic/018
   generic/177
   generic/130
2. xfs/139 now creates a scratch filesystem with AG size of 8192 filesystem
   blocks instead of the previously used 4400 filesystem blocks.
3. xfs/050 has now been fixed to work with 512 byte sized filesystem blocks.
   The "block soft" limit and "block hard" limit values have been increased to
   enable the user to have enough blocks in quota to be able to create the
   required test files when using 512 byte filesystem blocks.
4. The patch for xfs/299 has now been split into two. The first one fixes a bug
   in the test when using 4k block size and the second one lets the user execute
   the test on 64k block sized filesystems.

Thanks to Darrick J Wong and Zorro Lang for their review comments.

V2->V3:
Added fixes for getting generic/018, generic/108 and generic/459 tests
to work in 64k block size scenario.

V1->V2:
Eryu Guan pointed out that some of the tests were obtaining the
filesystem's block size value from $TEST_DIR even though the test was
executed on the $SCRATCH_DEV's filesystem. This version of the
patchset fixes the following tests to obtain the block size from
$SCRATCH_MNT. The relevant changes was made to the following tests:
xfs/009, xfs/050, xfs/074, xfs/139, xfs/140, xfs/190, xfs/299,
generic/177 and generic/230.

Chandan Rajendra (20):
  Fix xfs/009 to work with 64k block size
  xfs/050: Fix "Push past soft inode limit" case
  Fix xfs/050 to work with 64k block size
  Fix xfs/074 to work with 64k block size
  Fix xfs/127 to work with 64k block size
  Fix xfs/139 to work with 64k block size
  Fix xfs/140 to work with 64k block size
  Fix xfs/190 to work with 64k block size
  xfs/299: Fix "Push past soft inode limit" case
  Fix xfs/299 to work with 64k block size
  xfs/325: Inject free_extent error after CoW operation
  Fix generic/102 to work with 64k block size
  Fix generic/172 to work with 64k block size
  Filter fiemap output by FS block size
  Fix generic/177 to work with 64k block size
  Fix generic/230 to work with 64k block size
  Fix generic/235 to work with 64k block size
  Fix generic/459 to work with 64k block size
  Fix generic/018 to work with 64k block size
  Fix generic/108 to work with 64k block size

 common/punch          | 19 ++++++++---
 tests/generic/018     |  2 +-
 tests/generic/102     |  4 +--
 tests/generic/102.out | 20 +++++------
 tests/generic/108     |  4 +--
 tests/generic/172     |  4 +--
 tests/generic/177     | 20 ++++++-----
 tests/generic/177.out | 23 ++++++++-----
 tests/generic/230     | 23 +++++++------
 tests/generic/230.out | 16 ++++-----
 tests/generic/235     |  2 +-
 tests/generic/235.out |  4 +--
 tests/generic/459     | 14 ++++----
 tests/xfs/009         | 92 ++++++++++++++++++++++++++++++++++++++++++---------
 tests/xfs/009.out     | 66 ++++++++++++++++++------------------
 tests/xfs/050         | 26 ++++++++++-----
 tests/xfs/050.out     | 60 ++++++++++++++++-----------------
 tests/xfs/074         | 23 ++++++++++---
 tests/xfs/127         |  2 +-
 tests/xfs/139         | 15 +++++----
 tests/xfs/139.out     |  8 +++--
 tests/xfs/140         | 12 ++++---
 tests/xfs/190         | 26 ++++++++++-----
 tests/xfs/299         | 29 ++++++++++------
 tests/xfs/299.out     | 60 ++++++++++++++++-----------------
 tests/xfs/325         |  5 +--
 tests/xfs/325.out     |  2 +-
 27 files changed, 358 insertions(+), 223 deletions(-)

-- 
2.9.5

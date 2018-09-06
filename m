Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727827AbeIFNMb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 09:12:31 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w868XuQf025992
        for <linux-xfs@vger.kernel.org>; Thu, 6 Sep 2018 04:38:09 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2maymd3bb7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Sep 2018 04:38:09 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 6 Sep 2018 02:38:08 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V2 00/16] Fix tests to work on non-4k block sized fs instances
Date: Thu,  6 Sep 2018 14:09:57 +0530
Message-Id: <20180906084013.2687-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, eguan@redhat.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

This patchset fixes tests (mostly XFS specific ones) to work on
variable block size. These patches now use the output of "od" utility
to verify the contents of the test files instead of the md5sum
utility.

Also, The patchset modifies _filter_fiemap() filter function to
optionally print the file offset range in block size units.

Changelog:
V1->V2:
Eryu Guan pointed out that some of the tests were obtaining the
filesystem's block size value from $TEST_DIR even though the test was
executed on the $SCRATCH_DEV's filesystem. This version of the
patchset fixes the following tests to obtain the block size from
$SCRATCH_MNT. The relevant changes was made to the following tests:
xfs/009, xfs/050, xfs/074, xfs/139, xfs/140, xfs/190, xfs/299,
generic/177 and generic/230.

Chandan Rajendra (16):
  Fix xfs/009 to work with 64k block size
  xfs/050: Fix "Push past soft inode limit" case
  Fix xfs/050 to work with 64k block size
  Fix xfs/074 to work with 64k block size
  Fix xfs/127 to work with 64k block size
  Fix xfs/139 to work with 64k block size
  Fix xfs/140 to work with 64k block size
  Fix xfs/190 to work with 64k block size
  Fix xfs/299 to work with 64k block size
  xfs/325: Inject free_extent error after CoW operation
  Fix generic/102 to work with 64k block size
  Fix generic/172 to work with 64k block size
  Filter fiemap output by FS block size
  Fix generic/177 to work with 64k block size
  Fix generic/230 to work with 64k block size
  Fix generic/235 to work with 64k block size

 common/punch          | 19 ++++++++---
 tests/generic/102     |  4 +--
 tests/generic/102.out | 20 +++++------
 tests/generic/172     |  4 +--
 tests/generic/177     | 20 ++++++-----
 tests/generic/177.out | 23 ++++++++-----
 tests/generic/230     | 23 +++++++------
 tests/generic/230.out | 16 ++++-----
 tests/generic/235     |  2 +-
 tests/generic/235.out |  4 +--
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
 24 files changed, 348 insertions(+), 213 deletions(-)

-- 
2.9.5

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36981 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751790AbdIVCCn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 22:02:43 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.21/8.16.0.21) with SMTP id v8M22DPB028524
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 19:02:43 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2d4s5601uq-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 19:02:43 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH 0/3] Fix/harden "quick" tests for realtime subvolumes
Date: Thu, 21 Sep 2017 19:02:37 -0700
Message-ID: <20170922020240.2503987-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Some tests have issues when being run with realtime subvolumes.  This patch
set aims to harden fs tests so we can get reliable/reproducible test runs
with fstests for realtime subvolumes.

Two new _require functions are introduced along with a new flag to
automatically set the rtinherit=1 option upon mkfs'ing.

The problems I found were usually one of:
1. Snapshot + subsequent test being performed without regard to the realtime
subvolume.
2. Use of functions which are not supported by realtime devices.  Not setting
rtinherit on scratch devices for these cases fixes these tests.  Non-scratch
cases are more tricky since we don't control what goes into the MKFS_OPTIONS
variable.
3. xfs_repair being used directly without checking for RT devices.

After fixing these cases, you get 86 good "quick: xfs tests & 180 good "quick"
generic tests with the bulk are not run due to the lack of reflink and/or quota
support on realtime scratch targets.

P.S. I haven't forgotten about the non-"quick" tests, but I had to start
somewhere, and break this up a bit into a more manageable problem.


Richard Wareing (3):
  xfs/realtime: Add require_no_realtime function
  xfs/realtime: Default rtinherit=1, add _require_no_rtinherit function
  xfs/realtime: Fix direct invocations of xfs_repair

 common/rc                      | 32 +++++++++++++++++++++++++++++++-
 tests/generic/250              |  1 +
 tests/generic/252              |  1 +
 tests/generic/409              |  1 +
 tests/generic/410              |  1 +
 tests/generic/411              |  1 +
 tests/generic/427              |  1 +
 tests/generic/441              |  1 +
 tests/xfs/019                  |  1 +
 tests/xfs/031                  |  1 +
 tests/xfs/070                  |  4 ++--
 tests/xfs/077                  |  1 +
 tests/xfs/170                  |  1 +
 tests/xfs/187                  |  1 +
 tests/xfs/189                  |  1 +
 tests/xfs/191-input-validation |  1 +
 tests/xfs/202                  |  1 +
 tests/xfs/284                  |  1 +
 tests/xfs/291                  |  3 ++-
 19 files changed, 51 insertions(+), 4 deletions(-)

-- 
2.9.5


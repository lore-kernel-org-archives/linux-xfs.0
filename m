Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59074 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753279AbeAKDJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 22:09:04 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0B35P3N029231
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 19:09:03 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2fdtyjguef-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 19:09:03 -0800
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v3 0/3] Fix/harden "quick" tests for realtime subvolumes
Date: Wed, 10 Jan 2018 19:08:58 -0800
Message-ID: <20180111030901.1961285-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: darrick.wong@oracle.com, eguan@redhat.com, linux-xfs@vger.kernel.org

Applies clean to commit 95c924c65113d2b706436d8cd09cd391eddb795a.

Kernel: 4.14-rc8 (Commit 39dae59d66acd86d1de24294bd2f343fd5e7a625)
MKFS_OPTIONS="-m finobt=1,crc=1,reflink=1"

Updated patch set to address comments made by reviewers.  Changes are noted
on the patches.

A couple of tests (e.g. tests/xfs/191-input-validation) which work for Eryu 
still fail for me, but I'll comment on those w/ sample output on the mailing 
list, as I might have some toolchain issue on my end.

==== Original Cover Letter ===

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

P.S I haven't forgotten about the non-"quick" tests, but I had to start
somewhere, and break this up a bit into a more manageable problem.

Richard Wareing (3):
  xfs/realtime: Add require_no_realtime function
  xfs/realtime: Default rtinherit=1, add _require_no_rtinherit function
  xfs/realtime: Fix direct invocations of xfs_repair

 common/rc         | 29 +++++++++++++++++++++++++++--
 tests/generic/250 |  3 +++
 tests/generic/252 |  3 +++
 tests/generic/441 |  3 +++
 tests/xfs/070     |  5 ++++-
 tests/xfs/077     |  2 ++
 tests/xfs/170     |  1 +
 tests/xfs/189     |  1 +
 tests/xfs/284     |  2 ++
 tests/xfs/291     |  5 ++++-
 10 files changed, 50 insertions(+), 4 deletions(-)

-- 
2.9.5


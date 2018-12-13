Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:40837 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbeLMB0q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 20:26:46 -0500
Received: by mail-it1-f196.google.com with SMTP id h193so1387447ita.5
        for <linux-xfs@vger.kernel.org>; Wed, 12 Dec 2018 17:26:46 -0800 (PST)
From: Nick Bowler <nbowler@draconx.ca>
Subject: [RFC PATCH 0/2] Fixing xfs ioctls on x32
Date: Wed, 12 Dec 2018 20:29:58 -0500
Message-Id: <20181213013000.15716-1-nbowler@draconx.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

An error I got running xfs_growfs on my x32 system opened this can of
worms...

This series is intended to fix all XFS ioctls which don't work from
x32 userspace applications.

Test is xfstests "check -g quick", excluding generic/081 and xfs/014
which don't behave well for me and don't seem related to XFS ioctls.

Note that glibc's fallocate wrapper appears to be buggy on x32,
which causes several test failures.  I hacked around that in xfs_io
(the fallocate syscall itself appears to work perfectly fine on x32)
to get a cleaner test run.  Obviously this bug should be fixed but
it doesn't appear to be a kernel or xfsprogs problem.

All tests are running with the same 4.20-rc6 kernel, but different
userspace installations (pure x32 versus pure i686).  The "After"
results are obtained by reloading the xfs.ko kernel module with
the patched version and running the same set of tests.

All the remaining failures on x32 appear to be aio related, or are
also failing on the i686 tests.  I have no experience with aio but
I'm going to assume those problems have nothing to do with ioctl.

Before (i686 w/ 64bit kernel):

  Failures: generic/484 xfs/191-input-validation xfs/269 xfs/495
  Failed 4 of 656 tests

Before (x32):

  Failures: generic/018 generic/075 generic/079 generic/112 generic/113
            generic/114 generic/198 generic/207 generic/210 generic/240
            generic/252 generic/386 generic/427 generic/451 generic/465
            generic/484 xfs/002 xfs/009 xfs/026 xfs/027 xfs/028 xfs/046
            xfs/054 xfs/056 xfs/059 xfs/060 xfs/062 xfs/063 xfs/066
            xfs/069 xfs/072 xfs/078 xfs/106 xfs/118 xfs/164 xfs/165
            xfs/166 xfs/170 xfs/190 xfs/191-input-validation xfs/195
            xfs/250 xfs/266 xfs/269 xfs/281 xfs/282 xfs/283 xfs/289
            xfs/296 xfs/443 xfs/449 xfs/495
  Failed 52 of 656 tests

After (i686 w/ 64bit kernel):

  Failures: generic/484 xfs/191-input-validation xfs/269 xfs/495
  Failed 4 of 656 tests

After (x32):

  Failures: generic/112 generic/113 generic/114 generic/198 generic/207
            generic/210 generic/240 generic/252 generic/427 generic/451
            generic/465 generic/484 xfs/191-input-validation xfs/269
            xfs/495
  Failed 15 of 656 tests

Nick Bowler (2):
  xfs: Fix bulkstat compat ioctls on x32 userspace.
  xfs: Fix x32 ioctls when cmd numbers differ from ia32.

 fs/xfs/xfs_ioctl32.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

-- 
2.16.1

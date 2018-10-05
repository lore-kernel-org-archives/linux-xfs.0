Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52924 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbeJEHPM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:15:12 -0400
Subject: [PATCH 0/6] fstests: fixes and new tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:19:07 -0700
Message-ID: <153869874763.26648.516233620615833277.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org

Hi all,

The first patch provides a second regression test for a condition where
mmap read of a file's EOF page shows nonzero bytes after EOF if the
previous operation was a zero_range all the way to EOF.  This bug only
seems to manifest on XFS, but it uses generic APIs and so is a generic
test.  The patch concerned here is "xfs: ensure post-EOF zeroing happens
after zeroing part of a file".

The second patch adds tests to see if XFS can detect and correct
incorrect filesystem summary counters at mount time.

Patch 3-5 fix some minor problems that cropped up with the upcoming
xfsprogs 4.19 release due to stricter metadata verification.

Patch 6 adds some regression tests for incorrect behavior on the part of
the clonerange and deduperange ioctls.  Specifically, we check for a
lack of file range verification w.r.t. resource limits; lack of security
privilege clearing when a file is reflinked; exposure of stale disk
contents when a file is reflinked into well above EOF; and problems
deduping when a single byte in the middle of the range doesn't match.

--D

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48904 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbeGDEuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jul 2018 00:50:51 -0400
Subject: [PATCH 0/7] fstests: fix quota failures on xfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Jul 2018 21:50:47 -0700
Message-ID: <153067984748.28393.1595618163831671652.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

Several months ago I tried testing xfs with quotas enabled and was
surprised at the number of failures.  Since then I've been on a bug hunt
to triage the mess, and the following series fixes some of the low
hanging fruit.  Some of these are minor behavioral variations when quota
are enabled, and other fixes upgrade old v4 tests to work on v5
filesystems.

To reproduce the results, run xfstests with
'MOUNT_OPTIONS="-o usrquota,grpquota,prjquota"' on a v5 filesystem.
Strike the ',grpquota' on a v4 filesystem.

The first patch fixes differences in the golden output when quotas are
enabled on xfs -- mmap writes (intentionally) crashing with SIGBUS when
quota updates fail vs. msync failing with EIO.

The second patch fixes all the tests that require a specific quota mount
option configuration to filter out any quota options present in
MOUNT_OPTIONS.

The third patch updates xfs/001 to work with XFS v5 filesystems since
there was nothing particularly v4 specific about it.

The fourth patch enables tests that require a v4 format to filter out v5
mount options (such as grpquota) so that they can run.

Patch #5 upgrades xfs/288 to support XFS v5 since there was nothing
particular to v4 about that test.

Patch #6 fixes a problem in generic/338 where switching the disk backend
to dm-error on a xfs with quotas enabled causes the fs to go down with a
dirty log which is not recovered prior to the end of the test.  This was
originally a regression test for a NULL pointer dereference after the fs
shuts down, so we can skip the post-test fsck.

Patch #7 filters 'quota info will be regenerated on next quota mount'
messages from the xfs_repair golden output.

--D

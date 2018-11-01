Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52532 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbeKBIYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 04:24:09 -0400
Subject: [PATCH 0/8] fstests: fix quota failures on xfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Nov 2018 16:19:02 -0700
Message-ID: <154111434286.6577.15010861884505931015.stgit@magnolia>
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

The first patch fixes the sporadic quota count failures when testing XFS
with quotas by replacing the xfs_spaceman call that cleans out (only)
speculative preallocations with a umount/mount pair that forcibly cleans
out /all/ preallocations and delayed allocations.

The second patch fixes bugs in a couple of tests that use error
injection to test log recovery paths but don't succeed in directly
causing the error to trip.

The third patch works around the fact that mounting xfs with quotas
requires a writable block device even for a ro mount, which leads to
a slightly different error message from the mount call.

Patch 4 and 5 fix the dump and restore tests to handle the case that
quota inodes get sent along with dumps when quotas are enabled.

Patch 6 updates xfs/205 to work with v5 filesystems.

Patch 7 changes tests that require specific quota mount options to clear
out the background quota mount options so that we test with /exactly/
the set of mount options.

Patch 8 filters v5 mount options out of tests that format v4
filesystems on the scratch device.

--D

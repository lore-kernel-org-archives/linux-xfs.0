Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49698 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfCNVDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:03:49 -0400
Subject: [PATCH v2 00/36] xfsprogs-5.0: fix various problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:03:43 -0700
Message-ID: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are some fixes for xfsprogs 5.0:

Patch 1 fixes a deadlock in xfs_repair when we fail to flush an inode.
It's already on the list, but I pulled it in as a place to branch off
the upstream repo.

Patches 2-6 fix some errors in the autoconf scripts and tidy up some
of the debian packaging scripts.

Patches 7-9 are bugfixes and minor enhancements for xfs_io commands.

Patch 10 fixes xfs_scrub_all to discover the fs to physical device
mappings correctly when nvme devices are present in the system.

Patch 11 holds off automated xfs_scrub_all triggers until the system is
fully booted so that we don't end up racing metadata scrubbing with
system boot.

Patches 12-13 fix thread count discovery in xfs_scrub so that we stop
shadowing variables and estimate parallelism based at least somewhat on
the storage hardware and not just the number of CPUs.  In other words,
we'll stop pounding a spinning disk with all the CPUs.

Patches 14-15 restructure the read-verify pools to make them per-device
so that a media scan on heterogeneous storage won't flood a device with
low IOPS capacity.

Patch 16 teaches scrub not to complain if it can't close the mountpoint
after failing to open it.

Patch 17 teaches scrub to check filesystem labels for misleading
character sequences.

Patch 18 fixes the problem of xfs_scrub's support scripts not getting
rebuilt when file path definitions change.

Patch 19 teaches mkfs to validate extent size hint parameters so that
we cannot format filesystems that immediately fail to mount.

Patches 20-21 fix some finobt problems in xfs_db.

Patch 22 teaches xfs_info to be smarter about figuring out whether it
should be using a live query via xfs_spaceman or xfs_db.

Patches 23-24 fix some link count handling in xfs_repair when we're
(re)initializing the root directory and lost+found directories.

Patch 25 fixes some build warnings in xfs_repair.

Patch 26-27 refactor parts of xfs_repair to make it easier to pass
buffer ops pointers through the scan and rebuild functions.  These
cleanups should make it easier to adapt to the separation of buf_ops
for bnobt/cntbt and inobt/finobt that will appear in 5.1.

Patch 28-29 fix a crash in xfs_repair where accidentally create
duplicate rmapbt records for blocks that are initially allocated to the
free space btrees but then are freed back to the AGFL. while rebuilding
the rmap btree.

Patch 30 fixes a problem where xfs_repair phase 6 will fail to flush
partially corrected inode core data to the inode cluster buffer because
phase 6 hasn't yet fixed every thing that's wrong with the inode.  This
patch is part of a continuing series of fixes for Arkadiusz Miśkiewicz's
broken filesystem.

Patches 31-36 refactor the userspace buffer and inode log item handling
so that the item lifetimes make more sense -- they don't need to be kept
around after a transaction commits (or cancels), and we certainly don't
need to be leaking them because we got lazy about cleaning them up.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.0-fixes

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47826 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727383AbeLST3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 14:29:30 -0500
Subject: [PATCH 0/8] xfsprogs: various fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 19 Dec 2018 11:29:24 -0800
Message-ID: <154524776457.28646.3004453037075812416.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Here are some fixes for xfsprogs 4.20:

Patch 1 fixes xfs_scrub_all to discover the fs to physical device
mappings correctly when nvme devices are present in the system.

Patch 2 holds off automated xfs_scrub_all triggers until the system is
fully booted so that we don't end up racing metadata scrubbing with
system boot.

Patches 3-5 fix thread count discovery in xfs_scrub so that we stop
shadowing variables and estimate parallelism based at least somewhat on
the storage hardware and not just the number of CPUs.  In other words,
we'll stop pounding a spinning disk with all the CPUs.

Patches 6-7 fix some link count handling in xfs_repair when we're
(re)initializing the root directory and lost+found directories.

Patch 8 fixes some build warnings in xfs_repair.

This series survived overnight testing against current xfsprogs
for-next.  It can be pulled as a git branch[1].

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel

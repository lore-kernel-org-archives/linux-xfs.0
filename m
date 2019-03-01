Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41378 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCAX0w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:26:52 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NP3FK123240
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:26:51 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qtupetegg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:26:51 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NQoHI030658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:26:50 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21NQoUh007434
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:26:50 GMT
Subject: [PATCH 00/23] xfsprogs-5.0: fix various problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:26:48 -0800
Message-ID: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are some fixes for xfsprogs 5.0:

Patch 1 fixes the autoconf xattr.h check to use the new location of
xattr.h

Patch 2 adds some missing return value checks in xfs_io's
copy_file_range implementation.

Patch 3 teaches xfs_io's statx command to print attributes_mask.

Patch 4 fixes xfs_scrub_all to discover the fs to physical device
mappings correctly when nvme devices are present in the system.

Patch 5 holds off automated xfs_scrub_all triggers until the system is
fully booted so that we don't end up racing metadata scrubbing with
system boot.

Patches 6-7 fix thread count discovery in xfs_scrub so that we stop
shadowing variables and estimate parallelism based at least somewhat on
the storage hardware and not just the number of CPUs.  In other words,
we'll stop pounding a spinning disk with all the CPUs.

Patches 8-9 restructure the read-verify pools to make them per-device
so that a media scan on heterogeneous storage won't flood a device with
low IOPS capacity.

Patch 10 teaches scrub not to complain if it can't close the mountpoint
after failing to open it.

Patch 11 teaches scrub to check filesystem labels for misleading
character sequences.

Patch 12 teaches mkfs to validate extent size hint parameters so that
we cannot format filesystems that immediately fail to mount.

Patches 13-14 fix some link count handling in xfs_repair when we're
(re)initializing the root directory and lost+found directories.

Patch 15 fixes some build warnings in xfs_repair.

Patch 16 fixes an xfs_db problem where finobt decoding was broken.

Patch 17 fixes a metadump problem where the wrong type was used when
dumping free inode btree blocks.

Patch 18 teaches xfs_info to be smarter about figuring out whether it
should be using a live query via xfs_spaceman or xfs_db.

Patch 19-20 fix a crash in xfs_repair where accidentally create
duplicate rmapbt records for blocks that are initially allocated to the
free space btrees but then are freed back to the AGFL. while rebuilding
the rmap btree.

Patches 21-23 fix some use-after-free and stale log item problems in the
inode and buffer log items by modifying libxfs to discard those log
items when committing or cancelling a transaction.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.0-fixes

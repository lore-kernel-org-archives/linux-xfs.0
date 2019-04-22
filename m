Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44154 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfDVPqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Apr 2019 11:46:52 -0400
Subject: [PATCH v3 00/10] xfsprogs-5.0: fix various problems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 22 Apr 2019 08:44:50 -0700
Message-ID: <155594788997.115924.16224143537288136652.stgit@magnolia>
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

Patch 1 fixes the problem of xfs_scrub's support scripts not getting
rebuilt when file path definitions change.

Patch 2 fixes a problem xfs_info had in finding mounts.

Patch 3 fixes a crash in xfs_repair where accidentally create duplicate
rmapbt records for blocks that are initially allocated to the free space
btrees but then are freed back to the AGFL. while rebuilding the rmap
btree.

Patches 4-5 fix a problem where xfs_repair phase 6 will fail to flush
partially corrected inode core data to the inode cluster buffer because
phase 6 hasn't yet fixed every thing that's wrong with the inode.  This
patch is part of a continuing series of fixes for Arkadiusz Miśkiewicz's
broken filesystem.

Patch 6 fixes some static checker complaints about strncpy usage.

Patches 7-10 refactor the userspace buffer and inode log item handling
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

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfAACKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:10:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0129qaa171225
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:10:05 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jqx3u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:10:05 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012A0RB019213
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:10:00 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0129xM6022238
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:10:00 GMT
Subject: [PATCH v18 00/17] xfs: online repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:09:58 -0800
Message-ID: <154630859850.15625.17640302184521917854.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the first part of the eighteenth revision of a patchset that
adds to XFS kernel support for online metadata scrubbing and repair.
There aren't any on-disk format changes.

New for v18 is a rebase against 4.20 and the creation of explicit data
structures for storing intermediate reconstructed records.  Otherwise,
there hasn't been much activity here, as we've been too busy fixing
clone/copy/deduperange ioctls.

Patch 1 moves all the inode geometry information into a separate
structure so that we can later add more fields to make the online fsck
code less messy w.r.t. inode geometry.

Patch 2 creates a new data structure that provides an abstraction of a
big memory array by using linked lists.  This is where we store records
for btree reconstruction.  This first implementation is memory
inefficient and consumes a /lot/ of kernel memory, but lays the
groundwork for the last patch in the set to convert the implementation
to use a (memfd) swap file, which enables us to use pageable memory
without pounding the slab cache.

Patches 3-9 implement reconstruction of the free space btrees, the inode
btrees, the inodes, the inode forks, the inode block maps, and symbolic
links.

Patch 10 implements a new data structure for storing arbitrary key/value
pairs, which we're going to need to reconstruct extended attribute
forks.

Patches 11-13 clean up the block unmapping code so that we will be able
to perform a mass reset of an inode's fork.  This is a key component for
salvaging extended attributes, freeing all the attr fork blocks, and
reconstructing the extended attribute data.

Patch 14 implements extended attribute salvage.

Patch 15 augments scrub to rebuild extended attributes when any of the
attr blocks are fragmented.

Patch 16 implements reconstruction of quota blocks.

Patch 17 converts both in-memory array implementations from the clunky
linked list implementation to something resembling C arrays.  The array
data are backed by a (memfd) file, which means that idle data can be
paged out to disk instead of pinning kernel memory.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.20.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel

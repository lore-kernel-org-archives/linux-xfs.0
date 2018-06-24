Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57292 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752063AbeFXTXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:23:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJFbJ1115147
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:32 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jt7mp8hnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:32 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJNV1q024895
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:32 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5OJNVaS020321
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:23:31 GMT
Subject: [PATCH v16 00/21] xfs-4.19: online repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:23:30 -0700
Message-ID: <152986820984.3155.16417868536016544528.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the sixteenth revision of a patchset that adds to XFS kernel
support for online metadata scrubbing and repair.  There aren't any
on-disk format changes.

New for this version of the patch series are: a renaming of the 'repair
freeze' code into the 'scrub freeze' code so that scrubbers can freeze
the filesystem to check or repair metadata; a new ioctl flag for
userspace to grant the kernel permission to freeze the filesystem to do
work; a centralized iput helper that delays iput processing until after
the scrub freeze is lifted; and a new fs summary counter scrub/repair
function that can check the global icount/ifree/fdblock counters.

The first patch fixes a soon-to-be-invalid assumption in the rmap code
that the rmapbt can never be empty.  This won't be true at all for
realtime rmap and is briefly untrue for rmap repairs, so we might as
well restructure that assumption out of the code.

The next two patches create two predicates that decide if an inode has
CoW staging blocks that need to be freed or post-eof blocks that need to
be freed.

Patches 4-7 implement reconstruction of the AGF/AGI/AGFL headers, the
free space btrees, and the inode btrees.  These are the same patches as
v15.

Patches 8-9 implement the deferred iput code -- first the scrub-specific
iput helper that enables us delay iputting of inodes that have post-eof
or CoW blocks that need to be freed until we no longer have a
transaction and can let the iput work proceed.  The second patch fleshes
out the scrub iget/iput tracepoints for easier debugging.

Next comes the scrub freeze code which enables us to pause all other
work in the filesystem and introduces the FREEZE_OK ioctl flag for
userspace to control freeze policy.

Patch 11-19 implement online rmap, refcount, inode, ifork, bmap,
symlink, extended attribute, and quota repairs.  Patch 20 implements
online quotacheck via the scrub freezer.

Patch 21 implements the filesystem summary counter check and repair
code.  This turned out to be easier to implement than I had thought --
we gather the icount, ifree, and fdblocks counts from each of the AGs.
Next we adjust fdblocks by all the in-core reservations: resblks, per-AG
reservations, and all delayed allocation blocks of all in-core inodes.
Then we can compare our counts against the superblock's counts and
adjust accordingly.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.18-rc2.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33008 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751340AbeBWCBu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 21:01:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N21nax069911
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:49 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2ga9bpg24s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:49 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1N21kO9003462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:46 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1N21kr0010762
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 02:01:46 GMT
Subject: [PATCH v12 00/20] xfs: online repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 18:01:45 -0800
Message-ID: <151935130484.22097.9694510081310029779.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the twelfth revision of a patchset that adds to XFS kernel
support for online metadata scrubbing and repair.  There aren't any
on-disk format changes.

The first five patches add or expose various libxfs helpers that the
online repair code will use to reconstruct broken metadata.  Most
notably we add a NORMAP flag to the bmapi functions so that we can
use rmap data to rebuild block maps.

Patch six allows us to disable inode reclamation temporarily for the few
things that requires full filesystem scans; at the moment that is
limited to the rmap rebuilder.

Patches 7-20 introduce the online repair functionality for space
metadata.  Our general strategy for rebuilding damaged primary metadata
is to rebuild the structure completely from secondary metadata and free
the old structure after the fact; we do not try to salvage anything.
Consequently, online repair requires rmapbt.  Rebuilding the secondary
metadata (rmap) is much harder -- due to our locking rules (primary and
then secondary) we have to shut down the filesystem temporarily while we
scan all the primary metadata for data to put in the new secondary
structure.

Reconstructing inodes is difficult -- the ability to rebuild files
depends on the filesystem being able to load an inode (xfs_iget), which
means repair has to know how to zap any part of an inode record that
might trigger corruption errors from iget.  To that end, we can now
reset most of an inode record or an inode fork so that we can rebuild
the file.

The refcount rebuilder is more or less the same algorithm that
xfs_repair uses, but modified to reflect the constraints of running in
kernel space.

For rmap rebuilds, we cannot have anything on the filesystem taking
exclusive locks and we cannot have any allocation activity at all.
Therefore, we start by freezing the filesystem to allow other
transactions to finish.  Then, we disable periodic inode reclaim and
roll the freeze back just enough so that we can create our own
transactions but other writes will block.  Next, we scan all other AG
metadata structures, every inode, and every block map to reconstruct the
rmap data.  Then, we reinitialize the rmap btree root and reload the
rmap btree.  Finally, we release all the resource we grabbed and the
filesystem returns to normal.

Looking forward, the parent pointer feature that Allison Henderson is
working on will enable us to reconstruct directories, at which point
we'll be able to reconstruct most of a lightly damaged filesystem.  But
that's future talk.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.16-rc2.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel

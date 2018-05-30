Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51714 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbeE3Tam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 15:30:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4UJPbOL120270
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:30:42 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2j9x4h9374-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:30:42 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4UJUfmM027808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:30:41 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4UJUfgd018017
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 19:30:41 GMT
Subject: [PATCH v15.2 00/14] xfs-4.18: online repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 30 May 2018 12:30:39 -0700
Message-ID: <152770863951.11611.5866814627357136911.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the fifteenth revision of a patchset that adds to XFS kernel
support for online metadata scrubbing and repair.  There aren't any
on-disk format changes.

New in v15 of the patch series is the ability to scavenge broken
attribute forks for intact extended attributes, to repair minor
corruptions in the on-disk quota records, and to perform quotacheck
online.  The series was rebased atop for-next for 4.18 and a number
of minor bitrots bugs were fixed.

Patches 1-14 introduce the online repair functionality for space
metadata and certain file data.  Our general strategy for rebuilding
damaged primary metadata is to rebuild the structure completely from
secondary metadata and free the old structure after the fact; we do not
try to salvage anything.  Consequently, online repair requires rmapbt.
Rebuilding the secondary metadata (rmap) is much harder -- due to our
locking rules (primary and then secondary) we have to shut down the
filesystem temporarily while we scan all the primary metadata for data
to put in the new secondary structure.

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
transactions to finish.  Next, we scan all other AG metadata structures,
every inode, and every block map to reconstruct the rmap data.  Then, we
reinitialize the rmap btree root and reload the rmap btree.  Finally, we
release all the resource we grabbed and the filesystem returns to
normal.

The extended attribute repair function uses a different strategy from
the other repair code.  Since there are no secondary metadata for
extended attributes, we can't simply rebuild from an alternate data
source.  Therefore, this repairer simply walks through the blocks in the
attribute fork looking for attribute names and values that appear to be
intact, zaps the attr fork, and re-adds the collected names and values
to the new fork.  This enables us to trigger optimization notices for
attributes blocks with holes.

Quota repairs are fairly straightforward -- repair anything wrong with
the inode data fork, eliminate garbage extents, and then iterate all the
dquot blocks fixing up things that the dquot buffer verifier will
complain about.  This should leave the quota ip in good enough shape for
online quotacheck!  Here we reuse the same fs freezing mechanism as in
the rmap repair to block all other filesystem users.  Then we zero all
the quota counters, iterate all the inodes in the system to recalculate
the counts, and log all the dquots to disk.  We of course clear the CHKD
flags before starting out, so if we crash midway through, the mount time
quotacheck will run.

Looking forward, the parent pointer feature that Allison Henderson is
working on will enable us to reconstruct directories, at which point
we'll be able to reconstruct most of a lightly damaged filesystem.  But
that's future talk.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.17-rc7.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel

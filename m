Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36082 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfAACQz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:16:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012Ejj6173739
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:16:54 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2pp1jqx40d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:16:53 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012Gqdb000728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:16:52 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012GqbI006054
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:16:52 GMT
Subject: [PATCH 00/12] xfs: deferred inode inactivation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:16:50 -0800
Message-ID: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is a new patch series implementing deferred inode inactivation.
Inactivation is the process of updating all on-disk metadata when a file
is deleted -- freeing the data/attr/COW fork extent allocations,
removing the inode from the unlinked hash, marking the inode record
itself free, and updating the inode btrees so that they show the inode
as not being in use.

Currently, all this inactivation is performed during in-core inode
reclaim, which creates two big headaches: first, this makes direct
memory reclamation /really/ slow, and second, it prohibits us from
partially freezing the filesystem for online fsck activity because scrub
can hit direct memory reclaim.  It's ok for scrub to fail with ENOMEM,
but it's not ok for scrub to deadlock memory reclaim. :)

The implementation will be familiar to those who have studied how XFS
scans for reclaimable in-core inodes -- we create a couple more inode
state flags to mark an inode as needing inactivation and being in the
middle of inactivation.  When inodes need inactivation, we set iflags,
set the RECLAIM radix tree tag, update a count of how many resources
will be freed by the pending inactivations, and schedule a deferred work
item.  The deferred work item scans the inode radix tree for inodes to
inactivate, and does all the on-disk metadata updates.  Once the inode
has been inactivated, it is left in the reclaim state and the background
reclaim worker (or direct reclaim) will get to it eventually.

Patch 1 fixes fs freeze to clean out COW extents when possible.

Patch 2-3 refactor some of the inactivation predicates.

Patches 4-5 implement the count of blocks/quota that can be freed by
running inactivation; this is necessary to preserve the behavior where
you rm a file and the fs counters update immediately.

Patches 6-7 refactor more inode reclaim code so that we can reuse some
of it for inactivation.

Patch 8 delivers the core of the inactivation changes by altering the
inode lifetime state machine to include the new inode flags and
background workers.

Patches 9-10 makes it so that if an allocation attempt hits ENOSPC it
will force inactivation to free resources and try again.

Patch 11 converts the per-fs inactivation scanner to be tracked on a
per-AG basis so that we can be more targeted in our inactivation.

Patch 12 makes it so that a process deleting a directory tree or a very
fragmented file will wait for inactivation to happen so that a deltree
cannot flood the system with inactive inodes.

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

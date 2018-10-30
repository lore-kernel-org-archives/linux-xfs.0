Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63819 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727151AbeJ3UN6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 16:13:58 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0005bp-Rp
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:46 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0001jU-Pa
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/7] xfs_repair: scale to 150,000 iops
Date: Tue, 30 Oct 2018 22:20:36 +1100
Message-Id: <20181030112043.6034-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

This patchset enables me to successfully repair a rather large
metadump image (~500GB of metadata) that was provided to us because
it crashed xfs_repair. Darrick and Eric have already posted patches
to fix the crash bugs, and this series is built on top of them.
Those patches are:

	libxfs: add missing agfl free deferred op type
	xfs_repair: initialize realloced bplist in longform_dir2_entry_check
	xfs_repair: continue after xfs_bunmapi deadlock avoidance

This series starts with another couple of regression fixes - the
revert is for a change in 4.18, the unlinked list issue is only in
the 4.19 dev tree.

The third patch prevents a problem I had during development that
resulted in blowing the buffer cache size out to > 100GB RAM and
causing xfs_repair to be OOM-killed on my 128GB RAM machine. If
there was a sudden prefetch demand or a set of queues were allowed
to grow very deep (e.g. lots of AGs all starting prefetch at the
same time) then they would all race to expand the cache, causing
multiple expansions within a few milliseconds. Only one expansion
was needed, so I rate limited it.

The 4th patch actually solved the runaway queueing problems I was
having, but I figured it was still a good idea to prevent
unnecessary cache growth. The fourth patch allowed me to bound how
much work was queued internally to an AG in phase 6, so the queue
didn't suck up the entire AG's readahead in one go....

patches 5 and 6 protect objects/structures that have concurrent
access in phase 6 - the bad inode list and the inode chunk records
in the per-ag AVL trees. the trees themselves aren't modified in
phase 6, so they don't need any additional concurrency protection.

Patch 7 enables concurrency in phase 6. Firstly it parallelises
across AGs like phase 3 and 4, but because phase 6 is largely CPU
bound processing directories one at a time, it also uses a workqueue
to parallelise processing of individual inode chunks records. This
is convenient and easy to do, and is very effective. If you now have
the IO capability, phase 6 will still run as a CPU workload - I
watched it use 30 of 32 CPUs for 15 minutes before the long tail of
large directories slowly burnt down.

While burning all that CPU, it also sustained about 160k IOPS from
the SSDs. Phase 3 and 4 also ran at about 130-150k IOPS, but that is
about the current limit of the prefetching and IO infrastructure we
have in xfsprogs.

Comments, thoughts, ideas, testing all welcome!

Cheers,

Dave.

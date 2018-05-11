Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11929 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750972AbeEKWvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 18:51:12 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fHGsX-0008FZ-K6
        for linux-xfs@vger.kernel.org; Sat, 12 May 2018 08:51:09 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fHGsX-0007Ce-Gw
        for linux-xfs@vger.kernel.org; Sat, 12 May 2018 08:51:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: refactor and tablise growfs
Date: Sat, 12 May 2018 08:50:57 +1000
Message-Id: <20180511225107.27171-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

This is an update of the patch set I sent a while ago, and
Eric and Darrick have been bugging me to get sorted. The last
posting was here:

https://marc.info/?l=linux-xfs&m=151746732826277&w=2

This update addresses most of the comments that were made at the
time. most importantly, it gets rid of the use of uncached buffers
for secondary superblocks. Instead, I introduced a small helper to
mark a buffer as a "one-shot" buffer, which will cause the buffer to
be reclaimed when all active references go away rather than being
put on the LRU. If teh buffer is already on the LRU, then it
respects that and does not change the buffer behaviour (similar to
XFS_IGET_DONTCACHE for inodes).  THis means the growfs code will
play nicely with scrub and other occasional users of secondary
superblocks, but not add any long term cache footprint.

The other addition since the last posting is moving all the code
that does the AG header setup to libxfs so it canbe shared with
userspace(*). Most of the functions have been moved to new files
fs/xfs/libxfs/xfs_ag.[ch], but the secondary superblock update got
moved to fs/xfs/libxfs/xfs_sb.c, because it's purely about
superblock updates.

The pastchset just passed an overnight QA run on v4 and v5
filesystems w/ both 1k and 4k block sizes.

Comments?

-Dave.

Version 2:
- rebase on current for-next
- add oneshot cached buffer support
- clean up more of the typedef usage.
- move id->nfree calc to per-ag hdr init function from the freespace
  btree root initialisation.
- only use id->type and id->numrecs for the generic btree root block
  init calls.
- only call xfs_growfs_data_private() if the size is actually being
  changed.
- make sure we still update secondary superblocks if physical grow
  fails with ENOSPC.
- change secondary superblock updates to use cached one-shot
  buffers.
- moved the core code to libxfs so it can be shared easily with
  userspace.

(*) e.g. mkfs. More interestingly, this provides a mechanism for a
simple offline grow implementation to be added to xfs_spaceman for
vm/container deployment infrastructures that have to mount an fs
image just to grow it during their setup phase.



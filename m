Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:32332 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750779AbeFDEZd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 00:25:33 -0400
Date: Mon, 4 Jun 2018 14:22:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: NULL pointer dereference in xfs_bmap_extents_to_btree() when
 mounting and operating a crafted image
Message-ID: <20180604042227.GO10363@dastard>
References: <CANrHXgzLvaud2HEv3jAFGTfn5S80d7Rwj-ztJNWPT8eyFTohMg@mail.gmail.com>
 <20180603223435.GU10363@dastard>
 <20180603230341.GV10363@dastard>
 <20180603233114.GW10363@dastard>
 <CANrHXgwP5nOaG6nZwUs-bM_oJDNdUnXj=33xrrLJ-OvyCaz_EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANrHXgwP5nOaG6nZwUs-bM_oJDNdUnXj=33xrrLJ-OvyCaz_EA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wen Xu <xuwen.sjtu@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 10:07:52PM -0400, Wen Xu wrote:
> Hi Dave,
> 
> Very strange.
> 
> I checkout v4.17-rc7 of
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
> and merge with for-next of
> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/ to make the
> kernel build.

The last commit from the for-next tree I have is:

d25522f10cfa xfs: repair superblocks

Does that match what you merged?

> d1dabff17081af94c9604c5fdddd0de7  20.img
> mounting 20.img and running poc.c on mounted folder still gives me
> nullptr access.
> 
> [ 1381.524410] XFS (loop0): Mounting V4 Filesystem
> [ 1381.524484] XFS (loop0): Log size 864 blocks too small, minimum
> size is 942 blocks
> [ 1381.524487] XFS (loop0): Log size out of supported range.
> [ 1381.525728] XFS (loop0): Continuing onwards, but if log hangs are
> experienced then please report this message in the bug report.
> [ 1381.533754] XFS (loop0): Ending clean mount
> [ 1388.369552] XFS (loop0): xfs_buf_find: daddr 0x7fb28 out of range, EOFS 0x8000

So, somehow, it's getting a block beyond EOF being allocated out of
the free space tree. So what we have here is an uncaught corrupt
freespace record....

<sigh>

$ sudo xfs_repair -n -f xfs.img
Phase 1 - find and verify superblock...
bad primary superblock - inconsistent filesystem geometry in
realtime filesystem component !!!

attempting to find secondary superblock...
...Sorry, could not find valid secondary superblock
Exiting now.
$

Please use a filesystem with at least 2 AGs as the basis of your
fuzzing in future.

But, yeah, xfs_db tells me the by-size freespace btree is full of
crap, but the by-cnt tree is completely empty (i.e. corrupt) so
allocation should definitely be failing long before if gets anywhere
near returning an allocated block.

Ok, I just worked out why I haven't been able to reproduce the
issue: you have no error checking in your test code, so I get no
indication that it fails to run correctly when run as a user.

Alright, lets start this whole thing again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

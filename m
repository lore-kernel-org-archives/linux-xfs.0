Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:54833 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751817AbeBZAZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Feb 2018 19:25:53 -0500
Date: Mon, 26 Feb 2018 11:25:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Reflink (cow) copy of busy files
Message-ID: <20180226002533.GG30854@dastard>
References: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it>
 <20180224220757.GC30854@dastard>
 <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it>
 <20180225024727.GD30854@dastard>
 <25ebcdb42650430d83d283435053efed@assyoma.it>
 <20180225211309.GF30854@dastard>
 <d105d0000652be75774cc1f5f23eae68@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d105d0000652be75774cc1f5f23eae68@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Sun, Feb 25, 2018 at 10:58:16PM +0100, Gionatan Danti wrote:
> Il 25-02-2018 22:13 Dave Chinner ha scritto:
> >This isn't a copy on write issue. This is an issue of the state of
> >the file and the I/O stack above it at the time the data extents are
> >shared. There is I/O inflight, and so there's no guarantee that what
> >is in the extents being shared is consistent. Freezing the
> >filesystem stops IO in flight, so the extents can be shared while
> >the filesystem knows it has consistent state on stable storage.
> 
> Uhm, it seems the very same definition/catches of "crash-consistent"
> snapshot...
>
> Suppose an XFS filesystem used for VM disk images hosting, with
> running VMs. I naively execute a cp --reflink=always copy, stop the
> original VM and start the copied one.
>
> For an atomic snapshot I would expect that dataloss is comparable to
> a "power pull" case:
> - async writes are lost. After all, they were on the pagecache and
> never hit the backing file;
> - unacknowledged sync writes are lost. Again, they never
> successfully hit the disk;
> - acknowledged sync writes (ie: the one which returned) are properly
> written to the backing file.

Acknowledged sync writes are not guaranteed to be stable. They may
still be sitting in volatile caches below the backing file, and so
until there is a cache flush pushed down through all layers of the
storage stack (e.g. fsync on the backing file) those acknowledged
sync writes are not stable. That's one of the things quiescing the
filesystem guarantees, but running reflink to clone the file does
not.

IOWs, "properly written" is easy to say but very hard to guarantee.
We cannot make such assumptions about random user configs, nor we
can base recommendations on such assumptions.  If you choose not to
quiesce the filesystems before snapshotting them, then it's your
responsibility to guarantee your storage stack will work correctly.

> If the above is correct, when starting the new (copied) VM, the
> guest filesystem will behave as power was lost: its journal will be
> replied and broght to a consistent state.  Application can/will be
> affected based on what they were doing at the time of the reflinked
> copy, but important ones (ie: the ones correctly using fsync), as
> databases, will gracefully recover replying their logs.
> 
> This should be similar to how LVM snapshot works when no filesystem
> is (directly) layered on top of the volume (ie: volume assigned to a
> VM).

You still have to quiesce the filesystem when it's on top of a LVM
snapshot volume.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

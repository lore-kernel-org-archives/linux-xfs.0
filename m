Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:42333 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932141AbeBACAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 21:00:16 -0500
Date: Thu, 1 Feb 2018 13:01:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Virtual block address space mapping
Message-ID: <20180201020109.bfrbyr3jgcrukyfj@destitution>
References: <20180129100834.rhpgnz5572zxmqep@destitution>
 <20180131212501.GE4841@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180131212501.GE4841@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Jan 31, 2018 at 01:25:01PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 29, 2018 at 09:08:34PM +1100, Dave Chinner wrote:
> > Hi Folks,
> > 
> > I want to talk about virtual block address space abstractions for
> > the kernel. This is the layer I've added to the IO stack to provide
> > cloneable subvolumes in XFS, and it's really a generic abstraction
> > the stack should provide, not be something hidden inside a
> > filesystem.
> > 
> > Note: this is *not* a block device interface. That's the mistake
> > we've made previously when trying to more closely integrate
> > filesystems and block devices.  Filesystems sit on a block address
> > space but the current stack does not allow the address space to be
> > separated from the block device.  This means a block based
> > filesystem can only sit on a block device.  By separating the
> > address space from block device and replacing it with a mapping
> > interface we can break the fs-on-bdev requirement and add
> > functionality that isn't currently possible.
> > 
> > There are two parts; first is to modify the filesystem to use a
> > virtual block address space, and the second is to implement a
> > virtual block address space provider. The provider is responsible
> > for snapshot/cloning subvolumes, so the provider really needs to be
> > a block device or filesystem that supports COW (dm-thinp,
> > btrfs, XFS, etc).
> 
> Since I've not seen your code, what happens for the xfs that's written to
> a raw disk?  Same bdev/buftarg mechanism we use now?

Same.

> > I've implemented both sides on XFS to provide the capability for an
> > XFS filesystem to host XFS subvolumes. however, this is an abstract
> > interface and so if someone modifies ext4 to use a virtual block
> > address space, then XFS will be able to host cloneable ext4
> > subvolumes, too. :P
> 
> How hard is it to retrofit an existing bdev fs to use a virtual block
> address space?

Somewhat difficult, because the space cookies need to be plumbed
through to the IO routines. XFS has it's own data and metadata IO
pathways, so it's likely to be much easier to do this for than a
filesystem using generic writeback infrastructure....

> > The core API is a mapping and allocation interface based on the
> > iomap infrastructure we already use for the pNFS file layout and
> > fs/iomap.c. In fact, the whole mapping and two-phase write algorithm
> > is very similar to Christoph's export ops - we may even be able to
> > merge the two APIs depending on how pNFS ends up handing CoW
> > operations.
> 
> Hm, how /is/ that supposed to happen? :)

Not sure - I'm waiting for Christoph to tell us. :)

> I would surmise that pre-cow would work[1] albeit slowly.  It sorta
> looks like Christoph is working[2] on this for pnfs.  Looking at 2.4.5,
> we preallocate all the cow staging extents, hand the client the old maps
> to read from and the new maps to write to, the client deals with the
> actual copy-write, and finally when the client commits then we can do
> the usual remapping business.
> 
> (Yeah, that is much less nasty than my naïve approach.)

Yup, and that's pretty much what I'm doing. The subvolume already
has the modified data in it's cache, so when the subvol IO path
tries to remap the IO range, the underlying FS does the COW
allocation and indicates that it needs to run a commit operation on
IO completion. On completion, the subvol runs a ->commit(off, len,
VBAS_T_COW) operation and the underlying fs does the final
remapping.  A similar process is used to deal with preallocated
regions in the underlying file (remap returns IOMAP_UNWRITTEN,
subvol calls ->commit(VBAS_T_UNWRITTEN) on IO completion).

This means that the subvolume looks just like direct IO to the
underlying host filesystem - the XFS VBAS host implementation is
just a thin wrapper around existing internal iomap interfaces.

I'm working on cleaning it up for an initial patch posting so people
can get a better idea of how it currently works....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

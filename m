Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:32932 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753209AbeAaVZG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 16:25:06 -0500
Date: Wed, 31 Jan 2018 13:25:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [LSF/MM TOPIC] Virtual block address space mapping
Message-ID: <20180131212501.GE4841@magnolia>
References: <20180129100834.rhpgnz5572zxmqep@destitution>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180129100834.rhpgnz5572zxmqep@destitution>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jan 29, 2018 at 09:08:34PM +1100, Dave Chinner wrote:
> Hi Folks,
> 
> I want to talk about virtual block address space abstractions for
> the kernel. This is the layer I've added to the IO stack to provide
> cloneable subvolumes in XFS, and it's really a generic abstraction
> the stack should provide, not be something hidden inside a
> filesystem.
> 
> Note: this is *not* a block device interface. That's the mistake
> we've made previously when trying to more closely integrate
> filesystems and block devices.  Filesystems sit on a block address
> space but the current stack does not allow the address space to be
> separated from the block device.  This means a block based
> filesystem can only sit on a block device.  By separating the
> address space from block device and replacing it with a mapping
> interface we can break the fs-on-bdev requirement and add
> functionality that isn't currently possible.
> 
> There are two parts; first is to modify the filesystem to use a
> virtual block address space, and the second is to implement a
> virtual block address space provider. The provider is responsible
> for snapshot/cloning subvolumes, so the provider really needs to be
> a block device or filesystem that supports COW (dm-thinp,
> btrfs, XFS, etc).

Since I've not seen your code, what happens for the xfs that's written to
a raw disk?  Same bdev/buftarg mechanism we use now?

> I've implemented both sides on XFS to provide the capability for an
> XFS filesystem to host XFS subvolumes. however, this is an abstract
> interface and so if someone modifies ext4 to use a virtual block
> address space, then XFS will be able to host cloneable ext4
> subvolumes, too. :P

How hard is it to retrofit an existing bdev fs to use a virtual block
address space?

> The core API is a mapping and allocation interface based on the
> iomap infrastructure we already use for the pNFS file layout and
> fs/iomap.c. In fact, the whole mapping and two-phase write algorithm
> is very similar to Christoph's export ops - we may even be able to
> merge the two APIs depending on how pNFS ends up handing CoW
> operations.

Hm, how /is/ that supposed to happen? :)

I would surmise that pre-cow would work[1] albeit slowly.  It sorta
looks like Christoph is working[2] on this for pnfs.  Looking at 2.4.5,
we preallocate all the cow staging extents, hand the client the old maps
to read from and the new maps to write to, the client deals with the
actual copy-write, and finally when the client commits then we can do
the usual remapping business.

(Yeah, that is much less nasty than my naïve approach.)

[1] https://marc.info/?l=linux-xfs&m=151626136624010&w=2
[2] https://tools.ietf.org/id/draft-hellwig-nfsv4-rdma-layout-00.html

> The API also provides space tracking cookies so that the subvolume
> filesystem can reserve space in the host ahead of time and pass it
> around to all the objects it modifies and writes to ensure space is
> available for the writes. This matches to the transaction model in
> the filesystems so the host can ENOSPC before we start modifying
> subvolume metadata and doing IO.
> 
> If block devices like dm-thinp implement a provider, then we'll also
> be able to avoid the fatal ENOSPC-on-write-IO when the pool fills
> unexpectedly....

<nod>

--D

> There's lots to talk about here. And, in the end, if nobody thinks
> this is useful, then I'll just leave it all internal to XFS. :)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

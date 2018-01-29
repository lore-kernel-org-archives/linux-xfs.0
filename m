Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33497 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751204AbeA2KHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 05:07:46 -0500
Date: Mon, 29 Jan 2018 21:08:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [LSF/MM TOPIC] Virtual block address space mapping
Message-ID: <20180129100834.rhpgnz5572zxmqep@destitution>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

Hi Folks,

I want to talk about virtual block address space abstractions for
the kernel. This is the layer I've added to the IO stack to provide
cloneable subvolumes in XFS, and it's really a generic abstraction
the stack should provide, not be something hidden inside a
filesystem.

Note: this is *not* a block device interface. That's the mistake
we've made previously when trying to more closely integrate
filesystems and block devices.  Filesystems sit on a block address
space but the current stack does not allow the address space to be
separated from the block device.  This means a block based
filesystem can only sit on a block device.  By separating the
address space from block device and replacing it with a mapping
interface we can break the fs-on-bdev requirement and add
functionality that isn't currently possible.

There are two parts; first is to modify the filesystem to use a
virtual block address space, and the second is to implement a
virtual block address space provider. The provider is responsible
for snapshot/cloning subvolumes, so the provider really needs to be
a block device or filesystem that supports COW (dm-thinp,
btrfs, XFS, etc).

I've implemented both sides on XFS to provide the capability for an
XFS filesystem to host XFS subvolumes. however, this is an abstract
interface and so if someone modifies ext4 to use a virtual block
address space, then XFS will be able to host cloneable ext4
subvolumes, too. :P

The core API is a mapping and allocation interface based on the
iomap infrastructure we already use for the pNFS file layout and
fs/iomap.c. In fact, the whole mapping and two-phase write algorithm
is very similar to Christoph's export ops - we may even be able to
merge the two APIs depending on how pNFS ends up handing CoW
operations.

The API also provides space tracking cookies so that the subvolume
filesystem can reserve space in the host ahead of time and pass it
around to all the objects it modifies and writes to ensure space is
available for the writes. This matches to the transaction model in
the filesystems so the host can ENOSPC before we start modifying
subvolume metadata and doing IO.

If block devices like dm-thinp implement a provider, then we'll also
be able to avoid the fatal ENOSPC-on-write-IO when the pool fills
unexpectedly....

There's lots to talk about here. And, in the end, if nobody thinks
this is useful, then I'll just leave it all internal to XFS. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

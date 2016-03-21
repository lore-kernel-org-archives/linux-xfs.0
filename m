Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 11CD07CA1
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 17:36:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93A3CAC003
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 15:36:26 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hq5dVoz4GwFspsKH for <xfs@oss.sgi.com>;
	Mon, 21 Mar 2016 15:36:23 -0700 (PDT)
Date: Tue, 22 Mar 2016 09:36:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/9] dm-thin/xfs: prototype a block reservation
	allocation model
Message-ID: <20160321223621.GN11812@dastard>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
	<20160321133346.GD25476@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160321133346.GD25476@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Mon, Mar 21, 2016 at 02:33:46PM +0100, Carlos Maiolino wrote:
> Hi.
> 
> From my point of view, I like the idea of an interface between the filesystem,
> and the thin-provisioned device, so that we can actually know if the thin
> volume is running out of space or not, but, before we actually start to discuss
> how this should be implemented, I'd like to ask if this should be implemented.

TL;DR: No-brainer, yes.

> After a few days discussing this with some block layer and dm-thin developers,
> what I most hear/read is that a thin volume should be transparent to the
> filesystem. So, the filesystem itself should not know it's running over a
> thin-provisioned volume. And such interface being discussed here, breaks this
> abstraction.

We're adding things like fallocate to block devices to control
preallocation, zeroing and freeing of ranges within the block device
from user space. If filesystems can't directly control and query
block device ranges on thinp block devices, then why should we let
userspace have this capability?

The problem we need to solve is that users want transparency between
filesystems and thinp devices. They don't want the filesytsem to
tell them they have lots of space available, and then get unexpected
ENOSPC because the thinp pool backing the fs has run out of space.
Users don't want a write over a region they have run
posix_fallocate() on to return ENOSPC because the thinp pool ran out
of space, even after the filesystem said it guaranteed space was
available.Filesystems want to know that they should run fstrim
passes internally when the underlying thinp pool is running out of
space so that it can free as much unused space as possible.

So there's lots of reasons why we need closer functional integration of
the filesytem and block layers, but doing this does not need to
break the abstraction layer between the filesystem and block device.
Indeed, we have already have mechanisms to provide block layer
functionality to the filesystems, and this patchset uses it - the
bdev ops structure.

Just because the filesystem knows that the underlying device has
it's own space management and it has to interact with it to give
users the correct results does not mean we are "breaking layering
abstractions". Filesystems has long assumed that the the LBA space
presented by the block device is a physical representation of the
underlying device.

We know this is not true, and has not been true for a long time.
Most devices really present a virtual LBA space to the higher
layers, and manipulate their underlying "physical" storage in a
manner that suits them best. SSDs do this, thinp does this, RAID
does this, dedupe/compressing/encrypting storage does this, etc.
IOWs, we've got virtual LBA abstractions right through the storage
stack, whether the higher layers realise it or not.

IOWs, we know that filesystems have been using virutal LBA address
spaces for a long time, yet we keep a block device model that
treats them as a physical, unchangable address space with known
physical characteristics (e.g. seek time is correlated with LBA
distance). We need to stop thinking of block devices as linear
devices and start treating them as they really are - a set of
devices capable of complex management operations, and we need
to start exposing those management operations for the higher layer
to be able to take advantage of.

Filesystems can take advantage of block devices that expose some of
their space management operations. We can make the interactions
users have on these storage stacks much better if we expose smarter
primitives from the block devices to the filesystems. We don't need
to break or change any abstractions - the filesystem is still very
much separate from the block device - but we need to improve the
communications and functionality channels between them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

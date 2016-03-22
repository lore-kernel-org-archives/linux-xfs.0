Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E7C837CA6
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 07:07:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8DA2304059
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 05:07:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nioaHcUkhWD1BAwW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Mar 2016 05:06:59 -0700 (PDT)
Date: Tue, 22 Mar 2016 08:06:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/9] dm-thin/xfs: prototype a block reservation
	allocation model
Message-ID: <20160322120656.GB51718@bfoster.bfoster>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
	<20160321133346.GD25476@redhat.com>
	<20160321223621.GN11812@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160321223621.GN11812@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, xfs@oss.sgi.com

Re-add dm-devel@redhat.com, linux-block@vger.kernel.org to CC.

(Also not trimming since the previous replies dropped some CCs)

On Tue, Mar 22, 2016 at 09:36:21AM +1100, Dave Chinner wrote:
> On Mon, Mar 21, 2016 at 02:33:46PM +0100, Carlos Maiolino wrote:
> > Hi.
> > 
> > From my point of view, I like the idea of an interface between the filesystem,
> > and the thin-provisioned device, so that we can actually know if the thin
> > volume is running out of space or not, but, before we actually start to discuss
> > how this should be implemented, I'd like to ask if this should be implemented.
> 
> TL;DR: No-brainer, yes.
> 
> > After a few days discussing this with some block layer and dm-thin developers,
> > what I most hear/read is that a thin volume should be transparent to the
> > filesystem. So, the filesystem itself should not know it's running over a
> > thin-provisioned volume. And such interface being discussed here, breaks this
> > abstraction.
> 
> We're adding things like fallocate to block devices to control
> preallocation, zeroing and freeing of ranges within the block device
> from user space. If filesystems can't directly control and query
> block device ranges on thinp block devices, then why should we let
> userspace have this capability?
> 
> The problem we need to solve is that users want transparency between
> filesystems and thinp devices. They don't want the filesytsem to
> tell them they have lots of space available, and then get unexpected
> ENOSPC because the thinp pool backing the fs has run out of space.
> Users don't want a write over a region they have run
> posix_fallocate() on to return ENOSPC because the thinp pool ran out
> of space, even after the filesystem said it guaranteed space was
> available.Filesystems want to know that they should run fstrim
> passes internally when the underlying thinp pool is running out of
> space so that it can free as much unused space as possible.
> 
> So there's lots of reasons why we need closer functional integration of
> the filesytem and block layers, but doing this does not need to
> break the abstraction layer between the filesystem and block device.
> Indeed, we have already have mechanisms to provide block layer
> functionality to the filesystems, and this patchset uses it - the
> bdev ops structure.
> 
> Just because the filesystem knows that the underlying device has
> it's own space management and it has to interact with it to give
> users the correct results does not mean we are "breaking layering
> abstractions". Filesystems has long assumed that the the LBA space
> presented by the block device is a physical representation of the
> underlying device.
> 
> We know this is not true, and has not been true for a long time.
> Most devices really present a virtual LBA space to the higher
> layers, and manipulate their underlying "physical" storage in a
> manner that suits them best. SSDs do this, thinp does this, RAID
> does this, dedupe/compressing/encrypting storage does this, etc.
> IOWs, we've got virtual LBA abstractions right through the storage
> stack, whether the higher layers realise it or not.
> 
> IOWs, we know that filesystems have been using virutal LBA address
> spaces for a long time, yet we keep a block device model that
> treats them as a physical, unchangable address space with known
> physical characteristics (e.g. seek time is correlated with LBA
> distance). We need to stop thinking of block devices as linear
> devices and start treating them as they really are - a set of
> devices capable of complex management operations, and we need
> to start exposing those management operations for the higher layer
> to be able to take advantage of.
> 
> Filesystems can take advantage of block devices that expose some of
> their space management operations. We can make the interactions
> users have on these storage stacks much better if we expose smarter
> primitives from the block devices to the filesystems. We don't need
> to break or change any abstractions - the filesystem is still very
> much separate from the block device - but we need to improve the
> communications and functionality channels between them.
> 

Thanks for the replies. I don't have a ton to add on this point beyond
that I tend to agree with Dave. I don't think the mere existence of
additional functionality in the thin bdev necessarily breaks any kind of
contract or layering between the filesystem and thin volume. The key
point there is everything should continue to work as it does today if
the underlying device doesn't support the particular mechanism (i.e.,
reservation), the filesystem doesn't have support, or if the
administrator simply chooses not to enable it at mount time (I'd expect
a new mount option, though this rfc enlists '-o discard' for that
purpose ;) due to the tradeoffs.

The bigger questions I have are whether people agree the solution is
useful, whether the reserve/provision interface is appropriate or
generic enough for outside the XFS sandbox I'm playing in, etc. For
example, I wonder if something similar could be extended to writeable
snapshots in the future to avoid exhaustion of the exception store. Last
I knew, this currently can result in invalidating the entire snapshot. I
think COW down in the volume turns that into a slightly different
problem for the fs, but I would expect to be able to use the same
general mechanism there. That said, if these are internal only
interfaces, perhaps it's not such a big deal if they evolve a bit as we
go.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

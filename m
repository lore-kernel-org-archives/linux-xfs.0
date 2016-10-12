Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:6525 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934111AbcJLUyJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Oct 2016 16:54:09 -0400
Date: Thu, 13 Oct 2016 07:54:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: SEEK_HOLE second hole problem
Message-ID: <20161012205405.GE27872@dastard>
References: <2303295B-3B56-404D-BAE3-A644D67EEC49@redhat.com>
 <8273699b-8f7d-e7b9-492f-77cbb4f74ec5@sandeen.net>
 <4639FD81-EE17-4497-AB45-CC87348AE4F1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4639FD81-EE17-4497-AB45-CC87348AE4F1@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Benjamin Coddington <bcodding@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Wed, Oct 12, 2016 at 02:40:06PM -0400, Benjamin Coddington wrote:
> On 12 Oct 2016, at 13:06, Eric Sandeen wrote:
> 
> > On 10/12/16 11:15 AM, Benjamin Coddington wrote:
> >> While investigating generic/285 failure on NFS on an XFS export I think I
> >> found a seek hole bug.
> >>
> >> For a file with a hole/data pattern of hole, data, hole, data; it appears
> >> that SEEK_HOLE for pattern chunks larger than 65536 will be incorrect for
> >> seeking the start of the next hole after the first hole.
> >
> > [sandeen@sandeen ~]$ ./bcodding testfile
> > SEEK_HOLE found second hole at 196608, expecting 139264
> > [sandeen@sandeen ~]$ xfs_bmap testfile
> > testfile:
> > 	0: [0..135]: hole
> > 	1: [136..383]: 134432656..134432903
> > 	2: [384..407]: hole
> > 	3: [408..543]: 134432392..134432527
> >
> > the numbers in brackets are sector numbers, so there is a hole
> > at 0, blocks at 69632, hole at 196608, and more blocks at 208896.
> >
> > As bfoster mentioned on IRC, I think you are seeing xfs's speculative
> > preallocation at work; more data got written than you asked for,
> > but there's no guarantee about how a filesystem will allocate
> > blocks based on an IO pattern.
> >
> > The /data/ is correct even if a zero-filled block ended up somewhere
> > you didn't expect:
> 
> OK, this makes sense.  It's clear my understanding of a "hole" was off --
> we're really looking for the next unallocated range, not the next unwritten
> or zero range.

Which, quite frankly, is a major red flag. Filesystems control
allocation, not applications. Yes, you can /guide/ allocation with
fallocate() and things like extent size hints, but you cannot
/directly control/ how any filesystem allocates the blocks
underlying a file from userspace.

i.e. the moment an application makes an assumption that the
filesystem "must leave a hole" when doing some operation, or that
"we need to find the next unallocated region" in a file, the design
should be thrown away and shoul dbe started again without those
assumptions. That's because filesystem allocation behaviour is
completely undefined by any standard, not guaranteed by any
filesystem, and change between different filesystems and even
different versions of the same filesystem.

Remember - fallocate() defines a set of user visible behaviours, but
it does not dictate how a filesystem should implement them. e.g.
preallocation needs to guarantee that the next write to that region
does not ENOSPC. That can be done in several different ways - write
zeroes, allocate unwritten extents, accounting tricks to reserve
blocks, etc. Every one of these is going to give different output
when seek hole/data passes over those regions, but they will still
/all be correct/.

> Like me, generic/285 seems to have gotten this wrong too, but

The test isn't wrong - it's just a demonstration of the fact we
can't easily cater for every different allocation strategy that
filesystems and storage uses to optimise IO patterns and pervent
fragmentation.

e.g. the hack in generic/285 to turn off ext4's "zero-around"
functionality, which allocates and zeros small regions between data
rather than leaving a hole. That's a different style of
anti-fragmentation optimisation to what XFS uses, but the result is
the same - there is data (all zeroes) on ext4 where other
filesystems leave a hole.

IOWs, by changing a sysfs value we make ext4 return different
information from seek hole/data for exactly the same user IO
pattern. Yet both are correct....

> the short allocation sizes aren't triggering this preallocation when used
> directly on XFS.  For NFS the larger st_blksize means we see the

                                      ^ NFS client side
> preallocation happen.

NFS client write IO patterns require aggressive preallocation
strategies when XFS is used on the server to prevent excessive
fragmentation of larger files. What is being returned from seek
hole/data in this case is still correct and valid - it's just not
what you (or the test) were expecting.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57184 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726833AbfFYDzf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 23:55:35 -0400
Date: Tue, 25 Jun 2019 13:54:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: convert extents in place for ZERO_RANGE
Message-ID: <20190625035423.GG7777@dread.disaster.area>
References: <ace9a6b9-3833-ec15-e3df-b9d88985685e@redhat.com>
 <25a2ebbc-0ec9-f5dd-eba0-4101c80837dd@sandeen.net>
 <20190625023954.GF7777@dread.disaster.area>
 <2b135e00-3bfd-f41a-7c43-a0518fc756fe@sandeen.net>
 <20190625030018.GC5387@magnolia>
 <3f8037f0-08ff-98b2-6995-230e7bf33372@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f8037f0-08ff-98b2-6995-230e7bf33372@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 24, 2019 at 10:05:51PM -0500, Eric Sandeen wrote:
> On 6/24/19 10:00 PM, Darrick J. Wong wrote:
> > On Mon, Jun 24, 2019 at 09:52:03PM -0500, Eric Sandeen wrote:
> >> On 6/24/19 9:39 PM, Dave Chinner wrote:
> >>> On Mon, Jun 24, 2019 at 07:48:11PM -0500, Eric Sandeen wrote:
> >>>> Rather than completely removing and re-allocating a range
> >>>> during ZERO_RANGE fallocate calls, convert whole blocks in the
> >>>> range using xfs_alloc_file_space(XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT)
> >>>> and then zero the edges with xfs_zero_range()
> >>>
> >>> That's what I originally used to implement ZERO_RANGE and that
> >>> had problems with zeroing the partial blocks either side and
> >>> unexpected inode size changes. See commit:
> >>>
> >>> 5d11fb4b9a1d xfs: rework zero range to prevent invalid i_size updates
> >>
> >> Yep I did see that.  It had a lot of hand-rolled partial block stuff
> >> that seems more complex than this, no?  That commit didn't indicate
> >> what the root cause of the failure actually was, AFAICT.
> >>
> >> (funny thought that I skimmed that commit just to see why we had
> >> what we have, but didn't really intentionally re-implement it...
> >> even though I guess I almost did...)
> > 
> > FWIW the complaint I had about the fragmentary behavior really only
> > applied to fun and games when one fallocated an ext4 image and then ran
> > mkfs.ext4 which uses zero range which fragmented the image...
> > 
> >>> I also remember discussion about zero range being inefficient on
> >>> sparse files and fragmented files - the current implementation
> >>> effectively defragments such files, whilst using XFS_BMAPI_CONVERT
> >>> just leaves all the fragments behind.
> >>
> >> That's true - and it fragments unfragmented files.  Is ZERO_RANGE
> >> supposed to be a defragmenter?
> > 
> > ...so please remember, the key point we were talking about when we
> > discussed this a year ago was that if the /entire/ zero range maps to a
> > single extent within eof then maybe we ought to just convert it to
> > unwritten.
> 
> I remember you mentioning that, but honestly it seems like
> overcomplication to say "ZERO_RANGE will also defragment extents
> in the process, if it can..."

Keep in mind that my original implementation of ZERO_RANGE was
for someone who explicitly requested zeroing of preallocated VM
image files without reallocating them. Hence the XFS_BMAPI_CONVERT
implementation. They'd been careful about initial allocation, and
they wanted to reuse image files for new VMs without perturbing
their initial careful preallocation patterns.

I think the punch+reallocate is a more generally useful behaviour
because people are far less careful about image file layout (e.g.
might be using extent size hints or discard within the VM) and so
we're more likely to see somewhat fragmented files for zeroing than
we are fully intact.

SO, yeah, I can see arguments for both cases, and situations where
one behaviour would be preferred over the other.

Random thought: KEEP_SIZE == I know what I'm doing, just convert in
place because the layout is as I want it. !KEEP_SIZE = punch and
preallocate because we are likely changing the file size anyway?

> >>> What prevents xfs_zero_range() from changing the file size if
> >>> offset + len is beyond EOF and there are allocated extents (from
> >>> delalloc conversion) beyond EOF? (i.e. FALLOC_FL_KEEP_SIZE is set by
> >>> the caller).
> >>
> >> nothing, but AFAIK it does the same today... even w/o extents past
> >> EOF:
> >>
> >> $ xfs_io -f -c "truncate 0" -c "fzero 0 1m" testfile
> > 
> > fzero -k ?
> 
> $ xfs_io -f -c "truncate 0" -c "fzero -k 0 1m" testfile
> 
> $ ls -lh testfile
> -rw-------. 1 sandeen sandeen 0 Jun 24 22:02 testfile
> 
> with or without my patches.

My concern was about files with pre-existing extents beyond EOF.
i.e. something like this (on a vanilla kernel):

$ xfs_io -f -c "truncate 0"  -c "pwrite 0 16m" -c "fsync" -c "bmap -vp" -c "fzero -k 0 32m" -c "bmap -vp" -c "stat" testfile
wrote 16777216/16777216 bytes at offset 0
16 MiB, 4096 ops; 0.0000 sec (700.556 MiB/sec and 179342.3530 ops/sec)
testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET            TOTAL FLAGS
   0: [0..65407]:      1145960728..1146026135 10 (47331608..47397015) 65408 000000
testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET            TOTAL FLAGS
   0: [0..65535]:      1146026136..1146091671 10 (47397016..47462551) 65536 010000
fd.path = "testfile"
fd.flags = non-sync,non-direct,read-write
stat.ino = 1342366656
stat.type = regular file
stat.size = 16777216
stat.blocks = 65536
fsxattr.xflags = 0x2 [-p--------------]
fsxattr.projid = 0
fsxattr.extsize = 0
fsxattr.cowextsize = 0
fsxattr.nextents = 1
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136
$

So you can see it is 16MiB in size, but has 32MB of blocks allocated
to it, and it's a different 32MB of blocks that were allocated by
the delalloc because we punched and reallocated it as an unwritten
extent.

That's where I'm concerned - that range beyond EOF is no longer
punched away by this new code, an dit's not unwritten so the
zero_range is going to iterate and zero it, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

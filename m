Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57537 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751845AbdHDDOw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 23:14:52 -0400
Date: Fri, 4 Aug 2017 13:14:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Intermittent zeroed pages with AIO+DIO+XFS
Message-ID: <20170804031410.GC21024@dastard>
References: <dac170a5-d11f-c8ce-3890-8b5629364c18@scylladb.com>
 <20170803220922.GA21024@dastard>
 <9a63f206-d026-eae4-9556-957ef94855b4@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a63f206-d026-eae4-9556-957ef94855b4@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org, Glauber Costa <glauber@scylladb.com>, Raphael Carvalho <raphaelsc@scylladb.com>

On Fri, Aug 04, 2017 at 05:40:07AM +0300, Avi Kivity wrote:
> On 08/04/2017 01:09 AM, Dave Chinner wrote:
> >On Thu, Aug 03, 2017 at 05:52:45PM +0300, Avi Kivity wrote:
> >>Hello,
> >>
> >Hi Avi,
> >
> >>I have an application that uses AIO+DIO to write data to a file on
> >>XFS. The writes use 128k buffers. Very rarely, I see aligned 4k
> >>blocks within the file that are zeroed. The blocks are not aligned
> >>to 128k boundary, just 4k. The buffers are allocated in anonymous
> >>memory, which is usually using transparent hugepages.  The files are
> >>fully allocated, not sparse (checked post-mortem).
> >Did you check that the extents are written? i.e. there aren't
> >sporadic 4k unwritten extents in the file? (xfs_bmap -vvp output)
> 
> Raphael did that, and the result was that the file was NOT sparse.

Sure, but a file with unwritten extents is not sparse. It's just got
extents that will always read as zeros. The extra "-vvp" output
tells you the unwritten flag state and does not merge contiguous
extents that differ only in state.

i.e:

$ sudo xfs_io -fd -c "falloc 0 1M" -c "pwrite 900k 200k" /mnt/scratch/foo
wrote 204800/204800 bytes at offset 921600
200 KiB, 50 ops; 0.0000 sec (13.838 MiB/sec and 3542.5818 ops/sec)
$ sudo xfs_bmap /mnt/scratch/foo
/mnt/scratch/foo:
        0: [0..2199]: 160..2359

Looks fully allocated. However:

$ sudo xfs_bmap -vvp /mnt/scratch/foo
/mnt/scratch/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE       AG AG-OFFSET        TOTAL FLAGS
   0: [0..1799]:       160..1959          0 (160..1959)       1800 010000
   1: [1800..2199]:    1960..2359         0 (1960..2359)       400 000000
 FLAG Values:
    0100000 Shared extent
    0010000 Unwritten preallocated extent
    0001000 Doesn't begin on stripe unit
    0000100 Doesn't end   on stripe unit
    0000010 Doesn't begin on stripe width
    0000001 Doesn't end   on stripe width
$

The first 900k of the file is an unwritten extent, which returns
zeros...

> btw, we also run with the extent size hint set to 32MB.

Which means that space is definitely being allocated as unwritten
extents, then overwritten and converted on IO completion. Hence if
the overwrite is not complete, or there's a bug in the unwritten
extent conversion, it may leave unwritten extents where it
shouldn't....

> >What kernel version is this seen on? We've changed the XFS DIO
> >IO path implementation substantially in recent times....
> 
> CentOS 7.2's kernel. Glauber, do you now the precise version string?

Can you reproduce on an upstream kernel? Problems with highly
patched distro kernels really need to be directed to the distro...

> >>Does this trigger anything in anyone's mind?
> >Nope - do you have a reproducer you can share?
> >
> 
> Run a certain NoSQL database for months on a cluster with lots of
> activity, and _may_ see it a few time. It's very rare, but it's
> there.

Needle in a haystack, then - the problem could be anywhere in the
storage stack, including hardware. You're going to need to
isolate the problem to the filesystem for us, which means a
reproducer script of some kind...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

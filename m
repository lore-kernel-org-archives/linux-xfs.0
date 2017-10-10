Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:51653 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755376AbdJJWz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2017 18:55:28 -0400
Date: Wed, 11 Oct 2017 09:55:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: agcount for 2TB, 4TB and 8TB drives
Message-ID: <20171010225524.GV3666@dastard>
References: <CAJH6TXgShHj6UynrNAs8eG0ZRFz5gSGGY1ZARPSofsNibi0Grg@mail.gmail.com>
 <20171006153803.GI7122@magnolia>
 <8e6fd742-8767-e786-746d-2b9f2929b98c@sandeen.net>
 <20171006222031.GU3666@dastard>
 <b97b41f5-76dc-b2d7-3b34-02a331b0d8de@sandeen.net>
 <1b5b6410-b1d9-8519-7032-8ea0ca46f5b5@scylladb.com>
 <20171009112306.GM3666@dastard>
 <89a7ae9a-9960-ae37-f6ca-0c1f2e33f65f@scylladb.com>
 <20171009220332.GP3666@dastard>
 <38bd7785-174d-fd09-fc1f-50a2d4e1dd69@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38bd7785-174d-fd09-fc1f-50a2d4e1dd69@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-xfs@vger.kernel.org

On Tue, Oct 10, 2017 at 12:07:42PM +0300, Avi Kivity wrote:
> On 10/10/2017 01:03 AM, Dave Chinner wrote:
> >>On 10/09/2017 02:23 PM, Dave Chinner wrote:
> >>>On Mon, Oct 09, 2017 at 11:05:56AM +0300, Avi Kivity wrote:
> >>>Sure, that might be the IO concurrency the SSD sees and handles, but
> >>>you very rarely require that much allocation parallelism in the
> >>>workload. Only a small amount of the IO submission path is actually
> >>>allocation work, so a single AG can provide plenty of async IO
> >>>parallelism before an AG is the limiting factor.
> >>Sure. Can a single AG issue multiple I/Os, or is it single-threaded?
> >AGs don't issue IO. Applications issue IO, the filesystem allocates
> >space from AGs according to the write IO that passes through it.
> 
> What I meant was I/O in order to satisfy an allocation (read from
> the free extent btree or whatever), not the application's I/O.

Once you're in the per-AG allocator context, it is single threaded
until the allocation is complete. We do things like btree block
readahead to minimise IO wait times, but we can't completely hide
things like metadata read Io wait time when it is required to make
progress.

> >>I understand that XFS_XFLAG_EXTSIZE and XFS_IOC_FSSETXATTR can
> >>reduce the AG's load.
> >Not really. They change the allocation pattern on the inode. This
> >changes how the inode data is laid out on disk, but it doesn't
> >necessarily change the allocation overhead of the write IO path.
> >That's all dependent on what the application IO patterns are and how
> >they match the extent size hints.
> 
> I write 128k naturally-aligned writes using aio, so I expect it will
> match. Will every write go into the AG allocator, or just writes
> that cross a 32MB boundary?

It enters an allocation only when an allocation is required. i.e.
only when the write lands in a hole. If you're doing sequential 128k
writes and using 32MB extent size hints, then it only allocates once
every 32768/128 = 256 writes. If you are doing random IO into a
sparse file, then it all bets are off.

> >That's what RWF_NOWAIT is for. It pushes any write IO that requires
> >allocation into a thread rather possibly blocking the submitting
> >thread on any lock or IO in the allocation path.
> 
> Excellent, we'll use that, although it will be years before our
> users see the benefit.

Well, that's really in your control, not mine.

The disconnect between upstream progress and LTS production
systems is not something upstream can do anything about. Often the
problems LTS production systems see are already solved upstream and
so the only answer we can really give you here is "upgrade, backport
features your customers need yourself, or pay someone else to
maintain a backport with the features you need".

> >>Machines with 60-100 logical cores and low-tens of terabytes of SSD
> >>are becoming common.  How many AGs would work for such a machine?
> >Multidisk default, which will be 32 AGs for anything in the 1->32TB
> >range. And over 32TB, you get 1 AG per TB...
> 
> 
> Ok. Then doubling it so that each logical core has an AG wouldn't be
> such a big change.

But it won't make any difference to your workload because there's no
relationship between CPU cores and the AG selected for allocation.
The AG selection is based on filesystem relationships (e.g. local to
parent directory inode), and so if you have two files in the same
directory they will start trying to allocate from the same AG even
thought hey get written from different cores concurrently. The only
time they'll get moved into different AGs is if there is allocation
contention.

Yes, the allocator algorithms detect AG contention internally and
switch to uncontended AGs rather than blocking. There's /lots/ of
stuff inside the allocators to minimise blocking - that's one of the
reasons you see less submission blocking problems on XFS than other
filesytsems. If you're not getting threads blocking waiting to get
AGF locks, then you most certainly don't have allocator contention.
Even if you do have threads blocking on AGF locks, that could simply
be a sign you are running too close to ENOSPC, not contention...

The reality is, however, that even an uncontended AG can block if
the necessary metadata isn't in memory, or the log is full, or
memory cannot be immediately allocated, etc. RWF_NOWAIT avoids the
whole class of "allocator can block" problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

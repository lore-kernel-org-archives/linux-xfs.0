Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4500 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751436AbeA2Vzw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 16:55:52 -0500
Date: Tue, 30 Jan 2018 08:56:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_extent_busy_flush vs. aio
Message-ID: <20180129215645.c5dfa3mmoio2iovo@destitution>
References: <20180123161120.GC32478@bfoster.bfoster>
 <5f67219e-e48b-a954-69d4-318268645377@scylladb.com>
 <20180123164718.GE32478@bfoster.bfoster>
 <e1229a02-33ea-e5d5-d66f-36fa553a3393@scylladb.com>
 <20180123173902.GF32478@bfoster.bfoster>
 <f4751375-0710-cec8-ac6d-1f9546bba1ce@scylladb.com>
 <20180125130830.GD43198@bfoster.bfoster>
 <dd148ae0-fe9b-b5b6-5b03-05f0894ce969@scylladb.com>
 <20180129113556.fd4y3t5yupeqtn5t@destitution>
 <6eddde50-ad81-f2ce-c273-86442598a934@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6eddde50-ad81-f2ce-c273-86442598a934@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jan 29, 2018 at 01:44:14PM +0200, Avi Kivity wrote:
> 
> 
> On 01/29/2018 01:35 PM, Dave Chinner wrote:
> > On Mon, Jan 29, 2018 at 11:40:27AM +0200, Avi Kivity wrote:
> > > 
> > > On 01/25/2018 03:08 PM, Brian Foster wrote:
> > > > On Thu, Jan 25, 2018 at 10:50:40AM +0200, Avi Kivity wrote:
> > > > > On 01/23/2018 07:39 PM, Brian Foster wrote:
> > > > > > Yeah, could be.. perhaps the issue is that despite the large amount of
> > > > > > total free space, the free space is too fragmented to satisfy a
> > > > > > particular allocation request..?
> > > > >      from      to extents  blocks    pct
> > > > >         1       1    2702    2702   0.00
> > > > >         2       3     690    1547   0.00
> > > > >         4       7     115     568   0.00
> > > > >         8      15      60     634   0.00
> > > > >        16      31      63    1457   0.00
> > > > >        32      63     102    4751   0.00
> > > > >        64     127    7940  895365   0.19
> > > > >       128     255   49680 12422100   2.67
> > > > >       256     511    1025  417078   0.09
> > > > >       512    1023    4170 3660771   0.79
> > > > >      1024    2047    2168 3503054   0.75
> > > > >      2048    4095    2567 7729442   1.66
> > > > >      4096    8191    8688 59394413  12.76
> > > > >      8192   16383     310 3100186   0.67
> > > > >     16384   32767     112 2339935   0.50
> > > > >     32768   65535      35 1381122   0.30
> > > > >     65536  131071       8  651391   0.14
> > > > >    131072  262143       2  344196   0.07
> > > > >    524288 1048575       4 2909925   0.62
> > > > > 1048576 2097151       3 3550680   0.76
> > > > > 4194304 8388607      10 82497658  17.72
> > > > > 8388608 16777215      10 158022653  33.94
> > > > > 16777216 24567552       5 122778062  26.37
> > > > > total free extents 80469
> > > > > total free blocks 465609690
> > > > > average free extent size 5786.2
> > > > > 
> > > > > Looks like plenty of free large extents, with most of the free space
> > > > > completely, unfragmented.
> > > > > 
> > > > Indeed..
> > You need to look at each AG, not the overall summary. You could have
> > a suboptimal AG hidden in amongst that (e.g. near ENOSPC) and it's
> > that one AG that is causing all your problems.
> > 
> > There's many reasons this can happen, but the most common is the
> > working files in a directory (or subset of directories in the same
> > AG) have a combined space usage of larger than an AG ....
> 
> That's certainly possible, even likely (one huge directory with all of the
> files).
> 
> This layout is imposed on us by the compatibility gods. Is there a way to
> tell XFS to change its policy of on-ag-per-directory?

mount with inode32. That rotors files around all AGs in a round
robin fashion instead of trying to keep directory locality for  a
working set. i.e. it distributes the files evenly across the
filesystem.

However, this can have substantial impact on performance if the
workload requires locality of files for performance and you're
running on spinning rust. OTOH, if locality is not needed then
distributing all files across all AGs evenly should give more even
capacity usage.

And, based on what was discussed on #xfs overnight, don't bother
with the filestreams allocator - it will not solve the "full AG"
problem, but it will introduce a whole bunch of new problems for
you.

> That system has since been recycled, but we'll keep it in mind the next time
> we see it. Also, we'll have to fix the one-huge-directory problem for sure,
> one way or another.

If inode32 doesn't work for you, the easiest way is to use a small
directory hash - create top level directory with ~2x AG count child
directories and hash your files into those. This will distribute the
files roughly evenly across all AGs in the filesystem whilst still
maintaining locality within directories. It's kind of half way
between inode64 and inode32....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

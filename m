Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31113 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751014AbeACXAH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 18:00:07 -0500
Date: Thu, 4 Jan 2018 09:59:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Block size and read-modify-write
Message-ID: <20180103225954.GP5858@dastard>
References: <021d36d95a9de952ddd38cc56d18df4f@assyoma.it>
 <20180102102539.5kh2tjo5gmlewiek@odin.usersys.redhat.com>
 <20180103011926.GJ5858@dastard>
 <b58a3a90-0e7b-abca-91ce-8b2d8819a75b@assyoma.it>
 <20180103214741.GO5858@dastard>
 <fa54fea7ec0d836f2c037f7b71a17365@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa54fea7ec0d836f2c037f7b71a17365@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 03, 2018 at 11:09:30PM +0100, Gionatan Danti wrote:
> Il 03-01-2018 22:47 Dave Chinner ha scritto:
> >On Wed, Jan 03, 2018 at 03:54:42PM +0100, Gionatan Danti wrote:
> >>
> >>
> >>On 03/01/2018 02:19, Dave Chinner wrote:
> >>>Cached writes smaller than a *page* will cause RMW cycles in the
> >>>page cache, regardless of the block size of the filesystem.
> >>
> >>Sure, in this case a page-sized r/m/w cycle happen in the pagecache.
> >>However it seems to me that, when flushed to disk, writes happens at
> >>the block level granularity, as you can see from tests[1,2] below.
> >>Am I wrong? I am missing something?
> >
> >You're writing into unwritten extents. That's not a data overwrite,
> >so behaviour can be very different. And when you have sub-page block
> >sizes, the filesystem and/or page cache may decide not to read the
> >whole page if it doesn't need to immmediately. e.g. you'll see
> >different behaviour between a 512 byte write() and a 512 byte write
> >via mmap()...
> 
> The first "dd" execution surely writes into unwritten extents.
> However, on the following writes real data are overwritten, right?

Yes. But I'm talking about the initial page cache writes in your
tests, and they were all into unwritten extents. These are the
writes that had different behaviour in exach test case.

The second write in each test case was the direct IO write. That's
what went over existing data, written through the page cache by the
first write. They all had the same behaviour - a single 512 byte
write - as they were all being written into allocated blocks that
contained existing data on a device with a logical sector size of
512 bytes.

> >We've been over this many times in the past few years. user data
> >alignment is controlled by stripe unit/width specification,
> >not sector/block sizes.
> 
> Sure, but to avoid/mitigate device-level r/m/w, a proper alignement
> is not sufficient by itself. You should also avoid partial page
> writes.

That's an application problem, not a filesystem problem. All the
filesystem can do is align/size the data extents to match what is
optimal for the underlying storage (as we do for RAID) and hope
the application is smart enough to do large, well formed IOs to
the filesystem.

> Anyway, I got the message: this is not business XFS directly
> cares about.

I think you've jumped to entirely the wrong conclusion. We do care
about it because if you can't convey/control data alignment at the
filesystem level, then you can't fully optimise IO at the
application level.

The reality is that we've been doing these sorts of data alignment
optimisations for the last 20 years with XFS and applications using
direct IO. We care an awful lot about alignment of the filesystem
structure to the underlying device characteristics because if we
don't then IO performance is extremely difficult to maximise and/or
make deterministic.

However, this is such a complex domain that very, very few people
have the knowledge and expertise to understand how to take advantage
of it fully. It's hard even to convey just how complex it is to
people without a solid knowledge base of filesysystem and storage
knowledge, as this conversion shows...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:25977
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727800AbeISE1T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 00:27:19 -0400
Date: Wed, 19 Sep 2018 08:52:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: dm-writecache issue
Message-ID: <20180918225212.GJ27618@dastard>
References: <20180911221147.GA23308@redhat.com>
 <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com>
 <20180918123238.GI27618@dastard>
 <alpine.LRH.2.02.1809181014500.28565@file01.intranet.prod.int.rdu2.redhat.com>
 <20180918153324.GB13016@infradead.org>
 <alpine.LRH.2.02.1809181316230.7172@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1809181316230.7172@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>

On Tue, Sep 18, 2018 at 01:39:53PM -0400, Mikulas Patocka wrote:
> On Tue, 18 Sep 2018, Christoph Hellwig wrote:
> > On Tue, Sep 18, 2018 at 10:22:15AM -0400, Mikulas Patocka wrote:
> > > > On Tue, Sep 18, 2018 at 07:46:47AM -0400, Mikulas Patocka wrote:
> > SATA and SAS SSDs can always use the same trick as modern disks to
> > support 512 byte access where really needed (e.g. BIOS and legacy
> > OSes) but give a strong hint to modern OSes that they don't want that
> > to be actually used with the physical block exponent.  NVMe doesn't
> > have anything like that yet, but we are working on something like
> > that in the NVMe TWG.
> 
> The question is - why do you want to use 512-byte writes if they perform 
> badly? For example, the Kingston NVME SSD has 242k IOPS for 4k writes and 
> 45k IOPS for 2k writes.

We know all about this sort of thing for a long, long while (e.g.
the very first fusion IO hardware behaved like this).  We also know
that various intel SSDs have the same problems(*), not to mention
XFS being blamed for the single sector write data corruption
problems they had (which Christoph has already mentioned).

That said, we /rarely/ do 512 byte metadata IOs in active XFS
filesystems.  Single sector metadata are used only for static
metadata - the allocation group headers. They were designed as
single sector objects 25 years ago so they could be written
atomically and could be relied on to be intact after power failure
events.

In reality, we read these objects once into memory when they are
first accessed, and we only write them when the filesystem needs
journal space or goes idle, both of which may be "never" because
active metadata is just continually relogged and never rewritten in
place until the workload idles.

IOWs arguments about 512 byte sector metadata writes causing
performance issues are irrelevant to the discussion here because
they just don't.

> The same problem is with dm-writecache - it can run with 512-byte sectors, 
> but there's unnecessary overhead. It would be much better if XFS did 4k 
> aligned writes.
> 
> 
> You can do 4k writes and assume that only 512-byte units are written 
> atomically - that would be safe for old 512-byte sector disk and it 
> wouldn't degrade performance on SSDs.
> 
> If the XFS data blocks are aligned on 4k boundary, you can do 4k-aligned 
> I/Os on the metadata as well.

Yup, that's how XFS was designed way back when.  All the dynamically
allocated metadata in XFS (i.e. everything but the AG header blocks)
is filesystem block sized (or larger) and at least filesystem block
aligned. So if you use the default 4k filesystem block size, all the
dynamic metadata IO (dirs, btrees, inodes, etc) are at least 4k
aligned and sized.

This is all really basic filesystem design stuff - structures
critical to recovery and repair need to be robust against torn
writes (i.e. single sectors), while dynamically allocated run-time
structures (data or metadata) are all allocated in multiples of the
fundamental unit of space acounting (i.e. filesystem blocks).

> You could allocate metadata in 512-byte 
> quantities and you could do 4k reads and writes on them. You would 
> over-read and over-write a bit, but it will perform better due to avoiding 
> the read-modify-write logic in the SSD.

No, we can't do that. The transaction models requires independent IO
and locking for each of those AG headers. Trying to stuff them all
into one IO and/or buffer will cause deadlocks and lock contention
problems.

> I'm not an expert in the XFS journal - but could the journal writes be 
> just padded to 4k boundary (even if the journal space is allocated in 
> 512-byte quantities)?

<sigh>

What do you think the log stripe unit configuration option does?
Yup, it pads the log writes to whatever block size is specified.
We've had that functionality since around 2005. The issue here is
that the device told us "512 byte sectors" and no minimum/optimal IO
sizes, so mkfs doesn't add any padding by default.

Regardless, a log write is rarely a single sector - a log write
header is a complete sector, maybe 2 depending on the iclogbuf size,
which is then followed by the metadata that needs checkpointing.
The typical log IO is an entire iclogbuf, which defaults to 32k and
can be configured up to 256k. These writes have lsunit padding and
alignment (which may be single sector), but these large writes
didn't have any protection against tearing. Hence we still have to
ensure individual sectors in each write are intact during recovery.

Yes, we now have CRCs for entire log writes these large write tears
and other IO errors, but that doesn't change the underlying on-disk
format or algorithms that are used.

And that's the issue: the XFS journal is a sector based device, not
a filesystem block based device. It's on-disk format was designed
around the fact that torn writes do not occur inside a single
sector. Hence the log scan and search algorithms assume that it can
read and write individual sectors in the device, and that if the
per-sector log header has the correct sequence number stamped in it
then the entire sector has valid contents.

The long and short of all this is that block devices cannot
dynamically change their advertised sector size. Filesystems have
been designed for 40+ years around the assumption that the physical
sector size of the underlying storage device is fixed for the life
of the device. DM is just going to have to reject attempts to build
dynamically layered devices with incompatible sector size
requirements.

Cheers,

Dave.

(*) Some recent high end intel enterprise SSDs had bath-tub curve
performance problems with IO that isn't 128k aligned(**). I'm
guessing that the internal page (flash erase block) size was 128k,
and it didn't handle sub page or cross-page IO at all well. I'm not
sure if there were ever firmware updates to fix that.

(**) yes, filesystem developers see all sorts of whacky performance
problems with storage. That's because everyone blames the messenger
for storage problems (i.e. the filesystem), so we're the lucky
people get to triage them and determine where the problem really
lies.

-- 
Dave Chinner
david@fromorbit.com

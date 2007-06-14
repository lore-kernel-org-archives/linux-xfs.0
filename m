Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 05:04:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5EC4kWt007064
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 05:04:48 -0700
Date: Thu, 14 Jun 2007 22:04:13 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070614120413.GD86004887@sgi.com>
References: <20070426180332.GA7209@amitarora.in.ibm.com> <20070509160102.GA30745@amitarora.in.ibm.com> <20070510005926.GT85884050@sgi.com> <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614091458.GH5181@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, Suparna Bhattacharya <suparna@in.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com

On Thu, Jun 14, 2007 at 03:14:58AM -0600, Andreas Dilger wrote:
> On Jun 14, 2007  09:52 +1000, David Chinner wrote:
> > B FA_PREALLOCATE
> > provides the same functionality as
> > B FA_ALLOCATE
> > except it does not ever change the file size. This allows allocation
> > of zero blocks beyond the end of file and is useful for optimising
> > append workloads.
> > TP
> > B FA_DEALLOCATE
> > removes the underlying disk space with the given range. The disk space
> > shall be removed regardless of it's contents so both allocated space
> > from
> > B FA_ALLOCATE
> > and
> > B FA_PREALLOCATE
> > as well as from
> > B write(3)
> > will be removed.
> > B FA_DEALLOCATE
> > shall never remove disk blocks outside the range specified.
> 
> So this is essentially the same as "punch".

Depends on your definition of "punch".

> There doesn't seem to be
> a mechanism to only unallocate unused FA_{PRE,}ALLOCATE space at the
> end.

ftruncate()

> > B FA_DEALLOCATE
> > shall never change the file size. If changing the file size
> > is required when deallocating blocks from an offset to end
> > of file (or beyond end of file) is required,
> > B ftuncate64(3)
> > should be used.
> 
> This also seems to be a bit of a wart, since it isn't a natural converse
> of either of the above functions.  How about having two modes,
> similar to FA_ALLOCATE and FA_PREALLOCATE?

<shrug>

whatever.

> Say, FA_PUNCH (which
> would be as you describe here - deletes all data in the specified
> range changing the file size if it overlaps EOF,

Punch means different things to different people. To me (and probably
most XFS aware ppl) punch implies no change to the file size.

i.e. anyone curently using XFS_IOC_UNRESVSP will expect punching
holes to leave the file size unchanged. This is the behaviour I
described for FA_DEALLOCATE.

> and FA_DEALLOCATE,
> which only deallocates unused FA_{PRE,}ALLOCATE space?

That's an "unwritten-to-hole" extent conversion. Is that really
useful for anything? That's easily implemented with FIEMAP
and FA_DEALLOCATE.

Anyway, because we can't agree on a single pair of flags:

	FA_ALLOCATE        == posix_fallocate()
	FA_DEALLOCATE      == unwritten-to-hole ???
	FA_RESV_SPACE      == XFS_IOC_RESVSP64
	FA_UNRESV_SPACE    == XFS_IOC_UNRESVSP64

> We might also consider making @mode be a mask instead of an enumeration:
> 
> FA_FL_DEALLOC	0x01 (default allocate)
> FA_FL_KEEP_SIZE	0x02 (default extend/shrink size)
> FA_FL_DEL_DATA	0x04 (default keep written data on DEALLOC)

i.e:

#define FA_ALLOCATE	0
#define FA_DEALLOCATE	FA_FL_DEALLOC
#define FA_RESV_SPACE	FA_FL_KEEP_SIZE
#define FA_UNRESV_SPACE	FA_FL_DEALLOC | FA_FL_KEEP_SIZE | FA_FL_DEL_DATA

> I suppose it might be a bit late in the game to add a "goal"
> parameter and e.g. FA_FL_REQUIRE_GOAL, FA_FL_NEAR_GOAL, etc to make
> the API more suitable for XFS?

It would suffice for the simpler operations, I think, but we'll
rapidly run out of flags and we'll still need another interface
for doing complex stuff.....

> The goal could be a single __u64, or
> a struct with e.g. __u64 byte offset (possibly also __u32 lun like
> in FIEMAP).  I guess the one potential limitation here is the
> number of function parameters on some architectures.

To be useful it needs to __u64.

> > B ENOSPC
> > There is not enough space left on the device containing the file
> > referred to by
> > IR fd.
> 
> Should probably say whether space is removed on failure or not.  In

Right. I'd say on error you need to FA_DEALLOCATE to ensure any space
allocated was freed back up. That way the error handling in the allocate
functions is much simpler (i.e. no need to undo there).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

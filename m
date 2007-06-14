Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 12:33:56 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5EJXnWt005423
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 12:33:50 -0700
Date: Thu, 14 Jun 2007 13:33:47 -0600
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070614193347.GN5181@schatzie.adilger.int>
References: <20070509160102.GA30745@amitarora.in.ibm.com> <20070510005926.GT85884050@sgi.com> <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614120413.GD86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, Suparna Bhattacharya <suparna@in.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com

On Jun 14, 2007  22:04 +1000, David Chinner wrote:
> On Thu, Jun 14, 2007 at 03:14:58AM -0600, Andreas Dilger wrote:
> > > B FA_DEALLOCATE
> > > removes the underlying disk space with the given range. The disk space
> > > shall be removed regardless of it's contents so both allocated space
> > > from
> > > B FA_ALLOCATE
> > > and
> > > B FA_PREALLOCATE
> > > as well as from
> > > B write(3)
> > > will be removed.
> > > B FA_DEALLOCATE
> > > shall never remove disk blocks outside the range specified.
> > 
> > So this is essentially the same as "punch".
> 
> Depends on your definition of "punch".
> 
> > There doesn't seem to be
> > a mechanism to only unallocate unused FA_{PRE,}ALLOCATE space at the
> > end.
> 
> ftruncate()

No, that will delete written data also.  What I'm thinking is in cases
where an application does fallocate() to reserve a lot of space, and
when the application is finished it wants to unreserve any unused space.

> > > B FA_DEALLOCATE
> > > shall never change the file size. If changing the file size
> > > is required when deallocating blocks from an offset to end
> > > of file (or beyond end of file) is required,
> > > B ftuncate64(3)
> > > should be used.
> > 
> > This also seems to be a bit of a wart, since it isn't a natural converse
> > of either of the above functions.  How about having two modes,
> > similar to FA_ALLOCATE and FA_PREALLOCATE?
> 
> <shrug>
> 
> whatever.
> 
> > Say, FA_PUNCH (which
> > would be as you describe here - deletes all data in the specified
> > range changing the file size if it overlaps EOF,
> 
> Punch means different things to different people. To me (and probably
> most XFS aware ppl) punch implies no change to the file size.

If "punch" does not change the file size, how is it possible to determine
the end of the actual written data?  Say you have a file with records
in it, and these records are cancelled as they are processed (e.g. a
journal of sorts).  One usage model for punch() that we had in the past
is to punch out each record after it finishes processing, so that it will
not be re-processed after a crash.  If the file size doesn't change with
punch then there is no way to know when the last record is hit and the
rest of the file needs to be scanned.

> i.e. anyone curently using XFS_IOC_UNRESVSP will expect punching
> holes to leave the file size unchanged. This is the behaviour I
> described for FA_DEALLOCATE.
> 
> > and FA_DEALLOCATE,
> > which only deallocates unused FA_{PRE,}ALLOCATE space?
> 
> That's an "unwritten-to-hole" extent conversion. Is that really
> useful for anything? That's easily implemented with FIEMAP
> and FA_DEALLOCATE.

But why force the application to do this instead of making the
fallocate API sensible and allowing it to be done directly?

> Anyway, because we can't agree on a single pair of flags:
> 
> 	FA_ALLOCATE        == posix_fallocate()
> 	FA_DEALLOCATE      == unwritten-to-hole ???

I'd think this makes sense, being natural opposites of each other.
FA_ALLOCATE doesn't overwrite existing data with zeros, so FA_DEALLOCATE
shouldn't erase existing data.  If FA_ALLOCATE extends the file size,
then FA_DEALLOCATE should shrink it if there is no data at the end.

> 	FA_RESV_SPACE      == XFS_IOC_RESVSP64
> 	FA_UNRESV_SPACE    == XFS_IOC_UNRESVSP64

> > We might also consider making @mode be a mask instead of an enumeration:
> > 
> > FA_FL_DEALLOC	0x01 (default allocate)
> > FA_FL_KEEP_SIZE	0x02 (default extend/shrink size)
> > FA_FL_DEL_DATA	0x04 (default keep written data on DEALLOC)
> 
> #define FA_ALLOCATE	0
> #define FA_DEALLOCATE	FA_FL_DEALLOC
> #define FA_RESV_SPACE	FA_FL_KEEP_SIZE
> #define FA_UNRESV_SPACE	FA_FL_DEALLOC | FA_FL_KEEP_SIZE | FA_FL_DEL_DATA

OK, this makes the semantics of XFS_IOC_RESVSP64 and XFS_IOC_UNRESVSP64
clear at least.  The benefit is that it would also be possible (I'm
not necessarily advocating this as a flag, just an example) to have
semantics that are like XFS_IOC_ALLOCSP64 (zeroing written data while
preallocating) with:

#define FA_ZERO_SPACE    FA_DEL_DATA

or whatever semantics the caller actually wants, instead of restricting
them to the subset of combinations given by FA_ALLOCATE and FA_DEALLOCATE
(whatever it is we decide on in the end).

> > > B ENOSPC
> > > There is not enough space left on the device containing the file
> > > referred to by
> > > IR fd.
> > 
> > Should probably say whether space is removed on failure or not.  In
> 
> Right. I'd say on error you need to FA_DEALLOCATE to ensure any space
> allocated was freed back up. That way the error handling in the allocate
> functions is much simpler (i.e. no need to undo there).

Hmm, another flag?  FA_FL_FREE_ENOSPC?  I can imagine applications like
PVRs to want to preallocate, say, an estimated 30 min of space for a show
but if they only get 25 min of space returned they know some cleanup is
in order (which can be done asynchronously while the show is filling the
first 25 min of preallocated space).  Otherwise, they have to loop in
userspace trying decreasing preallocations until they fit, or starting
small and incrementally preallocating space until they get an error.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

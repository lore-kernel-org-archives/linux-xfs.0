Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jul 2007 09:21:59 -0700 (PDT)
Received: from mail.clusterfs.com (74-0-229-162.T1.lbdsl.net [74.0.229.162])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l61GLqtL001022
	for <xfs@oss.sgi.com>; Sun, 1 Jul 2007 09:21:54 -0700
Date: Sat, 30 Jun 2007 12:52:46 -0400
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070630165246.GA5159@schatzie.adilger.int>
References: <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630102111.GB23568@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Jun 30, 2007  11:21 +0100, Christoph Hellwig wrote:
> On Tue, Jun 26, 2007 at 04:02:47PM +0530, Amit K. Arora wrote:
> > Currently it is left on the file system implementation. In ext4, we do
> > not undo preallocation if some error (say, ENOSPC) is hit. Hence it may
> > end up with partial (pre)allocation. This is inline with dd and
> > posix_fallocate, which also do not free the partially allocated space.
> 
> I can't find anything in the specification of posix_fallocate
> (http://www.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html)
> that tells what should happen to allocate blocks on error.
> 
> But common sense would be to not leak disk space on failure of this
> syscall, and this definitively should not be left up to the filesystem,
> either we always leak it or always free it, and I'd strongly favour
> the latter variant.

I definitely agree that the behaviour should be specified part of
the interface.  The current behaviour of both ext4 and XFS is that the
successful part of the unallocated extent is left in place when returning
ENOSPC so we considered this the "consistent" behaviour.  This is the same
as e.g. sys_write() which does not remove the part of the write that was
successful if ENOSPC is hit.  I think this also makes sense for some usa
cases, because application like PVR may want to preallocate approximately
30min of space, but if it gets only 25min worth then it can at least start
using this while it also begins looking for and/or freeing old files.

If the space is always freed on ENOSPC, then there may be a significant
amount of work done and undone while the application is iterating over
possible sizes until one works.   It is easy for the application to
use fstat() to see the blocks/size actually preallocated on failure, and
explicitly request unallocation of this space if the outcome is undesirable.

If you think that applications have a strong preference for both kinds
of behaviour (e.g. database which requires the full allocation to succeed,
unlike PVR application above) then this could be encoded into a @mode flag.

> > > For FA_ZERO_SPACE - I'd think this would (IMHO) be the default - we
> > > don't want to expose uninitialized disk blocks to userspace.  I'm not
> > > sure if this makes sense at all.
> 
> This is the xfs unwritten extent behaviour.  But anyway, the important bit
> is uninitialized blocks should never ever leak to userspace, so there is
> not need for the flag.

I agree that we shouldn't need FA_ZERO_SPACE.  If an application wants
explicit zeros written to disk it can just do this with O_DIRECT writes
or similar.

> The more I think about it the more I'd prefer we would just put a simple
> syscall in that implements nothing but the posix_fallocate(3) semantics
> as defined in SuS, and then go on to brainstorm about advanced
> preallocation / layout hint semantics.

I don't think the current @mode flags introduce any significant complexity
in the implementation, and in fact one of the reasons these came up in the
first place was because David pointed out the XFS behaviour did NOT match
with posix_fallocate() and we started getting strange semantics enforced
by monolithic modes.  IMHO, coding for and understanding the semantics of
the monolithic modes is much more complex and less useful than the explicit
flags.

The @mode flags that are currently under consideration are (AFAIK):

FA_FL_DEALLOC	0x01 /* deallocate unwritten extent (default allocate) */
FA_FL_KEEP_SIZE	0x02 /* keep size for EOF {pre,de}alloc (default change size) */
FA_FL_DEL_DATA	0x04 /* delete existing data in alloc range (default keep) */

Your concern about leaking space would imply:

FA_FL_ERR_FREE	0x08 /* free preallocation on error (default keep prealloc) */

The other possible flags that were proposed, to avoid confusing backup and
HSM applications when preallocated space is added or removed from a file
(you don't want a backup app to re-backup a file that was migrated via HSM):

FA_FL_NO_MTIME	0x10 /* keep same mtime (default change on size, data change) */
FA_FL_NO_CTIME	0x20 /* keep same ctime (default change on size, data change) */

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

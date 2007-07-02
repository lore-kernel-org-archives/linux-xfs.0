Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jul 2007 04:47:31 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l62BlNtL028160
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 04:47:26 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l62BlMLP011478
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 07:47:22 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l62BlMk2534102
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 07:47:22 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l62BlMmO027492
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 07:47:22 -0400
Date: Mon, 2 Jul 2007 17:17:30 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070702114730.GA21966@amitarora.in.ibm.com>
References: <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070701225543.GW31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701225543.GW31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger@clusterfs.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Mon, Jul 02, 2007 at 08:55:43AM +1000, David Chinner wrote:
> On Sat, Jun 30, 2007 at 11:21:11AM +0100, Christoph Hellwig wrote:
> > On Tue, Jun 26, 2007 at 04:02:47PM +0530, Amit K. Arora wrote:
> > > > Can you clarify - what is the current behaviour when ENOSPC (or some other
> > > > error) is hit?  Does it keep the current fallocate() or does it free it?
> > > 
> > > Currently it is left on the file system implementation. In ext4, we do
> > > not undo preallocation if some error (say, ENOSPC) is hit. Hence it may
> > > end up with partial (pre)allocation. This is inline with dd and
> > > posix_fallocate, which also do not free the partially allocated space.
> > 
> > I can't find anything in the specification of posix_fallocate
> > (http://www.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html)
> > that tells what should happen to allocate blocks on error.
> 
> Yeah, and AFAICT glibc leaves them behind ATM.

Yes, it does.
 
> > But common sense would be to not leak disk space on failure of this
> > syscall, and this definitively should not be left up to the filesystem,
> > either we always leak it or always free it, and I'd strongly favour
> > the latter variant.

I would not call it a "leak", since the blocks which got allocated as
part of the partial success of the fallocate syscall can be strictly
accounted for (i.e. they are assigned to a particular inode). And these
can be freed by the application, using a suitable @mode of fallocate.
 
> We can't simply walk the range an remove unwritten extents, as some
> of them may have been present before the fallocate() call. That
> makes it extremely difficult to undo a failed call and not remove
> more pre-existing pre-allocations.

Same is true for ext4 too. It is very difficult to keep track of which
uninitialized (unwritten) extents got allocated as part of the current
syscall. This is because, as David mentions, some of them might be
already present; and also because some of the older ones may have got
merged with the *new* uninitialized/unwritten extents as part of the
current syscall. 
 
> Given the current behaviour for posix_fallocate() in glibc, I think
> that retaining the same error semantic and punting the cleanup to
> userspace (where the app will fail with ENOSPC anyway) is the only
> sane thing we can do here. Trying to undo this in the kernel leads
> to lots of extra rarely used code in error handling paths...

Right. This gives applications the free hand if they really want to use
the partially preallocated space, OR they want to free it; without
introducing additional complexity in the kernel.

--
Regards,
Amit Arora

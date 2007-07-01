Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jul 2007 15:56:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l61MuHtL027953
	for <xfs@oss.sgi.com>; Sun, 1 Jul 2007 15:56:19 -0700
Date: Mon, 2 Jul 2007 08:55:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070701225543.GW31489@sgi.com>
References: <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630102111.GB23568@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Sat, Jun 30, 2007 at 11:21:11AM +0100, Christoph Hellwig wrote:
> On Tue, Jun 26, 2007 at 04:02:47PM +0530, Amit K. Arora wrote:
> > > Can you clarify - what is the current behaviour when ENOSPC (or some other
> > > error) is hit?  Does it keep the current fallocate() or does it free it?
> > 
> > Currently it is left on the file system implementation. In ext4, we do
> > not undo preallocation if some error (say, ENOSPC) is hit. Hence it may
> > end up with partial (pre)allocation. This is inline with dd and
> > posix_fallocate, which also do not free the partially allocated space.
> 
> I can't find anything in the specification of posix_fallocate
> (http://www.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html)
> that tells what should happen to allocate blocks on error.

Yeah, and AFAICT glibc leaves them behind ATM.

> But common sense would be to not leak disk space on failure of this
> syscall, and this definitively should not be left up to the filesystem,
> either we always leak it or always free it, and I'd strongly favour
> the latter variant.

We can't simply walk the range an remove unwritten extents, as some
of them may have been present before the fallocate() call. That
makes it extremely difficult to undo a failed call and not remove
more pre-existing pre-allocations.

Given the current behaviour for posix_fallocate() in glibc, I think
that retaining the same error semantic and punting the cleanup to
userspace (where the app will fail with ENOSPC anyway) is the only
sane thing we can do here. Trying to undo this in the kernel leads
to lots of extra rarely used code in error handling paths...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

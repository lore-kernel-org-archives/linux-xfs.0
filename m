Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 11:19:20 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SIJEtL022006
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 11:19:15 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5SIJDwl006604
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 14:19:13 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5SIJ5bI262748
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 12:19:11 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5SIJ4LM004125
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 12:19:04 -0600
Date: Thu, 28 Jun 2007 23:49:13 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070628181913.GC1674@amitarora.in.ibm.com>
References: <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070626153413.GC6652@schatzie.adilger.int> <20070626231803.GQ31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626231803.GQ31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Wed, Jun 27, 2007 at 09:18:04AM +1000, David Chinner wrote:
> On Tue, Jun 26, 2007 at 11:34:13AM -0400, Andreas Dilger wrote:
> > On Jun 26, 2007  16:02 +0530, Amit K. Arora wrote:
> > > On Mon, Jun 25, 2007 at 03:46:26PM -0600, Andreas Dilger wrote:
> > > > Can you clarify - what is the current behaviour when ENOSPC (or some other
> > > > error) is hit?  Does it keep the current fallocate() or does it free it?
> > > 
> > > Currently it is left on the file system implementation. In ext4, we do
> > > not undo preallocation if some error (say, ENOSPC) is hit. Hence it may
> > > end up with partial (pre)allocation. This is inline with dd and
> > > posix_fallocate, which also do not free the partially allocated space.
> > 
> > Since I believe the XFS allocation ioctls do it the opposite way (free
> > preallocated space on error) this should be encoded into the flags.
> > Having it "filesystem dependent" just means that nobody will be happy.
> 
> No, XFs does not free preallocated space on error. it is up to the
> application to clean up.

Since XFS also does not free preallocated space on error and this
behavior is inline with dd, posix_fallocate() and the current ext4
implementation, do we still need FA_FL_FREE_ENOSPC flag ?
 
> > What I mean is that any data read from the file should have the "appearance"
> > of being zeroed (whether zeroes are actually written to disk or not).  What
> > I _think_ David is proposing is to allow fallocate() to return without
> > marking the blocks even "uninitialized" and subsequent reads would return
> > the old data from the disk.
> 
> Correct, but for swap files that's not an issue - no user should be able
> too read them, and FA_MKSWAP would really need root privileges to execute.

Will the FA_MKSWAP mode still be required with your suggested change of
teaching do_mpage_readpage() about unwritten extents being in place ?
Or, will you still like to have FA_MKSWAP mode ?

--
Regards,
Amit Arora

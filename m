Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5J1M1em006295 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 20:22:01 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZeFB5fut9rOYw3H4 for <xfs@oss.sgi.com>;
	Mon, 18 Jun 2012 18:22:00 -0700 (PDT)
Date: Tue, 19 Jun 2012 11:20:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS status update for May 2012
Message-ID: <20120619012035.GG25389@dastard>
References: <20120618120853.GA15480@infradead.org>
	<AD997E9D-2C1E-4EE4-80D7-2A5C998B6E9E@dilger.ca>
	<20120618184344.GV4721@sgi.com>
	<1005E3D5-D9F4-42F9-8BAE-9FB40A8AFA57@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1005E3D5-D9F4-42F9-8BAE-9FB40A8AFA57@dilger.ca>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andreas Dilger <adilger@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>, Ben Myers <bpm@sgi.com>, LKML List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Jun 18, 2012 at 02:36:27PM -0600, Andreas Dilger wrote:
> On 2012-06-18, at 12:43 PM, Ben Myers wrote:
> > On Mon, Jun 18, 2012 at 12:25:37PM -0600, Andreas Dilger wrote:
> >> On 2012-06-18, at 6:08 AM, Christoph Hellwig wrote:
> >>> May saw the release of Linux 3.4, including a decent sized XFS update.
> >>> Remarkable XFS features in Linux 3.4 include moving over all metadata
> >>> updates to use transactions, the addition of a work queue for the
> >>> low-level allocator code to avoid stack overflows due to extreme stack
> >>> use in the Linux VM/VFS call chain,
> >> 
> >> This is essentially a workaround for too-small stacks in the kernel,
> >> which we've had to do at times as well, by doing work in a separate
> >> thread (with a new stack) and waiting for the results?  This is a
> >> generic problem that any reasonably-complex filesystem will have when
> >> running under memory pressure on a complex storage stack (e.g. LVM +
> >> iSCSI), but causes unnecessary context switching.
> >> 
> >> Any thoughts on a better way to handle this, or will there continue
> >> to be a 4kB stack limit and hack around this with repeated kmalloc
> >> on callpaths for any struct over a few tens of bytes, implementing
> >> memory pools all over the place, and "forking" over to other threads
> >> to continue the stack consumption for another 4kB to work around
> >> the small stack limit?
> > 
> > FWIW, I think your characterization of the problem as a 'workaround for
> > too-small stacks in the kernel' is about right.  I don't think any of
> > the XFS folk were very happy about having to do this, but in the near
> > term it doesn't seem that we have a good alternative.  I'm glad to see
> > that there are others with the same pain, so maybe we can build some
> > support for upping the stack limit.
> 
> Is this problem mostly hit in XFS with dedicated service threads like
> kNFSd and similar, or is it a problem with any user thread perhaps
> entering the filesystem for memory reclaim inside an already-deep
> stack?

When you have the flusher thread using 2-2.5k of stack before it
enters the filesystem, DM and MD below the filesystem using 1-1.5k
of stack, and the scsi driver doing a mempool allocation taking 3k
of stack, there's basically nothing left for the filesystem.

We took this action because the flusher thread (i.e. the thread with
the lowest top level stack usage) was blowing the stack during
delayed allocation.

> For dedicated service threads I was wondering about allocating larger
> stacks for just those processes (16kB would be safe), and then doing
> something special at thread startup to use this larger stack.  If
> the problem is for any potential thread, then the solution would be
> much more complex in all likelihood.

Anything that does a filemap_fdatawrite() call is susceptible to a
stack overrun. i having seen a O_SYNC write(2) call overrun a stack
yet, but it was only a matter of time. I certainly have seen the
same write call from an NFSD overrun the stack. It's lucky we have
te IO-less throttling now, otherwise any thread that enters
balance_dirty_pages() was a candidate for a stack overrun....

IOWs,the only solution that would fix the problem was to split
allocations into a different stack so that we have the approximately
4k of stack space needed for the worst case XFS stack usage (double
btree split requiring metadata IO) and still have enough space left
for the DM/MD/SCSI stack underneath it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

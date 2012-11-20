Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKMKDfa217692 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 16:20:13 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JxUepzCvGqQVcvGP for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 14:22:22 -0800 (PST)
Date: Wed, 21 Nov 2012 09:22:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Don't flush inodes when project quota exceeded
Message-ID: <20121120222215.GH2591@dastard>
References: <1352766973-14197-1-git-send-email-jack@suse.cz>
	<20121119213913.GB29498@quack.suse.cz>
	<20121120161511.GE27055@sgi.com>
	<20121120170354.GF1408@quack.suse.cz>
	<20121120202038.GF2591@dastard> <50ABF54E.6070508@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50ABF54E.6070508@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue, Nov 20, 2012 at 04:25:34PM -0500, Brian Foster wrote:
> On 11/20/2012 03:20 PM, Dave Chinner wrote:
> > On Tue, Nov 20, 2012 at 06:03:54PM +0100, Jan Kara wrote:
> >> On Tue 20-11-12 10:15:11, Ben Myers wrote:
> >>> Hi Jan,
> >>>
> >>> On Mon, Nov 19, 2012 at 10:39:13PM +0100, Jan Kara wrote:
> >>>> On Tue 13-11-12 01:36:13, Jan Kara wrote:
> ...
> >>>
> >>> I think that there may be good reason to flush inodes even in the project quota
> >>> case.  Speculative allocation beyond EOF might need to be cleaned up.
> > 
> > The flushing at ENOSPC doesn't clear up speculative preallocation.
> > It writes back data which releases metadata reservations that
> > delalloc extents hold in addition to the data. The reservations are
> > held so that tree splits during allocation have block reserved and
> > we don't ENOSPC on delalloc all the time.
> > 
> 
> So does this apply to EDQUOT just the same as ENOSPC?

We don't apply it to edquot because the filesystem still has plenty
of data space available, hence removing the metadata reservations is
not necessary to prevent premature ENOSPC errors. The metadata
reservation is correctly attributed to the quota, so no flushing on
EDQUOT is fine...

> In other words,
> must we always do the flush, or can we replace the flush in EDQUOT
> situations with a targeted eofblocks scan and retry?

There is no flush for EDQUOT right now but we need to add a targeted
eofblocks scan and retry on EDQUOT.

> Are these metadata reservations accounted against the particular quota?

Yes.

> >>> I'm all
> >>> for passing back some data about why we hit ENOSPC.  Then we can combine this
> >>> with Brian Foster's work and flush only inodes that touch a given project,
> >>> user, or group quota.
> > 
> > Brian had more patches that throttled specualtive prealloc when
> > quota got low, as well as triggered a specific specualtive
> > allocation trimming passes when EDQUOT is hit. This will remove the
> > global inode flush from the project uota cae when it is done.
> 
> Yes, I need to resurrect those throttling patches as my next order of
> business. They never had the eofblocks bits originally but it seems like
> a logical add on at this point.

*nod*

> A point of confusion for me... above you reference removing the global
> inode flush from the project quota case, which I'm taking as we can do
> some kind of eofblocks scan here...

Yes, the only inodes that will have reserved metadata are those with
outstanding delayed allocation, and those are also the ones that
will have outstanding specualtive preallocation....

> >>   Yes, I agree flushing might be useful even for project quota but then why
> >> don't we flush inodes also for user quota?
> > 
> > It's by design. Directory tree quota is used as a method of
> > exporting multiple sub-dirs from a single filesystem but having them
> > appear to NFS clients just like a standalone filesystem. Hence when
> > you run out of projet quota, it is treated like an ENOSPC condition
> > for the directory sub-tree - it flushes as much of the metadata
> > reservations out as possible to maximise the data space for the
> > directory tree.

And FWIW, returning ENOSPC to the NFS client inthese situations is
the correct error to be returning as they know nothing about the
fact that project quotas are used on the server to limit the size of
the export the client has mounted.

> > For user/group quotas, this requirement of behaving like a
> > standalone filesystem does not exist, and so when you EDQUOT a
> > user/group there is no need to reclaim metadata reservations to make
> > more data space available....
> 
> ... but the metadata reservation issue discussed here sounds like it
> could still be a problem. Is the implication that we could still do a
> project quota filtered eofblocks scan, but it must also (or instead, if
> a flush implies trimming post-eof space) include an inode flush in the
> project quota case?

It's never been reported as a problem. In the absence of problems
being reported over the past 10+ years, I don't think we should be
changing the behaviour of inode flushing at EDQUOT. Trimming
speculative prealloc, yes, but I don't think flushing inodes is
necessary.

> Otherwise, unless I'm mistaken it sounds like we can use the existing
> eofblocks scan on user/group EDQUOT situations.

That we can. And for the project case, it's a simply and extra flag
and a call to filemap_flush() to do an async writeback before
trimming the specualtive preallocation.

> >> Also the performance impact
> >> is really huge - and here I agree that unless you are writing over NFS you
> >> won't notice because only NFS tries to push X MB to the filesystem page by
> >> page only to get ENOSPC each time...
> > 
> > The problem is the speculative allocation can trigger this behaviour
> > prematurely and repeatedly. That's where Brians prealloc throttle
> > patches come in - it reduces the occurrence of ENOSPC as the quota
> > limit is approached, and hence reduces the number of inode flushes.
> > 
> 
> I'll include this use case in my testing when I get back to those patches.

Cool.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

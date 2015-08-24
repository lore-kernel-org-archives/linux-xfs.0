Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4881C7F37
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 19:12:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E36F1AC003
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 17:12:26 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	3EtfIScFEILGxgRj for <xfs@oss.sgi.com>;
	Sun, 23 Aug 2015 17:12:24 -0700 (PDT)
Date: Mon, 24 Aug 2015 10:10:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: v5 filesystem corruption due to log recovery lsn ordering
Message-ID: <20150824001035.GZ714@dastard>
References: <20150819183904.GB49174@bfoster.bfoster>
	<20150819224453.GL3902@dastard>
	<20150820162529.GB13033@bfoster.bfoster>
	<20150821003449.GU714@dastard>
	<20150821143923.GC46372@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150821143923.GC46372@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 21, 2015 at 10:39:23AM -0400, Brian Foster wrote:
> On Fri, Aug 21, 2015 at 10:34:49AM +1000, Dave Chinner wrote:
> > On Thu, Aug 20, 2015 at 12:25:29PM -0400, Brian Foster wrote:
> > > On Thu, Aug 20, 2015 at 08:44:53AM +1000, Dave Chinner wrote:
> > > That's an interesting idea, but I wonder if it truly fixes the problem
> > > or just makes it potentially more difficult to reproduce. One concern is
> > > that even with this in place, all it takes to reintroduce the problem is
> > > for a filesystem to run a bit on an older kernel in a situation where
> > > the LSN is reset and enough modification has occurred to update whatever
> > > key metadata we determine as important with the reset LSNs.
> > 
> > We can't prevent that - that horse has already bolted.
> 
> Well, the feature bit can potentially do that. I'm not terribly fond of
> it (overkill) and the goal was't to fix older kernels so much as to
> prevent the problem from being reintroduced on newer kernels going
> forward (provided newer kernels implemented this mount-time LSN
> inheritance scheme).

We can prevent the problem of old userspace on newer kernels by
detecting a zeroed log - we don't need a feature bit for that.

> In other words, the proposed solution depends on trust of the metadata
> LSNs. One way we can trust those metadata LSNs is to prevent older
> kernels/xfsprogs from messing with them.

Well, it's old userspace we need to worry about here - kernels don't
zero the log...

> That said, I don't really agree with the assertion that upgraded
> userspace alone sufficiently alleviates the problem. A filesystem that's
> been around a while and has more recently been repaired is susceptible
> to this problem for the foreseeable future, upgraded userspace or not,
> until either all metadata with stale LSNs is updated or the problem is
> identified and repaired explicitly.

But there's nothing we can do in userspace to fix that. More on that
below.

> > > Another concern is that we're assuming that the key metadata will always
> > > have the most recent LSN. I think the closest thing to a guarantee we
> > > have of that is the superblock being updated on umount and every so
> > > often by xfs_log_worker() to cover the log. After a bit of playing
> > > around, I'm not so sure that is enough.
> > 
> > Sure, I just threw it out as a way to get a more recent LSN. The
> > only way to reliably get the highest LSN is to walk all the metadata
> > in the filesystem. We can't do that at mount time, so perhaps it
> > is best to just refuse to mount read-write and issue a warning to
> > upgrade xfsprogs and re-run xfs_repair.
> > 
> 
> Indeed, that sounds like a nicer approach to me. We're really only
> considering the superblock at mount time though (note that repair resets
> AG header LSNs), so we're not going to be guaranteed the mount fails for
> all affected fs'. What do you think about also firing a (one-time,
> probably) warning if we ever update a bit of metadata with a smaller
> LSN?

Larger LSN, you mean? ;)

But, yes, that is what I was thinking for solving the "horse has
already bolted" condition you described above. We can detect LSNs
beyond the current log in the metadata we read from disk and issue a
warning.  e.g in each metadata verifiers we add a:

	if (xfs_verify_lsn(mp, hdr->lsn))
		return false;

then we can warn immediately that this is a problem. If we discover
it during log recovery (i.e. lsn beyond the current head in the log
in a block that passes all the other metadata self checks) then we
can shut down or force the filesystem into read-only mode so that
the user has to update xfsprogs and run repair to fix it because we
can't safely run log recovery at this point.

> That bit of metadata is now "fixed" once written out, but the point is
> that the log item for this metadata was probably not effective and to
> notify the user that the fs' LSNs are potentially out of whack and a
> repair is in order.

That's true - if we don't hit a bad lsn in recovery, we just issue a
one-time warning from the verifiers and continue onwards. If the
user is lucky, the problem will fix itself before it is ever a
problem for recovery.

> > So, to repair: have it record LSNs as it walks the metadata and
> > at the start of phase 5 have it select a new cycle number higher
> > than the highest LSN found in the filesystem. Stamp the log with
> > that cycle number as well as all metadata that is being rebuilt
> > in phase 5, and all the superblocks.
> > 
> > Problem solved.
> > 
> 
> Yeah, I was thinking of just using the current head of the log, as
> described in my random note. Using the LSN from the metadata is probably
> necessary in the cases where the log might be corrupted, however.

And as a minor detail, I'd take the cycle number from the highest
LSN and bump it a few cycles just to make sure that the new LSN is
well beyond anything in the filesystem...

> The solution of detection in the kernel and a fix in repair sounds
> pretty good to me provided the detection is robust (e.g., the point
> above wrt a warning). Then we have something in current kernels that can
> effectively handle the problem regardless of how it might have been
> (re)introduced and it's fairly simple as well.

*nod*

I think we have a plan :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

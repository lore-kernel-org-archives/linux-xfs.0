Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF7017F4E
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 06:59:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96B3F304062
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2014 04:59:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h7LiL55e1jurJhCA for
	<xfs@oss.sgi.com>; Tue, 10 Jun 2014 04:59:00 -0700 (PDT)
Date: Tue, 10 Jun 2014 07:58:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [DISCUSS] Planning for new dev cycle (3.17)
Message-ID: <20140610115857.GC46344@bfoster.bfoster>
References: <20140609223320.GE9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140609223320.GE9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 10, 2014 at 08:33:20AM +1000, Dave Chinner wrote:
> Hi everyone,
> 
> Now that the 3.16 dev cycle has drawn to a close (one more
> linux-next build and I'll tag for-next and send a pull request),
> it's time to look ahead for the next couple of months. I think the
> current major pieces of work that are currently outstanding are
> these:
> 
> 	- Jeff's bulkstat rework
> 	- Brian's EOF prealloc scanning
> 	- Namjae's FALLOC_FL_INSERT_RANGE work
> 	- Eric's XFS_ERROR() macro removal and return () cleanup.
> 

I'm not tied to a particular kernel release by any means if there's
already a lot in the pipeline, but I'd like to include the basic sysfs
bits somewhere in the tail end of this.

> There's also two major pieces of infrastructure work I'd like to get
> done:
> 
> 	- convert XFS to negative error returns
> 	- restructure code to have a fs/xfs/libxfs structure similar
> 	  to userspace
> 
> Because Eric's XFS_ERROR removal touches the entire codebase, as
> does the negative error return and the libxfs restructuring, I'd
> like to get these done first and base the rest of the dev cycle work
> on top of that. Eric's patches just need a minor rebase and the
> libxfs restructure needs some makefile rework and review and they
> should be good to go.
> 

Sounds reasonable to me.

> The issue is the negative error number patchset, and how to handle
> review and testing. The patchset is already 62 patches long and it
> converts roughly half the code base. It'll take me another couple of
> days to convert the rest of the code, and that will probably take
> another 60 patches.
> 
> I understand that reviewing 100+ patches is going to be a pain, but
> each patch currently averages about +/- 10 lines. The current
> diffstat is:
> 
> 	37 files changed, 723 insertions(+), 722 deletions(-)
> 
> And that will probably double, so it's still going to be a fair
> amount of change.
> 

Is there any sort of more coarse logical breakdown of this series, or do
we want/need to convert the entire codebase all at once? The individual
patches sound relatively small... is there a particular method at play
there? E.g., a patch per function? file? call chain?

> So the big question is how do we handle the review side of things.
> I think testing won't be a huge issue because of the time we have in
> the cycle (a couple of months to the 3.17 merge, and then a couple
> more months in the 3.17-rcX cycle) to find and catch regressions,
> but I'd like to know what people think about the best way to review
> this change will be.
> 
> I'm happy for people to say "no, we need to review it patch by
> patch, so delay it for a cycle while we work through it", but I'm
> also happy for a "apply it all and look at error sources and
> inversion points for problems". The second is probably easier, as
> there will be very few remaining inversion points (only embedded
> errors in ioctl structures, I think) and all error sources should be
> negated at their definition and hence any error value (E* values)
> that are not defined as "-E*" is likely to be an mistake....
> 

Personally, I generally prefer going through individual patches. Even if
we don't post the entire series and do a patch-by-patch reviewed-by
(which sounds like overkill in this case), that helps me do bits a time,
keep track of where I am, etc. I say that before I've seen any of these
patches of course ;), so I could certainly see running through some kind
of approach of doing it batches (i.e., "look at this sequence of
patches, identify the affected segments of code, make a direct pass
through that code, repeat"). I guess it's hard to say without just
digging in and finding the most effective approach to get through it.

Perhaps if we just make a branch available with the patches, put a
notification on the list, and we can use that as a review thread..?

Brian

> I'll be spending the next couple of days finishing this all off, so
> once it is done I can focus on review and bug fixes for the rest of
> the 3.17 dev cycle. That allows me to  concentrate on a xfsprogs
> 3.2.1 release, subsequent userspace libxfs resync with the new
> kernel structure, and starting to work on some of the smart block
> device concepts I've been talking about recently....
> 
> These are not concrete plans - just what I'd *like* to do in the
> next couple of months. Reality is bound to mess up any plans I have,
> so I figure I mays as well mess them up straight away....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com



> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

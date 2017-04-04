Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:51959 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751867AbdDDMuM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2017 08:50:12 -0400
Date: Tue, 4 Apr 2017 22:50:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 0cbf8c9
Message-ID: <20170404125004.GB23007@dastard>
References: <20170330173724.GE4864@birch.djwong.org>
 <20170331160438.GA3255@infradead.org>
 <20170331170601.GH4874@birch.djwong.org>
 <20170402000214.GY23007@dastard>
 <20170403183915.GP4864@birch.djwong.org>
 <fac5c7f1-ddea-54de-60de-0f3d4032b263@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fac5c7f1-ddea-54de-60de-0f3d4032b263@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 03, 2017 at 01:56:37PM -0500, Eric Sandeen wrote:
> On 4/3/17 1:39 PM, Darrick J. Wong wrote:
> > On Sun, Apr 02, 2017 at 10:02:14AM +1000, Dave Chinner wrote:
> > The initial complaint (I think) came from a RH bug about this situation,
> > so I'm assuming that the RHers have a better view on this than I do...
> > IOWs, since we're spreading out some of the responsibility for owning
> > pieces of code to take pressure off the maintainer, it would help me to
> > have code authors and reviewers discuss the timeline in which they think
> > a given patchset should be upstreamed.  This doesn't have to be
> > particularly precise or set in stone -- even a hint such as "fix this
> > now", "next merge window", "code looks ok but let's soak this for a few
> > months" would help immensely.
> 
> Yes, we had one report.  Then we saw a guy with a /huge/ swath of space
> missing on IRC, and it was the same problem.

I've seen this sort of thing on and off randomly ever since I
started working on XFS....

[...]

> >> A simple risk mitigation strategy in this case would be to say
> >> "let's just enable it for v5 filesystems right now" because there
> >> are much fewer of those out there, and they are much less likey to
> >> have years of stale orphaned inodes on them or to be on storage old
> >> enough to be bit-rotting. And even if it is bitrotted, we'll get
> >> decent error reporting if there is a problem cleaning them up,
> >> too.
> 
> Eh, we now have verifiers even w/o V5, right.

But not CRC checking, which is the bit-rot detector...

> >> This will tell us if there is a mechanism problem in adding the
> >> new behaviour, leaving the only unknown at that point the "untouched
> >> metadata" risk. There's a chance we'll never see this, so once we
> >> know the mechanism is fine on v5 filesystems (say 6 months after
> >> kernel release) we can enable it on v4 filesystems. Then if problems
> >> crop up, we have a fair idea of whether it is a mechanism or bitrot
> >> problem that is causing recovery failures....
> > 
> > Ok.  See, this was what I was looking for, in terms of 'what is someone
> > uncomfortable about and what would they like us to do about it'.  Eric?
> 
> Well, tbh this all seems a bit circular and hand-wavy.
> 
> We're doing half of recovery and not the other half in the case where
> we have an RO mount.  And Dave has voiced some rather vague worries
> about fixing it to do /all/ of recovery on an ro mount.
> 
> I've written a test explicitly to exercise this, so we do have a functional
> regression test.  But we can't merge it because we're afraid it might
> break something in the field, and we won't know if it will break anything
> in the field until we merge it.

Hence the application of /risk mitigation strategies/ to allow us to
make forwards progress.

> I mean, I guess we could enable for v5 and not v4, but I'm really not
> understanding why there's so much fear around this particular change.
> There seems to be an order of magnitude more worry than for most other
> changes, and I don't know why that is.

Every change to "XFS has always done this" behaviour we've made over
the past few years has caused some sort of unintended consequence.
e.g. look at all the little changes and bugs and issues we've had
(and are still outstanding) due to changing the metadata writeback
error handling....

> Dave, if you have any specific worries or things that you want a testcase
> for, I'm all ears.  If it's vague fears, I'm not sure how to remedy that.

I haven't looked at the test case - it's not going to alleviate the
"stuff has been missing and not accessed for years" problems that
potentially lurk out there. That's what I'm worried about, and
there's absolutely nothing we can really do from a testing
perspective to alleviate those risks.

Hence my comments about flushing out all the issues on newer
filesystems and getting them fixed before we start taunting the
ghosts in the machine...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

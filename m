Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1BCCD7F37
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 17:32:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D1B878F8064
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 15:32:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6idtdWCWGAWzxbAM for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 15:31:52 -0700 (PDT)
Date: Wed, 20 Mar 2013 09:31:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/25] xfstests: remove bench infrastructure
Message-ID: <20130319223149.GA17758@dastard>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-3-git-send-email-david@fromorbit.com>
	<20130315193635.GA2025@caliban.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130315193635.GA2025@caliban.engr.sgi.com>
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
To: Phil White <pwhite@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 15, 2013 at 12:36:38PM -0700, Phil White wrote:
> On Fri, Mar 15, 2013 at 11:27:46PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The benchmark framework inside xfstests is basically unused,
> > bitrotted and not very useful. If we need benchmarks, lets use a
> > real benchmark framework, not xfstests. Kill it to remove
> > dependencies on common and common.rc.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> I've been straightforward and clear in why I reposted the patch set and why
> I'm personally interested in the benchmark framework staying around.  I don't
> see value in explaining it again.

I understand why you see value in a benchmark infrastructure, but
that's not the issue here. The issue at hand is whether we should be
trying to maintain arbitrary abstractions that are made redundant by
the cleanup patch in the hope they are useful in the future.

There are solid technical reasons for what I've done, but you
haven't provided any to advocate why we should accept your version
as a better solution. "personal interest" is a good thing to have,
but it's not a convincing technical argument....

FWIW, there's an example of this remove/re-implement process I
advocate for cleanups in this patchset.  I removed the expunged file
support because it makes infrastructure modifications simpler. I
then re-introduce an enhanced version of the same functionality
later in the series after all the structural changes have been made.

The result is a cleaner, more functional implementation. That would
not have occurred had I simply tried to keep the existing support
and then hack new functionality into it.  Instead, the separation of
old code removal and re-implementation in the new infrastructure has
lead to a better implementation and cleaner code.

There are no obstacles to making new abstractions as needed by the
new bench infrastructure and it's trivial to do as required by new
code. The result will be cleaner, more maintainable code, and that's
the compelling reason for removing the old abstractions before
introducing new dependencies.

Hence what I'm asking you is this: why you can't follow this same
process for your new benchmarking infrastructure? i.e. What makes the
existing abstaction so compelling that we need to keep it?

> I don't see how it serves anyone.  I don't see how it serves the community
> to repost this rather than excluding this change, pushing this through, and
> improving xfstests.  The resultant exchange of mail does nothing but to
> litter everyone else's inbox.

Ignoring the abstraction differences, the version I posted has new
functionality, is current with all the tests in the repository
(except now for the 313->306 renaming) and has several bug fixes
compared to the version you rebased.

If you consider that litter, then, well, .... <sigh>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

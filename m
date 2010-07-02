Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o62E36oD245357 for <xfs@oss.sgi.com>; Fri, 2 Jul 2010 09:03:06 -0500
Subject: Re: [PATCH 00/15] xfs: minimize DMAPI footprint
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100630002043.GB24712@dastard>
References: <1277762653.2040.554.camel@doink>
	<20100629075734.GA31118@infradead.org> <20100630002043.GB24712@dastard>
Date: Fri, 02 Jul 2010 09:05:47 -0500
Message-ID: <1278079547.1876.82.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

(Responding to Dave, since it basically included all of
Christoph's response as well.)

Quick summary:  we'll go ahead with the suggestion to
maintain the DMAPI code (all of it) in a separate branch.

On Wed, 2010-06-30 at 10:20 +1000, Dave Chinner wrote:
> On Tue, Jun 29, 2010 at 03:57:34AM -0400, Christoph Hellwig wrote:
> > > SGI has a product that uses the DMAPI support code that's
> > > included in mainline XFS, along with some additional code
> > > (the "never merged" stuff Christoph refers to) that we
> > > maintain separately.  To our customers that need it, this
> > > is an extremely important feature.
> > 
> > So why don't you bother to get HSM support upstream properly,
> > or at least maintain it somewhere where you can get at it?
> > What sourcxe tree do those important customers use it?
> > 
> > > What follows is a set of patches that I think accomplishes
> > > these goals.  The net result of these changes is:
> > 
> > While this is a lot better than the old DMAPI supoort, it's still
> > lots of dead code in the mainline tree, that won't ever be used
> > there, as proper HSM suport if it ever was merged would sit at
> > the VFS layer.

I agree that HSM support would be better implemented at
the VFS layer, allowing other file systems to benefit.
I do not agree that after my patch series is applied
it's "lots" of dead code in the mainline tree.  I also
think this is a case where it's better to preserve
something that works and evolve it into something better
than to throw it all away and start over.

That being said, until now I personally have spent almost
no time on the DMAPI code itself, and I don't claim any
special knowledge about the best way to provide kernel
support for HSM's.  I also acknowledge that there's a
bunch of other required DMAPI code that's not in the
mainline tree (but there was no intent to conceal it).

> My question about the DMAPI hooks also still stands - if we leave
> the hooks in mainline, how are we supposed to test that they are
> still placed correctly for the out-of-tree patches to function
> correctly? I can't see that we can actually do this, so I question
> the value of even leaving minimal hooks in place....

Point taken.  I (or SGI I guess) would much rather have
all of the code in the mainline tree but it's not.  (I
don't know any details on the history of that, by the way.)
Maintaining the other parts separately was done of necessity.

> > In addition to that the people who effectively maintain XFS for both
> > the community and lots of paying customers have done a large amount
> > of work ontop of the DMAPI removal of the last 1 1/2 month.  So I'd
> > say rebase your changes over
> > 
> > 	http://git.kernel.org/?p=linux/kernel/git/dgc/xfsdev.git;a=shortlog;h=refs/heads/for-2.6.36
> > 
> > and keep them in a separate branch dmapi-dev branch where SGI can pull
> > the code for it's customers from. This branch could also include the
> > actual dmapi code and core kernel modifications, so that people that
> > want dmapi support actually have chance to find a complete kernel tree
> > for it.
> 
> This makes a lot of sense to me. I'd prefer an all-or-nothing
> approach to supporting DMAPI (and any other out-of-tree enabling
> functionality for that matter) and putting it all in separate
> branch would give us both all and nothing. ;)

I think this is a good solution, allowing all of the code to
be published and available--and complete--while not forcing
the mainline code to be polluted by the clutter of non-operative
code.

> It would also help us test the DMAPI infrastructure without needing
> a HSM as the xfsqa test suite does a pretty good job of testing it.
> And, of course, we could also help clean it up if it is testable. As
> such, I'd be quite happy to maintain a dmapi-dev branch in the above
> repo if the eventual goal is to try to move the code towards being
> more acceptible for mainline inclusion....

Here is what I plan to do:
- Accept Christoph's "drop dmapi hooks" patch into the
  XFS master branch.  Once that's in, there's a huge
  cascade of subsequent work that need to be pulled in
  and I'll get those out there also.
- Work on creating a complete and working dmapi branch.
  Once we've got a fairly well-integrated whole, I will
  publish that branch on the XFS git tree.  We will plan
  to maintain that in parallel with the XFS master branch,
  re-basing it on the master branch periodically.
- I'll make an announcement on the list about the 
  availability of the new branch.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

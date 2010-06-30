Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5U0I7d7099097 for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 19:18:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19AE6419445
	for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 17:20:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	AmxsZJbP8U1KLbyr for <xfs@oss.sgi.com>;
	Tue, 29 Jun 2010 17:20:49 -0700 (PDT)
Date: Wed, 30 Jun 2010 10:20:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/15] xfs: minimize DMAPI footprint
Message-ID: <20100630002043.GB24712@dastard>
References: <1277762653.2040.554.camel@doink>
	<20100629075734.GA31118@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100629075734.GA31118@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

On Tue, Jun 29, 2010 at 03:57:34AM -0400, Christoph Hellwig wrote:
> > SGI has a product that uses the DMAPI support code that's
> > included in mainline XFS, along with some additional code
> > (the "never merged" stuff Christoph refers to) that we
> > maintain separately.  To our customers that need it, this
> > is an extremely important feature.
> 
> So why don't you bother to get HSM support upstream properly,
> or at least maintain it somewhere where you can get at it?
> What sourcxe tree do those important customers use it?
> 
> > What follows is a set of patches that I think accomplishes
> > these goals.  The net result of these changes is:
> 
> While this is a lot better than the old DMAPI supoort, it's still
> lots of dead code in the mainline tree, that won't ever be used
> there, as proper HSM suport if it ever was merged would sit at
> the VFS layer.

My question about the DMAPI hooks also still stands - if we leave
the hooks in mainline, how are we supposed to test that they are
still placed correctly for the out-of-tree patches to function
correctly? I can't see that we can actually do this, so I question
the value of even leaving minimal hooks in place....

> In addition to that the people who effectively maintain XFS for both
> the community and lots of paying customers have done a large amount
> of work ontop of the DMAPI removal of the last 1 1/2 month.  So I'd
> say rebase your changes over
> 
> 	http://git.kernel.org/?p=linux/kernel/git/dgc/xfsdev.git;a=shortlog;h=refs/heads/for-2.6.36
> 
> and keep them in a separate branch dmapi-dev branch where SGI can pull
> the code for it's customers from. This branch could also include the
> actual dmapi code and core kernel modifications, so that people that
> want dmapi support actually have chance to find a complete kernel tree
> for it.

This makes a lot of sense to me. I'd prefer an all-or-nothing
approach to supporting DMAPI (and any other out-of-tree enabling
functionality for that matter) and putting it all in separate
branch would give us both all and nothing. ;)

It would also help us test the DMAPI infrastructure without needing
a HSM as the xfsqa test suite does a pretty good job of testing it.
And, of course, we could also help clean it up if it is testable. As
such, I'd be quite happy to maintain a dmapi-dev branch in the above
repo if the eventual goal is to try to move the code towards being
more acceptible for mainline inclusion....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

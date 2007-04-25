Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Apr 2007 16:11:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3PNBefB005748
	for <xfs@oss.sgi.com>; Wed, 25 Apr 2007 16:11:44 -0700
Date: Thu, 26 Apr 2007 09:11:31 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: allocate alloc args
Message-ID: <20070425231131.GM48531920@melbourne.sgi.com>
References: <20070419073216.GT48531920@melbourne.sgi.com> <20070423212201.GB13572@infradead.org> <20070423223257.GM32602149@melbourne.sgi.com> <462E3DEA.1070907@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462E3DEA.1070907@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 24, 2007 at 12:27:06PM -0500, Eric Sandeen wrote:
> David Chinner wrote:
> > On Mon, Apr 23, 2007 at 10:22:01PM +0100, Christoph Hellwig wrote:
> 
> >> I don't like doing even more dynamic allocations that deep
> >> down in the stack.
> > 
> > I'm not a big fan of it either, but I don't really see any other
> > option here. We need a bunch of temporary space for structures
> > *somewhere*, and if there isn't enough stack space then it's
> > got to come frm somewhere else.
> 
> How about a global array of such structures which can be accessed as
> needed.  :)
> 
> /me runs
> 
> I think Christoph is on the right track here; find ways to make the
> functions use less stack down the chain, either by breaking them up,
> breaking up the large structures into what's actually needed, or
> something along those types of refactoring lines...

If that is our only option, then I can't see us making any significant
impact on the stack usage without a substantial rewrite of the code.
Given how critical it is for this code to be correct, QA time for
any substantial code change here is going to be measured in months....

So this approach is not going to give us any relief in the short/medium
term and hence I have to question the value of doing such a rework
because in the medium/long term ia32 is no longer important.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

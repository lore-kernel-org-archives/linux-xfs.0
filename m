Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 16:54:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5PNsmtL015330
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 16:54:50 -0700
Date: Tue, 26 Jun 2007 09:54:36 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] simplify vnode tracing calls
Message-ID: <20070625235436.GD31489@sgi.com>
References: <467F5053.4040108@sandeen.net> <20070625062047.GB1307@infradead.org> <467FCA62.8080800@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467FCA62.8080800@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 25, 2007 at 09:00:02AM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Mon, Jun 25, 2007 at 12:19:15AM -0500, Eric Sandeen wrote:
> >> Don't think I've sent this one yet... :)
> > 
> > Any chance we can keep the name lower-cases despite the simplified
> > prototype?
> 
> Yeah, it is a bit of a mishmash this way isn't it.  SGI guys, do you
> have a preference?  Christoph, how would you do it, vn_trace_enter(vp)
> macro calling __vn_trace_enter() function?

Yeah, keep the lower case names if possible. I can't think of a simpler
way of doing it, and it's not terribly ugly. I'm open to better
solutions, though.....

> > Also it might make sense to merge the previous patch into
> > this one.
> 
> *shrug* either way.

Keep 'em separate - that way I don't have to go and review this
first one again ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

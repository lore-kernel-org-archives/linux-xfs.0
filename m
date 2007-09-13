Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 17:10:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8D0Ac4p014896
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 17:10:40 -0700
Date: Thu, 13 Sep 2007 10:10:25 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: state of the cvs tree
Message-ID: <20070913001025.GR995458@sgi.com>
References: <20070912121938.GA16870@lst.de> <46E870AB.30906@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E870AB.30906@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Sep 13, 2007 at 09:05:15AM +1000, Mark Goodwin wrote:
> 
> 
> Christoph Hellwig wrote:
> >looks like the cvs tree is broken currently - fs/xfs/ is merged up to
> >2.6.23-rc, but everything else is still at 2.6.22-rc state leading to
> >various compile failures.
> 
> I think Tim is in the middle of the .23 update and still has some more
> to push in. Tim?
> 
> What else do you (or anyone for that matter) have in the pipeline for XFS?
> Whilst we're taking huge patches and cleanups, let's get them all in asap.

Let's plan this a little better than "ASAP". We've already got a
full queue for .24 - I'm uncomfortable with pushing anything more
given the nature of the changes we've made in this cycle and we
really want some testing time on that code before the .24 merge
window opens. Given that we are at .23-rc6 already, it won't be long
before .24-rc1 merge window is open, so lets stop pushing large
changes into the tree until after the .24-rc1 merge is done.

IOWs, I consider stuff like Eric's spin lock clean to be .25 material
at this point, not .24, and we should only be taking bug fixes and small,
contained features (e.g. fallocate support) for .24. Everything else
can wait until .25....

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 21:19:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l784JSbm022425
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 21:19:31 -0700
Date: Wed, 8 Aug 2007 14:19:20 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: qa 166 failure on f8 kernel
Message-ID: <20070808041920.GK52011508@sgi.com>
References: <46B91EBA.10407@sandeen.net> <20070808025615.GH52011508@sgi.com> <46B9316A.40508@sandeen.net> <20070808040804.GJ52011508@sgi.com> <46B94259.6060309@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B94259.6060309@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Aug 07, 2007 at 11:11:05PM -0500, Eric Sandeen wrote:
> David Chinner wrote:
> 
> > On Tue, Aug 07, 2007 at 09:58:50PM -0500, Eric Sandeen wrote:
> >   
> >> yeah, figured it had something to do w/ the ia64 weenies when I saw the
> >> 32 vs. 8, factor of 4 ... fine, fine, my bad.  :)
> >>     
> >
> > No, not your bad. Mine if anyones because I wrote the test.
> >
> > Cheers,
> >
> > Dave.
> >   
> Well, I was going to look at it more closely before I sent it off :)
> 
> What do you think of a patch like this, to munmap 16k chunks regardless
> of page size:

That could be done, but will break on 64k page size machines ;)

Perhaps the filter needs to use `getconf PAGE_SIZE` to filter the
output down:

ia64:

% getconf PAGE_SIZE
16384

x86_64:

% getconf PAGE_SIZE
4096

So the written extent sizes are output as a multiple of
page size rather than basic blocks....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

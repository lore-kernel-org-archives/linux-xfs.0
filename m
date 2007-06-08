Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 07:45:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l58EjEWt017931
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 07:45:15 -0700
Date: Sat, 9 Jun 2007 00:44:55 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS shrink functionality
Message-ID: <20070608144455.GE86004887@sgi.com>
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com> <20070604084154.GA8273@teal.hq.k1024.org> <1181291033.7510.40.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181291033.7510.40.camel@localhost>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <nahoo82@gmail.com>
Cc: Iustin Pop <iusty@k1024.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, cw@f00f.org

On Fri, Jun 08, 2007 at 10:23:53AM +0200, Ruben Porras wrote:
> Am Montag, den 04.06.2007, 10:41 +0200 schrieb Iustin Pop:
> > Good to know. If there is at least more documentation about the
> > internals, I could try to find some time to work on this again.
> 
> there is now a document explaining the XFS on disk format [0] and some
> presentations for training courses, I think none of this were available
> at the time you made the first try. Although they are not enough for our
> purpose. 

There's thousands of lines of code documenting that format as well ;)

> > My suggestion would be to start implementing these steps in reverse. 4)
> > is the most important as it touches the entire FS. If 4) is working
> > correctly, then 1) would be simpler (I think)
> 
> Why do you think that 1) would be simpler after 4)? For what I
> understand, they are independent.
> 
> 3) worries me, if walking the entire filesystem is needed, it want
> scale...

I think walking the filesystem can be avoided effectively by
introducing an reverse map that points to the owner of the block.
(i.e. another btree). Reverse mapping provides other benefits as
well e.g. somewhere to put block checksums and more information
for repair and scrubbing.

The hard part is the moving of metadata.  I haven't really though
deeply on the best method for this; there's lots of options and I
don't know what is the best way to proceed there yet. That's not
something I need to think about right now, though ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

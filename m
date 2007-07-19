Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 06:14:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6JDEObm022896
	for <linux-xfs@oss.sgi.com>; Thu, 19 Jul 2007 06:14:27 -0700
Date: Thu, 19 Jul 2007 23:14:01 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: tuning XFS for tiny files
Message-ID: <20070719131401.GW31489@sgi.com>
References: <m23azlbpl1.fsf@tstotts.net> <p73wswwwm1o.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73wswwwm1o.fsf@bingen.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: timotheus <timotheus@tstotts.net>, linux-xfs@oss.sgi.com

On Thu, Jul 19, 2007 at 03:38:43PM +0200, Andi Kleen wrote:
> timotheus <timotheus@tstotts.net> writes:
> 
> > Hi. Is there a way to tune XFS filesystem parameters to better address
> > the usage pattern of 10000s of tiny files in directories such as:
> >     maildir directory
> >     mh mail directory
> >     ccache directory
> > 
> > My understanding is that XFS will always be much slower than reiserfs
> > with respect to deleting 10000s files; but that XFS might be possible to
> > tune toward more rapid read access of 10000s of tiny files.
> 
> -d agcount=1 at mkfs time might help (unless you have a lot of CPUs) 

Yeah, might help, but it's not good for being able to repair the
filesystem - repair will be unable to find a secondary superblock
to compare the primary against and abort.....

-d agcount is only good for science experiments, not production
systems ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

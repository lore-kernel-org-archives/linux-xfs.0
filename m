Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 07:18:32 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6JEINbm022840
	for <linux-xfs@oss.sgi.com>; Thu, 19 Jul 2007 07:18:26 -0700
Date: Thu, 19 Jul 2007 15:54:59 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: tuning XFS for tiny files
Message-ID: <20070719135459.GA16552@one.firstfloor.org>
References: <m23azlbpl1.fsf@tstotts.net> <p73wswwwm1o.fsf@bingen.suse.de> <20070719131401.GW31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719131401.GW31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, timotheus <timotheus@tstotts.net>, linux-xfs@oss.sgi.com

On Thu, Jul 19, 2007 at 11:14:01PM +1000, David Chinner wrote:
> On Thu, Jul 19, 2007 at 03:38:43PM +0200, Andi Kleen wrote:
> > timotheus <timotheus@tstotts.net> writes:
> > 
> > > Hi. Is there a way to tune XFS filesystem parameters to better address
> > > the usage pattern of 10000s of tiny files in directories such as:
> > >     maildir directory
> > >     mh mail directory
> > >     ccache directory
> > > 
> > > My understanding is that XFS will always be much slower than reiserfs
> > > with respect to deleting 10000s files; but that XFS might be possible to
> > > tune toward more rapid read access of 10000s of tiny files.
> > 
> > -d agcount=1 at mkfs time might help (unless you have a lot of CPUs) 
> 
> Yeah, might help, but it's not good for being able to repair the
> filesystem - repair will be unable to find a secondary superblock
> to compare the primary against and abort.....

Any reason why it aborts? It could just continue with a warning, couldn't it?

> -d agcount is only good for science experiments, not production
> systems ;)

XFS small file performance needs a lot of science.

-Andi

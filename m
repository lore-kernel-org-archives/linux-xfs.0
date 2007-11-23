Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Nov 2007 20:03:52 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAN43hI4024729
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2007 20:03:46 -0800
Date: Fri, 23 Nov 2007 15:03:29 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071123040329.GB114266761@sgi.com>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <1195702123.8369.78.camel@localhost.localdomain> <20071122120611.GA3573@one.firstfloor.org> <20071122131539.GX114266761@sgi.com> <20071123025317.GA12257@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071123025317.GA12257@one.firstfloor.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, Stewart Smith <stewart@mysql.com>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Fri, Nov 23, 2007 at 03:53:17AM +0100, Andi Kleen wrote:
> On Fri, Nov 23, 2007 at 12:15:39AM +1100, David Chinner wrote:
> > On Thu, Nov 22, 2007 at 01:06:11PM +0100, Andi Kleen wrote:
> > > > FWIW from a "real time" database POV this seems to make sense to me...
> > > > in fact, we probably rely on filesystem metadata way too much
> > > > (historically it's just "worked".... although we do seem to get issues
> > > > on ext3).
> > > 
> > > For that case you really would need priority inheritance: any metadata
> > > IO on behalf or blocking a process needs to use the process' block IO 
> > > priority.
> > 
> > How do you do that when the processes are blocking on semaphores,
> > mutexes or rw-semaphores in the fileysystem three layers removed from
> > the I/O in progress?
> 
> [...] I didn't say it was easy (or rather explicitely said it would be tricky).
> Probably it would be possible to fold it somehow into rt mutexes PI,
> but it's not easy and semaphores would need to be handled too.
> 
> Just my point was to solve the metadata RT problem unconditionally increasing
> the priority is a bad idea and not really a replacement to a "full"
> solution. Short term a user can just increase the priority of all the XFS 
> threads anyways.

The point is that it's not actually a thread-based problem - the priority
can't be inherited via the traditional mutex-like manner. There is no
connection between a thread and an I/o it has already issued and so you
can't transfer a priority from a blocked thread to an issued-but-blocked
i/o....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

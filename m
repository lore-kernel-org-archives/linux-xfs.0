Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 May 2007 01:37:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4P8b1Wt005561
	for <xfs@oss.sgi.com>; Fri, 25 May 2007 01:37:02 -0700
Date: Fri, 25 May 2007 18:36:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
Message-ID: <20070525083650.GO85884050@sgi.com>
References: <200705241318.30711.dap@mail.index.hu> <Pine.LNX.4.64.0705240720040.16751@p34.internal.lan> <20070525000547.GH85884050@sgi.com> <1180056948.6183.10.camel@daptopfc.localdomain> <20070525045500.GF86004887@sgi.com> <1180071831.21028.125.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180071831.21028.125.camel@w100>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alberto Alonso <alberto@ggsys.net>
Cc: David Chinner <dgc@sgi.com>, Pallai Roland <dap@mail.index.hu>, Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Fri, May 25, 2007 at 12:43:51AM -0500, Alberto Alonso wrote:
> > >  The difference between ext3 and XFS is that ext3 will remount to
> > > read-only on the first write error but the XFS won't, XFS only fails
> > > only the current operation, IMHO. The method of ext3 isn't perfect, but
> > > in practice, it's working well.
> > 
> > XFS will shutdown the filesystem if metadata corruption will occur
> > due to a failed write. We don't immediately fail the filesystem on
> > data write errors because on large systems you can get *transient*
> > I/O errors (e.g. FC path failover) and so retrying failed data
> > writes is useful for preventing unnecessary shutdowns of the
> > filesystem.
> > 
> > Different design criteria, different solutions...
> 
> I think his point was that going into a read only mode causes a
> less catastrophic situation (ie. a web server can still serve
> pages).

Sure - but once you've detected one corruption or had metadata
I/O errors, can you trust the rest of the filesystem?

> I think that is a valid point, rather than shutting down
> the file system completely, an automatic switch to where the least
> disruption of service can occur is always desired.

I consider the possibility of serving out bad data (i.e after
a remount to readonly) to be the worst possible disruption of
service that can happen ;)

> Maybe the automatic failure mode could be something that is 
> configurable via the mount options.

If only it were that simple. Have you looked to see how many
hooks there are in XFS to shutdown without causing further
damage?

% grep FORCED_SHUTDOWN fs/xfs/*.[ch] fs/xfs/*/*.[ch] | wc -l
116

Changing the way we handle shutdowns would take a lot of time,
effort and testing. When can I expect a patch? ;)

> I personally have found the XFS file system to be great for
> my needs (except issues with NFS interaction, where the bug report
> never got answered), but that doesn't mean it can not be improved.

Got a pointer?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

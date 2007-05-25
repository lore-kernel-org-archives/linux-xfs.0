Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 May 2007 21:55:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4P4t9Wt012036
	for <xfs@oss.sgi.com>; Thu, 24 May 2007 21:55:11 -0700
Date: Fri, 25 May 2007 14:55:00 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
Message-ID: <20070525045500.GF86004887@sgi.com>
References: <200705241318.30711.dap@mail.index.hu> <Pine.LNX.4.64.0705240720040.16751@p34.internal.lan> <20070525000547.GH85884050@sgi.com> <1180056948.6183.10.camel@daptopfc.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180056948.6183.10.camel@daptopfc.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pallai Roland <dap@mail.index.hu>
Cc: David Chinner <dgc@sgi.com>, Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Fri, May 25, 2007 at 03:35:48AM +0200, Pallai Roland wrote:
> On Fri, 2007-05-25 at 10:05 +1000, David Chinner wrote:
> > > >It's a good question too, but I think the md layer could
> > > >save dumb filesystems like XFS if denies writes after 2 disks are failed, 
> > > >and
> > > >I cannot see a good reason why it's not behave this way.
> > 
> > How is *any* filesystem supposed to know that the underlying block
> > device has gone bad if it is not returning errors?
>  It is returning errors, I think so. If I try to write raid5 with 2
> failed disks with dd, I've got errors on the missing chunks.

Oh, did you look at your logs and find that XFS had spammed them
about writes that were failing?

>  The difference between ext3 and XFS is that ext3 will remount to
> read-only on the first write error but the XFS won't, XFS only fails
> only the current operation, IMHO. The method of ext3 isn't perfect, but
> in practice, it's working well.

XFS will shutdown the filesystem if metadata corruption will occur
due to a failed write. We don't immediately fail the filesystem on
data write errors because on large systems you can get *transient*
I/O errors (e.g. FC path failover) and so retrying failed data
writes is useful for preventing unnecessary shutdowns of the
filesystem.

Different design criteria, different solutions...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

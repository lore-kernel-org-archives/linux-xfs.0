Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 07:54:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7LEsLHa018339
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 07:54:21 -0700
Received: from rgminet01.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E7FE3BBB8C
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 07:55:39 -0700 (PDT)
Received: from rgminet01.oracle.com (rgminet01.oracle.com [148.87.113.118]) by cuda.sgi.com with ESMTP id WyBCY3dWbWOSR3nj for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 07:55:39 -0700 (PDT)
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
From: Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20080821085332.GG5706@disturbed>
References: <20080821051508.GB5706@disturbed>
	 <684252.68814.qm@web34508.mail.mud.yahoo.com>
	 <20080821061443.GD5706@disturbed>
	 <200808211700.39584.nickpiggin@yahoo.com.au>
	 <20080821085332.GG5706@disturbed>
Content-Type: text/plain; charset=utf-8
Date: Thu, 21 Aug 2008 10:52:44 -0400
Message-Id: <1219330364.7854.68.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, 2008-08-21 at 18:53 +1000, Dave Chinner wrote:
> On Thu, Aug 21, 2008 at 05:00:39PM +1000, Nick Piggin wrote:
> > On Thursday 21 August 2008 16:14, Dave Chinner wrote:
> > 
> > > I think that we need to issue explicit unplugs to get the log I/O
> > > dispatched the way we want on all elevators and stop trying to
> > > give elevators implicit hints by abusing the bio types and hoping
> > > they do the right thing....
> > 
> > FWIW, my explicit plugging idea is still hanging around in one of
> > Jens' block trees (actually he refreshed it a couple of months ago).
> > 
> > It provides an API for VM or filesystems to plug and unplug
> > requests coming out of the current process, and it can reduce the
> > need to idle the queue. Needs more performance analysis and tuning
> > though.
> 
> We've already got plenty of explicit unplugs in XFS to get stuff
> moving quickly - I'll just have to add another....
> 

I did some compilebench runs with xfs this morning, creating 30 kernel
trees on the same machine I posted btrfs and xfs numbers with last week.
Btrfs gets between 60 and 75MB/s average depending on the mount options
used, ext4 gets around 60MB/s

This is a single sata drive that can run at 100MB/s streaming writes.
The numbers show XFS is largely log bound, and that turning off barriers
makes a huge difference.  I'd be happy to try another run with explicit
unplugging somewhere in the transaction commit path.

I think the most relevant number is the count of MB written at the end
of blkparse. I'm not sure why the 4ag XFS writes less, but the numbers
do include calling sync at the end.  None of the filesystems were doing
barriers in these numbers:

Ext4                                9036MiB
Btrfs metadata dup                  9190MiB
Btrfs metadata dup no inline files 10280MiB
XFS 4ag, nobarrier                 14299MiB
XFS 1ag, nobarrier                 17836MiB

This is a long way of saying the xfs log isn't optimal for these kinds
of operations, which isn't really news.  I'm not ripping on xfs here,
this is just one tiny benchmark.

I uploaded some graphs of the IO here:

http://oss.oracle.com/~mason/seekwatcher/compilebench-30/xfs


XFS:

*** 4ag, 128m log, logbsize=256k
intial create total runs 30 avg 7.48 MB/s (user 0.52s sys 1.04s)

*** 4ag, 128m log, logbsize=256k, nobarrier
intial create total runs 30 avg 21.58 MB/s (user 0.51s sys 1.04s)
﻿http://oss.oracle.com/~mason/seekwatcher/compilebench-30/xfs/xfs-4ag-nobarrier.png

*** 1ag, 128m log, logbsize=256k, nobarrier
intial create total runs 30 avg 26.28 MB/s (user 0.50s sys 1.15s)
http://oss.oracle.com/~mason/seekwatcher/compilebench-30/xfs/xfs-nobarrier-1ag.png

It is hard to see in the graph, but it looks like the log is in the
first 128MB of the drive.  If we give XFS an external log device:

*** 1ag 128m external log, logbsize=256k, nobarrier
intial create total runs 30 avg 38.44 MB/s (user 0.51s sys 1.09s)

This graph shows that log is running more or less seek free between
30-60MB/s for the whole run.  I'd expect the explicit unplugging to help
the most in this config?

http://oss.oracle.com/~mason/seekwatcher/compilebench-30/xfs/xfs-external-log-disk.png

Here is the main disk during the run:
http://oss.oracle.com/~mason/seekwatcher/compilebench-30/xfs/xfs-external-log-main-disk.png


*** 1ag 128m external log, logbsize=256k, nobarrier, deadline
intial create total runs 30 avg 34.00 MB/s (user 0.51s sys 1.07s)

Deadline didn't help on this box.

-chris

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Aug 2007 05:17:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l71CHLbm024611
	for <linux-xfs@oss.sgi.com>; Wed, 1 Aug 2007 05:17:23 -0700
Date: Wed, 1 Aug 2007 22:17:13 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Proper method of snapshotting XFS with external log using LVM2
Message-ID: <20070801121713.GY31489@sgi.com>
References: <1185737538.12064.44.camel@server.ak.quickcircuit.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185737538.12064.44.camel@server.ak.quickcircuit.co.nz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mario Becroft <mb@gem.win.co.nz>
Cc: linux-xfs@oss.sgi.com

On Mon, Jul 30, 2007 at 07:32:18AM +1200, Mario Becroft wrote:
> I am using XFS and LVM2 under Linux. My XFS filesystems have an external
> log.
> 
> What is the correct method of creating an LVM2 snapshot of volumes
> containing an XFS filesystem with external log?

Not sure. I've never tried it.

> Do I need to snapshot the main filesystem volume and the log volume?

Yes.

> Should I be using xfs_freeze to ensure that the filesystem is not
> modified between when I create the filesystem snapshot and the log
> snapshot?

Yes.

> Or is there a special procedure for atomically creating both snapshots?
>
> Or should I not be using an external log? If not, won't this decrease
> performance?

If it doesn't work, then don't use an external log and yes, it will
decrease performance.

> In the past I have successfully used xfs_freeze and created separate
> snapshots of the filesystem and log volumes. However, I am not sure
> whether this is the recommended approach.

As long as both snapshots were taken with the one xfs_freeze command,
then it shouldbe ok.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

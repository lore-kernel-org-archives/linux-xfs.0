Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 16:28:29 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0O0SL7l016072
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 16:28:23 -0800
Date: Thu, 24 Jan 2008 11:28:28 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_rapair memory requirement per TB
Message-ID: <20080124002828.GC155259@sgi.com>
References: <1201042882.32649.256.camel@holwrs01.bp.com> <op.t5c3kfub3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080123085339.GB12435@p15145560.pureserver.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123085339.GB12435@p15145560.pureserver.info>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

On Wed, Jan 23, 2008 at 09:53:39AM +0100, Ralf Gross wrote:
> Barry Naujok schrieb:
> > >
> > >Reading the "Repairing a possibly incomplete xfs_growfs command?" thread
> > >this month makes me wonder if there is some type of rough formula or
> > >guesstimation cheat sheet to figure out how much memory and swap one
> > >would need for an xfs_repair given a file system with many terabytes.
> > >
> > >
> > >Say I have an 8TB LUN that needs an xfs_repair.  What would be the rough
> > >memory requirements and swap space?
> > >
> > 
> > General rule of thumb at the moment is 128MB of RAM/TB of filesystem
> > plus 4MB/million inodes on that filesystem.
> 
> Did this change lately? I found the rule of thumb: 2 GB RAM for 1 TB
> of disk storage + some RAM per x inodes.

The above is based on actual theoretical usage, the below:

> http://oss.sgi.com/archives/xfs/2005-08/msg00045.html

was based on reported usage on during live repair runs.

I think Barry discovered the difference to be things external
to repair such as heap fragmentation and has since corrected
the worst of the issues so requirements are, in general,
much closer to the theoretical numbers now.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

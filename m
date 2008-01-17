Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 15:46:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0HNjr8V002327
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 15:45:55 -0800
Date: Fri, 18 Jan 2008 10:46:04 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
Message-ID: <20080117234604.GG155407@sgi.com>
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253594C@pvn-3001.purevideo.local> <20080117030111.GH155259@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F02535951@pvn-3001.purevideo.local> <20080117231517.GF155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 17, 2008 at 03:29:17PM -0800, Mark Magpayo wrote:
> This is quite a relief to know that this is a fairly straightforward
> fix!  What luck that you had encountered it recently, I really
> appreciate the help.  Here's my uname output:
> 
> Linux purenas 2.6.16.55-c1 #1 SMP Fri Oct 19 16:45:15 EDT 2007 x86_64
> GNU/Linux
> 
> Maybe you guys fixed the bug already?

/me breathes a sigh of relief

I think we have:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=20f4ebf2bf2f57c1a9abb3655391336cc90314b3

[XFS] Make growfs work for amounts greater than 2TB
 
> iirc, I may have run xfs_growfs with an older version of xfsprogs, then
> was advised to update to the newest and try it again.  I may have run it
> on a version that still contained the bug?

Kernel bug, not userspace bug, AFAICT.

> So is this all I need then prior to an xfs_repair?:
> 
> > # for i in `seq 0 1 63`; do
> > > xfs_db -x -c "sb $i" -c 'write agcount 64' -c 'write dblock 4761733120'
> > /dev/vg0/lv0

Yes, I think that is all that is necessary (that+repair was what fixed
the problem at the customer site successfully).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

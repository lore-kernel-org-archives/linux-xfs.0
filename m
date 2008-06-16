Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jun 2008 08:49:28 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5GFnKGD014531
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 08:49:21 -0700
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
From: Miquel van Smoorenburg <mikevs@xs4all.net>
In-Reply-To: <1213356518.8530.5.camel@n2o.xs4all.nl>
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de>
	 <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com>
	 <1213309629.29745.8.camel@localhost.localdomain>
	 <20080613030841.GC3700@disturbed>  <1213356518.8530.5.camel@n2o.xs4all.nl>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 17:50:06 +0200
Message-Id: <1213631406.19372.15.camel@n2o.xs4all.nl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, lists@ku-gbr.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, mikevs@xs4all.net

On Fri, 2008-06-13 at 13:28 +0200, Miquel van Smoorenburg wrote:
> On Fri, 2008-06-13 at 13:08 +1000, Dave Chinner wrote: 
> > On Fri, Jun 13, 2008 at 12:27:09AM +0200, Miquel van Smoorenburg wrote:
>
> > > Linux transit5.news.xs4all.nl 2.6.25.6 #1 SMP Wed Jun 11 10:59:10 CEST
> > > 2008 x86_64 GNU/Linux
> > > 
> > > Filesystem "sda4": XFS internal error xfs_trans_cancel at line 1163 of
> > > file fs/xfs/xfs_trans.c.  Caller 0xffffffff880f1315
> > > Pid: 3402, comm: diablo Not tainted 2.6.25.6 #1
> > 
> > This commit in 2.6.26 will probably fix it.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75de2a91c98a6f486f261c1367fe59f5583e15a3
> 
> "At ENOSPC, we can get a filesystem shutdown due to a cancelling a dirty
> transaction in xfs_mkdir or xfs_create."
> 
> But The filesystem is only used for 35%. It might have hit 100% somewhere in
> the recent past though (a few reboots ago).
> I've applied the patch to 2.6.25.6 just in case, I'll let it run over
> the weekend to see what happens.

Well, the box has been up for 3 days now. When this problem first
appeared it only stayed up for a day max, so I'm reasonably positive
it's fixed.

The patch applies cleanly to 2.6.25.6 - perhaps it should go into
-stable.

Thanks,

Mike.

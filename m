Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 09:38:56 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6KGcbDW026142
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 09:38:39 -0700
Subject: Re: stable xfs
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
In-Reply-To: <20060720161707.GB26748@tuatara.stupidest.org>
References: <1153150223.4532.24.camel@localhost.localdomain>
	 <17595.47312.720883.451573@base.ty.sabi.co.UK>
	 <1153262166.2669.267.camel@localhost.localdomain>
	 <17597.27469.834961.186850@base.ty.sabi.co.UK>
	 <1153272044.2669.282.camel@localhost.localdomain>
	 <17598.2129.999932.67127@base.ty.sabi.co.UK>
	 <1153314670.2691.14.camel@localhost.localdomain>
	 <20060720061527.GB18135@tuatara.stupidest.org>
	 <1153404502.2768.50.camel@localhost.localdomain>
	 <20060720161707.GB26748@tuatara.stupidest.org>
Content-Type: text/plain
Date: Thu, 20 Jul 2006 12:38:01 -0400
Message-Id: <1153413481.2768.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, Linux XFS <linux-xfs@oss.sgi.com>

On Thu, 2006-07-20 at 09:17 -0700, Chris Wedgwood wrote:
> On Thu, Jul 20, 2006 at 10:08:22AM -0400, Ming Zhang wrote:
> 
> > we mainly handle large media files like 20-50GB. so file number is
> > not too much. but file size is large.
> 
> xfs_repair usually deals with that fairly well in reality (much better
> than lots of small files anyhow)

sounds cool. yes, large # of small files are always painful.


> 
> > hope i never need to run repair, but i do need to defrag from time
> > to time.
> 
> if you preallocate you can avoid that (this is what i do, i
> preallocate in the replication daemon)

i could not control my application. so i still need to do defrag some
time.

> 
> > hope this does not hold true for a 15x750GB SATA raid5. ;)
> 
> that's ~10TB or so, my guess is that a repair there would take some
> GBs of ram
> 
> it would be interesting to test it if you had the time

yes. i should find out. hope to force a repair? unplug my power cord? ;)


> 
> there is a 'formular' for working out how much ram is needed roughly
> (steve lord posted it a long time ago, hopefully someone can find that
> and repost is)
> 
> > say XFS can make use of parallel storage by using multiple
> > allocation groups. but XFS need to be built over one block
> > device. so if i have 4 smaller raid, i have to use LVM to glue them
> > before i create XFS over it right? but then u said XFS over LVM or N
> > MD is not good?
> 
> with recent kernels it shouldn't be a problem, the recursive nature of
> the block layer changed so you no longer blow up as badly as people
> did in the past (also, XFS tends to use less stack these days)

sounds cool.

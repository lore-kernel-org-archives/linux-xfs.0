Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 07:09:18 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6KE8xDW005151
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 07:08:59 -0700
Subject: Re: stable xfs
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
In-Reply-To: <20060720061527.GB18135@tuatara.stupidest.org>
References: <1153150223.4532.24.camel@localhost.localdomain>
	 <17595.47312.720883.451573@base.ty.sabi.co.UK>
	 <1153262166.2669.267.camel@localhost.localdomain>
	 <17597.27469.834961.186850@base.ty.sabi.co.UK>
	 <1153272044.2669.282.camel@localhost.localdomain>
	 <17598.2129.999932.67127@base.ty.sabi.co.UK>
	 <1153314670.2691.14.camel@localhost.localdomain>
	 <20060720061527.GB18135@tuatara.stupidest.org>
Content-Type: text/plain
Date: Thu, 20 Jul 2006 10:08:22 -0400
Message-Id: <1153404502.2768.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, Linux XFS <linux-xfs@oss.sgi.com>

On Wed, 2006-07-19 at 23:15 -0700, Chris Wedgwood wrote:
> On Wed, Jul 19, 2006 at 09:11:10AM -0400, Ming Zhang wrote:
> 
> > what kind of "ram vs fs" size ratio here will be a safe/good/proper
> > one?
> 
> it depends very much on what you are doing

we mainly handle large media files like 20-50GB. so file number is not
too much. but file size is large.

hope i never need to run repair, but i do need to defrag from time to
time.


> 
> > any rule of thumb? thanks!
> >
> > hope not 1:1. :)
> 
> i recent dealt with a corrupted filesystem that xfs_repair needed over
> 1GB to deal with --- the kicker is the filesystem was only 20GB, so
> that's 20:1 for xfs_repair

hope this does not hold true for a 15x750GB SATA raid5. ;)

> 
> i suspect that was anomalous though and that some bug or quirk of
> their fs cause xfs_repair to behave badly (that said, i'd had to have
> to repair an 8TB fs fill of maildir email boxes, which i know some
> people have)

ps, also another question brought up while reading this thread.

say XFS can make use of parallel storage by using multiple allocation
groups. but XFS need to be built over one block device. so if i have 4
smaller raid, i have to use LVM to glue them before i create XFS over it
right? but then u said XFS over LVM or N MD is not good?


Ming

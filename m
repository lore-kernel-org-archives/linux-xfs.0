Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 00:01:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q71IxF025555
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:01:19 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 663D5282F9A
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:02:18 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id A5rqGyUMHKVfsVuh for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 00:02:18 -0700 (PDT)
Date: Thu, 26 Jun 2008 17:02:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs Access to block zero  exception and system crash
Message-ID: <20080626070215.GI11558@disturbed>
References: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080625084931.GI16257@build-svl-1.agami.com> <340C71CD25A7EB49BFA81AE8C839266701323BE8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <340C71CD25A7EB49BFA81AE8C839266701323BE8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <Sagar_Borikar@pmc-sierra.com>
Cc: xfs@oss.sgi.com

[please wrap your replies at 72 columns]

On Wed, Jun 25, 2008 at 11:46:59PM -0700, Sagar Borikar wrote:
> >> with 2.6.18 kernel,128 MB of RAM, MIPS architecture and XFS version 
> >> 2.8.11.
> 
> > [...]
> 
> >> Can anyone let me know what could be the probable cause of this issue.
> 
> > they are all from  corrupted extent btrees.  There are many
> > possible causes of this that we've fixed over the past years
> > since 2.6.18 was released. Indeed, we are currently discussing
> > fixes for a bunch of problems that lead to corrupted extent
> > btrees and problems like this. I'd suggest that you should
> > probably start with a more recent kernel, make sure you have a
> > serial console and set the xfs_error_level to 11 so that it
> > gives as much information as possible on the console when the
> > error it > hit.  if that doesn't give a stack trace, then  you
> > need to set the xfs_panic_mask to crash the machine on block
> > zero accesses and report the stack ﬆraces that it outputs...
>  
> Yes, I went through the changes between 2.6.24 and 2.6.18 and they
> are quite a few. But as this is production system and on field,
> its not viable to upgrade the kernel.

Well, you're pretty much on your own then :/

> I do understand that there
> could be many places which can cause the corruption.
> Unfortunately, three different systems have given three different
> places of corruption as stated.

Yes, but all the same pattern of corruption, so it is likely
that it is one problem.

> Now I am sleeping in the access to
> block zero exception and rescheduling so that it won't stall the
> system and I can monitor the state of the filesystem. As the
> frequency of landing the error is once in 2.5 days under extreme
> stress,  if you could point me to the probable place to look at, I
> can narrow down the debugging path.

Like I said - it's a corrupt bmap btree. It could be a bug in the
bmap btree code, the alloc btree code, the inode data fork
manipulation code, it could be a block device bug returning bad data
to XFS on on a cancelled btree readahead, etc. IOWs, there are so many
possible causes of a corrupted btree that a bug report by itself is
mostly useless.

All I can suggest is working out a reproducable test case in your
development environment, attaching a debugger and start digging around
in memory when the problem is hit and try to find out exactly what
is corrupted. If you can't reproduce it or work out what is
occurring to trigger the problem, then we're not going to be able to
find the cause...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

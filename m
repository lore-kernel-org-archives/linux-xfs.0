Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 03:30:16 -0700 (PDT)
Received: from pqueuea.post.tele.dk (pqueuea.post.tele.dk [193.162.153.9])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6KATXDW004620
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 03:29:34 -0700
Received: from pfepb.post.tele.dk (pfepb.post.tele.dk [195.41.46.236])
	by pqueuea.post.tele.dk (Postfix) with ESMTP id DEE17375DDA
	for <xfs@oss.sgi.com>; Thu, 20 Jul 2006 12:29:08 +0200 (CEST)
Subject: Re: XFS breakage in 2.6.18-rc1
From: Kasper Sandberg <lkml@metanurb.dk>
In-Reply-To: <20060720085636.D1947140@wobbly.melbourne.sgi.com>
References: <20060718222941.GA3801@stargate.galaxy>
	 <20060719085731.C1935136@wobbly.melbourne.sgi.com>
	 <200607190908.30727.s0348365@sms.ed.ac.uk>
	 <20060720085636.D1947140@wobbly.melbourne.sgi.com>
Content-Type: text/plain
Date: Thu, 20 Jul 2006 12:29:02 +0200
Message-Id: <1153391342.31822.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Alistair John Strachan <s0348365@sms.ed.ac.uk>, Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, 2006-07-20 at 08:56 +1000, Nathan Scott wrote:
> On Wed, Jul 19, 2006 at 09:08:30AM +0100, Alistair John Strachan wrote:
> > On Tuesday 18 July 2006 23:57, Nathan Scott wrote:
> > [snip]
> > > > of programs fail in mysterious ways. I tried to recover using xfs_repair
> > > > but I feel that my partition is thorougly borked. Of course no data was
> > > > lost due to backups but still I'd like this bug to be fixed ;-)
> > >
> > > 2.6.18-rc1 should be fine (contains the corruption fix).  Did you
> > > mkfs and restore?  Or at least get a full repair run?  If you did,
> > > and you still see issues in .18-rc1, please let me know asap.
> > 
> > Just out of interest, I've got a few XFS volumes that were created 24 months 
> > ago on a machine that I upgraded to 2.6.17 about a month ago. I haven't seen 
> > any crashes so far.
> > 
> > Assuming I get the newest XFS repair tools on there, what's the disadvantage 
> > of repairing versus creating a new filesystem? What special circumstances are 
> > required to cause a crash?
> 
> There should be no disadvantage to repairing.  I will update the FAQ
> shortly to describe all the details of the problem, recommendations
> on how to address it, which kernel version is affected, etc.
this FAQ, is it this: http://oss.sgi.com/projects/xfs/faq.html#dir2 ?
(btw, it seems that while only in the TOC once, you have the same about
2.6.17 twice..)..

which version of xfsprogs should i use while doing the xfs_check ?

> 
> cheers.
> 

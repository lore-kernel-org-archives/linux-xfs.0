Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 May 2007 00:29:41 -0700 (PDT)
Received: from postfix2-g20.free.fr (postfix2-g20.free.fr [212.27.60.43])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l447TbfB018149
	for <xfs@oss.sgi.com>; Fri, 4 May 2007 00:29:38 -0700
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix2-g20.free.fr (Postfix) with ESMTP id CD3ADFA8658
	for <xfs@oss.sgi.com>; Fri,  4 May 2007 08:06:38 +0200 (CEST)
Date: Fri, 4 May 2007 09:06:13 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS crash on linux raid
Message-ID: <20070504090613.7c0f97d3@galadriel.home>
In-Reply-To: <20070504005922.GC32602149@melbourne.sgi.com>
References: <20070503164521.16efe075@harpe.intellique.com>
	<20070504005922.GC32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Le Fri, 4 May 2007 10:59:22 +1000 vous écriviez:

> Where there any I/o errors reported before the shutdown?
> 

Nope. To make it clear : the problem can be reproduce on several
different systems, different motherboards, different drives, different
RAID controllers... This isn't a hardware problem.

> > On a similar hardware with 2 3Ware-9550 16x750GB striped together,
> > but running 2.6.17.13, I had a similar fs crash last week.
> > Unfortunately I don't have the logs at hand, but we where able to
> > reproduce several times the crash at home :  
> 
> Hmm - 750GB drives are brand new. i wouldn't rule out media issues
> at this point...

The problem is quite easily reproduced with 500GB drives too.
 
> > Filesystem "md0": XFS internal error xfs_btree_check_sblock at line
> > 336 of file fs/xfs/xfs_btree.c.  Caller 0xc01fb282 <c0214568>  
> 
> Memory corruption?

Tried with different RAMs, and the problem occurs on ECC RAM too.

> > 
> > Out of curiosity, I've tried to use reiserfs (just to see how it
> > compares regarding this). Reiserfs crashed before even writing
> > 100MB!  
> 
> That indicates there's something wrong other than the filesystem.
> I'd suggest making sure your raid arrays, memory, etc are all
> functioning correctly first.

They are. I've tested 5 different machines so far (Supermicro or Tyan
mobos, kingston RAM, Intel or AMD cpus, hitachi and seagate drives...)
 
> What platform are you running on? Are you running ia32 with 4k stacks?

Yes. I'll try this week 2.6.18.8 thoroughly and 2.6.20.11 too. Then
jfs, just to be sure.

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 May 2007 08:30:51 -0700 (PDT)
Received: from smtp-ft1.fr.colt.net (smtp-ft1.fr.colt.net [213.41.78.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l44FUlfB030646
	for <xfs@oss.sgi.com>; Fri, 4 May 2007 08:30:49 -0700
Date: Fri, 4 May 2007 17:30:49 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS crash on linux raid
Message-ID: <20070504173049.14606033@harpe.intellique.com>
In-Reply-To: <463B4962.70904@sandeen.net>
References: <20070503164521.16efe075@harpe.intellique.com>
	<20070504005922.GC32602149@melbourne.sgi.com>
	<20070504090613.7c0f97d3@galadriel.home>
	<20070504073344.GL32602149@melbourne.sgi.com>
	<20070504152546.614374ac@harpe.intellique.com>
	<463B4962.70904@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Le Fri, 04 May 2007 09:55:30 -0500
Eric Sandeen <sandeen@sandeen.net> écrivait:

> Emmanuel Florac wrote:
> > Le Fri, 4 May 2007 17:33:44 +1000
> > David Chinner <dgc@sgi.com> écrivait:
> > 
> >> Well, there's your problem. Stack overflows.  IMO, if you use a
> >> filesystem, you shouldn't use 4k stacks. ;)
> >>
> >> If you remake you kernel with 8k stacks then your problems will
> >> most likely go away.
> > 
> > Well, I've double-checked the asm-i386/module.h, and it actually
> > looks like 4K stacks is NOT the default, so I must be using 8K,
> > isn't it?
> 
> Depends on how you config'd it, just look at the .config you built
> with, and search for CONFIG_4KSTACKS

config-2.6.17.13:

# CONFIG_4KSTACKS is not set

So the problem lies elsewhere...

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------

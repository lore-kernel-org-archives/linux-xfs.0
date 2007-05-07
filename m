Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 May 2007 19:11:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l472BXfB024497
	for <xfs@oss.sgi.com>; Sun, 6 May 2007 19:11:34 -0700
Date: Mon, 7 May 2007 12:11:22 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS crash on linux raid
Message-ID: <20070507021122.GQ32602149@melbourne.sgi.com>
References: <20070503164521.16efe075@harpe.intellique.com> <20070504005922.GC32602149@melbourne.sgi.com> <20070504090613.7c0f97d3@galadriel.home> <20070504073344.GL32602149@melbourne.sgi.com> <20070504152546.614374ac@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070504152546.614374ac@harpe.intellique.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Fri, May 04, 2007 at 03:25:46PM +0200, Emmanuel Florac wrote:
> Le Fri, 4 May 2007 17:33:44 +1000
> David Chinner <dgc@sgi.com> écrivait:
> 
> > Well, there's your problem. Stack overflows.  IMO, if you use a
> > filesystem, you shouldn't use 4k stacks. ;)
> > 
> > If you remake you kernel with 8k stacks then your problems will
> > most likely go away.
> 
> Well, I've double-checked the asm-i386/module.h, and it actually looks
> like 4K stacks is NOT the default, so I must be using 8K, isn't it?

Yes.

> I've ran the same test on the same machine but WITHOUT software raid-0
> (so write barriers are in use), and all went well, more than 3TB
> written without a glitch. I still think there's something related to
> the write barriers here. I'll try with another RAID controller, Adaptec
> for instance, to get sure the 3ware driver isn't involved. I'll also try
> again with an amd64 kernel.

So you use software raid and you get corruptions, right? I doubt this has
anything to do with write barriers - if it does thats an indication
of broken drivers or hardware.....

Can you run with "-o nobarrier" and no software raid and see if you
still have a problem?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

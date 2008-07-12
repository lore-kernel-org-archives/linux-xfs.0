Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Jul 2008 22:06:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6C55JBj029158
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 22:05:20 -0700
Received: from Chamillionaire.breakpoint.cc (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C298DFEC13
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 22:06:25 -0700 (PDT)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [85.10.199.196]) by cuda.sgi.com with ESMTP id hacZCWaJ9bqaEFmd for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 22:06:25 -0700 (PDT)
Date: Sat, 12 Jul 2008 07:06:12 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080712050612.GA11334@Chamillionaire.breakpoint.cc>
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <20080711190209.GA7401@Chamillionaire.breakpoint.cc> <20080711232201.GG11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080711232201.GG11558@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

* Dave Chinner | 2008-07-12 09:22:01 [+1000]:

>I effectively quoted from it:
>
>config XFS_DEBUG
>        bool "XFS Debugging support (EXPERIMENTAL)"
>        depends on XFS_FS && EXPERIMENTAL
>        help
>          Say Y here to get an XFS build with many debugging features,
>          including ASSERT checks, function wrappers around macros,
>          and extra sanity-checking functions in various code paths.
>
>          Note that the resulting code will be HUGE and SLOW, and probably
>          not useful unless you are debugging a particular problem.
>
>          Say N unless you are an XFS developer, or you play one on TV.
>
>> Debug mode is usually
>> noisy, little slower and mostly usefull just to the developers but *I*
>> would not expect to BUG() in the non-fatal case.
>
>What do you expect debug code to do? Asserts are designed to
>drop the machine into a debugger when they fail so the problem can
>be, well, debugged.
Sorry, I haven't read this. Userspace assert() results in abort() so it
sane to bug() in kernel.

>Dave.
Sebastian

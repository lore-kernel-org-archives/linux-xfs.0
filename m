Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 20:22:00 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B3LvCk005860
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 20:21:57 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FDCB18B194C
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 20:23:02 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 6wSAHcdt81A2C8Pu for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 20:23:02 -0700 (PDT)
Date: Fri, 11 Jul 2008 13:22:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlocked xfs
Message-ID: <20080711032258.GB11558@disturbed>
References: <4876C667.608@sandeen.net> <4876C9EB.7060601@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4876C9EB.7060601@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jul 11, 2008 at 12:48:11PM +1000, Mark Goodwin wrote:
> Thanks for the report Eric. This looks very similar to a
> deadlock Lachlan recently hit in the patch for
> "Use atomics for iclog reference counting"
> http://oss.sgi.com/archives/xfs/2008-02/msg00130.html
>
> It seems this patch can cause deadlocks under heavy log traffic.
> I don't think anyone has a fix yet ... Lachlan is out this week,
> but Tim can follow-up here ...

Nice to know - why didn't anyone email me or report this to the
list when the bug was first found? I mean, I wrote that code, I know
what it is supposed to be doing and as a result should be able
help find and fix the bug. Can you please post what details you have
about the problem (test case, stack traces, debugging info, etc)
so I can try to find the problem.

This is a regression that is in the mainline kernel that is due to
be released probably in the next couple of days. Having a little
bit of time to try and find the bug would have been nice...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

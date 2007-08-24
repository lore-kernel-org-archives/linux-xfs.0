Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 09:01:44 -0700 (PDT)
Received: from smtp118.sbc.mail.sp1.yahoo.com (smtp118.sbc.mail.sp1.yahoo.com [69.147.64.91])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OG1d4p030520
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 09:01:42 -0700
Date: Fri, 24 Aug 2007 08:35:56 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: XFS and 4k stacks/newer kernels.
Message-ID: <20070824153556.GA14476@puku.stupidest.org>
References: <20070824103846.GC13240@fysh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824103846.GC13240@fysh.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mike Ashton <mike@fysh.org>
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>

On Fri, Aug 24, 2007 at 11:38:47AM +0100, Mike Ashton wrote:

> I've just set up a new one based on exactly the same hardware but
> with a 2.6.22.3 kernel (and thus with compulsory 4k stacks, as I
> understand it?).

Not when I tested here.  Turn off 4K stacks.

> After giving it half an hour to wake up again, I hard rebooted and
> the XFS superblock was unreadable; bye bye filesystem.

Did xfs_repair fix the damage?

> So I've rolled back to 2.6.19, unsurprisingly, but I wanted to let
> you know that some issues with 4k stacks or other features of newer
> kernels may not have been resolved yet.

XFS on i386 with 4K stacks isn't safe.  People are working on making
it better but it's a bit of an uphill battle in some ways.

I've posted patches in the past to change of some the config logic to
avoid this but none of them ever got much more than a grunt ora snarky
anti-XFS comment, it's probably time to do it again.

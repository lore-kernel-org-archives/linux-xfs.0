Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 01:52:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7L8qptR025753
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 01:52:51 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48BE43BA0CB
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 01:54:11 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id t6XEShzHaP7OquvJ for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 01:54:11 -0700 (PDT)
Date: Thu, 21 Aug 2008 18:53:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080821085332.GG5706@disturbed>
References: <20080821051508.GB5706@disturbed> <684252.68814.qm@web34508.mail.mud.yahoo.com> <20080821061443.GD5706@disturbed> <200808211700.39584.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808211700.39584.nickpiggin@yahoo.com.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 21, 2008 at 05:00:39PM +1000, Nick Piggin wrote:
> On Thursday 21 August 2008 16:14, Dave Chinner wrote:
> 
> > I think that we need to issue explicit unplugs to get the log I/O
> > dispatched the way we want on all elevators and stop trying to
> > give elevators implicit hints by abusing the bio types and hoping
> > they do the right thing....
> 
> FWIW, my explicit plugging idea is still hanging around in one of
> Jens' block trees (actually he refreshed it a couple of months ago).
> 
> It provides an API for VM or filesystems to plug and unplug
> requests coming out of the current process, and it can reduce the
> need to idle the queue. Needs more performance analysis and tuning
> though.

We've already got plenty of explicit unplugs in XFS to get stuff
moving quickly - I'll just have to add another....

> But existing plugging is below the level of the elevators, and should
> only kick in for at most tens of ms at queue idle events, so it sounds
> like it may not be your problem. Elevators will need some hint to give
> priority to specific requests -- either via the current threads's io
> priority, or information attached to bios.

It's getting too bloody complex, IMO. What is right for one elevator
is wrong for another, so as a filesystem developer I have to pick
one to target. With the way the elevators have been regressing,
improving and changing behaviour, I am starting to think that I
should be picking the noop scheduler. Any 'advanced' scheduler that
is slower than the same test on the noop scheduler needs fixing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Oct 2007 15:46:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9AMkj1K007425
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 15:46:50 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id IAA23819 for <xfs@oss.sgi.com>; Thu, 11 Oct 2007 08:46:46 +1000
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id l9AMkjdD59239010
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2007 08:46:46 +1000 (AEST)
Received: (from dgc@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id l9AMkiwZ59287659
	for xfs@oss.sgi.com; Thu, 11 Oct 2007 08:46:44 +1000 (AEST)
Date: Thu, 11 Oct 2007 08:46:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Crash on 2.6.21.7 Vanilla + DRBD 0.7
Message-ID: <20071010224644.GP995458@sgi.com>
References: <20071004133302.GA5058@apartia.fr> <4704FA19.2080101@theendofthetunnel.de> <20071010151537.GA31573@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010151537.GA31573@apartia.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Oct 10, 2007 at 05:15:37PM +0200, Louis-David Mitterrand wrote:
> On Thu, Oct 04, 2007 at 04:35:05PM +0200, Hannes Dorbath wrote:
> > On 04.10.2007 15:33, vindex+lists-xfs@apartia.org wrote:
> >> What do you think about it ?
> >
> > Another thing, is there a special reason why you use DRBD 0.7.x branch? 
> > AFAIK it will still deadlock with kernel 2.6.22. You are not running .22, 
> > but if you upgrade you might have serious problems. You should really go 
> > with DRBD 8.0.6 if you can.
> >
> 
> After upgrading to 8.0.6 we had another xfs-related crash 4 days later. 
> In desperation we are about to abandon xfs and convert this huge 
> partition to ext3. Is there anyting else we could try before taking that 
> step?

Yes, please turn on slab debugging so we can try to find the cause
of this memory corruption. I expect the problem to be in DRBD as
nobody else running XFS is reporting this problem. However, without
running with the right debug options enabled we'll never get to
the bottom of the problem.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

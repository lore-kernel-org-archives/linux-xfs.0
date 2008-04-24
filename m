Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Apr 2008 23:30:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3O6URRB021460
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 23:30:29 -0700
Date: Thu, 24 Apr 2008 16:31:02 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS drops create/delete files to 6.6% of EXT3 (software raid) and to 0.6% of EXT3 (3ware hardware raid)
Message-ID: <20080424063102.GX103491721@sgi.com>
References: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com> <4810062F.50100@sandeen.net> <20080424053358.GW103491721@sgi.com> <c33e4330804232323p1b6d5121oc56b0c43663a4e84@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c33e4330804232323p1b6d5121oc56b0c43663a4e84@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Darling <darlingm@gmail.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Apr 24, 2008 at 02:23:45AM -0400, Michael Darling wrote:
> Eric, for the numbers you provided, are you using a single drive, software
> raid, or hardware raid?  If a hardware raid, is it a 3ware card?
> 
> I hadn't seen the nobarrier mount option before.  Using that changes
> sequential creates from about 190/second to about 2500/second, and changes
> sequential deletes from about 170/second to about 3700/second.
> 
> I don't yet have a BBU for the 3ware card, but would certainly get one if we
> go with the 3ware card before we start putting real data on the raid.  Am I
> right that with a BBU unit and a battery backup for the server as a whole,
> that nobarrier would be safe to use?

Are you using write caching on the RAID card? If yes, then you need a BBU
for the card if you want to enable the write cache safely.

> Not using nobarrier, but using logbsize 256k changes sequential creates from
> about 190/second to about 270/second.  So, it's an improvement, but no where
> near where a software raid performs (1600/second) or where the hardware raid
> performs with nobarrier.

Sounds like the hardware RAID is doing a full cache flush on barrier I/Os
which will cause lots and lots RMW cycles in the back end. i.e. slow.

Software raid ignores barriers, so is unsafe with any write cache turned
on (and that goes for any filesystem, not just XFS).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

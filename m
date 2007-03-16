Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 13:52:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2GKqL6p011912
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 13:52:24 -0700
Date: Sat, 17 Mar 2007 07:52:08 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Should xfs_repair take this long?
Message-ID: <20070316205208.GT6095633@melbourne.sgi.com>
References: <20070316160900.CNS43969@comet.stsci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316160900.CNS43969@comet.stsci.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Walker <walker@stsci.edu>
Cc: xfs@oss.sgi.com

On Fri, Mar 16, 2007 at 04:09:00PM -0400, Thomas Walker wrote:
> 
>   I already had xfs_repair scan the entire 6TB (took it 56 hours, which is
>   the reason for the subject line).  So it couldn't find a SB anywhere on
>   that volume and it walked all over it.  Therefore I guess the SB has been
>   overwritten by something, maybe parted.  As for the LVM physicals being in
>   the wrong order, I can try to reverse them but I'm really pretty sure I
>   have it right.  Still, since the scan by xfs_repair couldn't find a SB
>   anywhere I don't know what I would gain.

xfs-repair did find candidate secondary superblocks - it discarded them
for some reason or another. If they were ok, all repair would have done
is copied them to block zero and then continued.

I'm suggesting that you manually do this step, and then see if repair
will run.

>    Before wrapping this up, if you could just clarify a couple things.  If I
>    look at the bytes at the beginning of each physical part of the LVM's,
>    what am I looking for?  "XFSB"?

yes.

>    If I do find that byte string, why
>    couldn't xfs_repair find it when it did the scan and what do I do with it
>    if I do find one?

As I said above, xfs-repair did find some, but rejected them for some
(unknown) reason. if you find one, copy it over block zero of the partition,
and see if repair will run. Like I said, though, you'll probably want to
back up th partition first, or at least run repair in no-modify mode.

>    We see a software product call ufsexplorer that claims
>    to be able to recover data without an XFS super block, anybody try it?

Given that a) it runs on windows, and b) XFS support was apparently adding
only a week ago, I doubt there's many ppl here that have tried it....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
